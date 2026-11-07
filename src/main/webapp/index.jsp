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
    <title>Pet care - Hệ thống Dịch vụ Chăm sóc &amp; Spa Thú Cưng Hàng Đầu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
</head>
<body>

    <!-- ====================================================================
         1. TOP HEADER / NAVBAR
         ==================================================================== -->
    <header class="site-header">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand-wrap">
                <span class="brand-icon-box" aria-hidden="true">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                        <circle cx="7" cy="7.5" r="2.2"/>
                        <circle cx="12" cy="5.5" r="2.2"/>
                        <circle cx="17" cy="7.5" r="2.2"/>
                        <circle cx="19.5" cy="12" r="2"/>
                        <circle cx="4.5" cy="12" r="2"/>
                        <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                    </svg>
                </span>
                <span class="brand-text-col">
                    <span class="brand-title-row">
                        Pet care
                        <span class="brand-heart" aria-hidden="true">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            </svg>
                        </span>
                    </span>
                    <span class="brand-sub">Hệ thống Dịch vụ Chăm sóc &amp; Spa Thú Cưng Hàng Đầu</span>
                </span>
            </a>

            <nav class="main-nav" aria-label="Điều hướng chính">
                <a href="#trang-chu" class="active">Trang chủ</a>
                <a href="#khong-gian-section">Giới thiệu &amp; Cơ sở</a>
                <a href="#bang-gia-section">Bảng giá &amp; Dịch vụ</a>
                <a href="#quy-trinh-section">Quy trình chăm sóc</a>
                <a href="#quyen-loi-section">Tra cứu &amp; Hướng dẫn</a>
            </nav>

            <div class="header-auth-actions">
                <button type="button" class="btn-login-outline" data-open-booking="Đăng nhập">Đăng nhập</button>
                <button type="button" class="btn-register-solid" data-open-booking="Đăng ký tài khoản">Đăng ký tài khoản</button>
                <button type="button" class="btn-user-avatar" aria-label="Tài khoản" data-open-booking="Hồ sơ">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </button>
            </div>
        </div>
    </header>

    <!-- ====================================================================
         2. GUEST MODE NOTIFICATION BAR
         ==================================================================== -->
    <div class="guest-alert-bar">
        <div class="container guest-alert-inner">
            <div class="guest-alert-text">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
                <span>
                    <strong>Bạn đang duyệt ở chế độ Khách (Chưa đăng nhập).</strong>
                    Hãy đăng nhập hoặc tạo tài khoản để tự động lưu lịch chăm sóc định kỳ.
                </span>
            </div>
            <div class="guest-alert-btns">
                <button type="button" class="btn-guest-white" data-open-booking="Đăng nhập">Đăng nhập ngay</button>
                <button type="button" class="btn-guest-green" data-open-booking="Tạo tài khoản">Tạo tài khoản miễn phí</button>
            </div>
        </div>
    </div>

    <main id="trang-chu">

        <!-- ================================================================
             3. HERO SECTION
             ================================================================ -->
        <section class="hero-section">
            <div class="hero-glow-mint"></div>
            <div class="hero-glow-peach"></div>

            <div class="container hero-grid">
                <div class="hero-left">
                    <div class="hero-pill-badge">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2l2.4 2.1 3.1-.4 1.2 2.9 2.9 1.2-.4 3.1L23.3 13l-2.1 2.4.4 3.1-2.9 1.2-1.2 2.9-3.1-.4L12 24.3l-2.4-2.1-3.1.4-1.2-2.9-2.9-1.2.4-3.1L.7 13l2.1-2.4-.4-3.1 2.9-1.2 1.2-2.9 3.1.4L12 2zm-1.2 13.6l5.4-5.4-1.4-1.4-4 4-2-2-1.4 1.4 3.4 3.4z"/>
                        </svg>
                        CỔNG THÀNH VIÊN VÀ ĐẶT LỊCH SPA GROOMING PET CARE
                    </div>

                    <h1 class="hero-title">
                        Dịch Vụ Chăm Sóc &amp; Spa Thú Cưng<br />
                        <span class="highlight-underline">Chuyên Nghiệp Tận Tâm</span>
                    </h1>

                    <p class="hero-desc">
                        Trải nghiệm dịch vụ chăm sóc thú cưng toàn diện: tắm sấy thảo mộc thơm mát, cắt tỉa tạo
                        kiểu lông xinh xắn và chăm sóc tận tình với đội ngũ chuyên viên Grooming chuyên nghiệp,
                        yêu thương thú cưng hết lòng.
                    </p>

                    <div class="hero-cta-row">
                        <button type="button" class="btn-hero-primary" data-open-booking="Tắm Spa Thảo Mộc & Vệ Sinh Toàn Diện">
                            <span>Đăng ký thành viên mới</span>
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </button>

                        <button type="button" class="btn-hero-secondary" data-open-booking="Đăng nhập">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                                <polyline points="10 17 15 12 10 7"></polyline>
                                <line x1="15" y1="12" x2="3" y2="12"></line>
                            </svg>
                            <span>Đăng nhập tài khoản</span>
                        </button>
                    </div>

                    <div class="hero-gift-strip">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <polyline points="20 12 20 22 4 22 4 12"></polyline>
                            <rect x="2" y="7" width="20" height="5"></rect>
                            <line x1="12" y1="22" x2="12" y2="7"></line>
                            <path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"></path>
                            <path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"></path>
                        </svg>
                        <span>Tặng ngay 100 PetPoints &amp; Miễn phí dịch vụ sấy thơm khử mùi cho lần đầu ghé thăm!</span>
                    </div>

                    <div class="hero-stats-row">
                        <div class="hero-stat-card">
                            <span class="stat-icon-box mint">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                                    <circle cx="7" cy="7.5" r="2.1"/>
                                    <circle cx="12" cy="5.5" r="2.1"/>
                                    <circle cx="17" cy="7.5" r="2.1"/>
                                    <circle cx="19" cy="12" r="1.8"/>
                                    <circle cx="5" cy="12" r="1.8"/>
                                    <path d="M12 11.5c-3 0-5.5 2.1-5.5 4.8 0 1.8 1.5 3.2 3.3 3.2.9 0 1.5-.3 2.2-.3s1.3.3 2.2.3c1.8 0 3.3-1.4 3.3-3.2 0-2.7-2.5-4.8-5.5-4.8z"/>
                                </svg>
                            </span>
                            <div>
                                <strong>15.000+ Thú cưng</strong>
                                <span>Được chăm sóc chu đáo</span>
                            </div>
                        </div>

                        <div class="hero-stat-card">
                            <span class="stat-icon-box sky">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <circle cx="6" cy="6" r="3"></circle>
                                    <circle cx="6" cy="18" r="3"></circle>
                                    <line x1="20" y1="4" x2="8.12" y2="15.88"></line>
                                    <line x1="14.47" y1="14.48" x2="20" y2="20"></line>
                                    <line x1="8.12" y1="8.12" x2="12" y2="12"></line>
                                </svg>
                            </span>
                            <div>
                                <strong>Pro Groomer</strong>
                                <span>Chứng chỉ tạo kiểu quốc tế</span>
                            </div>
                        </div>

                        <div class="hero-stat-card">
                            <span class="stat-icon-box peach">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path>
                                </svg>
                            </span>
                            <div>
                                <strong>Organic 100%</strong>
                                <span>Phòng spa thơm mát, sạch khuẩn</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="hero-right">
                    <div class="hero-visual-card">
                        <img src="${pageContext.request.contextPath}/assets/images/hero-petcare-spa.jpg" alt="Salon Chăm Sóc & Khách Sạn Thú Cưng Pet care" />
                        <div class="hero-visual-overlay">
                            <div class="hero-ready-tag">
                                <span class="ready-dot"></span>
                                <span>Chuyên viên Spa &amp; Grooming Sẵn Sàng</span>
                            </div>
                            <h3>Salon Chăm Sóc &amp; Khách Sạn Thú Cưng Pet care</h3>
                            <p>Cơ sở 128 Nguyễn Đình Chiểu, Q.3, TP.HCM &amp; 45 Hoàng Cầu, Đống Đa, HN</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. PERSONALIZED SPACE SECTION (KHÔNG GIAN CÁ NHÂN HÓA)
             ================================================================ -->
        <section id="khong-gian-section" class="personal-section">
            <div class="container">
                <div class="section-split-head">
                    <div>
                        <span class="section-eyebrow eyebrow-green">KHÔNG GIAN CÁ NHÂN HÓA</span>
                        <h2 class="section-main-title">Hồ Sơ Bé Cưng &amp; Quản Lý Lịch Chăm Sóc Của Bạn</h2>
                    </div>
                    <p class="section-head-note">
                        Chế độ khách tạm khóa tính năng đồng bộ. Mở tài khoản để lưu kích thước lông,
                        sở thích làm đẹp và theo dõi lịch spa trực tuyến.
                    </p>
                </div>

                <div class="personal-cards-grid">
                    <!-- Left Card -->
                    <article class="personal-card">
                        <div class="personal-card-top">
                            <span class="personal-icon-lg green">
                                <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor">
                                    <circle cx="7" cy="7.5" r="2.2"/>
                                    <circle cx="12" cy="5.5" r="2.2"/>
                                    <circle cx="17" cy="7.5" r="2.2"/>
                                    <circle cx="19.5" cy="12" r="2"/>
                                    <circle cx="4.5" cy="12" r="2"/>
                                    <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                                </svg>
                            </span>
                            <span class="status-pill-peach">Chưa liên kết</span>
                        </div>

                        <h3>Bạn chưa có hồ sơ thú cưng nào</h3>
                        <p>
                            Tạo tài khoản ngay để lưu kích thước lông, giống loài, phong cách cắt tỉa yêu thích,
                            tính cách nhút nhát hay thói quen khi tắm sấy để chuyên viên chăm sóc tốt nhất.
                        </p>

                        <div class="mini-feature-boxes">
                            <div class="mini-feature-box">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <circle cx="6" cy="6" r="3"></circle>
                                    <circle cx="6" cy="18" r="3"></circle>
                                    <line x1="20" y1="4" x2="8.12" y2="15.88"></line>
                                    <line x1="14.47" y1="14.48" x2="20" y2="20"></line>
                                </svg>
                                <strong>Kiểu lông yêu thích</strong>
                                <span>Chờ kích hoạt</span>
                            </div>

                            <div class="mini-feature-box">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path>
                                </svg>
                                <strong>Liệu trình tắm sấy</strong>
                                <span>Chờ kích hoạt</span>
                            </div>

                            <div class="mini-feature-box">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                    <circle cx="12" cy="13" r="4"></circle>
                                </svg>
                                <strong>Album ảnh bé sau spa</strong>
                                <span>Chờ kích hoạt</span>
                            </div>
                        </div>

                        <div class="personal-card-actions">
                            <button type="button" class="btn-card-green" data-open-booking="Tạo hồ sơ bé cưng">
                                <span>+ Tạo hồ sơ bé cưng (Cần đăng nhập)</span>
                            </button>
                            <a href="#bang-gia-section" class="card-text-link">Xem mẫu hồ sơ chăm sóc &gt;</a>
                        </div>
                    </article>

                    <!-- Right Card -->
                    <article class="personal-card">
                        <div class="personal-card-top">
                            <span class="personal-icon-lg amber">
                                <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </span>
                            <span class="status-pill-slate">0 Lịch hẹn đang chạy</span>
                        </div>

                        <h3>Chưa có lịch hẹn nào đang diễn ra</h3>
                        <p>
                            Bạn đang ở chế độ duyệt Khách. Hãy đăng nhập để quản lý lịch hẹn spa, cắt tỉa lông,
                            tắm sấy hoặc gửi nội trú khách sạn, đổi ca hẹn miễn phí trước 2 tiếng.
                        </p>

                        <div class="personal-card-actions">
                            <button type="button" class="btn-card-green" data-open-booking="Đăng nhập đồng bộ lịch">
                                <span>Đăng nhập đồng bộ lịch</span>
                            </button>
                            <a href="#bang-gia-section" class="card-text-link green">Xem dịch vụ và bảng giá &darr;</a>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- ================================================================
             5. SERVICES & PRICING SECTION (BẢNG GIÁ MINH BẠCH 100%)
             ================================================================ -->
        <section id="bang-gia-section" class="services-pricing-section">
            <div class="container">
                <div class="section-split-head">
                    <div>
                        <span class="section-eyebrow eyebrow-green">BẢNG GIÁ MINH BẠCH 100%</span>
                        <h2 class="section-main-title">Dịch Vụ Chăm Sóc &amp; Làm Đẹp Thú Cưng</h2>
                        <p class="section-head-note" style="max-width: 620px; margin-top: 6px;">
                            Không phụ phí ẩn. Toàn bộ sữa tắm dưỡng lông, tinh dầu thảo mộc và phụ kiện đều minh bạch rõ ràng.
                        </p>
                    </div>

                    <div class="filter-tabs-bar" role="tablist">
                        <button type="button" class="filter-tab-btn active" data-filter="all">Tất cả dịch vụ</button>
                        <button type="button" class="filter-tab-btn" data-filter="tam-spa">Tắm &amp; Spa Vệ Sinh</button>
                        <button type="button" class="filter-tab-btn" data-filter="grooming">Grooming &amp; Cắt Tỉa</button>
                        <button type="button" class="filter-tab-btn" data-filter="khach-san">Khách Sạn &amp; Nội Trú</button>
                    </div>
                </div>

                <div class="services-cards-grid">
                    <c:forEach var="srv" items="${services}">
                        <article class="service-price-card" data-category="${srv.category}">
                            <div class="spc-top-row">
                                <span class="spc-badge ${srv.badgeTheme}">${srv.badgeText}</span>
                                <span class="spc-rating">&#9733; ${srv.ratingText}</span>
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
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <span>Đặt lịch ngay</span>
                                </button>
                            </div>
                        </article>
                    </c:forEach>

                    <!-- Card 6: Featured Combo Card -->
                    <article class="combo-featured-card" data-category="all">
                        <div class="combo-top-row">
                            <span class="combo-pill">Combo Làm Đẹp Tiết Kiệm</span>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M12 2l2.2 6.2L20.4 10l-6.2 2.2L12 18.4l-2.2-6.2L3.6 10l6.2-1.8L12 2z"/>
                            </svg>
                        </div>

                        <h3>Đặt Lịch Combo Spa &amp; Grooming Trọn Gói</h3>
                        <p>
                            Gói tắm thảo mộc kết hợp cắt tỉa form chuẩn tiết kiệm đến 20%,
                            tặng kèm sấy tinh dầu thơm tho lâu ngày.
                        </p>

                        <div class="combo-hotline-box">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#FFDCC5" stroke-width="2.2">
                                <path d="M3 18v-6a9 9 0 0 1 18 0v6"></path>
                                <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"></path>
                            </svg>
                            <div>
                                <small>Hotline đặt lịch &amp; tư vấn kiểu dáng:</small>
                                <strong>1900 8899 (Nhánh 1)</strong>
                            </div>
                        </div>

                        <button type="button" class="btn-combo-white" data-open-booking="Combo Spa & Grooming Trọn Gói">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span>Đặt hẹn combo làm đẹp ngay</span>
                        </button>
                    </article>
                </div>
            </div>
        </section>

        <!-- ================================================================
             6. 4-STEP BOOKING PROCESS SECTION
             ================================================================ -->
        <section id="quy-trinh-section" class="steps-section">
            <div class="container">
                <div class="section-header-center">
                    <span class="section-eyebrow eyebrow-amber">THAO TÁC THUẬN TIỆN &amp; NHANH CHÓNG</span>
                    <h2 class="section-main-title">Đặt Lịch Hẹn Dễ Dàng Chỉ Với 4 Bước</h2>
                    <p>
                        Giao diện tối ưu cho người bận rộn. Bạn hoàn toàn có thể kiểm tra lịch trống
                        và giữ slot trước khi đến cơ sở.
                    </p>
                </div>

                <div class="steps-4-grid">
                    <div class="step-item-card">
                        <div class="step-num-box mint">1</div>
                        <h3>Thêm thông tin bé</h3>
                        <p>
                            Nhập tên bé, giống loài (Chó / Mèo), cân nặng và lưu ý thói quen/tính cách để kỹ thuật viên
                            chuẩn bị phòng tắm phù hợp.
                        </p>
                        <div class="step-foot-pill green">
                            <span>&#10003; Tự lưu nếu đã đăng nhập</span>
                        </div>
                    </div>

                    <div class="step-item-card">
                        <div class="step-num-box peach">2</div>
                        <h3>Chọn gói chăm sóc</h3>
                        <p>
                            Tùy chọn Tắm spa thảo mộc, Grooming cắt tỉa tạo kiểu, Cạo lông hay Khách sạn thú cưng
                            theo mong muốn của bạn.
                        </p>
                        <div class="step-foot-pill amber">
                            <span>&#9733; Báo giá minh bạch tức thì</span>
                        </div>
                    </div>

                    <div class="step-item-card">
                        <div class="step-num-box sky">3</div>
                        <h3>Chọn khung giờ trống</h3>
                        <p>
                            Tra cứu slot bàn tắm/cắt tỉa còn trống trong tuần, chọn chi nhánh salon gần bạn nhất
                            và đặt giờ tiện lợi.
                        </p>
                        <div class="step-foot-pill sky">
                            <span>&#128197; Lịch trống thực tế 100%</span>
                        </div>
                    </div>

                    <div class="step-item-card">
                        <div class="step-num-box emerald">4</div>
                        <h3>Tạm giữ chỗ 15 phút</h3>
                        <p>
                            Hệ thống tự động khóa lịch chuyên viên cho bé trong 15 phút, bạn có thể thong thả
                            đến đúng giờ mà không phải đợi lâu.
                        </p>
                        <div class="step-foot-pill green">
                            <span>&#9201; Nhận mã QR check-in quầy</span>
                        </div>
                    </div>
                </div>

                <div class="commitment-strip">
                    <div class="commitment-left">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            <polyline points="9 12 11 14 15 10"></polyline>
                        </svg>
                        <div>
                            <strong>Cam kết linh hoạt tối đa cho Sen &amp; Boss</strong>
                            <span>Đặt lịch hoàn toàn không cần trả trước. Miễn phí đổi lịch hoặc hủy hẹn trước 2 giờ mà không phát sinh chi phí.</span>
                        </div>
                    </div>
                    <button type="button" class="btn-card-green" data-open-booking="Tắm Spa Thảo Mộc & Vệ Sinh Toàn Diện">
                        Thử đặt lịch ngay
                    </button>
                </div>
            </div>
        </section>

        <!-- ================================================================
             7. MEMBER BENEFITS SECTION (TẠI SAO BẠN NÊN MỞ TÀI KHOẢN PET CARE?)
             ================================================================ -->
        <section id="quyen-loi-section" class="benefits-section">
            <div class="container">
                <div class="section-split-head">
                    <div>
                        <span class="section-eyebrow eyebrow-green">QUYỀN LỢI THÀNH VIÊN</span>
                        <h2 class="section-main-title">Tại Sao Bạn Nên Mở Tài Khoản Pet care?</h2>
                        <p class="section-head-note" style="max-width: 560px; margin-top: 6px;">
                            Đăng ký chỉ mất 30 giây bằng số điện thoại, mở khóa trọn đời hệ sinh thái chăm sóc chuẩn quốc tế.
                        </p>
                    </div>
                    <button type="button" class="btn-card-green" data-open-booking="Đăng ký tài khoản miễn phí">
                        Đăng ký tài khoản miễn phí
                    </button>
                </div>

                <div class="benefits-4-grid">
                    <div class="benefit-card">
                        <div class="benefit-icon-box mint">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                            </svg>
                        </div>
                        <h3>Lịch chăm sóc &amp; Spa định kỳ</h3>
                        <p>
                            Nhắc hẹn tắm sấy, cắt tỉa lông hoặc bấm móng tự động theo chu kỳ 2 - 3 tuần
                            để bé cưng luôn sạch thơm rạng rỡ.
                        </p>
                        <div class="benefit-foot green">&#10003; Tích hợp qua Zalo OA &amp; SMS</div>
                    </div>

                    <div class="benefit-card">
                        <div class="benefit-icon-box emerald">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                        </div>
                        <h3>Album làm đẹp &amp; hình ảnh bé cưng</h3>
                        <p>
                            Lưu trữ toàn bộ ảnh chụp xinh xắn trước và sau khi làm đẹp của bé sau mỗi buổi spa.
                            Tải về máy sắc nét bất kỳ lúc nào.
                        </p>
                        <div class="benefit-foot green">&#10003; Lưu trữ vĩnh viễn chất lượng cao</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             8. BOTTOM GREEN CTA BANNER
             ================================================================ -->
        <section class="cta-bottom-banner">
            <div class="container cta-bottom-inner">
                <div class="cta-bottom-text">
                    <h2>Bắt Đầu Chăm Sóc &amp; Làm Đẹp Bé Cưng Ngay Hôm Nay</h2>
                    <p>
                        Đăng ký miễn phí trong 30 giây. Nhận ngay quyền lợi ưu tiên slot spa và
                        lưu giữ album làm đẹp trọn đời cho thú cưng của bạn.
                    </p>
                </div>
                <div class="cta-bottom-actions">
                    <button type="button" class="btn-cta-white" data-open-booking="Đăng ký tài khoản mới">
                        Đăng ký tài khoản mới
                    </button>
                    <button type="button" class="btn-cta-outline" data-open-booking="Đăng nhập">
                        Đã có tài khoản? Đăng nhập
                    </button>
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
                        <span class="brand-icon-box" style="width:34px;height:34px;border-radius:9px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                                <circle cx="7" cy="7.5" r="2.2"/>
                                <circle cx="12" cy="5.5" r="2.2"/>
                                <circle cx="17" cy="7.5" r="2.2"/>
                                <circle cx="19.5" cy="12" r="2"/>
                                <circle cx="4.5" cy="12" r="2"/>
                                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                            </svg>
                        </span>
                        <span>Pet care</span>
                    </div>
                    <p class="footer-desc">
                        Hệ thống Salon &amp; Spa Chăm Sóc Thú Cưng Tiêu Chuẩn Cao Cấp. Mang đến trải nghiệm
                        làm đẹp thư giãn tuyệt vời, lông mềm mượt thơm lâu với mỹ phẩm thảo mộc organic 100%.
                    </p>
                    <div class="footer-cert-badges">
                        <span class="footer-cert-pill">&#10003; Pro Grooming Certified</span>
                        <span class="footer-cert-pill">&#127807; 100% Organic Products</span>
                    </div>
                </div>

                <div class="footer-col">
                    <h4>Hệ Thống Cơ Sở</h4>
                    <div class="footer-info-list">
                        <div class="footer-info-item">
                            <span>&#128205;</span>
                            <div>
                                <strong>Cơ sở TP. Hồ Chí Minh:</strong>
                                <span>128 Nguyễn Đình Chiểu, Phường Võ Thị Sáu, Quận 3</span>
                            </div>
                        </div>
                        <div class="footer-info-item">
                            <span>&#128205;</span>
                            <div>
                                <strong>Cơ sở Hà Nội:</strong>
                                <span>45 Hoàng Cầu, Phường Ô Chợ Dừa, Quận Đống Đa</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="footer-col">
                    <h4>Giờ Hoạt Động &amp; Hotline</h4>
                    <div class="footer-info-list">
                        <div class="footer-info-item">
                            <span>&#128337;</span>
                            <span>Dịch vụ Spa &amp; Salon: 08:00 - 20:30 (Thứ 2 - CN)</span>
                        </div>
                        <div class="footer-info-item">
                            <span>&#127911;</span>
                            <div>
                                <strong class="amber">Tư vấn Grooming &amp; Đặt lịch:</strong>
                                <span>Hotline: 1900 8899 - Máy lẻ 1</span>
                            </div>
                        </div>
                        <div class="footer-info-item">
                            <span>&#9993;</span>
                            <span>contact@petcare.vn</span>
                        </div>
                    </div>
                </div>

                <div class="footer-col">
                    <h4>Quy Chuẩn &amp; Dịch Vụ</h4>
                    <ul class="footer-links-list">
                        <li><a href="#bang-gia-section">Chính sách bảo mật</a></li>
                        <li><a href="#bang-gia-section">Quy chuẩn vệ sinh salon</a></li>
                        <li><a href="#bang-gia-section">Cam kết bảo hành form tỉa</a></li>
                        <li><a href="#quy-trinh-section">Chính sách đổi lịch hẹn</a></li>
                    </ul>
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
                    <strong>Đã giữ chỗ 15 phút cho bé ${bookingData.petName}!</strong>
                    Cảm ơn <b>${bookingData.ownerName}</b> (${bookingData.phone}). Salon <b>Pet care</b> tại
                    <b>${bookingData.branch}</b> đã ghi nhận lịch <b>${bookingData.serviceName}</b>.
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
                            <option value="Tắm Spa Thảo Mộc & Vệ Sinh Toàn Diện (150.000 đ)">Tắm Spa Thảo Mộc &amp; Vệ Sinh Toàn Diện (150.000 đ)</option>
                            <option value="Grooming & Cắt Tỉa Lông Tạo Kiểu (280.000 đ)">Grooming &amp; Cắt Tỉa Lông Tạo Kiểu (280.000 đ)</option>
                            <option value="Spa Cắt Tỉa & Nhuộm Lông Thẩm Mỹ Cao Cấp (350.000 đ)">Spa Cắt Tỉa &amp; Nhuộm Lông Thẩm Mỹ Cao Cấp (350.000 đ)</option>
                            <option value="Cạo Lông Mát Mẻ & Phục Hồi Lông Rối (180.000 đ)">Cạo Lông Mát Mẻ &amp; Phục Hồi Lông Rối (180.000 đ)</option>
                            <option value="Khách Sạn Thú Cưng Lưu Trú VIP (200.000 đ/ngày)">Khách Sạn Thú Cưng Lưu Trú VIP (200.000 đ/ngày)</option>
                            <option value="Combo Spa & Grooming Trọn Gói (-20%)">Combo Spa &amp; Grooming Trọn Gói (-20%)</option>
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
