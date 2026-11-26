package com.petcare.services;

import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class AdminModuleTest {
    private Map<String,String> service() {
        return new HashMap<>(Map.of("name","Tắm sấy","category","GROOMING","duration_minutes","30","price","120000","is_active","1"));
    }
    @Test void acceptsValidServiceAndNormalizesOptionalFields() {
        var result=AdminModule.SERVICES.validate(service());
        assertEquals(30,result.get("duration_minutes"));
        assertNull(result.get("description"));
    }
    @Test void rejectsInvalidServiceValues() {
        for(var invalid:Map.of("name","x".repeat(101),"category","ADMIN","duration_minutes","0","price","-1","is_active","true").entrySet()) {
            var data=service(); data.put(invalid.getKey(),invalid.getValue());
            assertThrows(IllegalArgumentException.class,()->AdminModule.SERVICES.validate(data),invalid.getKey());
        }
    }
    @Test void rejectsMoneyOverflowAndFractionsBelowCent() {
        for(String value:List.of("100000000","1.001","NaN","1e1000000")) {
            var data=service(); data.put("price",value);
            assertThrows(IllegalArgumentException.class,()->AdminModule.SERVICES.validate(data));
        }
    }
    @Test void rejectsOvernightOrEmptyShifts() {
        for(String end:List.of("09:00","08:00")) {
            var data=Map.of("staff_id","2","work_date","2026-12-01","start_time","09:00","end_time",end);
            assertThrows(IllegalArgumentException.class,()->AdminModule.SHIFTS.validate(data));
        }
    }
    @Test void rejectsUnknownRoomStatus() {
        assertThrows(IllegalArgumentException.class,()->AdminModule.ROOMS.validate(Map.of("room_code","A1","daily_rate","100","status","FREE")));
    }
    @Test void rejectsFutureBirthDateAndZeroWeight() {
        var data=new HashMap<>(Map.of("owner_id","5","name","Miu","species","Mèo","birth_date","9999-12-31"));
        assertThrows(IllegalArgumentException.class,()->AdminModule.PETS.validate(data));
        data.remove("birth_date"); data.put("weight_kg","0");
        assertThrows(IllegalArgumentException.class,()->AdminModule.PETS.validate(data));
    }
}
