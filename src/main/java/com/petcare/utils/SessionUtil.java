package com.petcare.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class SessionUtil {
    private SessionUtil() {
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getUserId(request) != null;
    }

    public static Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (Integer) session.getAttribute("loggedInUserId");
    }

    public static String getRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (String) session.getAttribute("loggedInRole");
    }

    public static boolean isAdmin(HttpServletRequest request) {
        return "ADMIN".equals(getRole(request));
    }
}
