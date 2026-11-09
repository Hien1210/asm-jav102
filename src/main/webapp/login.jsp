<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập - Pet care | Hệ thống Dịch vụ Chăm sóc &amp; Spa Thú Cưng Hàng Đầu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css" />
</head>
<body>

    <!-- ====================================================================
         1. TOP HEADER / NAVBAR (Đồng bộ 100% với Trang chủ Pet care)
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
                <a href="${pageContext.request.contextPath}/home" class="active">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/home#khong-gian-section">Giới thiệu &amp; Cơ sở</a>
                <a href="${pageContext.request.contextPath}/home#bang-gia-section">Bảng giá &amp; Dịch vụ</a>
                <a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc</a>
                <a href="${pageContext.request.contextPath}/home#quyen-loi-section">Tra cứu &amp; Hướng dẫn</a>
            </nav>

            <div class="header-auth-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn-login-outline active-auth">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-solid">Đăng ký tài khoản</a>
                <a href="${pageContext.request.contextPath}/login" class="btn-user-avatar" aria-label="Tài khoản">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </a>
            </div>
        </div>
    </header>

    <!-- ====================================================================
         2. MAIN LOGIN STAGE
         ==================================================================== -->
    <main class="login-main">
        <div class="login-glow-mint"></div>

        <div class="login-card">
            <div class="login-card-top">
                <h1 class="login-title">Chào mừng trở lại!</h1>
                <p class="login-subtitle">Đăng nhập để theo dõi lịch spa, cắt tỉa lông và quản lý hồ sơ thú cưng của bạn.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="login-alert login-alert-error">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="login-form" id="loginForm">
                <!-- Field 1: Phone or Email -->
                <div class="form-group">
                    <div class="form-label-row">
                        <label for="identifier" class="form-label">Số điện thoại hoặc Email <span class="req">*</span></label>
                    </div>
                    <div class="input-wrapper">
                        <span class="input-icon-left">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </span>
                        <input
                            type="text"
                            id="identifier"
                            name="identifier"
                            class="form-control"
                            placeholder="Ví dụ: 0912 345 678 hoặc petcare@gmail.com"
                            value="${identifier}"
                            required
                            autocomplete="username"
                        />
                    </div>
                </div>

                <!-- Field 2: Password -->
                <div class="form-group">
                    <div class="form-label-row">
                        <label for="password" class="form-label">Mật khẩu tài khoản <span class="req">*</span></label>
                        <a href="#quen-mat-khau" class="forgot-link">Quên mật khẩu?</a>
                    </div>
                    <div class="input-wrapper">
                        <span class="input-icon-left">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)"
                            minlength="6"
                            required
                            autocomplete="current-password"
                        />
                        <button type="button" class="btn-toggle-pw" id="togglePwBtn" aria-label="Hiện/Ẩn mật khẩu">
                            <svg id="eyeOpenIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                            <svg id="eyeClosedIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                                <line x1="1" y1="1" x2="23" y2="23"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Remember Checkbox -->
                <label class="remember-row">
                    <input type="checkbox" name="remember" checked />
                    <span>Ghi nhớ đăng nhập trên thiết bị này</span>
                </label>

                <!-- Submit Button -->
                <button type="submit" class="btn-login-submit">
                    <span>Đăng nhập ngay</span>
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"/>
                        <polyline points="12 5 19 12 12 19"/>
                    </svg>
                </button>
            </form>

            <div class="login-divider"></div>

            <div class="register-prompt" style="margin-bottom: 0;">
                Bạn chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register">
                    Đăng ký ngay
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="9 18 15 12 9 6"/>
                    </svg>
                </a>
            </div>
        </div>

        <!-- Security Note Below Card -->
        <div class="security-note">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                <polyline points="9 12 11 14 15 10"/>
            </svg>
            <span>Bảo mật chuẩn mã hóa SSL 256-bit &bull; Hệ thống Pet care Grooming &amp; Spa</span>
        </div>
    </main>

    <!-- ====================================================================
         3. SITE FOOTER (Đồng bộ 100% với Trang chủ Pet care)
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
                    <h4>Giờ Hoạt Động &amp; Liên Hệ</h4>
                    <div class="footer-info-list">
                        <div class="footer-info-item">
                            <span>&#128337;</span>
                            <span>Dịch vụ Spa &amp; Salon: 08:00 - 20:30 (Thứ 2 - CN)</span>
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
                        <li><a href="${pageContext.request.contextPath}/home#bang-gia-section">Chính sách bảo mật</a></li>
                        <li><a href="${pageContext.request.contextPath}/home#bang-gia-section">Quy chuẩn vệ sinh salon</a></li>
                        <li><a href="${pageContext.request.contextPath}/home#bang-gia-section">Cam kết bảo hành form tỉa</a></li>
                        <li><a href="${pageContext.request.contextPath}/home#quy-trinh-section">Chính sách đổi lịch hẹn</a></li>
                    </ul>
                </div>
            </div>

            <div class="footer-bottom">
                <span>&copy; 2025 Pet care Pet Grooming &amp; Spa Salon. Toàn bộ quyền được bảo lưu.</span>
                <span class="footer-verified">&#10003; Chứng nhận Salon Grooming Chuyên Nghiệp Việt Nam</span>
            </div>
        </div>
    </footer>

    <script>
        (function() {
            var toggleBtn = document.getElementById('togglePwBtn');
            var pwInput = document.getElementById('password');
            var eyeOpen = document.getElementById('eyeOpenIcon');
            var eyeClosed = document.getElementById('eyeClosedIcon');

            if (toggleBtn && pwInput) {
                toggleBtn.addEventListener('click', function() {
                    var isPassword = pwInput.getAttribute('type') === 'password';
                    pwInput.setAttribute('type', isPassword ? 'text' : 'password');
                    eyeOpen.style.display = isPassword ? 'none' : 'block';
                    eyeClosed.style.display = isPassword ? 'block' : 'none';
                });
            }
        })();
    </script>
</body>
</html>
