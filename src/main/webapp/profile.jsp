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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=16" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css?v=2" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css?v=4" />
</head>

<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">

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
                            <span class="header-user-avatar-circle${not empty sessionScope.loggedInAvatarUrl ? ' has-photo' : ''}" data-pf-avatar-slot>
                                <c:if test="${not empty sessionScope.loggedInAvatarUrl}">
                                    <img src="${fn:escapeXml(sessionScope.loggedInAvatarUrl)}" alt="Ảnh đại diện" class="pf-avatar-img" />
                                </c:if>
                                <span data-pf-avatar-letter${not empty sessionScope.loggedInAvatarUrl ? ' hidden' : ''}>${fn:toUpperCase(fn:substring(fn:trim(sessionScope.loggedInUser), 0, 1))}</span>
                            </span>
                            <span class="header-user-info">
                                <span class="header-user-name">${fn:escapeXml(sessionScope.loggedInUser)}</span>
                                <span class="header-user-role-tag${sessionScope.loggedInRole == 'STAFF' ? ' header-user-role-tag-staff' : ''}">
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
                                <span class="dropdown-user-avatar${not empty sessionScope.loggedInAvatarUrl ? ' has-photo' : ''}" data-pf-avatar-slot>
                                    <c:if test="${not empty sessionScope.loggedInAvatarUrl}">
                                        <img src="${fn:escapeXml(sessionScope.loggedInAvatarUrl)}" alt="Ảnh đại diện" class="pf-avatar-img" />
                                    </c:if>
                                    <span data-pf-avatar-letter${not empty sessionScope.loggedInAvatarUrl ? ' hidden' : ''}>${fn:toUpperCase(fn:substring(fn:trim(sessionScope.loggedInUser), 0, 1))}</span>
                                </span>
                                <div class="dropdown-user-meta">
                                    <strong>${fn:escapeXml(sessionScope.loggedInUser)}</strong>
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
                                    <strong>${fn:escapeXml(sessionScope.loggedInPhone)}</strong>
                                </div>
                                <div class="dropdown-meta-row">
                                    <span>Email</span>
                                    <strong>${fn:escapeXml(sessionScope.loggedInEmail)}</strong>
                                </div>
                            </div>

                            <div class="dropdown-menu-actions">
                                <c:if test="${sessionScope.loggedInRole == 'CUSTOMER'}">
                                    <a href="${pageContext.request.contextPath}/customer/dat-lich" class="dropdown-menu-link">
                                        <span>Đặt lịch chăm sóc &amp; lưu trú</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/lich-hen" class="dropdown-menu-link">
                                        <span>Lịch hẹn của tôi</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/thu-cung" class="dropdown-menu-link">
                                        <span>Thú cưng của tôi</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/thanh-toan" class="dropdown-menu-link">
                                        <span>Thanh toán hóa đơn</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/danh-gia" class="dropdown-menu-link">
                                        <span>Đánh giá dịch vụ</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/thong-bao" class="dropdown-menu-link">
                                        <span>Thông báo</span>
                                    </a>
                                </c:if>
                                <c:if test="${sessionScope.loggedInRole == 'STAFF'}">
                                    <a href="${pageContext.request.contextPath}/staff/dat-lich-tai-quay" class="dropdown-menu-link">
                                        <span>Đặt lịch tại quầy</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/staff/lich-hen" class="dropdown-menu-link">
                                        <span>Lịch hẹn của tôi</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/staff/lich-lam-viec" class="dropdown-menu-link">
                                        <span>Lịch làm việc</span>
                                    </a>
                                </c:if>
                                <c:if test="${sessionScope.loggedInRole == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/tai-khoan" class="dropdown-menu-link">
                                        <span>Quản lý tài khoản</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/lich-hen" class="dropdown-menu-link">
                                        <span>Quản lý lịch hẹn</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/bao-cao" class="dropdown-menu-link">
                                        <span>Báo cáo doanh thu</span>
                                    </a>
                                </c:if>
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

    <c:set var="roleCssClass" value="pf-role-customer" />
    <c:if test="${sessionScope.currentUser.role == 'STAFF'}">
        <c:set var="roleCssClass" value="pf-role-staff" />
    </c:if>
    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
        <c:set var="roleCssClass" value="pf-role-admin" />
    </c:if>

    <c:set var="hasDebt" value="${not empty profileRemainingRaw and profileRemainingRaw gt 0}" />

    <main class="pf-stage ${roleCssClass}">
        <div class="pf-container">

            <!-- 1. ARCHITECTURAL IDENTITY COVER CARD -->
            <c:set var="userInitial" value="${fn:toUpperCase(fn:substring(fn:trim(sessionScope.currentUser.fullName), 0, 1))}" />
            <c:set var="curAvatarUrl" value="${not empty sessionScope.currentUser.avatarUrl ? sessionScope.currentUser.avatarUrl : sessionScope.loggedInAvatarUrl}" />
            <c:set var="curBannerUrl" value="${not empty sessionScope.currentUser.bannerUrl ? sessionScope.currentUser.bannerUrl : sessionScope.loggedInBannerUrl}" />

            <section class="pf-identity-card pf-animate" aria-label="Hồ sơ của người dùng"
                     data-avatar-url="${fn:escapeXml(curAvatarUrl)}"
                     data-banner-url="${fn:escapeXml(curBannerUrl)}"
                     data-user-initial="${fn:escapeXml(userInitial)}">
                <div class="pf-cover${not empty curBannerUrl ? ' has-banner-photo' : ''}" id="pfCoverBanner">
                    <c:if test="${not empty curBannerUrl}">
                        <img src="${fn:escapeXml(curBannerUrl)}" alt="Ảnh bìa hồ sơ" class="pf-cover-photo" />
                    </c:if>

                    <span class="pf-cover-kicker">
                        <span class="pf-cover-kicker-dot" aria-hidden="true"></span>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">HỒ SƠ QUẢN TRỊ VIÊN PETCARE</c:when>
                            <c:when test="${sessionScope.currentUser.role == 'STAFF'}">HỒ SƠ NHÂN VIÊN PETCARE</c:when>
                            <c:otherwise>TRUNG TÂM THÀNH VIÊN PETCARE</c:otherwise>
                        </c:choose>
                    </span>

                    <div class="pf-cover-top-right">
                        <span class="pf-cover-id-chip" title="Mã tài khoản">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                                <line x1="7" y1="10" x2="17" y2="10"></line>
                                <line x1="7" y1="14" x2="13" y2="14"></line>
                            </svg>
                            <span>ID #${sessionScope.currentUser.userId}</span>
                        </span>
                    </div>

                    <button type="button" class="pf-cover-edit-btn" data-open-media-editor="banner"
                            title="Thay đổi hoặc canh chỉnh ảnh bìa">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                            <circle cx="12" cy="13" r="4"></circle>
                        </svg>
                        <span>Đổi ảnh bìa</span>
                    </button>

                    <svg class="pf-cover-paw" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                        <circle cx="7" cy="7.5" r="2.2" />
                        <circle cx="12" cy="5.2" r="2.2" />
                        <circle cx="17" cy="7.5" r="2.2" />
                        <circle cx="4.3" cy="12.2" r="2" />
                        <circle cx="19.7" cy="12.2" r="2" />
                        <path d="M12 11.2c-3.4 0-6.2 2.4-6.2 5.4 0 2 1.7 3.4 3.8 3.4 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2.1 0 3.8-1.4 3.8-3.4 0-3-2.8-5.4-6.2-5.4z" />
                    </svg>
                </div>

                <div class="pf-identity-body">
                    <div class="pf-identity-left">
                        <div class="pf-avatar-wrap">
                            <span class="pf-avatar${not empty curAvatarUrl ? ' has-photo' : ''}" data-pf-avatar-slot>
                                <c:if test="${not empty curAvatarUrl}">
                                    <img src="${fn:escapeXml(curAvatarUrl)}" alt="Ảnh đại diện" class="pf-avatar-img" />
                                </c:if>
                                <span data-pf-avatar-letter${not empty curAvatarUrl ? ' hidden' : ''}>${fn:escapeXml(userInitial)}</span>
                                <button type="button" class="pf-avatar-hover-mask" data-open-media-editor="avatar"
                                        aria-label="Đổi ảnh đại diện">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                        <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                        <circle cx="12" cy="13" r="4"></circle>
                                    </svg>
                                    <span>Đổi ảnh</span>
                                </button>
                            </span>
                            <c:if test="${sessionScope.currentUser.active}">
                                <span class="pf-avatar-verified-top" title="Tài khoản đang hoạt động">
                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </span>
                            </c:if>
                            <button type="button" class="pf-avatar-edit-btn" data-open-media-editor="avatar"
                                    title="Đổi hoặc canh chỉnh ảnh đại diện" aria-label="Đổi ảnh đại diện">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                    <circle cx="12" cy="13" r="4"></circle>
                                </svg>
                            </button>
                        </div>

                        <div class="pf-identity-info">
                            <div class="pf-name-row">
                                <h1 class="pf-user-name">${fn:escapeXml(sessionScope.currentUser.fullName)}</h1>
                                <div class="pf-badges-row">
                                    <span class="pf-badge pf-badge-role">
                                        <c:choose>
                                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">ADMIN &bull; Quản trị viên</c:when>
                                            <c:when test="${sessionScope.currentUser.role == 'STAFF'}">STAFF &bull; Nhân viên</c:when>
                                            <c:otherwise>CUSTOMER &bull; Thành viên</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.active}">
                                            <span class="pf-badge pf-badge-active">
                                                <span class="pf-pulse-dot" aria-hidden="true"></span>
                                                <span>Đang hoạt động</span>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pf-badge pf-badge-locked">Đã khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="pf-meta-strip">
                                <span class="pf-meta-item" title="Số điện thoại">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <rect x="5" y="2" width="14" height="20" rx="2"></rect>
                                        <line x1="12" y1="18" x2="12.01" y2="18"></line>
                                    </svg>
                                    <span>${not empty sessionScope.currentUser.phone ? fn:escapeXml(sessionScope.currentUser.phone) : 'Chưa cập nhật SĐT'}</span>
                                </span>

                                <span class="pf-meta-item" title="${fn:escapeXml(sessionScope.currentUser.email)}">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                        <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg>
                                    <span>${fn:escapeXml(sessionScope.currentUser.email)}</span>
                                </span>

                                <span class="pf-meta-item" title="Ngày tham gia">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.currentUser.createdAt}">Tham gia ${sessionScope.currentUser.createdAt.toLocalDate()}</c:when>
                                            <c:otherwise>Thành viên mới</c:otherwise>
                                        </c:choose>
                                    </span>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="pf-identity-actions">
                        <a href="${pageContext.request.contextPath}/home" class="pf-btn pf-btn-secondary">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" aria-hidden="true">
                                <line x1="19" y1="12" x2="5" y2="12"></line>
                                <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            <span>Trang chủ</span>
                        </a>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'CUSTOMER'}">
                                <a href="${pageContext.request.contextPath}/customer/dat-lich" class="pf-btn pf-btn-primary">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                        <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <span>Đặt lịch Spa ngay</span>
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.role == 'STAFF'}">
                                <a href="${pageContext.request.contextPath}/staff/lich-hen" class="pf-btn pf-btn-primary">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                        <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <span>Khu vực Nhân viên</span>
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin/tai-khoan" class="pf-btn pf-btn-primary">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                        <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                                        <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                                        <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                                        <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                                    </svg>
                                    <span>Vào trang Quản trị</span>
                                </a>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- FEEDBACK ALERTS -->
            <c:if test="${not empty profileSuccess}">
                <div class="pf-alert pf-alert-success" role="status">
                    <div class="pf-alert-content">
                        <span class="pf-alert-icon" aria-hidden="true">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                <polyline points="22 4 12 14.01 9 11.01" />
                            </svg>
                        </span>
                        <span>${fn:escapeXml(profileSuccess)}</span>
                    </div>
                    <button type="button" class="pf-alert-close" data-dismiss-alert aria-label="Đóng thông báo">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
            </c:if>

            <c:if test="${not empty profileError}">
                <div class="pf-alert pf-alert-error" role="alert">
                    <div class="pf-alert-content">
                        <span class="pf-alert-icon" aria-hidden="true">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="8" x2="12" y2="12" />
                                <line x1="12" y1="16" x2="12.01" y2="16" />
                            </svg>
                        </span>
                        <span>${fn:escapeXml(profileError)}</span>
                    </div>
                    <button type="button" class="pf-alert-close" data-dismiss-alert aria-label="Đóng thông báo">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
            </c:if>

            <!-- 2. MAIN ASYMMETRIC WORKSPACE -->
            <div class="pf-workspace">

                <!-- LEFT RAIL -->
                <aside class="pf-rail pf-animate pf-delay-1" aria-label="Tổng quan tài khoản">

                    <c:choose>
                        <c:when test="${sessionScope.currentUser.role == 'CUSTOMER'}">
                            <!-- LIVE CUSTOMER ACTIVITY BENTO -->
                            <section class="pf-card">
                                <div class="pf-card-head">
                                    <div>
                                        <h2 class="pf-card-title">Tổng quan hoạt động</h2>
                                        <p class="pf-card-sub">Dữ liệu đồng bộ theo tài khoản của bạn</p>
                                    </div>
                                    <span class="pf-chip pf-chip-accent">Trực tiếp</span>
                                </div>

                                <div class="pf-metrics-grid">
                                    <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pf-metric-tile">
                                        <div class="pf-metric-top">
                                            <span class="pf-metric-label">Thú cưng</span>
                                            <span class="pf-metric-ico" aria-hidden="true">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                    <circle cx="11" cy="4" r="2"></circle>
                                                    <circle cx="18" cy="8" r="2"></circle>
                                                    <circle cx="20" cy="16" r="2"></circle>
                                                    <path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"></path>
                                                </svg>
                                            </span>
                                        </div>
                                        <span class="pf-metric-val">${profilePetCount != null ? profilePetCount : 0} bé</span>
                                        <span class="pf-metric-sub">Quản lý hồ sơ &rarr;</span>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pf-metric-tile">
                                        <div class="pf-metric-top">
                                            <span class="pf-metric-label">Lịch hẹn</span>
                                            <span class="pf-metric-ico" aria-hidden="true">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                                </svg>
                                            </span>
                                        </div>
                                        <span class="pf-metric-val">${profileAppointmentCount != null ? profileAppointmentCount : 0} lịch</span>
                                        <span class="pf-metric-sub">${profileActiveAppointmentCount != null ? profileActiveAppointmentCount : 0} đang xử lý</span>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/customer/thanh-toan" class="pf-metric-tile${hasDebt ? ' is-warn' : ''}">
                                        <div class="pf-metric-top">
                                            <span class="pf-metric-label">Hóa đơn</span>
                                            <span class="pf-metric-ico" aria-hidden="true">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                    <rect x="1" y="4" width="22" height="16" rx="2"></rect>
                                                    <line x1="1" y1="10" x2="23" y2="10"></line>
                                                </svg>
                                            </span>
                                        </div>
                                        <span class="pf-metric-val">${not empty profileRemainingBalance ? profileRemainingBalance : '0 đ'}</span>
                                        <span class="pf-metric-sub">
                                            <c:choose>
                                                <c:when test="${hasDebt}">Cần thanh toán &rarr;</c:when>
                                                <c:otherwise>Không có công nợ</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/customer/danh-gia" class="pf-metric-tile">
                                        <div class="pf-metric-top">
                                            <span class="pf-metric-label">Đánh giá</span>
                                            <span class="pf-metric-ico" aria-hidden="true">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                                </svg>
                                            </span>
                                        </div>
                                        <span class="pf-metric-val">${profileReviewCount != null ? profileReviewCount : 0} lượt</span>
                                        <span class="pf-metric-sub">${profileCompletedAppointmentCount != null ? profileCompletedAppointmentCount : 0} lịch hoàn thành</span>
                                    </a>
                                </div>
                            </section>

                            <!-- MY PETS ROSTER CARD -->
                            <section class="pf-card">
                                <div class="pf-card-head">
                                    <div>
                                        <h2 class="pf-card-title">Bé cưng của bạn</h2>
                                        <p class="pf-card-sub">Chọn nhanh để đặt lịch Spa &amp; Lưu trú</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pf-link-subtle">
                                        <span>+ Quản lý</span>
                                    </a>
                                </div>

                                <c:choose>
                                    <c:when test="${empty profilePets}">
                                        <div class="pf-pets-empty">
                                            <span class="pf-pets-empty-ico" aria-hidden="true">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <circle cx="11" cy="4" r="2"></circle>
                                                    <circle cx="18" cy="8" r="2"></circle>
                                                    <circle cx="20" cy="16" r="2"></circle>
                                                    <path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"></path>
                                                </svg>
                                            </span>
                                            <p>Chưa có hồ sơ bé cưng nào. Thêm bé ngay để đặt lịch chỉ trong 10 giây.</p>
                                            <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pf-btn pf-btn-primary" style="height:36px;padding:0 14px;font-size:0.79rem;">
                                                <span>+ Thêm bé cưng đầu tiên</span>
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="pf-pet-list">
                                            <c:forEach var="pet" items="${profilePets}" end="4">
                                                <a href="${pageContext.request.contextPath}/customer/dat-lich?petId=${pet.petId}"
                                                   class="pf-pet-row" title="Đặt lịch cho ${fn:escapeXml(pet.name)}">
                                                    <span class="pf-pet-avatar" aria-hidden="true">
                                                        ${fn:toUpperCase(fn:substring(fn:trim(pet.name), 0, 1))}
                                                    </span>
                                                    <span class="pf-pet-info">
                                                        <strong class="pf-pet-name">${fn:escapeXml(pet.name)}</strong>
                                                        <span class="pf-pet-meta">
                                                            ${fn:escapeXml(pet.species)}<c:if test="${not empty pet.breed}"> &bull; ${fn:escapeXml(pet.breed)}</c:if><c:if test="${not empty pet.weightKg}"> &bull; ${pet.weightKg} kg</c:if>
                                                        </span>
                                                    </span>
                                                    <span class="pf-pet-book-cta">Đặt lịch</span>
                                                </a>
                                            </c:forEach>
                                        </div>
                                        <c:if test="${profilePetCount != null and profilePetCount > 5}">
                                            <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pf-pets-more">
                                                Xem tất cả ${profilePetCount} bé cưng &rarr;
                                            </a>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </section>
                        </c:when>

                        <c:when test="${sessionScope.currentUser.role == 'STAFF'}">
                            <section class="pf-card">
                                <div class="pf-card-head">
                                    <div>
                                        <h2 class="pf-card-title">Không gian Nhân viên</h2>
                                        <p class="pf-card-sub">Truy cập nhanh nghiệp vụ hằng ngày</p>
                                    </div>
                                    <span class="pf-chip pf-chip-accent">STAFF</span>
                                </div>
                                <div class="pf-role-links">
                                    <a href="${pageContext.request.contextPath}/staff/lich-hen" class="pf-role-link">
                                        <span class="pf-role-link-left">
                                            <span class="pf-role-link-ico" aria-hidden="true">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                                </svg>
                                            </span>
                                            <span>Lịch hẹn của tôi</span>
                                        </span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/staff/lich-lam-viec" class="pf-role-link">
                                        <span class="pf-role-link-left">
                                            <span class="pf-role-link-ico" aria-hidden="true">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="9"></circle>
                                                    <polyline points="12 7 12 12 15 15"></polyline>
                                                </svg>
                                            </span>
                                            <span>Lịch làm việc 14 ngày</span>
                                        </span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/staff/dat-lich-tai-quay" class="pf-role-link">
                                        <span class="pf-role-link-left">
                                            <span class="pf-role-link-ico" aria-hidden="true">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                    <polyline points="9 12 11 14 15 10"></polyline>
                                                </svg>
                                            </span>
                                            <span>Đặt lịch tại quầy</span>
                                        </span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                </div>
                            </section>
                        </c:when>

                        <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                            <section class="pf-card">
                                <div class="pf-card-head">
                                    <div>
                                        <h2 class="pf-card-title">Khu vực Quản trị</h2>
                                        <p class="pf-card-sub">Điều phối hệ thống PetCare</p>
                                    </div>
                                    <span class="pf-chip pf-chip-accent">ADMIN</span>
                                </div>
                                <div class="pf-role-links">
                                    <a href="${pageContext.request.contextPath}/admin/tai-khoan" class="pf-role-link">
                                        <span class="pf-role-link-left">
                                            <span class="pf-role-link-ico" aria-hidden="true">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                </svg>
                                            </span>
                                            <span>Quản lý tài khoản</span>
                                        </span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/lich-hen" class="pf-role-link">
                                        <span class="pf-role-link-left">
                                            <span class="pf-role-link-ico" aria-hidden="true">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                                </svg>
                                            </span>
                                            <span>Quản lý lịch hẹn</span>
                                        </span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/bao-cao" class="pf-role-link">
                                        <span class="pf-role-link-left">
                                            <span class="pf-role-link-ico" aria-hidden="true">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                                </svg>
                                            </span>
                                            <span>Báo cáo doanh thu</span>
                                        </span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                </div>
                            </section>
                        </c:when>
                    </c:choose>

                    <!-- ACCOUNT TRUST & SESSION CARD -->
                    <section class="pf-card pf-trust-card">
                        <div class="pf-card-head" style="margin-bottom: 10px;">
                            <div>
                                <h2 class="pf-card-title">Trạng thái &amp; Bảo mật</h2>
                                <p class="pf-card-sub">Thông tin phiên đăng nhập hiện tại</p>
                            </div>
                        </div>

                        <div class="pf-trust-list">
                            <div class="pf-trust-row">
                                <span class="pf-trust-key">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                    <span>Chuẩn mã hóa</span>
                                </span>
                                <span class="pf-trust-val">BCrypt 256-bit</span>
                            </div>
                            <div class="pf-trust-row">
                                <span class="pf-trust-key">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="9 12 11 14 15 10"></polyline>
                                    </svg>
                                    <span>Xác thực tài khoản</span>
                                </span>
                                <span class="pf-trust-val" style="color: ${sessionScope.currentUser.active ? '#047857' : '#b91c1c'};">
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.active}">Đã kích hoạt</c:when>
                                        <c:otherwise>Đã khóa</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="pf-trust-row">
                                <span class="pf-trust-key">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    <span>Vai trò hệ thống</span>
                                </span>
                                <span class="pf-trust-val">${sessionScope.currentUser.role}</span>
                            </div>
                        </div>

                        <c:if test="${sessionScope.currentUser.role == 'CUSTOMER'}">
                            <a href="${pageContext.request.contextPath}/customer/thong-bao" class="pf-trust-link">
                                <span style="display:inline-flex;align-items:center;gap:8px;">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                    </svg>
                                    <span>Hộp thư thông báo</span>
                                </span>
                                <span class="pf-chip pf-chip-accent">${profileNotificationCount != null ? profileNotificationCount : 0}</span>
                            </a>
                        </c:if>

                        <div class="pf-logout-box">
                            <a href="${pageContext.request.contextPath}/logout" class="pf-logout-btn">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" aria-hidden="true">
                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                    <polyline points="16 17 21 12 16 7"></polyline>
                                    <line x1="21" y1="12" x2="9" y2="12"></line>
                                </svg>
                                <span>Đăng xuất tài khoản</span>
                            </a>
                        </div>
                    </section>
                </aside>

                <!-- RIGHT MAIN COLUMN -->
                <div class="pf-main-col pf-animate pf-delay-2">

                    <!-- QUICK SECTION NAVIGATION -->
                    <nav class="pf-quick-nav" aria-label="Điều hướng nhanh mục hồ sơ">
                        <a href="#section-info" class="is-active" data-pf-nav="section-info">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <span>Thông tin cá nhân</span>
                        </a>
                        <a href="#section-security" data-pf-nav="section-security">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                            <span>Đổi mật khẩu</span>
                        </a>
                        <a href="#section-shortcuts" data-pf-nav="section-shortcuts">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                                <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                                <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                                <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                            </svg>
                            <span>Tiện ích nhanh</span>
                        </a>
                    </nav>

                    <!-- PANEL 1: PERSONAL INFORMATION -->
                    <section id="section-info" class="pf-card pf-form-card">
                        <div class="pf-card-head pf-card-head-border">
                            <div class="pf-card-title-group">
                                <span class="pf-card-icon" aria-hidden="true">
                                    <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </span>
                                <div>
                                    <h2 class="pf-card-title">Thông tin cá nhân</h2>
                                    <p class="pf-card-sub">
                                        Quản lý họ tên và thông tin liên hệ dùng cho xác nhận lịch hẹn tại PetCare.
                                    </p>
                                </div>
                            </div>
                            <span class="pf-chip pf-chip-accent" id="profileSyncChip">&#10003; Đã đồng bộ</span>
                        </div>

                        <form action="${pageContext.request.contextPath}/profile" method="post" class="pf-form" id="profileInfoForm">
                            <input type="hidden" name="action" value="updateProfile" />

                            <div class="pf-field">
                                <div class="pf-field-head">
                                    <label for="profileFullName" class="pf-label">Họ và tên <span class="req">*</span></label>
                                    <span class="pf-hint">Hiển thị trên hóa đơn &amp; lịch hẹn</span>
                                </div>
                                <div class="input-wrapper">
                                    <span class="input-icon-left" aria-hidden="true">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                    </span>
                                    <input type="text" id="profileFullName" name="fullName" class="form-control" maxlength="100"
                                        value="${fn:escapeXml(sessionScope.currentUser.fullName)}"
                                        data-initial="${fn:escapeXml(sessionScope.currentUser.fullName)}"
                                        placeholder="Nhập họ và tên của bạn" required />
                                </div>
                            </div>

                            <div class="pf-form-row-2">
                                <div class="pf-field">
                                    <div class="pf-field-head">
                                        <label for="profilePhone" class="pf-label">Số điện thoại <span class="req">*</span></label>
                                        <span class="pf-hint">Xác nhận lịch hẹn</span>
                                    </div>
                                    <div class="input-wrapper">
                                        <span class="input-icon-left" aria-hidden="true">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect>
                                                <line x1="12" y1="18" x2="12.01" y2="18"></line>
                                            </svg>
                                        </span>
                                        <input type="tel" id="profilePhone" name="phone" class="form-control" maxlength="20"
                                            value="${fn:escapeXml(sessionScope.currentUser.phone)}"
                                            data-initial="${fn:escapeXml(sessionScope.currentUser.phone)}"
                                            placeholder="Ví dụ: 0912345678" required />
                                    </div>
                                </div>

                                <div class="pf-field">
                                    <div class="pf-field-head">
                                        <label for="profileEmail" class="pf-label">Địa chỉ Email <span class="req">*</span></label>
                                        <span class="pf-hint">Nhận thông báo</span>
                                    </div>
                                    <div class="input-wrapper">
                                        <span class="input-icon-left" aria-hidden="true">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                                <polyline points="22,6 12,13 2,6"></polyline>
                                            </svg>
                                        </span>
                                        <input type="email" id="profileEmail" name="email" class="form-control" maxlength="100"
                                            value="${fn:escapeXml(sessionScope.currentUser.email)}"
                                            data-initial="${fn:escapeXml(sessionScope.currentUser.email)}"
                                            placeholder="email@domain.com" required />
                                    </div>
                                </div>
                            </div>

                            <div class="pf-form-footer">
                                <span class="pf-form-note">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="16" x2="12" y2="12"></line>
                                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                    </svg>
                                    <span>Cập nhật có hiệu lực ngay trên toàn bộ dịch vụ.</span>
                                </span>
                                <div class="pf-form-actions">
                                    <button type="button" class="pf-btn pf-btn-ghost" id="profileResetBtn" hidden>
                                        Hoàn tác
                                    </button>
                                    <button type="submit" class="pf-btn pf-btn-primary">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                            <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                            <polyline points="7 3 7 8 15 8"></polyline>
                                        </svg>
                                        <span>Lưu thay đổi hồ sơ</span>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </section>

                    <!-- PANEL 2: SECURITY & CHANGE PASSWORD -->
                    <section id="section-security" class="pf-card pf-form-card">
                        <div class="pf-card-head pf-card-head-border">
                            <div class="pf-card-title-group">
                                <span class="pf-card-icon" aria-hidden="true">
                                    <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                        <polyline points="9 12 11 14 15 10"></polyline>
                                    </svg>
                                </span>
                                <div>
                                    <h2 class="pf-card-title">Bảo mật &amp; Đổi mật khẩu</h2>
                                    <p class="pf-card-sub">
                                        Cập nhật mật khẩu định kỳ để bảo vệ tài khoản và lịch sử chăm sóc thú cưng.
                                    </p>
                                </div>
                            </div>
                            <span class="pf-chip">BCrypt 256-bit</span>
                        </div>

                        <form action="${pageContext.request.contextPath}/profile" method="post" class="pf-form" id="profilePasswordForm">
                            <input type="hidden" name="action" value="changePassword" />

                            <div class="pf-field">
                                <div class="pf-field-head">
                                    <label for="currentPassword" class="pf-label">Mật khẩu hiện tại <span class="req">*</span></label>
                                </div>
                                <div class="input-wrapper">
                                    <span class="input-icon-left" aria-hidden="true">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                            <line x1="1" y1="1" x2="23" y2="23" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <div class="pf-form-row-2">
                                <div class="pf-field">
                                    <div class="pf-field-head">
                                        <label for="newPassword" class="pf-label">Mật khẩu mới <span class="req">*</span></label>
                                        <span class="pf-hint">Tối thiểu 8 ký tự</span>
                                    </div>
                                    <div class="input-wrapper">
                                        <span class="input-icon-left" aria-hidden="true">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
                                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                                <line x1="1" y1="1" x2="23" y2="23" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <div class="pf-field">
                                    <div class="pf-field-head">
                                        <label for="confirmPassword" class="pf-label">Xác nhận mật khẩu <span class="req">*</span></label>
                                        <span class="pf-hint" id="pwMatchLabel" aria-live="polite"></span>
                                    </div>
                                    <div class="input-wrapper">
                                        <span class="input-icon-left" aria-hidden="true">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
                                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                                <line x1="1" y1="1" x2="23" y2="23" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- LIVE PASSWORD STRENGTH & REQUIREMENTS -->
                            <div class="pf-pw-box" aria-live="polite">
                                <div class="pf-pw-top">
                                    <span class="pf-pw-title">Độ mạnh mật khẩu</span>
                                    <span class="pf-pw-status" id="pwStrengthLabel">Chưa nhập mật khẩu mới</span>
                                </div>
                                <div class="pf-pw-bars">
                                    <span class="profile-pw-seg" data-seg="1"></span>
                                    <span class="profile-pw-seg" data-seg="2"></span>
                                    <span class="profile-pw-seg" data-seg="3"></span>
                                    <span class="profile-pw-seg" data-seg="4"></span>
                                </div>
                                <div class="pf-pw-rules">
                                    <span class="pf-pw-rule" data-rule="len">
                                        <span class="pf-pw-rule-dot" aria-hidden="true">
                                            <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                        </span>
                                        <span>Từ 8 ký tự</span>
                                    </span>
                                    <span class="pf-pw-rule" data-rule="case">
                                        <span class="pf-pw-rule-dot" aria-hidden="true">
                                            <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                        </span>
                                        <span>Chữ hoa &amp; thường</span>
                                    </span>
                                    <span class="pf-pw-rule" data-rule="num">
                                        <span class="pf-pw-rule-dot" aria-hidden="true">
                                            <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                        </span>
                                        <span>Có chữ số</span>
                                    </span>
                                    <span class="pf-pw-rule" data-rule="sym">
                                        <span class="pf-pw-rule-dot" aria-hidden="true">
                                            <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                        </span>
                                        <span>Ký tự đặc biệt</span>
                                    </span>
                                </div>
                            </div>

                            <div class="pf-form-footer">
                                <span class="pf-form-note">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <rect x="3" y="11" width="18" height="11" rx="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                    <span>Mật khẩu được băm một chiều an toàn, không lưu dạng thô.</span>
                                </span>
                                <div class="pf-form-actions">
                                    <button type="submit" class="pf-btn pf-btn-primary">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                            <polyline points="9 12 11 14 15 10"></polyline>
                                        </svg>
                                        <span>Cập nhật mật khẩu</span>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </section>
                </div>
            </div>

            <!-- 3. ROLE-AWARE SHORTCUT HUB -->
            <section id="section-shortcuts" class="pf-shortcuts-section pf-animate pf-delay-3" aria-label="Tiện ích nhanh">
                <div class="pf-section-head">
                    <h2>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">Phân hệ quản trị PetCare</c:when>
                            <c:when test="${sessionScope.currentUser.role == 'STAFF'}">Công cụ làm việc Nhân viên</c:when>
                            <c:otherwise>Tiện ích thành viên PetCare</c:otherwise>
                        </c:choose>
                    </h2>
                    <span>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">Đi tới nhanh các trang quản trị danh mục và báo cáo</c:when>
                            <c:when test="${sessionScope.currentUser.role == 'STAFF'}">Quản lý lịch hẹn, ca trực và đặt lịch cho khách tại quầy</c:when>
                            <c:otherwise>Truy cập nhanh mọi dịch vụ chăm sóc dành riêng cho bạn</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="pf-shortcut-grid">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser.role == 'STAFF'}">
                            <a href="${pageContext.request.contextPath}/staff/lich-hen" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-indigo" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Lịch hẹn của tôi</strong></span>
                                    <p>Xem lịch hẹn được phân công, check-in và cập nhật tiến độ thực hiện</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/staff/lich-lam-viec" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-blue" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="9"></circle>
                                        <polyline points="12 7 12 12 15 15"></polyline>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Lịch làm việc</strong></span>
                                    <p>Theo dõi ca trực và khung giờ làm việc trong 14 ngày tới</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/staff/dat-lich-tai-quay" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-amber" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="1" y="4" width="22" height="16" rx="2"></rect>
                                        <line x1="1" y1="10" x2="23" y2="10"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Đặt lịch tại quầy</strong></span>
                                    <p>Tạo lịch nhanh cho khách vãng lai, thêm thú cưng và thu tiền trực tiếp</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>
                        </c:when>

                        <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/tai-khoan" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-emerald" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Quản lý tài khoản</strong></span>
                                    <p>Phân quyền, trạng thái hoạt động và đặt lại mật khẩu thành viên</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/lich-hen" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-blue" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Quản lý lịch hẹn</strong></span>
                                    <p>Theo dõi, lọc trạng thái và điều phối toàn bộ lịch dịch vụ &amp; lưu trú</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/bao-cao" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-amber" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="18" y1="20" x2="18" y2="10"></line>
                                        <line x1="12" y1="20" x2="12" y2="4"></line>
                                        <line x1="6" y1="20" x2="6" y2="14"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Báo cáo doanh thu</strong></span>
                                    <p>Thống kê thực thu theo khoảng thời gian và xuất file CSV</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/dich-vu" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-teal" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                                        <polyline points="2 17 12 22 22 17"></polyline>
                                        <polyline points="2 12 12 17 22 12"></polyline>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Quản lý dịch vụ</strong></span>
                                    <p>Cập nhật danh mục Spa, thời lượng và bảng giá dịch vụ lẻ</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/combo" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-rose" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="20 12 20 22 4 22 4 12"></polyline>
                                        <rect x="2" y="7" width="20" height="5"></rect>
                                        <line x1="12" y1="22" x2="12" y2="7"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Quản lý gói Combo</strong></span>
                                    <p>Thiết lập gói chăm sóc kết hợp nhiều dịch vụ với mức giá ưu đãi</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/phong" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-indigo" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row"><strong>Quản lý phòng lưu trú</strong></span>
                                    <p>Cấu hình hạng phòng khách sạn thú cưng, đơn giá và trạng thái bảo trì</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>
                        </c:when>

                        <c:otherwise>
                            <!-- CUSTOMER: 6 UNIQUE, BALANCED SHORTCUT CARDS -->
                            <a href="${pageContext.request.contextPath}/customer/dat-lich" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-teal" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row">
                                        <strong>Đặt lịch Spa, Combo &amp; Lưu trú</strong>
                                    </span>
                                    <p>Đặt dịch vụ lẻ, gói combo ưu đãi hoặc phòng khách sạn thú cưng</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-blue" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row">
                                        <strong>Lịch hẹn của tôi</strong>
                                        <c:if test="${profileActiveAppointmentCount != null and profileActiveAppointmentCount > 0}">
                                            <span class="pf-shortcut-pill">${profileActiveAppointmentCount} đang xử lý</span>
                                        </c:if>
                                    </span>
                                    <p>Theo dõi tiến độ chăm sóc, xem chi tiết hóa đơn &amp; hủy lịch khi cần</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-emerald" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="4" r="2"></circle>
                                        <circle cx="18" cy="8" r="2"></circle>
                                        <circle cx="20" cy="16" r="2"></circle>
                                        <path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"></path>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row">
                                        <strong>Thú cưng của tôi</strong>
                                        <c:if test="${profilePetCount != null and profilePetCount > 0}">
                                            <span class="pf-shortcut-pill">${profilePetCount} bé</span>
                                        </c:if>
                                    </span>
                                    <p>Quản lý hồ sơ, cân nặng, ngày sinh &amp; ghi chú sức khỏe bé cưng</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/customer/thanh-toan" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-amber" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                                        <line x1="1" y1="10" x2="23" y2="10"></line>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row">
                                        <strong>Thanh toán hóa đơn</strong>
                                        <c:if test="${hasDebt}">
                                            <span class="pf-shortcut-pill is-warn">Còn nợ</span>
                                        </c:if>
                                    </span>
                                    <p>Thanh toán Online / Tại quầy, xem số dư &amp; tra cứu lịch sử giao dịch</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/customer/danh-gia" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-rose" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row">
                                        <strong>Đánh giá dịch vụ</strong>
                                    </span>
                                    <p>Gửi đánh giá 1–5 sao &amp; nhận xét cho các lịch hẹn đã hoàn thành</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/customer/thong-bao" class="pf-shortcut-card">
                                <span class="pf-shortcut-icon pf-ico-indigo" aria-hidden="true">
                                    <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                    </svg>
                                </span>
                                <span class="pf-shortcut-body">
                                    <span class="pf-shortcut-title-row">
                                        <strong>Thông báo của tôi</strong>
                                        <c:if test="${profileNotificationCount != null and profileNotificationCount > 0}">
                                            <span class="pf-shortcut-pill">${profileNotificationCount}</span>
                                        </c:if>
                                    </span>
                                    <p>Xem lịch sử xác nhận đặt lịch, cập nhật tiến độ &amp; thanh toán</p>
                                </span>
                                <svg class="pf-shortcut-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
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
                        <li><a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc 4 bước</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h4>Dịch Vụ Nổi Bật</h4>
                    <ul class="footer-links-list">
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Grooming &amp; Tắm sấy thảo mộc</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Cắt tỉa tạo kiểu chuẩn Salon</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Spa thảo dược &amp; Chăm sóc da</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Combo chăm sóc &amp; Lưu trú VIP</a></li>
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

    <script>
        (function () {
            /* 1. Dismissible alerts */
            document.querySelectorAll("[data-dismiss-alert]").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var box = btn.closest(".pf-alert");
                    if (box) box.remove();
                });
            });

            /* 2. Dirty-state tracker + Reset for personal info form */
            var infoForm = document.getElementById("profileInfoForm");
            var syncChip = document.getElementById("profileSyncChip");
            var resetBtn = document.getElementById("profileResetBtn");

            if (infoForm) {
                var trackedFields = infoForm.querySelectorAll("input[data-initial]");

                function checkDirty() {
                    var dirty = false;
                    trackedFields.forEach(function (input) {
                        if (input.value !== input.getAttribute("data-initial")) {
                            dirty = true;
                        }
                    });

                    if (syncChip) {
                        if (dirty) {
                            syncChip.textContent = "• Có thay đổi chưa lưu";
                            syncChip.className = "pf-chip pf-chip-warn";
                        } else {
                            syncChip.textContent = "✓ Đã đồng bộ";
                            syncChip.className = "pf-chip pf-chip-accent";
                        }
                    }
                    if (resetBtn) {
                        resetBtn.hidden = !dirty;
                    }
                }

                trackedFields.forEach(function (input) {
                    input.addEventListener("input", checkDirty);
                });

                if (resetBtn) {
                    resetBtn.addEventListener("click", function () {
                        trackedFields.forEach(function (input) {
                            input.value = input.getAttribute("data-initial") || "";
                        });
                        checkDirty();
                    });
                }
            }

            /* 3. Live password strength meter + 4-rule chips + confirm match */
            var pw = document.getElementById("newPassword");
            var cf = document.getElementById("confirmPassword");
            var segs = document.querySelectorAll(".profile-pw-seg");
            var strengthLbl = document.getElementById("pwStrengthLabel");
            var matchLbl = document.getElementById("pwMatchLabel");
            var ruleEls = {
                len: document.querySelector('.pf-pw-rule[data-rule="len"]'),
                case: document.querySelector('.pf-pw-rule[data-rule="case"]'),
                num: document.querySelector('.pf-pw-rule[data-rule="num"]'),
                sym: document.querySelector('.pf-pw-rule[data-rule="sym"]')
            };

            function updatePwUi() {
                if (!pw) return;
                var v = pw.value || "";
                var checks = {
                    len: v.length >= 8,
                    case: /[A-Z]/.test(v) && /[a-z]/.test(v),
                    num: /[0-9]/.test(v),
                    sym: /[^A-Za-z0-9]/.test(v)
                };

                Object.keys(ruleEls).forEach(function (key) {
                    if (ruleEls[key]) {
                        ruleEls[key].classList.toggle("is-met", checks[key]);
                    }
                });

                var score = 0;
                if (v.length > 0) {
                    if (checks.len) score++;
                    if (checks.case) score++;
                    if (checks.num) score++;
                    if (checks.sym) score++;
                    score = Math.max(1, score);
                }

                var colors = ["#e2e8f0", "#ef4444", "#f59e0b", "#10b981", "#075c45"];
                var labels = [
                    "Chưa nhập mật khẩu mới",
                    "Mật khẩu yếu (cần tối thiểu 8 ký tự)",
                    "Mật khẩu trung bình",
                    "Mật khẩu khá mạnh",
                    "Mật khẩu rất mạnh"
                ];

                segs.forEach(function (el, idx) {
                    el.style.background = (idx < score) ? colors[score] : "#e2e8f0";
                });
                if (strengthLbl) {
                    strengthLbl.textContent = labels[score];
                    strengthLbl.style.color = score > 0 ? colors[score] : "#64748b";
                }

                if (cf && matchLbl) {
                    if (!cf.value) {
                        matchLbl.textContent = "";
                    } else if (cf.value === v) {
                        matchLbl.textContent = "✓ Khớp mật khẩu";
                        matchLbl.style.color = "#047857";
                    } else {
                        matchLbl.textContent = "Chưa khớp";
                        matchLbl.style.color = "#dc2626";
                    }
                }
            }

            if (pw) pw.addEventListener("input", updatePwUi);
            if (cf) cf.addEventListener("input", updatePwUi);

            /* 4. Quick section nav active state */
            var navLinks = document.querySelectorAll("[data-pf-nav]");
            navLinks.forEach(function (link) {
                link.addEventListener("click", function () {
                    navLinks.forEach(function (other) { other.classList.remove("is-active"); });
                    link.classList.add("is-active");
                });
            });
        })();
    </script>
    <!-- PRECISION IMAGE CROP & CLOUDINARY UPLOAD STUDIO MODAL -->
    <div id="pfMediaModal" class="pf-modal" role="dialog" aria-modal="true" aria-labelledby="pfMediaTitle" hidden>
        <div class="pf-modal-backdrop" data-close-media-modal></div>
        <div class="pf-modal-dialog">
            <div class="pf-modal-head">
                <div>
                    <h2 class="pf-modal-title" id="pfMediaTitle">Chỉnh sửa ảnh đại diện</h2>
                    <p class="pf-modal-sub" id="pfMediaSub">Kéo thả, phóng to/thu nhỏ, xoay và canh khung chính xác trước khi lưu lên Cloudinary.</p>
                </div>
                <button type="button" class="pf-modal-close" data-close-media-modal aria-label="Đóng trình chỉnh sửa ảnh">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>

            <div class="pf-modal-body">
                <div id="pfMediaError" class="pf-media-error" role="alert" hidden></div>
                <input type="file" id="pfMediaFileInput" accept="image/jpeg,image/png,image/webp,image/gif" hidden />

                <!-- DROPZONE -->
                <div id="pfMediaDropzone" class="pf-dropzone" role="button" tabindex="0">
                    <span class="pf-dropzone-ico" aria-hidden="true">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="17 8 12 3 7 8"></polyline>
                            <line x1="12" y1="3" x2="12" y2="15"></line>
                        </svg>
                    </span>
                    <strong>Chọn ảnh từ máy hoặc kéo thả vào đây</strong>
                    <span>Hỗ trợ JPG, PNG, WebP, GIF &bull; Tối đa 8 MB &bull; Tối ưu tự động qua Cloudinary CDN</span>
                </div>

                <!-- STUDIO EDITOR -->
                <div id="pfMediaEditorWrap" class="pf-editor-layout" hidden>
                    <div class="pf-crop-stage-card">
                        <div class="pf-crop-stage" id="pfCropStage" title="Kéo ảnh để di chuyển, cuộn chuột để thu phóng">
                            <canvas id="pfCropCanvas" class="pf-crop-canvas"></canvas>
                        </div>
                        <div class="pf-stage-bar">
                            <span>Kéo ảnh · Cuộn chuột thu phóng · Phím mũi tên canh từng px</span>
                            <span id="pfPosReadout">X: 0px · Y: 0px</span>
                        </div>
                    </div>

                    <div class="pf-studio-panel">
                        <!-- LIVE PREVIEW -->
                        <div class="pf-preview-box" id="pfLivePreviewWrap">
                            <div class="pf-preview-frame">
                                <canvas id="pfLivePreviewCanvas"></canvas>
                            </div>
                            <div class="pf-preview-meta">
                                <strong>Xem trước thực tế</strong>
                                <span>Hiển thị đúng tỷ lệ sau khi lưu lên hồ sơ của bạn.</span>
                            </div>
                        </div>

                        <!-- ZOOM & ROTATION -->
                        <div class="pf-ctrl-group">
                            <div class="pf-ctrl-row">
                                <div class="pf-ctrl-head">
                                    <label for="pfZoomRange">Thu phóng (Zoom)</label>
                                    <output id="pfZoomVal">100%</output>
                                </div>
                                <div class="pf-slider-line">
                                    <button type="button" class="pf-mini-btn" id="pfBtnZoomOut" aria-label="Thu nhỏ">&minus;</button>
                                    <input type="range" id="pfZoomRange" class="pf-range" min="100" max="300" step="1" value="100" />
                                    <button type="button" class="pf-mini-btn" id="pfBtnZoomIn" aria-label="Phóng to">+</button>
                                </div>
                            </div>

                            <div class="pf-ctrl-row">
                                <div class="pf-ctrl-head">
                                    <label for="pfRotateRange">Góc xoay chi tiết</label>
                                    <output id="pfRotateVal">0&deg;</output>
                                </div>
                                <div class="pf-slider-line">
                                    <button type="button" class="pf-mini-btn" id="pfBtnRotLeft" title="Xoay trái 90°">-90&deg;</button>
                                    <input type="range" id="pfRotateRange" class="pf-range" min="-45" max="45" step="1" value="0" />
                                    <button type="button" class="pf-mini-btn" id="pfBtnRotRight" title="Xoay phải 90°">+90&deg;</button>
                                </div>
                            </div>
                        </div>

                        <!-- FLIP, NUDGE & LIGHT -->
                        <div class="pf-ctrl-group">
                            <div class="pf-tool-bar">
                                <button type="button" class="pf-mini-btn" id="pfBtnFlipH">Lật ngang</button>
                                <button type="button" class="pf-mini-btn" id="pfBtnFlipV">Lật dọc</button>
                                <button type="button" class="pf-mini-btn" id="pfBtnCenterCrop">Canh giữa</button>
                                <button type="button" class="pf-mini-btn" id="pfBtnResetCrop">Đặt lại</button>
                            </div>

                            <div class="pf-nudge-row">
                                <span style="font-size:0.75rem;font-weight:700;color:var(--pf-ink-2);">Dịch chuyển mịn</span>
                                <div class="pf-nudge-pad">
                                    <button type="button" class="pf-mini-btn" data-nudge="left" aria-label="Dịch trái">&larr;</button>
                                    <button type="button" class="pf-mini-btn" data-nudge="up" aria-label="Dịch lên">&uarr;</button>
                                    <button type="button" class="pf-mini-btn" data-nudge="down" aria-label="Dịch xuống">&darr;</button>
                                    <button type="button" class="pf-mini-btn" data-nudge="right" aria-label="Dịch phải">&rarr;</button>
                                </div>
                            </div>

                            <div class="pf-ctrl-2col">
                                <div class="pf-ctrl-row">
                                    <div class="pf-ctrl-head">
                                        <label for="pfBrightRange">Độ sáng</label>
                                        <output id="pfBrightVal">100%</output>
                                    </div>
                                    <input type="range" id="pfBrightRange" class="pf-range" min="75" max="130" step="1" value="100" />
                                </div>

                                <div class="pf-ctrl-row">
                                    <div class="pf-ctrl-head">
                                        <label for="pfContrastRange">Tương phản</label>
                                        <output id="pfContrastVal">100%</output>
                                    </div>
                                    <input type="range" id="pfContrastRange" class="pf-range" min="75" max="130" step="1" value="100" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pf-modal-foot">
                <div class="pf-modal-foot-left">
                    <button type="button" class="pf-btn pf-btn-secondary" id="pfBtnChooseAnother" hidden>Chọn ảnh khác</button>
                    <button type="button" class="pf-btn pf-btn-danger-soft" id="pfBtnRemoveMedia" hidden>Khôi phục mặc định</button>
                </div>
                <div class="pf-modal-foot-right">
                    <button type="button" class="pf-btn pf-btn-secondary" id="pfBtnCancelMedia" data-close-media-modal>Hủy</button>
                    <button type="button" class="pf-btn pf-btn-primary" id="pfBtnSaveMedia" disabled>
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="17 8 12 3 7 8"></polyline>
                            <line x1="12" y1="3" x2="12" y2="15"></line>
                        </svg>
                        <span>Lưu &amp; tải lên Cloudinary</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/profile-media-editor.js?v=2"></script>
    <script src="${pageContext.request.contextPath}/assets/js/pw-toggle.js?v=1"></script>
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>

</html>
