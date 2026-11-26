package com.petcare.controllers;

import com.petcare.services.AdminModule;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/admin/dich-vu")
public class QuanLyDichVuServlet extends AdminCatalogServlet {
    public QuanLyDichVuServlet() { super(AdminModule.SERVICES); }
}