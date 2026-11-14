package com.petcare.utils;

import java.util.Locale;
import java.util.regex.Pattern;

public final class ValidationUtil {
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^(0|\\+84)[0-9]{8,10}$");

    private ValidationUtil() { }

    public static String normalizeEmail(String email) {
        if (email == null) {
            return "";
        }
        return email.trim().toLowerCase(Locale.ROOT);
    }

    public static String normalizePhone(String phone) {
        if (phone == null) {
            return "";
        }
        String cleaned = phone.replaceAll("[\\s.\\-()]", "");
        if (cleaned.startsWith("+84")) {
            cleaned = "0" + cleaned.substring(3);
        }
        return cleaned;
    }

    public static boolean isValidEmail(String email) {
        String normalized = normalizeEmail(email);
        return !normalized.isEmpty() && normalized.length() <= 100
                && EMAIL_PATTERN.matcher(normalized).matches();
    }

    public static boolean isValidPhone(String phone) {
        String normalized = normalizePhone(phone);
        return !normalized.isEmpty() && normalized.length() <= 20
                && PHONE_PATTERN.matcher(normalized).matches();
    }
}
