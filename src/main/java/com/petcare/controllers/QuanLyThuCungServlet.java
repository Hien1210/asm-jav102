package com.petcare.controllers;

import com.petcare.services.AdminModule;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/admin/thu-cung")
public class QuanLyThuCungServlet extends AdminCatalogServlet {
    public QuanLyThuCungServlet() { super(AdminModule.PETS); }
}
