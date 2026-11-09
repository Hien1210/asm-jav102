<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký tài khoản - Pet care | Hệ thống Dịch vụ Chăm sóc &amp; Spa Thú Cưng Hàng Đầu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css" />
</head>
<body>

    <!-- ====================================================================
         1. TOP HEADER / NAVBAR (Đồng bộ 100% với Trang chủ & Đăng nhập Pet care)
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
                <a href="${pageContext.request.contextPath}/login" class="btn-login-outline">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-solid active-auth">Đăng ký tài khoản</a>
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
         2. MAIN REGISTER STAGE
         ==================================================================== -->
    <main class="login-main">
        <div class="login-glow-mint"></div>

        <div class="login-card register-card">
            <div class="login-card-top">
                <h1 class="login-title">Tạo tài khoản <span class="brand-accent">Pet care</span></h1>
                <p class="login-subtitle" style="max-width: 460px;">
                    Đăng ký thành viên để lưu trữ hồ sơ bé cưng, theo dõi lịch spa định kỳ, cắt tỉa lông tạo kiểu và nhận ưu đãi chăm sóc thú cưng đặc quyền.
                </p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="login-alert login-alert-error">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="login-form" id="registerForm">
                <!-- Field 1: Full Name -->
                <div class="form-group">
                    <div class="form-label-row">
                        <label for="fullName" class="form-label">Họ và tên chủ thú cưng <span class="req">*</span></label>
                        <span class="form-label-hint">Tên hiển thị trên lịch spa</span>
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
                            id="fullName"
                            name="fullName"
                            class="form-control"
                            placeholder="Ví dụ: Nguyễn Thuỳ Trang"
                            value="${fullName}"
                            required
                            autocomplete="name"
                        />
                    </div>
                </div>

                <!-- Row 2: Phone & Email -->
                <div class="form-grid-2">
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="phone" class="form-label">Số điện thoại đăng ký <span class="req">*</span></label>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="5" y="2" width="14" height="20" rx="2" ry="2"/>
                                    <line x1="12" y1="18" x2="12.01" y2="18"/>
                                </svg>
                            </span>
                            <input
                                type="tel"
                                id="phone"
                                name="phone"
                                class="form-control"
                                placeholder="VD: 0912 345 678"
                                value="${phone}"
                                required
                                autocomplete="tel"
                            />
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="email" class="form-label">Email</label>
                            <span class="form-label-hint">Tùy chọn</span>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                    <polyline points="22,6 12,13 2,6"/>
                                </svg>
                            </span>
                            <input
                                type="email"
                                id="email"
                                name="email"
                                class="form-control"
                                placeholder="VD: thuytrang@gmail.com"
                                value="${email}"
                                autocomplete="email"
                            />
                        </div>
                    </div>
                </div>

                <!-- Row 3: Password & Confirm Password -->
                <div class="form-grid-2">
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="password" class="form-label">Mật khẩu tạo mới <span class="req">*</span></label>
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
                                placeholder="Tối thiểu 8 ký tự"
                                minlength="8"
                                required
                                autocomplete="new-password"
                            />
                            <button type="button" class="btn-toggle-pw" data-toggle-target="password" aria-label="Hiện/Ẩn mật khẩu">
                                <svg class="eye-open" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                                <svg class="eye-closed" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                                    <line x1="1" y1="1" x2="23" y2="23"/>
                                </svg>
                            </button>
                        </div>
                        <div class="pw-strength-row" aria-hidden="true">
                            <span class="pw-bar" id="pwBar1"></span>
                            <span class="pw-bar" id="pwBar2"></span>
                            <span class="pw-bar" id="pwBar3"></span>
                            <span class="pw-strength-label" id="pwStrengthText">Bảo mật</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="confirmPassword" class="form-label">Nhập lại mật khẩu <span class="req">*</span></label>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                                    <polyline points="9 12 11 14 15 10"/>
                                </svg>
                            </span>
                            <input
                                type="password"
                                id="confirmPassword"
                                name="confirmPassword"
                                class="form-control"
                                placeholder="Khớp với mật khẩu trên"
                                minlength="8"
                                required
                                autocomplete="new-password"
                            />
                            <button type="button" class="btn-toggle-pw" data-toggle-target="confirmPassword" aria-label="Hiện/Ẩn mật khẩu">
                                <svg class="eye-open" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                                <svg class="eye-closed" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                                    <line x1="1" y1="1" x2="23" y2="23"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Terms Checkbox -->
                <label class="remember-row terms-row">
                    <input type="checkbox" name="terms" required checked />
                    <span>
                        Tôi đồng ý với <a href="${pageContext.request.contextPath}/home#bang-gia-section">Điều khoản dịch vụ</a>
                        và <a href="${pageContext.request.contextPath}/home#bang-gia-section">Chính sách bảo mật</a> của Pet care Spa &amp; Grooming.
                    </span>
                </label>

                <!-- Submit Button -->
                <button type="submit" class="btn-login-submit">
                    <span>Đăng ký tài khoản ngay</span>
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"/>
                        <polyline points="12 5 19 12 12 19"/>
                    </svg>
                </button>
            </form>

            <div class="login-divider"></div>

            <div class="register-prompt" style="margin-bottom: 0;">
                Đã có tài khoản thành viên?
                <a href="${pageContext.request.contextPath}/login">
                    Đăng nhập ngay
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
            // 1. Toggle password visibility
            var toggleBtns = document.querySelectorAll('[data-toggle-target]');
            toggleBtns.forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var targetId = btn.getAttribute('data-toggle-target');
                    var input = document.getElementById(targetId);
                    var eyeOpen = btn.querySelector('.eye-open');
                    var eyeClosed = btn.querySelector('.eye-closed');
                    if (input) {
                        var isPassword = input.getAttribute('type') === 'password';
                        input.setAttribute('type', isPassword ? 'text' : 'password');
                        if (eyeOpen) eyeOpen.style.display = isPassword ? 'none' : 'block';
                        if (eyeClosed) eyeClosed.style.display = isPassword ? 'block' : 'none';
                    }
                });
            });

            // 2. Password strength indicator
            var pwInput = document.getElementById('password');
            var b1 = document.getElementById('pwBar1');
            var b2 = document.getElementById('pwBar2');
            var b3 = document.getElementById('pwBar3');
            var label = document.getElementById('pwStrengthText');
            if (pwInput && b1 && b2 && b3 && label) {
                pwInput.addEventListener('input', function() {
                    var val = pwInput.value || '';
                    b1.className = 'pw-bar';
                    b2.className = 'pw-bar';
                    b3.className = 'pw-bar';
                    if (val.length === 0) {
                        label.textContent = 'Bảo mật';
                    } else if (val.length < 8) {
                        b1.classList.add('active-weak');
                        label.textContent = 'Yếu';
                    } else if (val.length < 11) {
                        b1.classList.add('active-medium');
                        b2.classList.add('active-medium');
                        label.textContent = 'Khá';
                    } else {
                        b1.classList.add('active-strong');
                        b2.classList.add('active-strong');
                        b3.classList.add('active-strong');
                        label.textContent = 'Mạnh';
                    }
                });
            }
        })();
    </script>
</body>
</html>

