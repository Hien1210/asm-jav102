package com.petcare.controllers;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.util.concurrent.atomic.AtomicReference;
import static org.junit.jupiter.api.Assertions.*;

class HomeServletTest {
    @Test
    void legacyBookingPostMustRedirectInsteadOfClaimingSuccess() throws Exception {
        AtomicReference<String> redirect = new AtomicReference<>();
        HttpServletRequest request = (HttpServletRequest) Proxy.newProxyInstance(
                getClass().getClassLoader(), new Class[]{HttpServletRequest.class}, (p, m, a) -> {
                    if (m.getName().equals("getContextPath")) return "/petcare";
                    if (m.getName().equals("getServletPath")) return "/dat-lich";
                    if (m.getName().equals("getRequestDispatcher"))
                        fail("A booking cannot show success without being persisted");
                    return null;
                });
        HttpServletResponse response = (HttpServletResponse) Proxy.newProxyInstance(
                getClass().getClassLoader(), new Class[]{HttpServletResponse.class}, (p, m, a) -> {
                    if (m.getName().equals("sendRedirect")) redirect.set((String) a[0]);
                    return null;
                });
        new HomeServlet().doPost(request, response);
        assertEquals("/petcare/customer/dat-lich", redirect.get());
    }
}
