<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu — Pet care | Pet Spa &amp; Grooming Lounge</title>
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
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo" class="brand-logo-img" />
                </span>
            </a>
        </div>
    </header>

    <main class="login-main">
        <div class="login-glow-mint"></div>

        <div class="login-card">
            <div class="login-card-top">
                <h1 class="login-title">Quên mật khẩu?</h1>
                <p class="login-subtitle">
                    Nhập số điện thoại hoặc email đã đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu qua email.
                </p>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="login-alert login-alert-success">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.2">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                        <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                    <span>${fn:escapeXml(successMessage)}</span>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="login-alert login-alert-error">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.2">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="12" />
                        <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span>${fn:escapeXml(errorMessage)}</span>
                </div>
            </c:if>

            <c:if test="${empty successMessage}">
                <form action="${pageContext.request.contextPath}/quen-mat-khau" method="post" class="login-form">
                    <div class="form-group">
                        <div class="form-label-row">
                            <label for="identifier" class="form-label">Số điện thoại hoặc Email <span
                                    class="req">*</span></label>
                        </div>
                        <div class="input-wrapper">
                            <span class="input-icon-left">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>
                            </span>
                            <input type="text" id="identifier" name="identifier" class="form-control"
                                placeholder="Ví dụ: 0912 345 678 hoặc petcare@gmail.com"
                                value="${fn:escapeXml(identifier)}" required autocomplete="username" />
                        </div>
                    </div>

                    <button type="submit" class="btn-login-submit">
                        <span>Gửi liên kết đặt lại mật khẩu</span>
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12" />
                            <polyline points="12 5 19 12 12 19" />
                        </svg>
                    </button>
                </form>
            </c:if>

            <div class="login-divider"></div>

            <div class="register-prompt">
                <a href="${pageContext.request.contextPath}/login">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="15 18 9 12 15 6" />
                    </svg>
                    Quay lại đăng nhập
                </a>
            </div>
        </div>
    </main>
</body>

</html>
