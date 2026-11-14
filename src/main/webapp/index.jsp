<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcare.controller.HomeServlet" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=15" />
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
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <div class="header-user-wrap">
                            <div class="header-user-trigger">
                                <a href="${pageContext.request.contextPath}/profile" class="header-user-pill">
                                    <span class="header-user-avatar-circle">
                                        ${fn:toUpperCase(fn:substring(fn:trim(sessionScope.loggedInUser), 0, 1))}
                                    </span>
                                    <span class="header-user-info">
                                        <span class="header-user-name">${sessionScope.loggedInUser}</span>
                                        <span class="header-user-role-tag">
                                            <c:choose>
                                                <c:when test="${sessionScope.loggedInRole == 'ADMIN'}">Quản trị viên</c:when>
                                                <c:when test="${sessionScope.loggedInRole == 'STAFF'}">Nhân viên</c:when>
                                                <c:otherwise>Thành viên</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </span>
                                    <svg class="header-user-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                        <polyline points="6 9 12 15 18 9"></polyline>
                                    </svg>
                                </a>

                                <div class="header-user-dropdown">
                                    <div class="dropdown-user-head">
                                        <span class="dropdown-user-avatar">
                                            ${fn:toUpperCase(fn:substring(fn:trim(sessionScope.loggedInUser), 0, 1))}
                                        </span>
                                        <div class="dropdown-user-meta">
                                            <strong>${sessionScope.loggedInUser}</strong>
                                            <span>Mã TV #${sessionScope.loggedInUserId} &bull; ${sessionScope.loggedInRole}</span>
                                        </div>
                                    </div>

                                    <div class="dropdown-meta-list">
                                        <div class="dropdown-meta-row">
                                            <span>Mã tài khoản</span>
                                            <strong>#${sessionScope.loggedInUserId}</strong>
                                        </div>
                                        <div class="dropdown-meta-row">
                                            <span>Điện thoại</span>
                                            <strong>${sessionScope.loggedInPhone}</strong>
                                        </div>
                                        <div class="dropdown-meta-row">
                                            <span>Email</span>
                                            <strong>${sessionScope.loggedInEmail}</strong>
                                        </div>
                                    </div>

                                    <div class="dropdown-menu-actions">
                                        <a href="${pageContext.request.contextPath}/profile" class="dropdown-menu-link">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                            <span>Hồ sơ &amp; Đổi mật khẩu</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-menu-link logout-link">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                                <polyline points="16 17 21 12 16 7"></polyline>
                                                <line x1="21" y1="12" x2="9" y2="12"></line>
                                            </svg>
                                            <span>Đăng xuất tài khoản</span>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/logout" class="btn-header-logout" title="Đăng xuất">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                    <polyline points="16 17 21 12 16 7"></polyline>
                                    <line x1="21" y1="12" x2="9" y2="12"></line>
                                </svg>
                                <span>Đăng xuất</span>
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-login-outline">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-register-solid">Đăng ký tài khoản</a>
                        <a href="${pageContext.request.contextPath}/login" class="btn-user-avatar" aria-label="Tài khoản">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </a>
                    </c:otherwise>
                </c:choose>
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
         2. SUBTLE GUEST MODE BAR (Guests only)
         ==================================================================== -->
    <c:if test="${empty sessionScope.currentUser}">
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
    </c:if>

    <main id="trang-chu" class="petpy-main petpy-v13-green">

        <!-- ================================================================
             3. HERO SECTION (Petpy Collage Layout + Pet Care Forest Green Theme)
             ================================================================ -->
        <section class="petpy-hero petpy-section-rel">
            <svg class="petpy-paw-bg" style="top:34px;left:43%;width:30px;height:30px;transform:rotate(-15deg);" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
            </svg>
            <svg class="petpy-paw-bg" style="bottom:20px;left:36%;width:38px;height:38px;transform:rotate(18deg);" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
            </svg>

            <div class="container petpy-hero-grid">
                <div class="petpy-hero-left reveal-up">
                    <div class="hero-pill-badge">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2l2.4 2.1 3.1-.4 1.2 2.9 2.9 1.2-.4 3.1L23.3 13l-2.1 2.4.4 3.1-2.9 1.2-1.2 2.9-3.1-.4L12 24.3l-2.4-2.1-3.1.4-1.2-2.9-2.9-1.2.4-3.1L.7 13l2.1-2.4-.4-3.1 2.9-1.2 1.2-2.9 3.1.4L12 2zm-1.2 13.6l5.4-5.4-1.4-1.4-4 4-2-2-1.4 1.4 3.4 3.4z"/>
                        </svg>
                        <span>SPA &amp; GROOMING THÚ CƯNG CHUẨN QUỐC TẾ</span>
                    </div>

                    <h1 class="petpy-hero-title">
                        <span>Dịch Vụ Chăm Sóc</span><br/>
                        <span class="petpy-title-line">
                            <span>Cho</span>
                            <span class="petpy-inline-dog-pill">
                                <img src="${pageContext.request.contextPath}/assets/images/review-dog-bo.jpg" alt="Cún cưng đáng yêu tại Pet care" />
                            </span>
                            <span>Bé Cưng</span>
                        </span>
                        <span class="highlight-green-brand">Chuyên Nghiệp Tận Tâm</span>
                    </h1>

                    <p class="petpy-hero-desc">
                        Trải nghiệm dịch vụ tắm spa thảo mộc Organic, cắt tỉa tạo kiểu chuẩn Salon và lưu trú phòng kính 360&deg;
                        với đội ngũ chuyên viên tận tâm, yêu thương từng bé cưng.
                    </p>

                    <div class="petpy-hero-cta">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser or not empty sessionScope.loggedInUser}">
                                <button type="button" class="btn-hero-primary" data-open-booking="Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện">
                                    <span>Đặt lịch chăm sóc ngay</span>
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </button>
                                <a href="#bang-gia-section" class="petpy-link-more">
                                    XEM BẢNG GIÁ &amp; DỊCH VỤ &rsaquo;
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn-hero-primary" data-open-booking="Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện">
                                    <span>Đặt lịch giữ chỗ ngay</span>
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </button>
                                <a href="#bang-gia-section" class="petpy-link-more">
                                    XEM BẢNG GIÁ &amp; DỊCH VỤ &rsaquo;
                                </a>
                            </c:otherwise>
                        </c:choose>
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

                <div class="petpy-collage hero-art-collage reveal-up">
                    <svg class="art-deco-paw paw-1" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                        <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                        <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                    </svg>
                    <svg class="art-deco-paw paw-2" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                        <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                        <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                    </svg>

                    <div class="art-photo-card art-photo-card-top">
                        <img src="${pageContext.request.contextPath}/assets/images/hero-petcare-spa.jpg" alt="Chuyên viên Grooming chăm sóc cún cưng tại Pet care" />
                        <span class="art-mini-pill top-pill">&#9733; 4.9 &bull; Spa Organic</span>
                    </div>

                    <button type="button" class="art-badge-24h" data-open-booking="Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện">
                        <strong>24/7</strong>
                        <span>Hỗ trợ giữ chỗ</span>
                    </button>

                    <button type="button" class="art-stamp-circle" data-open-booking="Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện" aria-label="Đặt lịch nhanh Pet care">
                        <svg class="petpy-stamp-ring" viewBox="0 0 120 120" aria-hidden="true">
                            <defs>
                                <path id="artStampPath" d="M 60, 60 m -40, 0 a 40,40 0 1,1 80,0 a 40,40 0 1,1 -80,0" />
                            </defs>
                            <text fill="#E8FBF2" font-size="8.6" font-weight="800" letter-spacing="2.3">
                                <textPath href="#artStampPath">&bull; PET CARE SPA &bull; GROOMING &amp; RELAX </textPath>
                            </text>
                        </svg>
                        <svg class="art-stamp-paw" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <circle cx="7" cy="7.5" r="1.7"/>
                            <circle cx="12" cy="5.5" r="1.7"/>
                            <circle cx="17" cy="7.5" r="1.7"/>
                            <path d="M12 11.5c-3 0-5.4 2.1-5.4 4.7 0 1.7 1.4 3 3.2 3 .9 0 1.5-.3 2.2-.3s1.3.3 2.2.3c1.8 0 3.2-1.3 3.2-3 0-2.6-2.4-4.7-5.4-4.7z"/>
                        </svg>
                    </button>

                    <div class="art-photo-card art-photo-card-bottom">
                        <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg" alt="Cắt tỉa tạo kiểu Salon Hàn Nhật tại Pet care" />
                        <span class="art-mini-pill bottom-pill">&#9986; Salon Hàn - Nhật</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. MINT HORIZONTAL BANNER + INTEGRATED TRUST METRICS
             ================================================================ -->
        <section class="petpy-banner-section">
            <div class="container">
                <div class="petpy-yellow-banner reveal-up">
                    <img src="${pageContext.request.contextPath}/assets/images/service-bath.jpg" alt="Bé cưng thư giãn" class="pyb-floating-pet" />

                    <div class="pyb-grid">
                        <div class="pyb-item">
                            <div class="pyb-head">
                                <span class="pyb-icon" aria-hidden="true">
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                        <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"></path>
                                    </svg>
                                </span>
                                <h3>Tắm Spa Thảo Mộc</h3>
                            </div>
                            <p>
                                Sữa tắm hữu cơ dịu nhẹ, ngâm bồn sục micro-bubble và sấy phồng êm ái giúp bé thư giãn tuyệt đối.
                            </p>
                        </div>

                        <div class="pyb-item">
                            <div class="pyb-head">
                                <span class="pyb-icon" aria-hidden="true">
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                    </svg>
                                </span>
                                <h3>Phòng Kính 360&deg; &amp; Lưu Trú</h3>
                            </div>
                            <p>
                                Không gian vách kính trong suốt khử khuẩn UV kết hợp phòng nghỉ VIP điều hòa có camera 24/7.
                            </p>
                        </div>

                        <div class="pyb-quote">
                            <p>
                                Thú cưng không chỉ là vật nuôi, mà là thành viên bé nhỏ đáng yêu nhất trong gia đình bạn.
                            </p>
                        </div>
                    </div>

                    <div class="pyb-stats-bar">
                        <div class="pyb-stat-pill">
                            <strong>5.000+</strong>
                            <span>Bé cưng đã chăm sóc</span>
                        </div>
                        <div class="pyb-stat-pill">
                            <strong>20+</strong>
                            <span>Chuyên viên Grooming</span>
                        </div>
                        <div class="pyb-stat-pill">
                            <strong>10+</strong>
                            <span>Cơ sở tiêu chuẩn</span>
                        </div>
                        <div class="pyb-stat-pill">
                            <strong>4.9/5 &#9733;</strong>
                            <span>98% Khách hàng hài lòng</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             5. SERVICE WE PROVIDE SHOWCASE + DETAILED PRICING CATALOG
             ================================================================ -->
        <section id="bang-gia-section" class="petpy-services-section petpy-section-rel">
            <svg class="petpy-paw-bg" style="top:18px;left:22%;width:42px;height:42px;transform:rotate(-22deg);" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
            </svg>

            <div class="container">
                <div class="petpy-services-showcase reveal-up">
                    <div class="pss-list-col">
                        <span class="section-eyebrow">LIỆU TRÌNH ĐƯỢC YÊU THÍCH</span>
                        <h2 class="pss-title">Dịch Vụ<br/>Chúng Tôi Cung Cấp</h2>
                        <div class="pss-list">
                            <button type="button" class="pss-row-item" data-open-booking="Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện">
                                <span>Tắm Sấy Thảo Mộc Organic</span>
                                <span class="pss-row-right"><em>150.000 đ</em> &rarr;</span>
                            </button>
                            <button type="button" class="pss-row-item" data-open-booking="Cắt Tỉa Tạo Kiểu Chuẩn Salon">
                                <span>Cắt Tỉa Tạo Kiểu Chuẩn Salon</span>
                                <span class="pss-row-right"><em>280.000 đ</em> &rarr;</span>
                            </button>
                            <button type="button" class="pss-row-item" data-open-booking="Spa Thảo Dược &amp; Phục Hồi Da Lông">
                                <span>Spa Thảo Dược &amp; Phục Hồi Da</span>
                                <span class="pss-row-right"><em>350.000 đ</em> &rarr;</span>
                            </button>
                            <button type="button" class="pss-row-item" data-open-booking="Vệ Sinh Tai, Móng &amp; Tuyến Hôi Chuyên Sâu">
                                <span>Vệ Sinh Tai, Móng &amp; Tuyến Hôi</span>
                                <span class="pss-row-right"><em>120.000 đ</em> &rarr;</span>
                            </button>
                            <button type="button" class="pss-row-item" data-open-booking="Combo Chăm Sóc Toàn Diện &amp; Lưu Trú VIP">
                                <span>Combo Chăm Sóc &amp; Lưu Trú VIP</span>
                                <span class="pss-row-right"><em>390.000 đ</em> &rarr;</span>
                            </button>
                        </div>
                    </div>

                    <div class="pss-center-pink-card">
                        <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg" alt="Chuyên viên chăm sóc và cắt tỉa thú cưng tại Pet care" />
                    </div>

                    <div class="pss-right-col">
                        <div class="pss-right-copy">
                            <p>
                                Mọi nhu cầu chăm sóc thú cưng trong một nơi duy nhất: từ tắm thư giãn, tạo kiểu theo giống
                                đến phục hồi da lông chuyên sâu &mdash; không phụ phí ẩn tại TP.HCM &amp; Hà Nội.
                            </p>
                            <a href="#bang-gia-chi-tiet" class="petpy-btn-outline-blue">
                                Xem bảng giá chi tiết
                            </a>
                        </div>

                        <div class="pss-mini-video-card">
                            <div class="pss-mvc-left">
                                <h4>Tham Quan Cơ Sở</h4>
                                <span>Phòng kính 360&deg; &amp; Bồn Ozone</span>
                                <a href="${pageContext.request.contextPath}/branches.jsp" class="pss-play-btn" aria-label="Tham quan hệ thống cơ sở Pet care">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                                        <polygon points="6 4 20 12 6 20 6 4"></polygon>
                                    </svg>
                                </a>
                            </div>
                            <img src="${pageContext.request.contextPath}/assets/images/branch-hn.jpg" alt="Không gian Pet care Spa" class="pss-mvc-thumb" />
                        </div>
                    </div>
                </div>

                <!-- Interactive Filterable Pricing Catalog (Compatible with home.js) -->
                <div id="bang-gia-chi-tiet" class="petpy-catalog-wrap">
                    <div class="section-split-head reveal-up">
                        <div>
                            <span class="section-eyebrow">BẢNG GIÁ &amp; LIỆU TRÌNH MINH BẠCH</span>
                            <h2 class="section-main-title">Chọn Gói Dịch Vụ Phù Hợp Cho Bé</h2>
                            <p class="section-subtitle">
                                Niêm yết rõ ràng theo cân nặng. Nhấn vào từng thẻ để xem chi tiết từng bước thực hiện.
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
                                <div class="spc-media-wrap">
                                    <c:choose>
                                        <c:when test="${srv.id == 'grooming-cat-tia'}">
                                            <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg" alt="${srv.title}" class="spc-media-img" />
                                        </c:when>
                                        <c:when test="${srv.id == 'spa-cham-soc-da'}">
                                            <img src="${pageContext.request.contextPath}/assets/images/service-flea.jpg" alt="${srv.title}" class="spc-media-img" />
                                        </c:when>
                                        <c:when test="${srv.id == 've-sinh-tai-mong'}">
                                            <img src="${pageContext.request.contextPath}/assets/images/service-shaving.jpg" alt="${srv.title}" class="spc-media-img" />
                                        </c:when>
                                        <c:when test="${srv.id == 'cham-soc-suc-khoe'}">
                                            <img src="${pageContext.request.contextPath}/assets/images/service-petshop.jpg" alt="${srv.title}" class="spc-media-img" />
                                        </c:when>
                                        <c:when test="${srv.id == 'combo-cham-soc'}">
                                            <img src="${pageContext.request.contextPath}/assets/images/service-boarding.jpg" alt="${srv.title}" class="spc-media-img" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/service-bath.jpg" alt="${srv.title}" class="spc-media-img" />
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="spc-media-overlay">
                                        <span class="spc-duration-pill">${srv.badgeText}</span>
                                        <span class="spc-floating-price">${srv.priceValue}${srv.priceSuffix}</span>
                                    </div>
                                </div>

                                <div class="spc-top-row">
                                    <span class="spc-badge ${srv.badgeTheme}">${srv.badgeText}</span>
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
            </div>
        </section>

        <!-- ================================================================
             6. VETTED SPECIALISTS SECTION (Petpy Layout + Green Theme)
             ================================================================ -->
        <section class="petpy-vetted-section">
            <div class="container petpy-vetted-grid">
                <div class="pvs-media-wrap reveal-up">
                    <div class="pvs-yellow-photo">
                        <img src="${pageContext.request.contextPath}/assets/images/hero-petcare.jpg" alt="Bé Poodle xinh xắn sau buổi Spa tại Pet care" />
                    </div>
                    <div class="pvs-floating-product">
                        <img src="${pageContext.request.contextPath}/assets/images/service-petshop.jpg" alt="Mỹ phẩm thảo mộc Organic" />
                        <strong>100% Thảo Mộc Organic</strong>
                    </div>
                </div>

                <div class="pvs-copy reveal-up">
                    <span class="section-eyebrow">TIÊU CHUẨN CHUYÊN MÔN PET CARE</span>
                    <h2>Chuyên Viên Grooming Tuyển Chọn Khắt Khe</h2>
                    <p>
                        Mỗi bé cưng đều có cá tính riêng. Chúng tôi tuyển chọn và đào tạo đội ngũ kỹ thuật viên không chỉ vững tay nghề mà còn thực sự kiên nhẫn và yêu thương động vật.
                    </p>

                    <div class="pvs-checklist">
                        <div class="pvs-check-item">
                            <span class="pvs-check-icon" aria-hidden="true">&#10003;</span>
                            <span>100% chuyên viên sở hữu chứng chỉ Grooming chuyên nghiệp &amp; kiểm tra tay nghề định kỳ.</span>
                        </div>
                        <div class="pvs-check-item">
                            <span class="pvs-check-icon" aria-hidden="true">&#10003;</span>
                            <span>Quy trình tắm sấy êm ái, tuyệt đối không dùng lồng sấy nóng gây căng thẳng cho bé.</span>
                        </div>
                        <div class="pvs-check-item">
                            <span class="pvs-check-icon" aria-hidden="true">&#10003;</span>
                            <span>Toàn bộ kéo, lược, tông-đơ và khăn tắm đều được tiệt trùng tia UV chuẩn quốc tế.</span>
                        </div>
                        <div class="pvs-check-item">
                            <span class="pvs-check-icon" aria-hidden="true">&#10003;</span>
                            <span>Bảo hành form dáng cắt tỉa trong 48 giờ tại toàn bộ hệ thống chi nhánh.</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             7. FLEXIBLE SCHEDULING + 4-STEP PROCESS SUMMARY
             ================================================================ -->
        <section id="quy-trinh-section" class="petpy-schedule-section petpy-section-rel">
            <svg class="petpy-paw-bg" style="top:38px;left:6%;width:38px;height:38px;transform:rotate(-20deg);" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
            </svg>

            <div class="container">
                <div class="petpy-center-title reveal-up">
                    <span class="section-eyebrow">QUY TRÌNH &amp; ĐẶT LỊCH NHANH CHÓNG</span>
                    <h2>Lịch Hẹn Luôn Sẵn Sàng &bull; Quy Trình 4 Bước</h2>
                </div>

                <div class="petpy-schedule-3grid">
                    <article class="ps3-card reveal-up">
                        <div class="ps3-icon green-soft" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                        </div>
                        <h3>Đặt Lịch Phút Chót</h3>
                        <p>
                            Đưa bé đi Spa gấp trong ngày? Hệ thống tự động giữ chỗ chuyên viên ngay trong 15 phút mà không phải chờ lâu.
                        </p>
                    </article>

                    <article class="ps3-card reveal-up">
                        <div class="ps3-icon mint-soft" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <h3>Đổi Giờ Hẹn Linh Hoạt</h3>
                        <p>
                            Lịch trình bận rộn thay đổi đột xuất? Bạn dễ dàng chọn lại khung giờ hoặc cơ sở khác chỉ trong 1 chạm.
                        </p>
                    </article>

                    <article class="ps3-card reveal-up">
                        <div class="ps3-icon emerald-soft" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </div>
                        <h3>Huỷ Hẹn Không Phí</h3>
                        <p>
                            Đặt lịch không cần trả trước và miễn phí hoàn toàn khi dời hoặc hủy ca hẹn trước giờ thực hiện 2 tiếng.
                        </p>
                    </article>
                </div>

                <!-- Slim 4-Step Care Journey Bar -->
                <div class="petpy-4step-bar reveal-up">
                    <div class="p4b-step">
                        <span class="p4b-num">01</span>
                        <div>
                            <strong>Đặt lịch 30s</strong>
                            <span>Giữ slot chuyên viên thực tế</span>
                        </div>
                    </div>
                    <div class="p4b-step">
                        <span class="p4b-num">02</span>
                        <div>
                            <strong>Tiếp nhận &amp; Kiểm tra</strong>
                            <span>Tầm soát da, tai, móng miễn phí</span>
                        </div>
                    </div>
                    <div class="p4b-step">
                        <span class="p4b-num">03</span>
                        <div>
                            <strong>Grooming &amp; Spa</strong>
                            <span>Phòng kính quan sát 360&deg;</span>
                        </div>
                    </div>
                    <div class="p4b-step">
                        <span class="p4b-num">04</span>
                        <div>
                            <strong>Bàn giao &amp; Bảo hành</strong>
                            <span>Bảo hành form tỉa 48 giờ</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             8. TRUSTWORTHY CARE & SAME TRUSTED SITTER + REVIEWS
             ================================================================ -->
        <section id="quyen-loi-section" class="petpy-trust-section petpy-section-rel">
            <svg class="petpy-paw-bg" style="bottom:48px;right:6%;width:40px;height:40px;transform:rotate(14deg);" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <circle cx="7" cy="7.5" r="2"/><circle cx="12" cy="5.5" r="2"/><circle cx="17" cy="7.5" r="2"/><circle cx="4.5" cy="12" r="1.8"/><circle cx="19.5" cy="12" r="1.8"/>
                <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
            </svg>

            <div class="container">
                <div class="petpy-center-title reveal-up">
                    <span class="section-eyebrow">KHÔNG GIAN SALON FLAGSHIP</span>
                    <h2>Chăm Sóc Tận Tâm, Tin Cậy<br/>&amp; An Toàn Cho Bé</h2>
                </div>

                <div class="petpy-trust-row reveal-up">
                    <div class="ptr-green-card">
                        <img src="${pageContext.request.contextPath}/assets/images/service-bath.jpg" alt="Tắm thư giãn an toàn cho thú cưng" />
                    </div>

                    <div class="ptr-copy">
                        <h3>Quy trình tiếp nhận &amp; chăm sóc minh bạch từng bước</h3>
                        <p>
                            Mọi công đoạn từ kiểm tra tình trạng da lông, ngâm bồn sục Ozone đến cắt tỉa tạo kiểu đều diễn ra sau vách kính 360&deg; trong suốt để bạn luôn an tâm.
                        </p>
                        <button type="button" class="btn-hero-primary" data-open-booking="Grooming &amp; Tắm Sấy Thảo Mộc Toàn Diện">
                            <span>Đặt lịch ngay</span>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </button>
                    </div>

                    <div class="ptr-pink-box-wrap">
                        <div class="ptr-pink-card">
                            <img src="${pageContext.request.contextPath}/assets/images/branch-hcm.jpg" alt="Cơ sở Spa Pet care TP.HCM" />
                        </div>
                        <a href="${pageContext.request.contextPath}/branches.jsp" class="ptr-caption">
                            KHÁM PHÁ CƠ SỞ TP.HCM &amp; HÀ NỘI &rarr;
                        </a>
                    </div>
                </div>

                <div class="petpy-center-title reveal-up">
                    <span class="section-eyebrow">QUYỀN LỢI THÀNH VIÊN &amp; CẢM NHẬN</span>
                    <h2>Đồng Hành Cùng Chuyên Viên<br/>Quen Thuộc Mỗi Lần Ghé Spa</h2>
                </div>

                <div class="petpy-sitter-row reveal-up">
                    <div class="psr-copy">
                        <h3>Lưu trữ sổ tay làm đẹp &amp; thói quen riêng của bé</h3>
                        <p>
                            Tài khoản thành viên ghi nhớ kiểu cắt yêu thích, loại sữa tắm dịu nhẹ hợp da và album ảnh sau mỗi buổi làm đẹp tại Pet care.
                        </p>
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser}">
                                <a href="${pageContext.request.contextPath}/profile" class="petpy-btn-outline-blue">
                                    Quản lý hồ sơ thành viên &rarr;
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/register" class="petpy-btn-outline-blue">
                                    Tạo hồ sơ miễn phí &rarr;
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="psr-center-pink">
                        <img src="${pageContext.request.contextPath}/assets/images/service-boarding.jpg" alt="Chăm sóc lưu trú VIP tại Pet care" />
                    </div>

                    <div class="psr-right-reviews">
                        <div class="psr-avatars-stack">
                            <img src="${pageContext.request.contextPath}/assets/images/review-cat-miu.jpg" alt="Bé Miu" />
                            <img src="${pageContext.request.contextPath}/assets/images/review-dog-bo.jpg" alt="Bé Bơ" />
                            <img src="${pageContext.request.contextPath}/assets/images/review-dog-may.jpg" alt="Bé Mây" />
                        </div>
                        <span class="psr-right-label">Cảm nhận từ khách hàng &amp; bé cưng</span>

                        <c:forEach var="rev" items="${reviews}" end="1">
                            <article class="psr-quote-card">
                                <p>${rev.quote}</p>
                                <strong>${rev.authorName}</strong>
                                <span>${rev.branchName} &bull; ${rev.timeAgo}</span>
                            </article>
                        </c:forEach>
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
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedInUser}">
                                    <a href="${pageContext.request.contextPath}/services.jsp" class="btn-cta-outline-white">
                                        Xem bảng giá chi tiết
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/register" class="btn-cta-outline-white">
                                        Đăng ký tài khoản mới
                                    </a>
                                </c:otherwise>
                            </c:choose>
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
                        <input type="text" id="ownerName" name="ownerName" class="modal-input"
                            value="${sessionScope.loggedInUser}" placeholder="Nguyễn Thảo My" required />
                    </div>
                    <div class="modal-field">
                        <label for="phone">Số điện thoại / Zalo *</label>
                        <input type="tel" id="phone" name="phone" class="modal-input"
                            value="${sessionScope.loggedInPhone}" placeholder="0912 345 678" required />
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
