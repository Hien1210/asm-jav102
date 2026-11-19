<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Giới thiệu &amp; Hệ thống Cơ sở — Pet care | Pet Spa &amp; Grooming Lounge</title>
            <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
            <link rel="preconnect" href="https://fonts.googleapis.com" />
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
            <link
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"
                rel="stylesheet" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=9" />
        </head>

        <body>

            <!-- ====================================================================
         1. STICKY HEADER
         ==================================================================== -->
            <header class="site-header" id="siteHeader">
                <div class="header-inner">
                    <a href="${pageContext.request.contextPath}/home" class="brand-wrap"
                        aria-label="Pet care — Trang chủ">
                        <span class="brand-icon-box">
                            <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo"
                                class="brand-logo-img" />
                        </span>
                    </a>

                    <nav class="main-nav" id="mainNav" aria-label="Điều hướng chính">
                        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/branches.jsp" class="active">Giới thiệu &amp; Cơ sở</a>
                        <a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a>
                        <a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc</a>
                        <a href="${pageContext.request.contextPath}/home#quyen-loi-section">Tra cứu &amp; Hướng dẫn</a>
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
                                <a href="${pageContext.request.contextPath}/login" class="btn-user-avatar" aria-label="Tài khoản thành viên">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.1">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </header>

            <main>
                <!-- ================================================================
             2. SUBPAGE HERO — GIỚI THIỆU THƯƠNG HIỆU & TIÊU CHUẨN CƠ SỞ
             ================================================================ -->
                <section class="subpage-hero">
                    <div class="container">
                        <div class="subpage-breadcrumb">
                            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                            <span>/</span>
                            <span>Giới thiệu &amp; Hệ thống Cơ sở</span>
                        </div>

                        <div class="subpage-hero-grid">
                            <div>
                                <div class="section-eyebrow">
                                    <span>GIỚI THIỆU THƯƠNG HIỆU &amp; KHÔNG GIAN SPA</span>
                                </div>
                                <h1 class="subpage-title">
                                    Hệ Thống Salon &amp; Spa Thú Cưng <span>Chuẩn Quốc Tế Pet care</span>
                                </h1>
                                <p class="subpage-desc">
                                    Ra đời với sứ mệnh nâng tầm trải nghiệm chăm sóc thú cưng tại Việt Nam, mỗi cơ sở
                                    <strong>Pet care Spa &amp; Grooming Lounge</strong> đều được thiết kế theo tiêu
                                    chuẩn phòng
                                    kính vô trùng 360°, ngập tràn ánh sáng tự nhiên, tách biệt hoàn toàn khu vực Chó
                                    &amp; Mèo
                                    để các bé luôn an tâm thư giãn như ở nhà.
                                </p>
                                <div class="subpage-highlights-row">
                                    <span class="subpage-pill">&#10003; 100% Phòng Grooming Vách Kính Quan Sát</span>
                                    <span class="subpage-pill">&#10003; Khử Khuẩn Tia UV-C &amp; Nước Lọc RO</span>
                                    <span class="subpage-pill">&#10003; Mỹ Phẩm Thảo Mộc Organic Nhập Khẩu</span>
                                </div>
                            </div>

                            <div class="hero-image-frame">
                                <img src="${pageContext.request.contextPath}/assets/images/branch-hcm.jpg"
                                    alt="Không gian bên trong cơ sở Pet care Spa" />
                                <div class="hero-image-overlay"></div>
                            </div>
                        </div>

                        <!-- 3 Tiêu chuẩn không gian cơ sở -->
                        <div class="standards-3-grid">
                            <article class="standard-card">
                                <div class="standard-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                    </svg>
                                </div>
                                <h3>Vô Trùng Chuẩn Y Khoa</h3>
                                <p>
                                    Toàn bộ bàn cắt, bồn tắm sục, lược và tông-đơ được tiệt trùng bằng tủ tia UV-C và
                                    dung dịch
                                    sát khuẩn an toàn sau mỗi lượt phục vụ.
                                </p>
                            </article>

                            <article class="standard-card">
                                <div class="standard-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                </div>
                                <h3>Không Gian Kính Minh Bạch 360°</h3>
                                <p>
                                    Ba mẹ có thể thưởng thức trà thảo mộc tại sảnh chờ và trực tiếp quan sát trọn vẹn
                                    quá trình
                                    chuyên viên tắm sấy, cắt tỉa cho bé cưng.
                                </p>
                            </article>

                            <article class="standard-card">
                                <div class="standard-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path
                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                    </svg>
                                </div>
                                <h3>Tách Biệt Khu Chó &amp; Mèo</h3>
                                <p>
                                    Phòng Grooming và phòng lưu trú của các bé Mèo được cách âm riêng biệt với khu vực
                                    của Chó,
                                    triệt tiêu tiếng ồn giúp bé không sợ hãi.
                                </p>
                            </article>
                        </div>
                    </div>
                </section>

                <!-- ================================================================
             3. DANH SÁCH HỆ THỐNG CƠ SỞ PET CARE SPA (CÓ NÚT XEM CƠ SỞ)
             ================================================================ -->
                <section class="branches-section" id="danh-sach-co-so">
                    <div class="container">
                        <div class="section-header-center">
                            <div class="section-eyebrow">
                                <span>HỆ THỐNG CHI NHÁNH TOÀN QUỐC</span>
                            </div>
                            <h2 class="section-title">Các Cơ Sở Pet care Spa &amp; Grooming</h2>
                            <p class="section-subtitle">
                                Chọn cơ sở gần bạn nhất để xem chi tiết không gian phòng ốc, trang thiết bị và đặt lịch
                                hẹn
                                trước cho bé cưng.
                            </p>
                        </div>

                        <div class="branches-grid">
                            <!-- Cơ sở 1: Quận 3, TP.HCM -->
                            <article class="branch-card">
                                <div class="branch-photo-wrap">
                                    <img src="${pageContext.request.contextPath}/assets/images/branch-hcm.jpg"
                                        alt="Pet care Spa Nguyễn Đình Chiểu Quận 3 TP.HCM" />
                                    <div class="branch-status-pill">
                                        <span class="status-dot"></span>
                                        <span>Flagship TP. Hồ Chí Minh</span>
                                    </div>
                                </div>

                                <div class="branch-body">
                                    <h3 class="branch-name">Pet care Spa &mdash; Nguyễn Đình Chiểu, Quận 3</h3>

                                    <div class="branch-info-list">
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><strong>Địa chỉ:</strong> 128 Nguyễn Đình Chiểu, Phường Võ Thị Sáu,
                                                Quận 3,
                                                TP.HCM</span>
                                        </div>
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><strong>Giờ hoạt động:</strong> 08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ
                                                Nhật)</span>
                                        </div>
                                    </div>

                                    <div class="branch-amenities-tags">
                                        <span class="branch-amenity-tag">Bồn sục Micro-bubble</span>
                                        <span class="branch-amenity-tag">Phòng kính 360°</span>
                                        <span class="branch-amenity-tag">Pet Hotel VIP</span>
                                        <span class="branch-amenity-tag">Bãi đỗ xe ô tô</span>
                                    </div>

                                    <div class="branch-actions">
                                        <a href="${pageContext.request.contextPath}/branch-q3.jsp"
                                            class="btn-branch-outline">
                                            Xem cơ sở
                                        </a>
                                        <a href="${pageContext.request.contextPath}/login" class="btn-branch-solid">
                                            <span>Đặt lịch</span>
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.3">
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                                <polyline points="12 5 19 12 12 19"></polyline>
                                            </svg>
                                        </a>
                                    </div>
                                </div>
                            </article>

                            <!-- Cơ sở 2: Đống Đa, Hà Nội -->
                            <article class="branch-card">
                                <div class="branch-photo-wrap">
                                    <img src="${pageContext.request.contextPath}/assets/images/branch-hn.jpg"
                                        alt="Pet care Spa Hoàng Cầu Đống Đa Hà Nội" />
                                    <div class="branch-status-pill">
                                        <span class="status-dot"></span>
                                        <span>Flagship Hà Nội</span>
                                    </div>
                                </div>

                                <div class="branch-body">
                                    <h3 class="branch-name">Pet care Spa &mdash; Hoàng Cầu, Đống Đa</h3>

                                    <div class="branch-info-list">
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><strong>Địa chỉ:</strong> 45 Hoàng Cầu, Phường Ô Chợ Dừa, Quận Đống
                                                Đa, Hà
                                                Nội</span>
                                        </div>
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><strong>Giờ hoạt động:</strong> 08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ
                                                Nhật)</span>
                                        </div>
                                    </div>

                                    <div class="branch-amenities-tags">
                                        <span class="branch-amenity-tag">Spa Thảo Dược</span>
                                        <span class="branch-amenity-tag">Khu Mèo Riêng Biệt</span>
                                        <span class="branch-amenity-tag">Camera 24/7</span>
                                        <span class="branch-amenity-tag">Sân chơi cỏ tự nhiên</span>
                                    </div>

                                    <div class="branch-actions">
                                        <a href="${pageContext.request.contextPath}/branch-dongda.jsp"
                                            class="btn-branch-outline">
                                            Xem cơ sở
                                        </a>
                                        <a href="${pageContext.request.contextPath}/login" class="btn-branch-solid">
                                            <span>Đặt lịch</span>
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.3">
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                                <polyline points="12 5 19 12 12 19"></polyline>
                                            </svg>
                                        </a>
                                    </div>
                                </div>
                            </article>

                            <!-- Cơ sở 3: Thảo Điền, TP. Thủ Đức -->
                            <article class="branch-card">
                                <div class="branch-photo-wrap">
                                    <img src="${pageContext.request.contextPath}/assets/images/hero-petcare-spa.jpg"
                                        alt="Pet care Spa Thảo Điền TP.HCM" />
                                    <div class="branch-status-pill">
                                        <span class="status-dot"></span>
                                        <span>Cơ sở Thảo Điền &bull; TP.HCM</span>
                                    </div>
                                </div>

                                <div class="branch-body">
                                    <h3 class="branch-name">Pet care Spa &mdash; Xuân Thủy, Thảo Điền</h3>

                                    <div class="branch-info-list">
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><strong>Địa chỉ:</strong> 82 Xuân Thủy, Phường Thảo Điền, TP. Thủ Đức,
                                                TP.HCM</span>
                                        </div>
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><strong>Giờ hoạt động:</strong> 08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ
                                                Nhật)</span>
                                        </div>
                                    </div>

                                    <div class="branch-amenities-tags">
                                        <span class="branch-amenity-tag">Hồ bơi thú cưng</span>
                                        <span class="branch-amenity-tag">Grooming Chuẩn Asian</span>
                                        <span class="branch-amenity-tag">Resort Villa VIP</span>
                                        <span class="branch-amenity-tag">Đưa đón tận nơi</span>
                                    </div>

                                    <div class="branch-actions">
                                        <a href="${pageContext.request.contextPath}/branch-thaodien.jsp"
                                            class="btn-branch-outline">
                                            Xem cơ sở
                                        </a>
                                        <a href="${pageContext.request.contextPath}/login" class="btn-branch-solid">
                                            <span>Đặt lịch</span>
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.3">
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                                <polyline points="12 5 19 12 12 19"></polyline>
                                            </svg>
                                        </a>
                                    </div>
                                </div>
                            </article>

                            <!-- Cơ sở 4: Cầu Giấy, Hà Nội -->
                            <article class="branch-card">
                                <div class="branch-photo-wrap">
                                    <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg"
                                        alt="Pet care Spa Trần Thái Tông Cầu Giấy Hà Nội" />
                                    <div class="branch-status-pill">
                                        <span class="status-dot"></span>
                                        <span>Cơ sở Cầu Giấy &bull; Hà Nội</span>
                                    </div>
                                </div>

                                <div class="branch-body">
                                    <h3 class="branch-name">Pet care Spa &mdash; Trần Thái Tông, Cầu Giấy</h3>

                                    <div class="branch-info-list">
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                            <span><strong>Địa chỉ:</strong> 106 Trần Thái Tông, Phường Dịch Vọng Hậu,
                                                Quận Cầu
                                                Giấy, Hà Nội</span>
                                        </div>
                                        <div class="branch-info-row">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <span><strong>Giờ hoạt động:</strong> 08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ
                                                Nhật)</span>
                                        </div>
                                    </div>

                                    <div class="branch-amenities-tags">
                                        <span class="branch-amenity-tag">Tắm Sấy Thảo Mộc</span>
                                        <span class="branch-amenity-tag">Ủ Bùn Khoáng Biển</span>
                                        <span class="branch-amenity-tag">Lồng Sấy Tĩnh Âm</span>
                                        <span class="branch-amenity-tag">Sảnh chờ Cafe</span>
                                    </div>

                                    <div class="branch-actions">
                                        <a href="${pageContext.request.contextPath}/branch-caugiay.jsp"
                                            class="btn-branch-outline">
                                            Xem cơ sở
                                        </a>
                                        <a href="${pageContext.request.contextPath}/login" class="btn-branch-solid">
                                            <span>Đặt lịch</span>
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.3">
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                                <polyline points="12 5 19 12 12 19"></polyline>
                                            </svg>
                                        </a>
                                    </div>
                                </div>
                            </article>
                        </div>
                    </div>
                </section>

                <!-- ================================================================
             4. BOOKING CTA SECTION
             ================================================================ -->
                <section class="booking-cta-section">
                    <div class="container">
                        <div class="booking-cta-card">
                            <div class="booking-cta-left">
                                <div class="booking-cta-badge">
                                    <span>&#10024; ĐẶT LỊCH TRƯỚC &bull; KHÔNG CẦN CHỜ ĐỢI</span>
                                </div>
                                <h2 class="booking-cta-title">
                                    Đặt lịch chăm sóc cho bé tại cơ sở gần bạn nhất
                                </h2>
                                <p class="booking-cta-desc">
                                    Chọn dịch vụ, cơ sở và khung giờ phù hợp chỉ trong vài bước. Đội ngũ chuyên viên Pet
                                    care sẽ
                                    chuẩn bị sẵn phòng tắm thảo mộc và đón bé đúng giờ.
                                </p>
                            </div>

                            <div class="booking-cta-panel">
                                <h4>Hỗ trợ đặt lịch &amp; Tư vấn cơ sở</h4>
                                <p>Mở cửa xuyên suốt từ Thứ 2 đến Chủ Nhật hàng tuần.</p>

                                <div class="booking-cta-perks">
                                    <div class="booking-cta-perk">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                        <span>Giữ chỗ ưu tiên theo khung giờ đã hẹn</span>
                                    </div>
                                    <div class="booking-cta-perk">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                        <span>Miễn phí kiểm tra da, lông &amp; tai trước khi tắm</span>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/login" class="btn-cta-book-now">
                                    <span>Đăng nhập để đặt lịch ngay</span>
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.4">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <!-- ====================================================================
         5. FOOTER
         ==================================================================== -->
            <footer class="site-footer">
                <div class="container">
                    <div class="footer-grid">
                        <div class="footer-col">
                            <div class="footer-brand-row">
                                <span class="footer-brand-icon">
                                    <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4"
                                        alt="PetCare Logo" />
                                </span>
                            </div>
                            <p class="footer-desc">
                                Hệ thống Salon &amp; Spa Chăm Sóc Thú Cưng Tiêu Chuẩn Cao Cấp. Mang đến trải nghiệm làm
                                đẹp thư
                                giãn, an toàn với mỹ phẩm thảo mộc organic 100%.
                            </p>
                        </div>

                        <div class="footer-col">
                            <h4>Liên Kết Nhanh</h4>
                            <ul class="footer-links-list">
                                <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a>
                                </li>
                                <li><a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a>
                                </li>
                                <li><a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm
                                        sóc 4 bước</a></li>
                            </ul>
                        </div>

                        <div class="footer-col">
                            <h4>Dịch Vụ Chăm Sóc</h4>
                            <ul class="footer-links-list">
                                <li><a href="${pageContext.request.contextPath}/services.jsp">Grooming &amp; Tắm sấy
                                        thảo mộc</a></li>
                                <li><a href="${pageContext.request.contextPath}/services.jsp">Cắt tỉa tạo kiểu chuẩn
                                        Salon</a></li>
                                <li><a href="${pageContext.request.contextPath}/services.jsp">Spa thảo dược &amp; Chăm
                                        sóc da</a></li>
                                <li><a href="${pageContext.request.contextPath}/services.jsp">Combo chăm sóc &amp; Lưu
                                        trú VIP</a></li>
                            </ul>
                        </div>

                        <div class="footer-col">
                            <h4>Thông Tin Liên Hệ</h4>
                            <div class="footer-info-list">
                                <div class="footer-info-item">
                                    <span><strong>TP.HCM:</strong> 128 Nguyễn Đình Chiểu, Q.3</span>
                                </div>
                                <div class="footer-info-item">
                                    <span><strong>Hà Nội:</strong> 45 Hoàng Cầu, Q. Đống Đa</span>
                                </div>
                                <div class="footer-info-item">
                                    <span>08:00 &ndash; 20:30 &bull; contact@petcare.vn</span>
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

        </body>

        </html>