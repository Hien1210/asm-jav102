<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcare.controller.HomeServlet" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (request.getAttribute("services") == null) {
        request.setAttribute("services", HomeServlet.buildDefaultServices());
    }
    if (request.getAttribute("reviews") == null) {
        request.setAttribute("reviews", HomeServlet.buildDefaultReviews());
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Pet care — Dịch Vụ Chăm Sóc &amp; Spa Thú Cưng Chuyên Nghiệp Tận Tâm</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=6" />
</head>
<body>

    <!-- ====================================================================
         1. TOP HEADER / NAVBAR (Sticky, 76px, Modern Premium)
         ==================================================================== -->
    <header class="site-header">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand-wrap" aria-label="Pet care — Trang chủ">
                <span class="brand-icon-box">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo" class="brand-logo-img" />
                </span>
            </a>

            <nav class="main-nav" aria-label="Điều hướng chính">
                <a href="${pageContext.request.contextPath}/home" class="active">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a>
                <a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a>
                <a href="#quy-trinh-section">Quy trình chăm sóc</a>
                <a href="#quyen-loi-section">Tra cứu &amp; Hướng dẫn</a>
            </nav>

            <div class="header-auth-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn-login-outline">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-solid">Đăng ký tài khoản</a>
                <a href="${pageContext.request.contextPath}/login" class="btn-user-avatar" aria-label="Tài khoản">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </a>
                <button type="button" class="mobile-menu-toggle" id="mobileMenuBtn" aria-label="Mở menu" aria-expanded="false">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                </button>
            </div>
        </div>
    </header>

    <!-- ====================================================================
         2. SUBTLE GUEST MODE BAR
         ==================================================================== -->
    <div class="guest-alert-bar">
        <div class="container guest-alert-inner">
            <div class="guest-alert-text">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
                <span>
                    <strong>Chế độ Khách (Chưa đăng nhập):</strong>
                    Đăng nhập hoặc mở tài khoản để tự động lưu hồ sơ bé cưng và lịch chăm sóc định kỳ.
                </span>
            </div>
            <div class="guest-alert-btns">
                <a href="${pageContext.request.contextPath}/login" class="btn-guest-white">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-guest-green">Tạo tài khoản miễn phí</a>
            </div>
        </div>
    </div>

    <main id="trang-chu">

        <!-- ================================================================
             3. HERO SECTION (55% Text / 45% Photorealistic Pet Spa Image)
             ================================================================ -->
        <section class="hero-section">
            <div class="container hero-grid">
                <div class="hero-left reveal-up">
                    <div class="hero-pill-badge">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2l2.4 2.1 3.1-.4 1.2 2.9 2.9 1.2-.4 3.1L23.3 13l-2.1 2.4.4 3.1-2.9 1.2-1.2 2.9-3.1-.4L12 24.3l-2.4-2.1-3.1.4-1.2-2.9-2.9-1.2.4-3.1L.7 13l2.1-2.4-.4-3.1 2.9-1.2 1.2-2.9 3.1.4L12 2zm-1.2 13.6l5.4-5.4-1.4-1.4-4 4-2-2-1.4 1.4 3.4 3.4z"/>
                        </svg>
                        <span>CỔNG THÀNH VIÊN &amp; ĐẶT LỊCH SPA GROOMING PET CARE</span>
                    </div>

                    <h1 class="hero-title">
                        Dịch Vụ Chăm Sóc &amp; Spa Thú Cưng
                        <span class="highlight-brand">Chuyên Nghiệp Tận Tâm</span>
                    </h1>

                    <p class="hero-desc">
                        Trải nghiệm dịch vụ chăm sóc thú cưng toàn diện với đội ngũ chuyên viên Grooming chuyên nghiệp,
                        tận tâm và yêu thương thú cưng.
                    </p>

                    <div class="hero-cta-row">
                        <a href="${pageContext.request.contextPath}/register" class="btn-hero-primary">
                            <span>Đăng ký thành viên mới</span>
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </a>

                        <a href="${pageContext.request.contextPath}/login" class="btn-hero-secondary">
                            <span>Đăng nhập tài khoản</span>
                        </a>
                    </div>

                    <div class="hero-trust-notes">
                        <span class="hero-trust-item">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                            Mỹ phẩm thảo mộc Organic 100%
                        </span>
                        <span class="hero-trust-item">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                            Phòng kính tiệt trùng UV chuẩn quốc tế
                        </span>
                    </div>
                </div>

                <div class="hero-right reveal-up">
                    <div class="hero-visual-card">
                        <img src="${pageContext.request.contextPath}/assets/images/hero-petcare-spa.jpg" alt="Chuyên viên Pet Grooming đang chăm sóc thú cưng tại Pet care Spa" />
                        <div class="hero-visual-overlay"></div>
                        <div class="hero-floating-card">
                            <div class="hero-floating-left">
                                <div class="hero-ready-tag">
                                    <span class="ready-dot"></span>
                                    <span>&#10003; Chuyên viên Spa &amp; Grooming sẵn sàng</span>
                                </div>
                                <p>128 Nguyễn Đình Chiểu, Q.3, TP.HCM &bull; 45 Hoàng Cầu, Đống Đa, HN</p>
                            </div>
                            <button type="button" class="hero-floating-btn" data-open-booking="Grooming & Tắm Sấy Thảo Mộc Toàn Diện">
                                Đặt lịch nhanh
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. SOCIAL PROOF SECTION (Immediately Below Hero)
             ================================================================ -->
        <section class="social-proof-section" aria-label="Chỉ số tin cậy">
            <div class="container">
                <div class="social-proof-header reveal-up">
                    <span class="sp-stars" aria-hidden="true">&#9733;&#9733;&#9733;&#9733;&#9733;</span>
                    <span class="sp-trust-label">&ldquo;Được khách hàng tin tưởng&rdquo;</span>
                    <span class="sp-trust-sub">&mdash; Đánh giá 4.9/5 từ cộng đồng nuôi thú cưng tại Việt Nam</span>
                </div>

                <div class="stats-4-grid">
                    <div class="stat-minimal-card reveal-up">
                        <div class="stat-minimal-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                                <circle cx="7" cy="7.5" r="2"/>
                                <circle cx="12" cy="5.5" r="2"/>
                                <circle cx="17" cy="7.5" r="2"/>
                                <circle cx="19.5" cy="12" r="1.8"/>
                                <circle cx="4.5" cy="12" r="1.8"/>
                                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                            </svg>
                        </div>
                        <div class="stat-minimal-content">
                            <strong>5.000+</strong>
                            <span>Thú cưng đã chăm sóc</span>
                        </div>
                    </div>

                    <div class="stat-minimal-card reveal-up">
                        <div class="stat-minimal-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="6" cy="6" r="3"></circle>
                                <circle cx="6" cy="18" r="3"></circle>
                                <line x1="20" y1="4" x2="8.12" y2="15.88"></line>
                                <line x1="14.47" y1="14.48" x2="20" y2="20"></line>
                            </svg>
                        </div>
                        <div class="stat-minimal-content">
                            <strong>20+</strong>
                            <span>Chuyên viên Grooming</span>
                        </div>
                    </div>

                    <div class="stat-minimal-card reveal-up">
                        <div class="stat-minimal-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                        </div>
                        <div class="stat-minimal-content">
                            <strong>10+</strong>
                            <span>Cơ sở tiêu chuẩn</span>
                        </div>
                    </div>

                    <div class="stat-minimal-card reveal-up">
                        <div class="stat-minimal-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            </svg>
                        </div>
                        <div class="stat-minimal-content">
                            <strong>98%</strong>
                            <span>Khách hàng hài lòng</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             5. SERVICES SECTION ("Dịch vụ chăm sóc toàn diện")
             ================================================================ -->
        <section id="bang-gia-section" class="services-pricing-section">
            <div class="container">
                <div class="section-split-head reveal-up">
                    <div>
                        <span class="section-eyebrow">BẢNG GIÁ &amp; LIỆU TRÌNH MINH BẠCH</span>
                        <h2 class="section-main-title">Dịch vụ chăm sóc toàn diện</h2>
                        <p class="section-subtitle">
                            Mọi nhu cầu chăm sóc thú cưng trong một nơi. Không phụ phí ẩn, quy trình chuẩn quốc tế.
                        </p>
                    </div>

                    <div class="filter-tabs-bar" role="tablist">
                        <button type="button" class="filter-tab-btn active" data-filter="all">Tất cả dịch vụ</button>
                        <button type="button" class="filter-tab-btn" data-filter="tam-spa">Tắm &amp; Spa</button>
                        <button type="button" class="filter-tab-btn" data-filter="grooming">Grooming &amp; Cắt Tỉa</button>
                        <button type="button" class="filter-tab-btn" data-filter="khach-san">Combo &amp; Lưu Trú</button>
                    </div>
                </div>

                <div class="services-cards-grid">
                    <c:forEach var="srv" items="${services}">
                        <article class="service-price-card reveal-up" data-category="${srv.category}">
                            <div class="spc-header-block">
                                <span class="spc-icon-circle" aria-hidden="true">
                                    <c:choose>
                                        <c:when test="${srv.id == 'grooming-cat-tia'}">
                                            <svg class="ico" viewBox="0 0 24 24">
                                                <circle class="ico-tone" cx="6.5" cy="6.5" r="2.7" />
                                                <circle class="ico-tone" cx="6.5" cy="17.5" r="2.7" />
                                                <circle cx="6.5" cy="6.5" r="2.7" />
                                                <circle cx="6.5" cy="17.5" r="2.7" />
                                                <path d="M8.6 8.3L19.5 18.8" />
                                                <path d="M8.6 15.7L19.5 5.2" />
                                                <circle class="ico-solid" cx="12.2" cy="12" r="1.05" />
                                                <path class="ico-tone" d="M19.5 9.8l.55 1.65 1.65.55-1.65.55-.55 1.65-.55-1.65-1.65-.55 1.65-.55z" />
                                                <path d="M19.5 10l.5 1.5 1.5.5-1.5.5-.5 1.5-.5-1.5-1.5-.5 1.5-.5z" />
                                            </svg>
                                        </c:when>
                                        <c:when test="${srv.id == 'spa-cham-soc-da'}">
                                            <svg class="ico" viewBox="0 0 24 24">
                                                <path class="ico-tone" d="M12 3.2c2.8 3.1 4.1 6.1 4.1 9.1a4.1 4.1 0 0 1-8.2 0c0-3 1.3-6 4.1-9.1z" />
                                                <path d="M12 3.2c2.8 3.1 4.1 6.1 4.1 9.1a4.1 4.1 0 0 1-8.2 0c0-3 1.3-6 4.1-9.1z" />
                                                <path d="M8.2 14.2C4.9 13.4 3.1 10.9 3.4 7.7c2.8.3 4.8 1.9 5.6 4.3" />
                                                <path d="M15.8 14.2c3.3-.8 5.1-3.3 4.8-6.5-2.8.3-4.8 1.9-5.6 4.3" />
                                                <path d="M5 18.8c2.1.9 4.5 1.3 7 1.3s4.9-.4 7-1.3" />
                                            </svg>
                                        </c:when>
                                        <c:when test="${srv.id == 've-sinh-tai-mong'}">
                                            <svg class="ico" viewBox="0 0 24 24">
                                                <path class="ico-tone" d="M12 11.8c-3 0-5.4 2.1-5.4 4.7 0 1.8 1.5 3.1 3.3 3.1.8 0 1.5-.3 2.1-.3s1.3.3 2.1.3c1.8 0 3.3-1.3 3.3-3.1 0-2.6-2.4-4.7-5.4-4.7z" />
                                                <path d="M12 11.8c-3 0-5.4 2.1-5.4 4.7 0 1.8 1.5 3.1 3.3 3.1.8 0 1.5-.3 2.1-.3s1.3.3 2.1.3c1.8 0 3.3-1.3 3.3-3.1 0-2.6-2.4-4.7-5.4-4.7z" />
                                                <circle class="ico-tone" cx="5.2" cy="10.8" r="1.65" />
                                                <circle cx="5.2" cy="10.8" r="1.65" />
                                                <circle class="ico-tone" cx="9.2" cy="6.6" r="1.75" />
                                                <circle cx="9.2" cy="6.6" r="1.75" />
                                                <circle class="ico-tone" cx="14.8" cy="6.6" r="1.75" />
                                                <circle cx="14.8" cy="6.6" r="1.75" />
                                                <circle class="ico-tone" cx="18.8" cy="10.8" r="1.65" />
                                                <circle cx="18.8" cy="10.8" r="1.65" />
                                            </svg>
                                        </c:when>
                                        <c:when test="${srv.id == 'cham-soc-suc-khoe'}">
                                            <svg class="ico" viewBox="0 0 24 24">
                                                <path class="ico-tone" d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                                <path d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                                <path d="M7.8 12h2l1.4-2.8 1.6 5.4 1.4-2.6h2" />
                                            </svg>
                                        </c:when>
                                        <c:when test="${srv.id == 'combo-cham-soc'}">
                                            <svg class="ico" viewBox="0 0 24 24">
                                                <path class="ico-tone" d="M3.5 17L5.2 7.8l4.3 3.7L12 5.4l2.5 6.1 4.3-3.7L20.5 17H3.5z" />
                                                <path d="M3.5 17L5.2 7.8l4.3 3.7L12 5.4l2.5 6.1 4.3-3.7L20.5 17H3.5z" />
                                                <path d="M4.5 19.8h15" />
                                                <circle class="ico-solid" cx="12" cy="3.8" r="1" />
                                                <circle class="ico-solid" cx="4.8" cy="6.2" r="0.9" />
                                                <circle class="ico-solid" cx="19.2" cy="6.2" r="0.9" />
                                            </svg>
                                        </c:when>
                                        <c:otherwise>
                                            <svg class="ico" viewBox="0 0 24 24">
                                                <path class="ico-tone" d="M4 12.5h16V15a5 5 0 0 1-5 5H9a5 5 0 0 1-5-5v-2.5z" />
                                                <path d="M2 12.5h20" />
                                                <path d="M4 12.5V15a5 5 0 0 0 5 5h6a5 5 0 0 0 5-5v-2.5" />
                                                <path d="M7 20l-1 1.8" />
                                                <path d="M17 20l1 1.8" />
                                                <path d="M6 12.5V6.8A3.3 3.3 0 0 1 9.3 3.5c1.5 0 2.7 1 3.1 2.4" />
                                                <circle class="ico-tone" cx="15.8" cy="7.5" r="1.5" />
                                                <circle cx="15.8" cy="7.5" r="1.5" />
                                                <circle cx="19" cy="5.2" r="1.1" />
                                                <circle class="ico-solid" cx="13.2" cy="9.2" r="1" />
                                            </svg>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="spc-badge ${srv.badgeTheme}">${srv.badgeText}</span>
                            </div>

                            <div class="spc-top-row">
                                <span class="spc-tag">Chuẩn Pet Spa</span>
                                <span class="spc-rating">${srv.ratingText}</span>
                            </div>

                            <h3>${srv.title}</h3>
                            <p>${srv.description}</p>

                            <div class="spc-tags">
                                <c:forEach var="t" items="${srv.tags}">
                                    <span class="spc-tag">${t}</span>
                                </c:forEach>
                            </div>

                            <div class="spc-footer">
                                <div>
                                    <span class="spc-price-label">${srv.priceLabel}</span>
                                    <span class="spc-price-val">${srv.priceValue}</span>
                                    <c:if test="${not empty srv.priceSuffix}">
                                        <span class="spc-price-suffix">${srv.priceSuffix}</span>
                                    </c:if>
                                </div>
                                <button type="button" class="btn-spc-book" data-open-booking="${srv.title}">
                                    <span>Đặt lịch</span>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </button>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- ================================================================
             6. 4-STEP CARE PROCESS TIMELINE ("Quy trình chăm sóc")
             ================================================================ -->
        <section id="quy-trinh-section" class="steps-section">
            <div class="container">
                <div class="section-header-center reveal-up">
                    <span class="section-eyebrow">QUY TRÌNH CHUẨN PET SPA</span>
                    <h2 class="section-main-title">Quy Trình Chăm Sóc 4 Bước Chuyên Nghiệp</h2>
                    <p class="section-subtitle">
                        Trực quan, minh bạch và nhẹ nhàng. Mỗi bé cưng đều được chăm sóc theo phác đồ riêng biệt để
                        luôn thoải mái như ở nhà.
                    </p>
                </div>

                <div class="process-timeline-grid">
                    <div class="process-step-card reveal-up">
                        <div class="process-step-top">
                            <span class="process-num-badge">01</span>
                            <span class="process-step-arrow" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </span>
                        </div>
                        <h3>Đặt lịch</h3>
                        <p>
                            Chọn gói dịch vụ, cơ sở Pet Care Spa gần bạn và khung giờ phù hợp chỉ trong 30 giây. Hệ
                            thống tự động giữ chỗ chuyên viên.
                        </p>
                        <span class="process-step-tag">&#10003; Giữ slot thực tế 100%</span>
                    </div>

                    <div class="process-step-card reveal-up">
                        <div class="process-step-top">
                            <span class="process-num-badge">02</span>
                            <span class="process-step-arrow" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </span>
                        </div>
                        <h3>Tiếp nhận thú cưng</h3>
                        <p>
                            Chuyên viên làm quen với bé, kiểm tra tình trạng da, độ dày lông, tai móng và tư vấn kiểu
                            cắt tỉa phù hợp nhất.
                        </p>
                        <span class="process-step-tag">&#10003; Tầm soát da lông miễn phí</span>
                    </div>

                    <div class="process-step-card reveal-up">
                        <div class="process-step-top">
                            <span class="process-num-badge">03</span>
                            <span class="process-step-arrow" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </span>
                        </div>
                        <h3>Grooming &amp; Spa</h3>
                        <p>
                            Thực hiện tắm thảo mộc hữu cơ, massage thư giãn, sấy phồng êm ái không gây tiếng ồn và cắt
                            tỉa tạo kiểu tỉ mỉ.
                        </p>
                        <span class="process-step-tag">&#10003; Phòng kính quan sát trực tiếp</span>
                    </div>

                    <div class="process-step-card reveal-up">
                        <div class="process-step-top">
                            <span class="process-num-badge">04</span>
                            <span class="process-step-arrow" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </span>
                        </div>
                        <h3>Bàn giao &amp; Thanh toán</h3>
                        <p>
                            Xịt dưỡng nước hoa dịu nhẹ, chụp ảnh lưu vào hồ sơ thành viên, bàn giao bé cho chủ nuôi và
                            thanh toán minh bạch.
                        </p>
                        <span class="process-step-tag">&#10003; Bảo hành form tỉa 48 giờ</span>
                    </div>
                </div>

                <div class="commitment-strip reveal-up">
                    <div class="commitment-left">
                        <div class="commitment-icon-wrap">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                        </div>
                        <div>
                            <strong>Cam kết linh hoạt tối đa cho Sen &amp; Boss</strong>
                            <span>Đặt lịch hoàn toàn không cần trả trước. Miễn phí đổi lịch hoặc hủy hẹn trước 2 giờ mà không phát sinh chi phí.</span>
                        </div>
                    </div>
                    <button type="button" class="btn-card-green" data-open-booking="Grooming & Tắm Sấy Thảo Mộc Toàn Diện">
                        <span>Đặt lịch giữ chỗ ngay</span>
                    </button>
                </div>

                <!-- 2 Quick Portal Cards connecting to Dedicated Branches Page & Dedicated Services Page -->
                <div class="home-portal-banners reveal-up">
                    <div class="portal-banner-card mint-theme">
                        <div>
                            <span class="section-eyebrow" style="margin-bottom:8px;">CHUYÊN TRANG CƠ SỞ SPA</span>
                            <h3>Giới Thiệu &amp; Hệ Thống Cơ Sở Pet care</h3>
                            <p>
                                Tham quan không gian phòng Grooming vách kính 360°, khu sục bồn Ozone, phòng lưu trú VIP
                                và tìm địa chỉ chi nhánh Pet care Spa gần bạn nhất tại TP.HCM &amp; Hà Nội.
                            </p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/branches.jsp" class="btn-card-green">
                                <span>Khám phá Hệ thống Cơ sở &rarr;</span>
                            </a>
                        </div>
                    </div>

                    <div class="portal-banner-card">
                        <div>
                            <span class="section-eyebrow" style="margin-bottom:8px;">CHUYÊN TRANG BẢNG GIÁ</span>
                            <h3>Bảng Giá Chi Tiết Theo Cân Nặng</h3>
                            <p>
                                Tra cứu minh bạch toàn bộ 6 gói dịch vụ chăm sóc thú cưng và biểu phí niêm yết theo từng
                                mức cân nặng (&lt;5kg, 5&ndash;10kg, 10&ndash;20kg, &gt;20kg).
                            </p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/services.jsp" class="btn-secondary-hero" style="height:46px;padding:0 20px;">
                                <span>Xem Bảng giá &amp; Dịch vụ &rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             7. MEMBER LOOKUP & PERSONALIZED SPACE ("Tra cứu & Hướng dẫn")
             ================================================================ -->
        <section id="quyen-loi-section" class="member-space-section">
            <div class="container">
                <div class="section-split-head reveal-up">
                    <div>
                        <span class="section-eyebrow">TRA CỨU &amp; QUYỀN LỢI THÀNH VIÊN</span>
                        <h2 class="section-main-title">Hồ Sơ Bé Cưng &amp; Quản Lý Lịch Chăm Sóc</h2>
                        <p class="section-subtitle">
                            Đăng ký chỉ mất 30 giây bằng số điện thoại để lưu trữ lịch sử làm đẹp và thói quen riêng của bé.
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/register" class="btn-card-green">Đăng ký tài khoản miễn phí</a>
                </div>

                <div class="member-showcase-grid">
                    <article class="personal-card reveal-up">
                        <div class="personal-card-top">
                            <span class="personal-icon-lg">
                                <svg width="25" height="25" viewBox="0 0 24 24" fill="currentColor">
                                    <circle cx="7" cy="7.5" r="2.2"/>
                                    <circle cx="12" cy="5.5" r="2.2"/>
                                    <circle cx="17" cy="7.5" r="2.2"/>
                                    <circle cx="19.5" cy="12" r="2"/>
                                    <circle cx="4.5" cy="12" r="2"/>
                                    <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                                </svg>
                            </span>
                            <span class="status-pill">Chế độ Khách &bull; Chưa liên kết</span>
                        </div>

                        <h3>Lưu trữ sổ tay làm đẹp riêng cho bé</h3>
                        <p>
                            Tạo tài khoản ngay để lưu kích thước lông, giống loài, phong cách cắt tỉa yêu thích,
                            tính cách nhút nhát hay thói quen khi tắm sấy để chuyên viên chăm sóc tốt nhất.
                        </p>

                        <div class="mini-feature-boxes">
                            <div class="mini-feature-box">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <circle cx="6" cy="6" r="3"></circle>
                                    <circle cx="6" cy="18" r="3"></circle>
                                    <line x1="20" y1="4" x2="8.12" y2="15.88"></line>
                                    <line x1="14.47" y1="14.48" x2="20" y2="20"></line>
                                </svg>
                                <strong>Kiểu lông yêu thích</strong>
                                <span>Chờ kích hoạt</span>
                            </div>

                            <div class="mini-feature-box">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path>
                                </svg>
                                <strong>Liệu trình tắm sấy</strong>
                                <span>Chờ kích hoạt</span>
                            </div>

                            <div class="mini-feature-box">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                    <circle cx="12" cy="13" r="4"></circle>
                                </svg>
                                <strong>Album ảnh sau spa</strong>
                                <span>Chờ kích hoạt</span>
                            </div>
                        </div>

                        <div class="personal-card-actions">
                            <button type="button" class="btn-card-green" data-open-booking="Grooming & Tắm Sấy Thảo Mộc Toàn Diện">
                                <span>+ Tạo hồ sơ &amp; Đặt lịch hẹn</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/login" class="card-text-link">Đăng nhập đồng bộ lịch &rarr;</a>
                        </div>
                    </article>

                    <div class="benefits-stack">
                        <div class="benefit-row-card reveal-up">
                            <div class="benefit-icon-box">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                </svg>
                            </div>
                            <div>
                                <h3>Nhắc lịch chăm sóc &amp; Spa định kỳ</h3>
                                <p>
                                    Hệ thống tự động nhắc hẹn tắm sấy, cắt tỉa lông hoặc mài móng theo chu kỳ 2 &ndash; 3 tuần để bé cưng luôn sạch thơm rạng rỡ.
                                </p>
                            </div>
                        </div>

                        <div class="benefit-row-card reveal-up">
                            <div class="benefit-icon-box">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                    <polyline points="21 15 16 10 5 21"></polyline>
                                </svg>
                            </div>
                            <div>
                                <h3>Album làm đẹp &amp; hình ảnh bé cưng</h3>
                                <p>
                                    Lưu trữ toàn bộ ảnh chụp sắc nét trước và sau mỗi buổi Grooming tại studio của salon. Dễ dàng tải về bất kỳ lúc nào.
                                </p>
                            </div>
                        </div>

                        <div class="benefit-row-card reveal-up">
                            <div class="benefit-icon-box">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <div>
                                <h3>Ưu tiên giữ chỗ &amp; Đổi ca hẹn linh hoạt</h3>
                                <p>
                                    Thành viên được ưu tiên chọn chuyên viên Grooming yêu thích và đổi khung giờ hẹn trực tuyến miễn phí trước 2 tiếng.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             9. BOOKING CTA SECTION ("Đặt lịch chăm sóc cho bé ngay hôm nay")
             ================================================================ -->
        <section class="booking-cta-section">
            <div class="container">
                <div class="booking-cta-card reveal-up">
                    <div class="booking-cta-content">
                        <span class="cta-badge">ĐẶT LỊCH TRỰC TUYẾN NHANH CHÓNG</span>
                        <h2>Đặt lịch chăm sóc cho bé ngay hôm nay</h2>
                        <p>
                            Chọn dịch vụ, cơ sở và thời gian phù hợp chỉ trong vài bước. Đội ngũ chuyên viên Pet care luôn sẵn sàng đón tiếp bé cưng của bạn.
                        </p>
                        <div class="booking-cta-btns">
                            <button type="button" class="btn-cta-mint" data-open-booking="Grooming & Tắm Sấy Thảo Mộc Toàn Diện">
                                <span>Đặt lịch ngay</span>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </button>
                            <a href="${pageContext.request.contextPath}/register" class="btn-cta-outline-white">
                                Đăng ký tài khoản mới
                            </a>
                        </div>
                    </div>

                    <div class="booking-cta-white-box">
                        <h3>Đặc quyền khi đặt lịch trước</h3>
                        <p>Áp dụng tại toàn bộ hệ thống Pet care Spa</p>
                        <div class="cta-quick-highlights">
                            <div class="cta-quick-item">
                                <span class="check">&#10003;</span>
                                <span>Giữ chỗ chuyên viên 15 phút, không phải chờ đợi</span>
                            </div>
                            <div class="cta-quick-item">
                                <span class="check">&#10003;</span>
                                <span>Tặng gói kiểm tra da lông &amp; xịt dưỡng tinh dầu</span>
                            </div>
                            <div class="cta-quick-item">
                                <span class="check">&#10003;</span>
                                <span>Miễn phí đổi hoặc hủy lịch hẹn trước 2 giờ</span>
                            </div>
                        </div>
                        <button type="button" class="btn-cta-box-full" data-open-booking="Combo Chăm Sóc Toàn Diện & Lưu Trú VIP">
                            <span>Chọn khung giờ trống ngay &rarr;</span>
                        </button>
                    </div>
                </div>
            </div>
        </section>

    </main>

    <!-- ====================================================================
         10. SITE FOOTER
         ==================================================================== -->
    <footer class="site-footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <div class="footer-brand-row">
                        <span class="footer-brand-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo" />
                        </span>
                    </div>
                    <p class="footer-desc">
                        Hệ thống Salon &amp; Spa Chăm Sóc Thú Cưng Tiêu Chuẩn Cao Cấp. Mang đến trải nghiệm làm đẹp thư giãn, an toàn với mỹ phẩm thảo mộc organic 100%.
                    </p>
                    <div class="footer-socials" aria-label="Mạng xã hội">
                        <a href="#trang-chu" class="footer-social-link" aria-label="Facebook">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"></path>
                            </svg>
                        </a>
                        <a href="#trang-chu" class="footer-social-link" aria-label="Instagram">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect>
                                <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path>
                                <line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line>
                            </svg>
                        </a>
                        <a href="#trang-chu" class="footer-social-link" aria-label="Youtube">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M22.54 6.42a2.78 2.78 0 0 0-1.94-2C18.88 4 12 4 12 4s-6.88 0-8.6.46a2.78 2.78 0 0 0-1.94 2A29 29 0 0 0 1 11.75a29 29 0 0 0 .46 5.33A2.78 2.78 0 0 0 3.4 19c1.72.46 8.6.46 8.6.46s6.88 0 8.6-.46a2.78 2.78 0 0 0 1.94-2 29 29 0 0 0 .46-5.25 29 29 0 0 0-.46-5.33z"></path>
                                <polygon points="9.75 15.02 15.5 11.75 9.75 8.48 9.75 15.02"></polygon>
                            </svg>
                        </a>
                    </div>
                </div>

                <div class="footer-col">
                    <h4>Liên Kết &amp; Hỗ Trợ</h4>
                    <ul class="footer-links-list">
                        <li><a href="#trang-chu">Trang chủ</a></li>
                        <li><a href="#khong-gian-section">Hệ thống cơ sở Spa</a></li>
                        <li><a href="#quy-trinh-section">Quy trình chăm sóc 4 bước</a></li>
                        <li><a href="#quyen-loi-section">Quyền lợi thành viên</a></li>
                        <li><a href="#quy-trinh-section">Chính sách đổi lịch &amp; Bảo hành</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h4>Dịch Vụ Nổi Bật</h4>
                    <ul class="footer-links-list">
                        <li><a href="#bang-gia-section">Grooming &amp; Tắm sấy thảo mộc</a></li>
                        <li><a href="#bang-gia-section">Cắt tỉa tạo kiểu chuẩn Salon</a></li>
                        <li><a href="#bang-gia-section">Spa thảo dược &amp; Chăm sóc da</a></li>
                        <li><a href="#bang-gia-section">Vệ sinh tai, móng &amp; tuyến hôi</a></li>
                        <li><a href="#bang-gia-section">Combo chăm sóc &amp; Lưu trú VIP</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h4>Thông Tin Liên Hệ</h4>
                    <div class="footer-info-list">
                        <div class="footer-info-item">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            <div>
                                <strong>TP.HCM:</strong> 128 Nguyễn Đình Chiểu, Q.3
                            </div>
                        </div>
                        <div class="footer-info-item">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            <div>
                                <strong>Hà Nội:</strong> 45 Hoàng Cầu, Q. Đống Đa
                            </div>
                        </div>
                        <div class="footer-info-item">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ Nhật)</span>
                        </div>
                        <div class="footer-info-item">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                <polyline points="22,6 12,13 2,6"></polyline>
                            </svg>
                            <span>contact@petcare.vn &bull; 1900 6868</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <span>&copy; 2025 Pet care Pet Grooming &amp; Spa Salon. Toàn bộ quyền được bảo lưu.</span>
                <span class="footer-verified">&#10003; Chứng nhận Salon Grooming Chuyên Nghiệp Việt Nam</span>
            </div>
        </div>
    </footer>

    <!-- ====================================================================
         11. INTERACTIVE BOOKING MODAL
         ==================================================================== -->
    <div class="modal-backdrop ${bookingSuccess ? 'open' : ''}" id="bookingModal">
        <div class="booking-modal-box">
            <button type="button" class="modal-close-btn" id="closeModalBtn" aria-label="Đóng">&times;</button>
            <h3>Đặt Lịch Hẹn &amp; Giữ Chỗ Tại Pet care</h3>
            <p>Hệ thống tự động giữ chỗ chuyên viên 15 phút. Miễn phí đổi hoặc hủy hẹn trước 2 giờ.</p>

            <c:if test="${bookingSuccess}">
                <div class="booking-toast">
                    <strong>&#10003; Đã giữ chỗ 15 phút cho bé ${bookingData.petName}!</strong><br/>
                    Cảm ơn <b>${bookingData.ownerName}</b> (${bookingData.phone}). Hệ thống <b>Pet care</b> tại cơ sở
                    <b>${bookingData.branch}</b> đã ghi nhận lịch hẹn gói <b>${bookingData.serviceName}</b>.
                </div>
            </c:if>
            <div class="booking-toast" id="bookingSuccessStatic" style="display:none;"></div>

            <form action="${pageContext.request.contextPath}/dat-lich" method="post" id="petcareBookingForm">
                <div class="modal-form-grid">
                    <div class="modal-field">
                        <label for="ownerName">Họ và tên Sen *</label>
                        <input type="text" id="ownerName" name="ownerName" class="modal-input" placeholder="Nguyễn Thảo My" required />
                    </div>
                    <div class="modal-field">
                        <label for="phone">Số điện thoại / Zalo *</label>
                        <input type="tel" id="phone" name="phone" class="modal-input" placeholder="0912 345 678" required />
                    </div>
                    <div class="modal-field">
                        <label for="petName">Tên bé cưng *</label>
                        <input type="text" id="petName" name="petName" class="modal-input" placeholder="Miu, Bơ, Mây..." required />
                    </div>
                    <div class="modal-field">
                        <label for="petType">Giống loài &amp; Cân nặng *</label>
                        <select id="petType" name="petType" class="modal-input">
                            <option value="Chó (2 - 5 kg)">Chó (2 - 5 kg)</option>
                            <option value="Mèo (2 - 5 kg)">Mèo (2 - 5 kg)</option>
                            <option value="Chó (5 - 12 kg)">Chó (5 - 12 kg)</option>
                            <option value="Chó (> 12 kg)">Chó (&gt; 12 kg)</option>
                        </select>
                    </div>
                    <div class="modal-field full">
                        <label for="modalServiceName">Gói dịch vụ chăm sóc *</label>
                        <select id="modalServiceName" name="serviceName" class="modal-input">
                            <option value="Grooming & Tắm Sấy Thảo Mộc Toàn Diện (150.000 đ)">Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện (150.000 đ)</option>
                            <option value="Cắt Tỉa Tạo Kiểu Chuẩn Salon (280.000 đ)">Cắt Tỉa Tạo Kiểu Chuẩn Salon (280.000 đ)</option>
                            <option value="Spa Thảo Dược & Phục Hồi Da Lông (350.000 đ)">Spa Thảo Dược &amp; Phục Hồi Da Lông (350.000 đ)</option>
                            <option value="Vệ Sinh Tai, Móng & Tuyến Hôi Chuyên Sâu (120.000 đ)">Vệ Sinh Tai, Móng &amp; Tuyến Hôi Chuyên Sâu (120.000 đ)</option>
                            <option value="Kiểm Tra Sức Khỏe Cơ Bản & Gỡ Rối Lông (180.000 đ)">Kiểm Tra Sức Khỏe Cơ Bản &amp; Gỡ Rối Lông (180.000 đ)</option>
                            <option value="Combo Chăm Sóc Toàn Diện & Lưu Trú VIP (390.000 đ)">Combo Chăm Sóc Toàn Diện &amp; Lưu Trú VIP (390.000 đ)</option>
                        </select>
                    </div>
                    <div class="modal-field">
                        <label for="branch">Chi nhánh Salon Pet care *</label>
                        <select id="branch" name="branch" class="modal-input">
                            <option value="128 Nguyễn Đình Chiểu, Q.3, TP.HCM">128 Nguyễn Đình Chiểu, Q.3, TP.HCM</option>
                            <option value="45 Hoàng Cầu, Đống Đa, Hà Nội">45 Hoàng Cầu, Đống Đa, Hà Nội</option>
                        </select>
                    </div>
                    <div class="modal-field">
                        <label for="timeSlot">Khung giờ hẹn *</label>
                        <select id="timeSlot" name="timeSlot" class="modal-input">
                            <option value="09:00 - 10:30">09:00 - 10:30</option>
                            <option value="10:30 - 12:00">10:30 - 12:00</option>
                            <option value="14:00 - 15:30">14:00 - 15:30</option>
                            <option value="16:00 - 17:30">16:00 - 17:30</option>
                            <option value="18:00 - 19:30">18:00 - 19:30</option>
                        </select>
                    </div>
                    <div class="modal-field full">
                        <label for="notes">Lưu ý tính cách / thói quen của bé</label>
                        <textarea id="notes" name="notes" class="modal-input" placeholder="Ví dụ: Bé hơi nhát máy sấy, thích cắt form Teddy tròn..."></textarea>
                    </div>
                </div>
                <button type="submit" class="btn-modal-submit">Xác nhận đặt lịch &amp; Giữ chỗ 15 phút</button>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>
