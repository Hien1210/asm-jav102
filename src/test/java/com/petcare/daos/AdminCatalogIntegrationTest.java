package com.petcare.daos;

import com.petcare.services.AdminModule;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import java.sql.SQLException;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

/** Explicit opt-in: creates only QA rows and removes them in finally. */
@EnabledIfSystemProperty(named="petcare.integration",matches="true")
class AdminCatalogIntegrationTest {
    @Test void realDatabaseCrudAndConstraints() throws Exception {
        AdminCatalogDAO dao=new AdminCatalogDAO();
        String tag="QA-"+UUID.randomUUID().toString().substring(0,8);
        List<Map.Entry<AdminModule,Integer>> created=new ArrayList<>();
        try {
            var service=new HashMap<>(Map.of("name",tag,"category","GROOMING","duration_minutes","30","price","123456.78","is_active","1"));
            int sid=create(dao,created,AdminModule.SERVICES,service,List.of());
            assertEquals(tag,dao.find(AdminModule.SERVICES,sid).get("name"));
            service.put("name",tag+" updated");
            dao.save(AdminModule.SERVICES,sid,AdminModule.SERVICES.validate(service),List.of());
            assertEquals(tag+" updated",dao.find(AdminModule.SERVICES,sid).get("name"));
            var combo=Map.of("name",tag,"price","100000","is_active","1");
            int cid=create(dao,created,AdminModule.COMBOS,combo,List.of(sid));
            assertEquals(List.of(sid),dao.comboServices(cid));
            assertThrows(SQLException.class,()->dao.delete(AdminModule.SERVICES,sid));
            assertNotNull(dao.find(AdminModule.SERVICES,sid));
            assertThrows(IllegalArgumentException.class,()->dao.save(AdminModule.COMBOS,cid,AdminModule.COMBOS.validate(combo),List.of(Integer.MAX_VALUE)));
            assertEquals(List.of(sid),dao.comboServices(cid),"Failed combo edit must retain membership");
            var changedCombo=Map.of("name",tag+" rollback","price","100000","is_active","1");
            assertThrows(SQLException.class,()->dao.save(AdminModule.COMBOS,cid,AdminModule.COMBOS.validate(changedCombo),List.of(sid,sid)));
            assertEquals(tag,dao.find(AdminModule.COMBOS,cid).get("name"),"Child insert failure must roll back parent edit");
            assertEquals(List.of(sid),dao.comboServices(cid));
            int rid=create(dao,created,AdminModule.ROOMS,Map.of("room_code",tag,"daily_rate","200000","status","AVAILABLE"),List.of());
            assertThrows(SQLException.class,()->dao.save(AdminModule.ROOMS,null,AdminModule.ROOMS.validate(Map.of("room_code",tag,"daily_rate","1","status","AVAILABLE")),List.of()));
            assertNotNull(dao.find(AdminModule.ROOMS,rid));
            var customers=dao.users("CUSTOMER"); var staff=dao.users("STAFF");
            assertFalse(customers.isEmpty()); assertFalse(staff.isEmpty());
            int owner=((Number)customers.get(0).get("user_id")).intValue();
            int staffId=((Number)staff.get(0).get("user_id")).intValue();
            var pet=new HashMap<>(Map.of("owner_id",""+owner,"name",tag,"species","Mèo","weight_kg","2.50"));
            int pid=create(dao,created,AdminModule.PETS,pet,List.of());
            pet.put("weight_kg","3.50");
            dao.save(AdminModule.PETS,pid,AdminModule.PETS.validate(pet),List.of());
            assertEquals(new java.math.BigDecimal("3.50"),dao.find(AdminModule.PETS,pid).get("weight_kg"));
            var shift=Map.of("staff_id",""+staffId,"work_date","2099-12-01","start_time","09:00","end_time","10:00");
            int shiftId=create(dao,created,AdminModule.SHIFTS,shift,List.of());
            dao.save(AdminModule.SHIFTS,shiftId,AdminModule.SHIFTS.validate(shift),List.of());
            dao.save(AdminModule.ROOMS,rid,AdminModule.ROOMS.validate(Map.of("room_code",tag,"daily_rate","300000","status","MAINTENANCE")),List.of());
            assertEquals("MAINTENANCE",dao.find(AdminModule.ROOMS,rid).get("status"));
            assertThrows(SQLException.class,()->dao.save(AdminModule.SHIFTS,null,AdminModule.SHIFTS.validate(shift),List.of()));
        } finally {
            Collections.reverse(created);
            for(var entry:created) dao.delete(entry.getKey(),entry.getValue());
        }
        for(var entry:created) assertNull(dao.find(entry.getKey(),entry.getValue()));
    }
    private int create(AdminCatalogDAO dao,List<Map.Entry<AdminModule,Integer>> created,AdminModule m,Map<String,String> data,List<Integer> services) throws Exception {
        int id=dao.save(m,null,m.validate(data),services); created.add(Map.entry(m,id)); return id;
    }
}
