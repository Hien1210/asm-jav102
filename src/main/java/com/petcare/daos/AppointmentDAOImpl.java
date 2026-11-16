package com.petcare.daos;

import com.microsoft.sqlserver.jdbc.SQLServerCallableStatement;
import com.microsoft.sqlserver.jdbc.SQLServerDataTable;
import com.petcare.utils.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

public class AppointmentDAOImpl implements AppointmentDAO {

    @Override
    public int bookService(int customerId, int petId, int serviceId, int staffId,
                            Timestamp scheduledStart, Timestamp scheduledEnd) throws SQLException {
        SQLServerDataTable items = new SQLServerDataTable();
        items.addColumnMetadata("service_id", Types.INTEGER);
        items.addColumnMetadata("staff_id", Types.INTEGER);
        items.addColumnMetadata("scheduled_start", Types.TIMESTAMP);
        items.addColumnMetadata("scheduled_end", Types.TIMESTAMP);
        items.addRow(serviceId, staffId, scheduledStart, scheduledEnd);

        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall(
                     "{call dbo.BookServiceAppointment(?,?,?,?,?)}")) {
            stmt.setInt(1, customerId);
            stmt.setInt(2, petId);
            ((SQLServerCallableStatement) stmt).setStructured(3, "dbo.ServiceBookingItems", items);
            stmt.setNull(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.execute();
            return stmt.getInt(5);
        }
    }
}
