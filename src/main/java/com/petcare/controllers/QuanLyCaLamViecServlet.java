package com.petcare.controllers;

import com.petcare.services.AdminModule;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/admin/ca-lam-viec")
public class QuanLyCaLamViecServlet extends AdminCatalogServlet {
    public QuanLyCaLamViecServlet() { super(AdminModule.SHIFTS); }
}