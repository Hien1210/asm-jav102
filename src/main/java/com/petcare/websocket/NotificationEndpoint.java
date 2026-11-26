package com.petcare.websocket;

import jakarta.websocket.CloseReason;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * Day thong bao realtime toi cac trinh duyet dang mo cua dung tai khoan (theo userId) hoac
 * dung vai tro (ADMIN/STAFF/CUSTOMER) dang dang nhap. Client chi lang nghe, khong gui tin nhan
 * len (@OnMessage khong can thiet). Nguon goc thong bao (vi du: dat lich thanh cong) goi cac
 * method static notifyUser(...)/notifyRoles(...) sau khi da xu ly nghiep vu xong.
 */
@ServerEndpoint(value = "/ws/notifications", configurator = HttpSessionConfigurator.class)
public class NotificationEndpoint {

    private static final Map<Integer, Set<Session>> sessionsByUser = new ConcurrentHashMap<>();
    private static final Map<String, Set<Session>> sessionsByRole = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        Object userIdObj = config.getUserProperties().get("currentUserId");
        if (!(userIdObj instanceof Integer userId)) {
            closeQuietly(session, "unauthorized");
            return;
        }
        Object roleObj = config.getUserProperties().get("currentUserRole");
        String role = (roleObj instanceof String) ? (String) roleObj : null;

        session.getUserProperties().put("userId", userId);
        session.getUserProperties().put("role", role);

        sessionsByUser.computeIfAbsent(userId, k -> new CopyOnWriteArraySet<>()).add(session);
        if (role != null) {
            sessionsByRole.computeIfAbsent(role, k -> new CopyOnWriteArraySet<>()).add(session);
        }
    }

    @OnClose
    public void onClose(Session session) {
        Object userIdObj = session.getUserProperties().get("userId");
        if (userIdObj instanceof Integer userId) {
            removeFromGroup(sessionsByUser, userId, session);
        }
        Object roleObj = session.getUserProperties().get("role");
        if (roleObj instanceof String role) {
            removeFromGroup(sessionsByRole, role, session);
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Khong can xu ly gi them - container se tu dong dong session loi.
    }

    /** Day thong bao toi tat ca phien dang mo cua 1 tai khoan cu the (vi du: chinh khach vua dat lich). */
    public static void notifyUser(int userId, String type, String title, String message) {
        Set<Session> sessions = sessionsByUser.get(userId);
        if (sessions == null || sessions.isEmpty()) {
            return;
        }
        String payload = toJson(type, title, message);
        for (Session session : sessions) {
            sendQuietly(session, payload);
        }
    }

    /** Day thong bao toi tat ca phien dang mo cua cac vai tro cho (vi du: ADMIN, STAFF theo doi don moi). */
    public static void notifyRoles(String[] roles, String type, String title, String message) {
        if (roles == null || roles.length == 0) {
            return;
        }
        String payload = toJson(type, title, message);
        for (String role : roles) {
            Set<Session> sessions = sessionsByRole.get(role);
            if (sessions == null || sessions.isEmpty()) {
                continue;
            }
            for (Session session : sessions) {
                sendQuietly(session, payload);
            }
        }
    }

    private static <K> void removeFromGroup(Map<K, Set<Session>> groups, K key, Session session) {
        Set<Session> sessions = groups.get(key);
        if (sessions == null) {
            return;
        }
        sessions.remove(session);
        groups.computeIfPresent(key, (k, v) -> v.isEmpty() ? null : v);
    }

    private static String toJson(String type, String title, String message) {
        return "{\"type\":\"" + escape(type) + "\",\"title\":\"" + escape(title)
                + "\",\"message\":\"" + escape(message) + "\"}";
    }

    private static String escape(String value) {
        if (value == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(value.length());
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            switch (c) {
                case '"' -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                case '\t' -> sb.append("\\t");
                default -> {
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
                }
            }
        }
        return sb.toString();
    }

    private static void closeQuietly(Session session, String reason) {
        try {
            session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, reason));
        } catch (IOException ignored) {
        }
    }

    private static void sendQuietly(Session session, String payload) {
        try {
            session.getBasicRemote().sendText(payload);
        } catch (IOException ignored) {
        }
    }
}
