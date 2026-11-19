package com.petcare.websocket;

import com.petcare.models.Users;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;

import java.util.List;
import java.util.Map;

/**
 * Gan thong tin nguoi dung dang dang nhap (tu HttpSession co san) vao WebSocket session,
 * de endpoint biet nen day thong bao cho ai ma khong can client tu khai bao userId.
 */
public class HttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        // Chong CSWSH (Cross-Site WebSocket Hijacking): neu co header Origin va host cua no
        // khac voi host dang phuc vu request nay, coi handshake la tu nguon khong tin cay va
        // khong gan currentUserId -> endpoint se tu dong tu choi (unauthorized).
        if (!isSameOriginOrAbsent(request)) {
            return;
        }

        Object httpSessionObj = request.getHttpSession();
        if (httpSessionObj instanceof HttpSession httpSession) {
            Object userObj = httpSession.getAttribute(SessionUtil.ATTR_CURRENT_USER);
            if (userObj instanceof Users user) {
                sec.getUserProperties().put("currentUserId", user.getUserId());
                sec.getUserProperties().put("currentUserRole", user.getRole());
            }
        }
    }

    private boolean isSameOriginOrAbsent(HandshakeRequest request) {
        Map<String, List<String>> headers = request.getHeaders();
        String origin = firstHeader(headers, "Origin");
        if (origin == null || origin.isEmpty()) {
            return true;
        }
        String host = firstHeader(headers, "Host");
        if (host == null || host.isEmpty()) {
            return true;
        }
        String originHost = extractHost(origin);
        return originHost != null && originHost.equalsIgnoreCase(host);
    }

    private String firstHeader(Map<String, List<String>> headers, String name) {
        if (headers == null) {
            return null;
        }
        for (Map.Entry<String, List<String>> entry : headers.entrySet()) {
            if (entry.getKey() != null && entry.getKey().equalsIgnoreCase(name)) {
                List<String> values = entry.getValue();
                return (values != null && !values.isEmpty()) ? values.get(0) : null;
            }
        }
        return null;
    }

    private String extractHost(String originHeaderValue) {
        try {
            String withoutScheme = originHeaderValue.replaceFirst("^[a-zA-Z][a-zA-Z0-9+.-]*://", "");
            int slashIdx = withoutScheme.indexOf('/');
            return slashIdx >= 0 ? withoutScheme.substring(0, slashIdx) : withoutScheme;
        } catch (Exception e) {
            return null;
        }
    }
}
