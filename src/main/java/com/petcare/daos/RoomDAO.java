package com.petcare.daos;

import com.petcare.models.Rooms;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public interface RoomDAO {

    /** Non-maintenance rooms that can be booked for boarding. */
    List<Rooms> findBookableRooms() throws SQLException;

    /** Non-maintenance rooms without overlapping active stays in [checkIn, checkOut). */
    List<Rooms> findAvailableRoomsForDates(LocalDate checkIn, LocalDate checkOut) throws SQLException;

    Rooms findById(int roomId) throws SQLException;
}
