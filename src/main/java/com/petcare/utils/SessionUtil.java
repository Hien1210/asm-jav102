package com.petcare.utils;

import com.petcare.models.Users;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class SessionUtil {
    public static final String ATTR_CURRENT_USER = "currentUser";
    public static final String ATTR_USER_ID = "loggedInUserId";
    public static final String ATTR_USER_NAME = "loggedInUser";
    public static final String ATTR_USER_EMAIL = "loggedInEmail";
    public static final String ATTR_USER_PHONE = "loggedInPhone";
    public static final String ATTR_USER_ROLE = "loggedInRole";

    private SessionUtil() { }

    public static void storeAuthenticatedUser(HttpServletRequest request, Users user, boolean rememberMe) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession session = request.getSession(true);
        writeUserAttributes(session, user);
        if (rememberMe) {
            session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 ngày
        } else {
            session.setMaxInactiveInterval(30 * 60); // 30 phút
        }
    }

    public static void refreshSessionUser(HttpServletRequest request, Users user) {
        if (user == null) {
            return;
        }
        HttpSession session = request.getSession(true);
        writeUserAttributes(session, user);
    }

    private static void writeUserAttributes(HttpSession session, Users user) {
        session.setAttribute(ATTR_CURRENT_USER, user);
        session.setAttribute(ATTR_USER_ID, user.getUserId());
        session.setAttribute(ATTR_USER_NAME, user.getFullName());
        session.setAttribute(ATTR_USER_EMAIL, user.getEmail());
        session.setAttribute(ATTR_USER_PHONE, user.getPhone());
        session.setAttribute(ATTR_USER_ROLE, user.getRole());
    }

    public static Users getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object obj = session.getAttribute(ATTR_CURRENT_USER);
        return (obj instanceof Users user) ? user : null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    public static boolean hasRole(HttpServletRequest request, String... allowedRoles) {
        Users user = getCurrentUser(request);
        if (user == null || user.getRole() == null) {
            return false;
        }
        for (String role : allowedRoles) {
            if (role != null && role.equalsIgnoreCase(user.getRole())) {
                return true;
            }
        }
        return false;
    }

    public static void clearSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
