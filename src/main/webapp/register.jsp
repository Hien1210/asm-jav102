<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký tài khoản — Pet care | Pet Spa &amp; Grooming Lounge</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=5" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css" />
</head>

<body>

    <header class="site-header">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand-wrap" aria-label="Pet care — Trang chủ">
                <span class="brand-icon-box">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo" class="brand-logo-img" />
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
                <a href="${pageContext.request.contextPath}/login" class="btn-login-outline">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-solid active-auth">Đăng ký tài
                    khoản</a>
                <a href="${pageContext.request.contextPath}/login" class="btn-user-avatar" aria-label="Tài khoản">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.1">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </a>
            </div>
        </div>
    </header>

    <main class="login-main">
        <div class="login-glow-mint"></div>

        <div class="login-card register-card">
            <div class="auth-mode-switcher" aria-label="Chuyển đổi Đăng nhập và Đăng ký">
                <a href="${pageContext.request.contextPath}/login" class="auth-mode-tab">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="auth-mode-tab active">Tạo tài khoản</a>
            </div>

            <div class="login-card-top">
                <h1 class="login-title">Tạo tài khoản <span class="brand-accent">Pet care</span></h1>
                <p class="login-subtitle">
                    Đăng ký thành viên để lưu trữ hồ sơ bé cưng, theo dõi lịch spa định kỳ và nhận ưu đãi chăm sóc đặc
                    quyền.
                </p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="login-alert login-alert-error">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.2">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="12" />
                        <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="login-form">
                <div class="form-group">
                    <div class="form-label-row">
                        <label for="fullName" class="form-label">Họ và tên chủ thú cưng <span
                                class="req">*</span></label>
                        <span class="form-label-hint">Tên hiển thị trên lịch spa</span>
                    </div>
                    <div class="input-wrapper">
                        <span class="input-icon-left">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                <circle cx="12" cy="7" r="4" />
                            </svg>
                        </span>
                        <input type="text" id="fullName" name="fullName" class="form-control"
                            placeholder="Ví dụ: Nguyễn Thuỳ Trang" value="${fullName}" required autocomplete="name" />
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="phone" class="form-label">Số điện thoại đăng ký <span
                                    class="req">*</span></label>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="5" y="2" width="14" height="20" rx="2" ry="2" />
                                    <line x1="12" y1="18" x2="12.01" y2="18" />
                                </svg>
                            </span>
                            <input type="tel" id="phone" name="phone" class="form-control"
                                placeholder="VD: 0912 345 678" value="${phone}" required autocomplete="tel" />
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="email" class="form-label">Email</label>
                            <span class="form-label-hint">Tùy chọn</span>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                    <polyline points="22,6 12,13 2,6" />
                                </svg>
                            </span>
                            <input type="email" id="email" name="email" class="form-control"
                                placeholder="VD: thuytrang@gmail.com" value="${email}" autocomplete="email" />
                        </div>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="password" class="form-label">Mật khẩu tạo mới <span class="req">*</span></label>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                </svg>
                            </span>
                            <input type="password" id="password" name="password" class="form-control"
                                placeholder="Tối thiểu 8 ký tự" minlength="8" required autocomplete="new-password" />
                        </div>
                        <div class="pw-strength-row" aria-hidden="true">
                            <span class="pw-bar"></span>
                            <span class="pw-bar"></span>
                            <span class="pw-bar"></span>
                            <span class="pw-strength-label">Bảo mật</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="confirmPassword" class="form-label">Nhập lại mật khẩu <span
                                    class="req">*</span></label>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                    <polyline points="9 12 11 14 15 10" />
                                </svg>
                            </span>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                                placeholder="Khớp với mật khẩu trên" minlength="8" required
                                autocomplete="new-password" />
                        </div>
                    </div>
                </div>

                <label class="remember-row terms-row">
                    <input type="checkbox" name="terms" required checked />
                    <span>
                        Tôi đồng ý với <a href="${pageContext.request.contextPath}/services.jsp">Điều khoản dịch vụ</a>
                        và <a href="${pageContext.request.contextPath}/services.jsp">Chính sách bảo mật</a> của Pet care
                        Spa &amp; Grooming.
                    </span>
                </label>

                <button type="submit" class="btn-login-submit">
                    <span>Đăng ký tài khoản ngay</span>
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12" />
                        <polyline points="12 5 19 12 12 19" />
                    </svg>
                </button>
            </form>

            <div class="login-divider"></div>

            <div class="register-prompt">
                Đã có tài khoản thành viên?
                <a href="${pageContext.request.contextPath}/login">
                    Đăng nhập ngay
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="9 18 15 12 9 6" />
                    </svg>
                </a>
            </div>
        </div>

        <div class="security-note">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"
                stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                <polyline points="9 12 11 14 15 10" />
            </svg>
            <span>Bảo mật chuẩn mã hóa SSL 256-bit &bull; Hệ thống Pet care Grooming &amp; Spa</span>
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

</body>

</html>