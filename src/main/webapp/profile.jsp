<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hồ sơ của người dùng — Pet care | Pet Spa &amp; Grooming Lounge</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=9" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css?v=2" />
</head>

<body>

    <header class="site-header">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand-wrap" aria-label="Pet care — Trang chủ">
                <span class="brand-icon-box">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo"
                        class="brand-logo-img" />
                </span>
            </a>

            <nav class="main-nav" aria-label="Điều hướng chính">
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a>
                <a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a>
                <a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc</a>
                <a href="${pageContext.request.contextPath}/home#quyen-loi-section">Tra cứu &amp; Hướng dẫn</a>
            </nav>

            <div class="header-auth-actions">
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
                            <svg class="header-user-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.4">
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
                                <a href="${pageContext.request.contextPath}/home" class="dropdown-menu-link">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                    </svg>
                                    <span>Quay về Trang chủ</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-menu-link logout-link">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
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
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.1">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                        <span>Đăng xuất</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="profile-stage">
        <div class="profile-container">

            <section class="profile-hero-banner" aria-label="Hồ sơ của người dùng">
                <div class="profile-hero-top">
                    <div class="profile-hero-left">
                        <div class="profile-hero-avatar-wrap">
                            <span class="profile-hero-avatar">
                                ${fn:toUpperCase(fn:substring(fn:trim(sessionScope.currentUser.fullName), 0, 1))}
                            </span>
                        </div>
                        <div>
                            <span class="profile-hero-eyebrow">TRUNG TÂM TÀI KHOẢN THÀNH VIÊN</span>
                            <h1 class="profile-hero-title">${sessionScope.currentUser.fullName}</h1>
                            <div class="profile-hero-badges">
                                <span class="profile-hero-badge">
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">ADMIN &bull; Quản trị viên</c:when>
                                        <c:when test="${sessionScope.currentUser.role == 'STAFF'}">STAFF &bull; Nhân viên</c:when>
                                        <c:otherwise>CUSTOMER &bull; Thành viên Pet care</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="profile-hero-badge">
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.active}">Tài khoản xác thực &bull; Localhost</c:when>
                                        <c:otherwise>Đã khóa</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="profile-hero-actions">
                        <a href="${pageContext.request.contextPath}/home" class="btn-banner-white">
                            <span>&larr; Quay về Trang chủ</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/services.jsp" class="btn-banner-outline">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span>Đặt lịch Spa ngay</span>
                        </a>
                    </div>
                </div>

                <div class="profile-kpi-grid">
                    <div class="profile-kpi-card">
                        <span class="profile-kpi-label">Mã thành viên</span>
                        <span class="profile-kpi-value">#${sessionScope.currentUser.userId}</span>
                    </div>
                    <div class="profile-kpi-card">
                        <span class="profile-kpi-label">Số điện thoại</span>
                        <span class="profile-kpi-value">${sessionScope.currentUser.phone}</span>
                    </div>
                    <div class="profile-kpi-card">
                        <span class="profile-kpi-label">Địa chỉ Email</span>
                        <span class="profile-kpi-value" title="${sessionScope.currentUser.email}">${sessionScope.currentUser.email}</span>
                    </div>
                    <div class="profile-kpi-card">
                        <span class="profile-kpi-label">Ngày tham gia</span>
                        <span class="profile-kpi-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser.createdAt}">${sessionScope.currentUser.createdAt.toLocalDate()}</c:when>
                                <c:otherwise>Thành viên mới</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </section>

            <c:if test="${not empty profileSuccess}">
                <div class="login-alert login-alert-success">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.2">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                        <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                    <span>${profileSuccess}</span>
                </div>
            </c:if>

            <c:if test="${not empty profileError}">
                <div class="login-alert login-alert-error">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.2">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="12" />
                        <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span>${profileError}</span>
                </div>
            </c:if>

            <div class="profile-two-col">
                <section class="profile-panel">
                    <div class="profile-panel-head">
                        <div class="profile-panel-title-wrap">
                            <span class="profile-panel-icon" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </span>
                            <div>
                                <h2 class="profile-card-title">Thông tin cá nhân</h2>
                                <p class="profile-card-sub">
                                    Quản lý thông tin liên hệ hiển thị khi đặt lịch Spa &amp; Grooming.
                                </p>
                            </div>
                        </div>
                        <span class="profile-panel-tag">&#10003; Đã đồng bộ</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/profile" method="post" class="login-form">
                        <input type="hidden" name="action" value="updateProfile" />

                        <div class="form-group">
                            <div class="form-label-row">
                                <label for="profileFullName" class="form-label">Họ và tên chủ thú cưng <span class="req">*</span></label>
                            </div>
                            <div class="input-wrapper">
                                <span class="input-icon-left">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </span>
                                <input type="text" id="profileFullName" name="fullName" class="form-control"
                                    value="${sessionScope.currentUser.fullName}" placeholder="Nhập họ và tên của bạn" required />
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-label-row">
                                <label for="profilePhone" class="form-label">Số điện thoại liên hệ <span class="req">*</span></label>
                                <span class="form-label-hint">Dùng để xác nhận lịch hẹn</span>
                            </div>
                            <div class="input-wrapper">
                                <span class="input-icon-left">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect>
                                        <line x1="12" y1="18" x2="12.01" y2="18"></line>
                                    </svg>
                                </span>
                                <input type="tel" id="profilePhone" name="phone" class="form-control"
                                    value="${sessionScope.currentUser.phone}" placeholder="Ví dụ: 0912345678" required />
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-label-row">
                                <label for="profileEmail" class="form-label">Địa chỉ Email <span class="req">*</span></label>
                            </div>
                            <div class="input-wrapper">
                                <span class="input-icon-left">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                        <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg>
                                </span>
                                <input type="email" id="profileEmail" name="email" class="form-control"
                                    value="${sessionScope.currentUser.email}" placeholder="email@domain.com" required />
                            </div>
                        </div>

                        <button type="submit" class="btn-login-submit">
                            <span>Lưu thay đổi hồ sơ</span>
                        </button>
                    </form>
                </section>

                <section class="profile-panel">
                    <div class="profile-panel-head">
                        <div class="profile-panel-title-wrap">
                            <span class="profile-panel-icon" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    <polyline points="9 12 11 14 15 10"></polyline>
                                </svg>
                            </span>
                            <div>
                                <h2 class="profile-card-title">Bảo mật &amp; Đổi mật khẩu</h2>
                                <p class="profile-card-sub">
                                    Cập nhật mật khẩu định kỳ để bảo vệ tài khoản và lịch sử bé cưng.
                                </p>
                            </div>
                        </div>
                        <span class="profile-panel-tag">BCrypt 256-bit</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/profile" method="post" class="login-form">
                        <input type="hidden" name="action" value="changePassword" />

                        <div class="form-group">
                            <div class="form-label-row">
                                <label for="currentPassword" class="form-label">Mật khẩu hiện tại <span class="req">*</span></label>
                            </div>
                            <div class="input-wrapper">
                                <span class="input-icon-left">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                </span>
                                <input type="password" id="currentPassword" name="currentPassword"
                                    class="form-control has-pw-toggle" placeholder="Nhập mật khẩu hiện tại" required />
                                <button type="button" class="pw-toggle-btn" aria-label="Hiện mật khẩu"
                                    title="Hiện mật khẩu" aria-pressed="false">
                                    <svg class="icon-eye" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" aria-hidden="true">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                    <svg class="icon-eye-off" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" aria-hidden="true">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                        <line x1="1" y1="1" x2="23" y2="23" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-label-row">
                                <label for="newPassword" class="form-label">Mật khẩu mới <span class="req">*</span></label>
                                <span class="form-label-hint">Tối thiểu 8 ký tự</span>
                            </div>
                            <div class="input-wrapper">
                                <span class="input-icon-left">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                </span>
                                <input type="password" id="newPassword" name="newPassword" minlength="8"
                                    class="form-control has-pw-toggle" placeholder="Nhập mật khẩu mới" required />
                                <button type="button" class="pw-toggle-btn" aria-label="Hiện mật khẩu"
                                    title="Hiện mật khẩu" aria-pressed="false">
                                    <svg class="icon-eye" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" aria-hidden="true">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                    <svg class="icon-eye-off" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" aria-hidden="true">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                        <line x1="1" y1="1" x2="23" y2="23" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-label-row">
                                <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="req">*</span></label>
                            </div>
                            <div class="input-wrapper">
                                <span class="input-icon-left">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </span>
                                <input type="password" id="confirmPassword" name="confirmPassword" minlength="8"
                                    class="form-control has-pw-toggle" placeholder="Nhập lại mật khẩu mới" required />
                                <button type="button" class="pw-toggle-btn" aria-label="Hiện mật khẩu"
                                    title="Hiện mật khẩu" aria-pressed="false">
                                    <svg class="icon-eye" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" aria-hidden="true">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                    <svg class="icon-eye-off" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" aria-hidden="true">
                                        <path
                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                        <line x1="1" y1="1" x2="23" y2="23" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn-login-submit">
                            <span>Cập nhật mật khẩu</span>
                        </button>
                    </form>
                </section>
            </div>

            <div class="profile-shortcut-grid" aria-label="Tiện ích nhanh">
                <a href="${pageContext.request.contextPath}/services.jsp" class="profile-shortcut-card">
                    <span class="profile-shortcut-icon" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                    </span>
                    <span class="profile-shortcut-body">
                        <strong>Đặt lịch Grooming &amp; Spa</strong>
                        <span>Xem bảng giá theo cân nặng &amp; đặt lịch ngay</span>
                    </span>
                    <svg class="profile-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </a>

                <a href="${pageContext.request.contextPath}/branches.jsp" class="profile-shortcut-card">
                    <span class="profile-shortcut-icon" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                    </span>
                    <span class="profile-shortcut-body">
                        <strong>Hệ thống Chi nhánh</strong>
                        <span>4 cơ sở tiêu chuẩn tại TP.HCM &amp; Hà Nội</span>
                    </span>
                    <svg class="profile-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </a>

                <a href="${pageContext.request.contextPath}/home#quy-trinh-section" class="profile-shortcut-card">
                    <span class="profile-shortcut-icon" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            <polyline points="9 12 11 14 15 10"></polyline>
                        </svg>
                    </span>
                    <span class="profile-shortcut-body">
                        <strong>Quy trình Chăm sóc</strong>
                        <span>4 bước tắm thảo mộc &amp; tạo kiểu an toàn</span>
                    </span>
                    <svg class="profile-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </a>
            </div>
        </div>
    </main>

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
                        Hệ thống Salon &amp; Spa Chăm Sóc Thú Cưng Tiêu Chuẩn Cao Cấp. Mang đến trải nghiệm làm đẹp thư
                        giãn, an toàn với mỹ phẩm thảo mộc organic 100%.
                    </p>
                </div>

                <div class="footer-col">
                    <h4>Liên Kết &amp; Hỗ Trợ</h4>
                    <ul class="footer-links-list">
                        <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/branches.jsp">Hệ thống cơ sở Spa</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a></li>
                        <li><a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc 4
                                bước</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h4>Dịch Vụ Nổi Bật</h4>
                    <ul class="footer-links-list">
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Grooming &amp; Tắm sấy thảo
                                mộc</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Cắt tỉa tạo kiểu chuẩn Salon</a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Spa thảo dược &amp; Chăm sóc
                                da</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Combo chăm sóc &amp; Lưu trú
                                VIP</a></li>
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

    <script src="${pageContext.request.contextPath}/assets/js/pw-toggle.js?v=1"></script>
</body>

</html>
