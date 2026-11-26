package com.petcare.controllers;

import com.petcare.services.AdminModule;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/admin/phong")
public class QuanLyPhongServlet extends AdminCatalogServlet {
    public QuanLyPhongServlet() { super(AdminModule.ROOMS); }
}