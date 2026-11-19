package com.petcare.daos;

import com.petcare.models.Users;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.sql.*;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class AccountAdminProtectionTest {
    private String actorRole="ADMIN", targetRole="CUSTOMER", lastSql;
    private boolean actorActive=true, missingProcedure=false;
    private int commits, rollbacks, writes, procedureFailure;
    private final Map<Integer,Object> bound=new HashMap<>();

    @SuppressWarnings("unchecked") private <T> T proxy(Class<T> type,java.lang.reflect.InvocationHandler handler) {
        return (T)Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{type},handler);
    }
    private ResultSet rows() {
        List<Map<String,Object>> records=new ArrayList<>();
        records.add(Map.of("user_id",1,"role",actorRole,"is_active",actorActive));
        if(targetRole!=null) records.add(Map.of("user_id",2,"role",targetRole,"is_active",true));
        int[] index={-1};
        return proxy(ResultSet.class,(p,m,a)->switch(m.getName()) {
            case "next" -> ++index[0]<records.size();
            case "getInt", "getString", "getBoolean" -> records.get(index[0]).get(a[0]);
            default -> null;
        });
    }
    private AccountDAOImpl dao() {
        Connection connection=proxy(Connection.class,(p,m,a)->switch(m.getName()) {
            case "prepareStatement" -> {
                lastSql=(String)a[0];
                yield proxy(PreparedStatement.class,(ps,method,args)->switch(method.getName()) {
                    case "setInt", "setObject" -> { bound.put((Integer)args[0],args[1]); yield null; }
                    case "executeQuery" -> rows();
                    case "executeUpdate" -> { writes++; yield 1; }
                    default -> null;
                });
            }
            case "prepareCall" -> proxy(CallableStatement.class,(ps,method,args)->{
                if(method.getName().equals("execute")) {
                    if(missingProcedure) throw new SQLException("Missing procedure","42000",2812);
                    if(procedureFailure!=0) throw new SQLException("Constraint failed","23000",procedureFailure);
                    writes++; return true;
                }
                return null;
            });
            case "commit" -> { commits++; yield null; }
            case "rollback" -> { rollbacks++; yield null; }
            default -> null;
        });
        return new AccountDAOImpl(()->connection);
    }
    private Users target() { return new Users(2,"Customer","qa@example.test",null,null,"STAFF",true,null); }

    @Test void rolePromotedAfterServletCheckCannotBeLocked() {
        targetRole="ADMIN";
        assertThrows(IllegalArgumentException.class,()->dao().setManagedActive(1,2,false));
        assertEquals(0,writes); assertEquals(0,commits); assertEquals(1,rollbacks);
    }
    @Test void adminCannotBeDemotedOrHavePasswordReplaced() {
        targetRole="ADMIN";
        assertThrows(IllegalArgumentException.class,()->dao().updateManagedProfile(1,target()));
        assertThrows(IllegalArgumentException.class,()->dao().resetManagedPassword(1,2,"hash"));
        assertEquals(0,writes); assertEquals(0,commits);
    }
    @Test void revokedActorCannotWriteEvenWithOldAdminSession() {
        actorRole="STAFF";
        assertThrows(IllegalArgumentException.class,()->dao().setManagedActive(1,2,false));
        assertEquals(0,writes);
    }
    @Test void inactiveActorCannotWrite() {
        actorActive=false;
        assertThrows(IllegalArgumentException.class,()->dao().resetManagedPassword(1,2,"hash"));
        assertEquals(0,writes);
    }
    @Test void customerManagementStillWorksWithLockedAuthorizationRead() throws Exception {
        assertTrue(dao().setManagedActive(1,2,false));
        assertEquals(1,writes); assertEquals(1,commits);
        assertTrue(lastSql.contains("UPDLOCK, HOLDLOCK"));
    }
    @Test void missingProcedureFallbackKeepsParameterOrderAndDoesNotOverwriteRole() throws Exception {
        missingProcedure=true;
        assertTrue(dao().setManagedActive(1,2,false));
        assertEquals(false,bound.get(1)); assertEquals(2,bound.get(2));
        assertFalse(lastSql.contains("SET role"));
        assertEquals(1,commits);
    }
    @Test void profileFallbackBindsIdentifierLast() throws Exception {
        missingProcedure=true;
        assertTrue(dao().updateManagedProfile(1,target()));
        assertEquals("Customer",bound.get(1)); assertEquals("qa@example.test",bound.get(2));
        assertEquals("STAFF",bound.get(4)); assertEquals(2,bound.get(5));
    }
    @Test void missingTargetRollsBackWithoutSuccess() throws Exception {
        targetRole=null;
        assertFalse(dao().setManagedActive(1,2,false));
        assertEquals(0,writes); assertEquals(0,commits); assertEquals(1,rollbacks);
    }
    @Test void mixedCaseAdminIsProtected() {
        targetRole="admin";
        assertThrows(IllegalArgumentException.class,()->dao().setManagedActive(1,2,false));
        assertEquals(0,writes);
    }
    @Test void constraintFailureRollsBackWithoutTryingFallback() {
        procedureFailure=547;
        assertThrows(SQLException.class,()->dao().setManagedActive(1,2,false));
        assertEquals(0,writes); assertEquals(0,commits); assertEquals(1,rollbacks);
    }
    @Test void passwordFallbackBindsHashBeforeIdentifier() throws Exception {
        missingProcedure=true;
        assertTrue(dao().resetManagedPassword(1,2,"new-hash"));
        assertEquals("new-hash",bound.get(1)); assertEquals(2,bound.get(2));
    }
}
