package com.petcare.utils;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public final class DateUtil {
    public static final ZoneId VN_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    private static final DateTimeFormatter DATE_VN = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DATETIME_VN = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
    private static final DateTimeFormatter TIME_VN = DateTimeFormatter.ofPattern("HH:mm");

    private DateUtil() { }

    public static LocalDateTime nowVn() {
        return LocalDateTime.now(VN_ZONE);
    }

    public static LocalDate todayVn() {
        return LocalDate.now(VN_ZONE);
    }

    public static String formatDate(LocalDate date) {
        return date == null ? "" : date.format(DATE_VN);
    }

    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime == null ? "" : dateTime.format(DATETIME_VN);
    }

    public static String formatTime(LocalTime time) {
        return time == null ? "" : time.format(TIME_VN);
    }

    public static String formatVnd(BigDecimal amount) {
        if (amount == null) {
            return "0 đ";
        }
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.forLanguageTag("vi-VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(amount) + " đ";
    }

    public static String dayOfWeekLabel(int dayOfWeek) {
        return switch (dayOfWeek) {
            case 0 -> "Chủ nhật";
            case 1 -> "Thứ 2";
            case 2 -> "Thứ 3";
            case 3 -> "Thứ 4";
            case 4 -> "Thứ 5";
            case 5 -> "Thứ 6";
            case 6 -> "Thứ 7";
            default -> "Ngày " + dayOfWeek;
        };
    }

    public static LocalDateTime parseLocalDateTime(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String cleaned = raw.trim().replace(' ', 'T');
        return LocalDateTime.parse(cleaned);
    }

    public static LocalDate parseLocalDate(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String trimmed = raw.trim();
        if (trimmed.length() >= 10) {
            return LocalDate.parse(trimmed.substring(0, 10));
        }
        return LocalDate.parse(trimmed);
    }

    public static LocalTime parseLocalTime(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        return LocalTime.parse(raw.trim());
    }
}
