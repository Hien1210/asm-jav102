package com.petcare.services;

import java.math.BigDecimal;
import java.time.*;
import java.util.*;

/** Fixed schema for the five administration screens; identifiers never come from HTTP input. */
public enum AdminModule {
    SERVICES("dich-vu", "Dịch vụ", "Services", "service_id", List.of(
            field("name", "Tên dịch vụ", "text", 100, true),
            field("description", "Mô tả", "text", 500, false),
            choice("category", "Nhóm", "GROOMING,MEDICAL,VACCINATION,BOARDING,OTHER"),
            field("duration_minutes", "Thời lượng (phút)", "number", 0, true),
            field("price", "Giá (đ)", "decimal", 0, true), choice("is_active", "Hoạt động", "1,0"))),
    COMBOS("combo", "Combo", "Combos", "combo_id", List.of(
            field("name", "Tên combo", "text", 100, true),
            field("description", "Mô tả", "text", 500, false),
            field("price", "Giá (đ)", "decimal", 0, true), choice("is_active", "Hoạt động", "1,0"))),
    ROOMS("phong", "Phòng lưu trú", "Rooms", "room_id", List.of(
            field("room_code", "Mã phòng", "text", 20, true), field("room_type", "Loại phòng", "text", 50, false),
            field("daily_rate", "Giá mỗi ngày (đ)", "decimal", 0, true),
            choice("status", "Trạng thái", "AVAILABLE,OCCUPIED,MAINTENANCE"))),
    SHIFTS("ca-lam-viec", "Ca làm việc", "Shifts", "shift_id", List.of(
            field("staff_id", "Nhân viên", "staff", 0, true), field("work_date", "Ngày làm việc", "date", 0, true),
            field("start_time", "Giờ bắt đầu", "time", 0, true), field("end_time", "Giờ kết thúc", "time", 0, true))),
    PETS("thu-cung", "Thú cưng", "Pets", "pet_id", List.of(
            field("owner_id", "Chủ thú cưng", "customer", 0, true), field("name", "Tên thú cưng", "text", 100, true),
            field("species", "Loài", "text", 50, true), field("breed", "Giống", "text", 100, false),
            field("weight_kg", "Cân nặng (kg)", "decimal", 0, false), field("birth_date", "Ngày sinh", "date", 0, false),
            field("medical_notes", "Ghi chú sức khỏe", "text", 4000, false)));

    public static class Field {
        private final String name, label, type;
        private final int max;
        private final boolean required;
        private final List<String> options;
        Field(String name, String label, String type, int max, boolean required, List<String> options) {
            this.name=name; this.label=label; this.type=type; this.max=max; this.required=required; this.options=options;
        }
        public String getName() { return name; }
        public String getLabel() { return label; }
        public String getType() { return type; }
        public int getMax() { return max; }
        public boolean isRequired() { return required; }
        public List<String> getOptions() { return options; }
    }
    private static Field field(String n, String l, String t, int m, boolean r) { return new Field(n,l,t,m,r,List.of()); }
    private static Field choice(String n, String l, String values) { return new Field(n,l,"select",0,true,List.of(values.split(","))); }
    private final String path, title, table, id;
    private final List<Field> fields;
    AdminModule(String path, String title, String table, String id, List<Field> fields) {
        this.path=path; this.title=title; this.table=table; this.id=id; this.fields=fields;
    }
    public String getPath() { return path; }
    public String getTitle() { return title; }
    public String getTable() { return table; }
    public String getId() { return id; }
    public List<Field> getFields() { return fields; }

    public Map<String,Object> validate(Map<String,String> input) {
        Map<String,Object> result = new LinkedHashMap<>();
        for (Field f : fields) {
            String value = Objects.toString(input.get(f.name), "").trim();
            if (value.isEmpty()) {
                if (f.required) throw new IllegalArgumentException("Vui lòng nhập " + f.label + ".");
                result.put(f.name,null); continue;
            }
            try {
                Object parsed = switch (f.type) {
                    case "number", "staff", "customer" -> {
                        int n = Integer.parseInt(value);
                        if (n <= 0) throw new IllegalArgumentException();
                        yield n;
                    }
                    case "decimal" -> {
                        if (!value.matches("[0-9]{1,8}(\\.[0-9]{1,2})?")) throw new IllegalArgumentException();
                        BigDecimal n = new BigDecimal(value).setScale(2, java.math.RoundingMode.UNNECESSARY);
                        BigDecimal max = f.name.equals("weight_kg") ? new BigDecimal("999.99") : new BigDecimal("99999999.99");
                        if (n.signum() < 0 || n.compareTo(max)>0 || (f.name.equals("weight_kg") && n.signum()==0))
                            throw new IllegalArgumentException();
                        yield n;
                    }
                    case "date" -> {
                        LocalDate date = LocalDate.parse(value);
                        if (date.getYear()<1 || date.getYear()>9999 || (f.name.equals("birth_date") && date.isAfter(LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")))))
                            throw new IllegalArgumentException();
                        yield java.sql.Date.valueOf(date);
                    }
                    case "time" -> java.sql.Time.valueOf(LocalTime.parse(value));
                    case "select" -> {
                        if (!f.options.contains(value)) throw new IllegalArgumentException();
                        yield f.name.equals("is_active") ? Integer.valueOf(value) : value;
                    }
                    default -> {
                        if (value.length()>f.max) throw new IllegalArgumentException();
                        yield value;
                    }
                };
                result.put(f.name,parsed);
            } catch (RuntimeException ex) {
                throw new IllegalArgumentException(f.label + " không hợp lệ hoặc vượt giới hạn.");
            }
        }
        if (this==SHIFTS && ((java.sql.Time)result.get("start_time")).compareTo((java.sql.Time)result.get("end_time"))>=0)
            throw new IllegalArgumentException("Giờ kết thúc phải sau giờ bắt đầu.");
        return result;
    }
}
