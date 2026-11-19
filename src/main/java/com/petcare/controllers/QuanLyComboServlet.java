package com.petcare.controllers;

import com.petcare.services.AdminModule;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/admin/combo")
public class QuanLyComboServlet extends AdminCatalogServlet {
    public QuanLyComboServlet() { super(AdminModule.COMBOS); }
}