<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bảng giá &amp; Dịch vụ — Pet care | Pet Spa &amp; Grooming Lounge</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=6" />
</head>

<body>

    <!-- ====================================================================
         1. STICKY HEADER
         ==================================================================== -->
    <header class="site-header" id="siteHeader">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand-wrap" aria-label="Pet care — Trang chủ">
                <span class="brand-icon-box">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png?v=4" alt="PetCare Logo" class="brand-logo-img" />
                </span>
            </a>

            <nav class="main-nav" aria-label="Điều hướng chính">
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a>
                <a href="${pageContext.request.contextPath}/services.jsp" class="active">Bảng giá &amp; Dịch vụ</a>
                <a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc</a>
                <a href="${pageContext.request.contextPath}/home#quyen-loi-section">Tra cứu &amp; Hướng dẫn</a>
            </nav>

            <div class="header-auth-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn-login-outline">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-solid">Đăng ký tài khoản</a>
                <a href="${pageContext.request.contextPath}/login" class="btn-user-avatar" aria-label="Tài khoản thành viên">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.1">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </a>
            </div>
        </div>
    </header>

    <main>
        <!-- ================================================================
             2. SUBPAGE HERO — BẢNG GIÁ & DỊCH VỤ
             ================================================================ -->
        <section class="subpage-hero">
            <div class="container">
                <div class="subpage-breadcrumb">
                    <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    <span>/</span>
                    <span>Bảng giá &amp; Dịch vụ</span>
                </div>

                <div class="subpage-hero-grid">
                    <div>
                        <div class="section-eyebrow">
                            <span>MINH BẠCH CHI PHÍ &bull; CAM KẾT CHẤT LƯỢNG</span>
                        </div>
                        <h1 class="subpage-title">
                            Bảng Giá &amp; Dịch Vụ <span>Chăm Sóc Toàn Diện</span>
                        </h1>
                        <p class="subpage-desc">
                            Mọi gói dịch vụ tại <strong>Pet care Spa</strong> đều được niêm yết công khai theo cân nặng
                            của bé, sử dụng 100% sữa tắm thảo mộc hữu cơ nhập khẩu và bảo hành form cắt tỉa miễn phí
                            trong vòng 48 giờ.
                        </p>

                        <div class="svc-hero-pills">
                            <span class="svc-hero-pill">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <path class="ico-tone" d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                    <path d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                    <polyline points="9 12 11 14 15.2 9.8" />
                                </svg>
                                <span>Không Phụ Thu Phí Ẩn</span>
                            </span>
                            <span class="svc-hero-pill">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle class="ico-tone" cx="12" cy="9" r="5.5" />
                                    <circle cx="12" cy="9" r="5.5" />
                                    <path d="M8.5 13.8L7.5 21l4.5-2.2L16.5 21l-1-7.2" />
                                </svg>
                                <span>Bảo Hành Form 48 Giờ</span>
                            </span>
                            <span class="svc-hero-pill">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect class="ico-tone" x="4" y="9" width="16" height="11" rx="2" />
                                    <rect x="3" y="6.5" width="18" height="3.5" rx="1" />
                                    <path d="M5 10v8.5A1.5 1.5 0 0 0 6.5 20h11a1.5 1.5 0 0 0 1.5-1.5V10" />
                                    <line x1="12" y1="6.5" x2="12" y2="20" />
                                    <path d="M12 6.5H8.5a2 2 0 1 1 0-4c2.4 0 3.5 4 3.5 4z" />
                                    <path d="M12 6.5h3.5a2 2 0 1 0 0-4c-2.4 0-3.5 4-3.5 4z" />
                                </svg>
                                <span>Giảm 15% Thành Viên Mới</span>
                            </span>
                        </div>

                        <div class="svc-hero-actions">
                            <a href="${pageContext.request.contextPath}/register" class="btn-svc-primary">
                                <span>Đặt lịch chăm sóc ngay</span>
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                    <polyline points="12 5 19 12 12 19" />
                                </svg>
                            </a>
                            <a href="#bang-gia-can-nang" class="btn-secondary-hero">
                                <span>Xem bảng giá theo cân nặng</span>
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <polyline points="5 12 12 19 19 12" />
                                </svg>
                            </a>
                        </div>
                    </div>

                    <div class="svc-hero-media">
                        <div class="hero-image-frame">
                            <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg"
                                alt="Chuyên viên đang cắt tỉa tạo kiểu lông cho thú cưng tại Pet care" />
                            <div class="hero-image-overlay"></div>
                        </div>
                        <div class="svc-hero-float">
                            <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                <path class="ico-solid"
                                    d="M12 2.8l2.5 5.1 5.6.8-4.05 3.95.96 5.58L12 15.6l-5.01 2.63.96-5.58L3.9 8.7l5.6-.8L12 2.8z" />
                            </svg>
                            <div>
                                <strong>4.9 / 5 Đánh Giá Hài Lòng</strong>
                                <span>5.000+ bé cưng đã trải nghiệm chuẩn Spa</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 4 Commitment Highlights Strip -->
                <div class="svc-commit-strip">
                    <div class="svc-commit-item">
                        <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                            <path class="ico-tone" d="M17.5 3.5C11 3.5 5.5 8 5.5 14.5c0 2.1.7 3.9 2 5.2 5.8-.5 11.5-5.3 11.5-12.5 0-1.3-.5-2.6-1.5-3.7z" />
                            <path d="M18.5 3.5C11 3.5 5 8.5 5 15c0 1.8.6 3.5 1.8 4.8C13.2 19.5 19 14.5 19 7c0-1.2-.2-2.4-.5-3.5z" />
                            <path d="M5 19.5C8.5 15.5 12 12 16 9" />
                        </svg>
                        <div>
                            <strong>Mỹ Phẩm Organic 100%</strong>
                            <span>Thảo mộc dịu nhẹ, an toàn da nhạy cảm</span>
                        </div>
                    </div>

                    <div class="svc-commit-item">
                        <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                            <path class="ico-tone"
                                d="M12 20.5s-7.5-4.8-7.5-10a4.4 4.4 0 0 1 7.5-3.1 4.4 4.4 0 0 1 7.5 3.1c0 5.2-7.5 10-7.5 10z" />
                            <path
                                d="M12 20.5s-7.5-4.8-7.5-10a4.4 4.4 0 0 1 7.5-3.1 4.4 4.4 0 0 1 7.5 3.1c0 5.2-7.5 10-7.5 10z" />
                            <path d="M8.5 11.5h2l1.2-2.2 1.4 4.2 1.2-2h1.7" />
                        </svg>
                        <div>
                            <strong>Không Gây Mê - Không Ép</strong>
                            <span>Chăm sóc kiên nhẫn theo nhịp sinh học bé</span>
                        </div>
                    </div>

                    <div class="svc-commit-item">
                        <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                            <path class="ico-tone" d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                            <path d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                            <path d="M12 7.5l.7 2.1 2.1.7-2.1.7-.7 2.1-.7-2.1-2.1-.7 2.1-.7z" />
                        </svg>
                        <div>
                            <strong>Tiệt Trùng Tia UV-C</strong>
                            <span>Vệ sinh 100% dụng cụ sau từng bé</span>
                        </div>
                    </div>

                    <div class="svc-commit-item">
                        <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                            <path class="ico-tone" d="M2 12s3.8-6.5 10-6.5S22 12 22 12s-3.8 6.5-10 6.5S2 12 2 12z" />
                            <path d="M2 12s3.8-6.5 10-6.5S22 12 22 12s-3.8 6.5-10 6.5S2 12 2 12z" />
                            <circle cx="12" cy="12" r="3.2" />
                        </svg>
                        <div>
                            <strong>Phòng Kính Kín Đáo 360°</strong>
                            <span>Ba mẹ quan sát trực tiếp tại sảnh</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             3. 6 GÓI DỊCH VỤ CHĂM SÓC CHUYÊN SÂU
             ================================================================ -->
        <section class="svc-section" id="danh-muc-dich-vu">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>DANH MỤC 6 GÓI CHĂM SÓC CHUẨN SALON</span>
                    </div>
                    <h2 class="section-title">Dịch vụ chăm sóc toàn diện</h2>
                    <p class="section-subtitle">
                        Mọi nhu cầu chăm sóc thú cưng trong một nơi &mdash; từ tắm sấy thảo mộc, cắt tỉa tạo kiểu đến
                        spa phục hồi da lông và lưu trú VIP.
                    </p>
                </div>

                <div class="svc-grid">
                    <!-- Card 1: Grooming & Tắm sấy -->
                    <article class="svc-card">
                        <div class="svc-card-media">
                            <img src="${pageContext.request.contextPath}/assets/images/service-bath.jpg" alt="Dịch vụ Grooming và Tắm sấy thảo mộc" />
                            <span class="svc-card-tag is-hot">Được yêu thích nhất</span>
                            <span class="svc-card-time">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12 7 12 12 15.5 13.5" />
                                </svg>
                                <span>60 Phút</span>
                            </span>
                        </div>
                        <div class="svc-card-body">
                            <div class="svc-card-icon" aria-hidden="true">
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
                            </div>
                            <span class="svc-card-cat">Chăm Sóc Hằng Tuần</span>
                            <h3 class="svc-card-title">Grooming &amp; Tắm sấy</h3>
                            <p class="svc-card-desc">
                                Làm sạch sâu bằng sữa tắm thảo mộc hữu cơ, massage thư giãn, vắt tuyến hôi và sấy bông
                                mượt chuẩn spa.
                            </p>
                            <ul class="svc-card-list">
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Tắm 2 lần sữa tắm organic dịu nhẹ</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Vệ sinh tai, cắt mài móng &amp; tuyến hôi</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Sấy đánh bông chống tĩnh điện không ồn</span>
                                </li>
                            </ul>
                            <div class="svc-card-footer">
                                <div>
                                    <span class="svc-price-label">Chi phí trọn gói</span>
                                    <span class="svc-price">180.000đ <small>/ từ &lt; 5kg</small></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn-svc-book">
                                    <span>Đặt lịch</span>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- Card 2: Cắt tỉa tạo kiểu -->
                    <article class="svc-card">
                        <div class="svc-card-media">
                            <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg" alt="Dịch vụ Cắt tỉa tạo kiểu chuẩn Salon" />
                            <span class="svc-card-tag">Stylist Chuyên Nghiệp</span>
                            <span class="svc-card-time">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12 7 12 12 15.5 13.5" />
                                </svg>
                                <span>90 &ndash; 120 Phút</span>
                            </span>
                        </div>
                        <div class="svc-card-body">
                            <div class="svc-card-icon" aria-hidden="true">
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
                            </div>
                            <span class="svc-card-cat">Tạo Kiểu Salon</span>
                            <h3 class="svc-card-title">Cắt tỉa tạo kiểu</h3>
                            <p class="svc-card-desc">
                                Cắt tỉa form Teddy, Poodle, Pomeranian, Bichon chuẩn quốc tế bằng kéo chuyên dụng, tôn
                                lên nét đáng yêu riêng của bé.
                            </p>
                            <ul class="svc-card-list">
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Đã bao gồm Combo Tắm sấy 10 bước</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Tạo form theo dáng mặt &amp; chất lông</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Bảo hành chỉnh sửa form miễn phí 48h</span>
                                </li>
                            </ul>
                            <div class="svc-card-footer">
                                <div>
                                    <span class="svc-price-label">Chi phí trọn gói</span>
                                    <span class="svc-price">320.000đ <small>/ từ &lt; 5kg</small></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn-svc-book">
                                    <span>Đặt lịch</span>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- Card 3: Spa & Chăm sóc da -->
                    <article class="svc-card">
                        <div class="svc-card-media">
                            <img src="${pageContext.request.contextPath}/assets/images/hero-petcare-spa.jpg" alt="Spa và Chăm sóc da thảo dược" />
                            <span class="svc-card-tag">Phục Hồi Chuyên Sâu</span>
                            <span class="svc-card-time">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12 7 12 12 15.5 13.5" />
                                </svg>
                                <span>75 Phút</span>
                            </span>
                        </div>
                        <div class="svc-card-body">
                            <div class="svc-card-icon" aria-hidden="true">
                                <svg class="ico" viewBox="0 0 24 24">
                                    <path class="ico-tone" d="M12 3.2c2.8 3.1 4.1 6.1 4.1 9.1a4.1 4.1 0 0 1-8.2 0c0-3 1.3-6 4.1-9.1z" />
                                    <path d="M12 3.2c2.8 3.1 4.1 6.1 4.1 9.1a4.1 4.1 0 0 1-8.2 0c0-3 1.3-6 4.1-9.1z" />
                                    <path class="ico-tone" d="M8.2 14.2C4.9 13.4 3.1 10.9 3.4 7.7c2.8.3 4.8 1.9 5.6 4.3" />
                                    <path d="M8.2 14.2C4.9 13.4 3.1 10.9 3.4 7.7c2.8.3 4.8 1.9 5.6 4.3" />
                                    <path class="ico-tone" d="M15.8 14.2c3.3-.8 5.1-3.3 4.8-6.5-2.8.3-4.8 1.9-5.6 4.3" />
                                    <path d="M15.8 14.2c3.3-.8 5.1-3.3 4.8-6.5-2.8.3-4.8 1.9-5.6 4.3" />
                                    <path d="M5 18.8c2.1.9 4.5 1.3 7 1.3s4.9-.4 7-1.3" />
                                </svg>
                            </div>
                            <span class="svc-card-cat">Trị Liệu Da Lông</span>
                            <h3 class="svc-card-title">Spa &amp; Chăm sóc da</h3>
                            <p class="svc-card-desc">
                                Ngâm bồn sục Micro-bubble Ozone kết hợp ủ bùn khoáng thảo dược, hỗ trợ giảm viêm da và
                                khử mùi hôi lâu dài.
                            </p>
                            <ul class="svc-card-list">
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Sục khí nano Micro-bubble làm sạch sâu</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Ủ bùn khoáng Dead Sea &amp; Collagen</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Dưỡng ẩm dịu ngứa cho da nhạy cảm</span>
                                </li>
                            </ul>
                            <div class="svc-card-footer">
                                <div>
                                    <span class="svc-price-label">Chi phí trọn gói</span>
                                    <span class="svc-price">280.000đ <small>/ từ &lt; 5kg</small></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn-svc-book">
                                    <span>Đặt lịch</span>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- Card 4: Vệ sinh tai / móng -->
                    <article class="svc-card">
                        <div class="svc-card-media">
                            <img src="${pageContext.request.contextPath}/assets/images/service-shaving.jpg" alt="Vệ sinh tai và cắt mài móng thú cưng" />
                            <span class="svc-card-tag">Chăm Sóc Định Kỳ</span>
                            <span class="svc-card-time">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12 7 12 12 15.5 13.5" />
                                </svg>
                                <span>30 Phút</span>
                            </span>
                        </div>
                        <div class="svc-card-body">
                            <div class="svc-card-icon" aria-hidden="true">
                                <svg class="ico" viewBox="0 0 24 24">
                                    <path class="ico-tone"
                                        d="M12 11.8c-3 0-5.4 2.1-5.4 4.7 0 1.8 1.5 3.1 3.3 3.1.8 0 1.5-.3 2.1-.3s1.3.3 2.1.3c1.8 0 3.3-1.3 3.3-3.1 0-2.6-2.4-4.7-5.4-4.7z" />
                                    <path
                                        d="M12 11.8c-3 0-5.4 2.1-5.4 4.7 0 1.8 1.5 3.1 3.3 3.1.8 0 1.5-.3 2.1-.3s1.3.3 2.1.3c1.8 0 3.3-1.3 3.3-3.1 0-2.6-2.4-4.7-5.4-4.7z" />
                                    <circle class="ico-tone" cx="5.2" cy="10.8" r="1.65" />
                                    <circle cx="5.2" cy="10.8" r="1.65" />
                                    <circle class="ico-tone" cx="9.2" cy="6.6" r="1.75" />
                                    <circle cx="9.2" cy="6.6" r="1.75" />
                                    <circle class="ico-tone" cx="14.8" cy="6.6" r="1.75" />
                                    <circle cx="14.8" cy="6.6" r="1.75" />
                                    <circle class="ico-tone" cx="18.8" cy="10.8" r="1.65" />
                                    <circle cx="18.8" cy="10.8" r="1.65" />
                                </svg>
                            </div>
                            <span class="svc-card-cat">Chăm Sóc Chi Tiết</span>
                            <h3 class="svc-card-title">Vệ sinh tai / móng</h3>
                            <p class="svc-card-desc">
                                Combo 7 bước: cắt &amp; mài nhẵn móng, nhổ lông tai, vệ sinh ống tai khử mùi, cạo lông
                                bàn chân và dưỡng đệm thịt.
                            </p>
                            <ul class="svc-card-list">
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Cắt &amp; mài tròn đầu móng bằng máy tĩnh âm</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Làm sạch ráy &amp; nhổ lông tai không đau</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Thoa sáp bơ dưỡng hồng đệm bàn chân</span>
                                </li>
                            </ul>
                            <div class="svc-card-footer">
                                <div>
                                    <span class="svc-price-label">Chi phí trọn gói</span>
                                    <span class="svc-price">90.000đ <small>/ từ &lt; 5kg</small></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn-svc-book">
                                    <span>Đặt lịch</span>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- Card 5: Chăm sóc sức khỏe cơ bản -->
                    <article class="svc-card">
                        <div class="svc-card-media">
                            <img src="${pageContext.request.contextPath}/assets/images/branch-hcm.jpg" alt="Kiểm tra sức khỏe cơ bản tại Pet care" />
                            <span class="svc-card-tag">Tầm Soát Sức Khỏe</span>
                            <span class="svc-card-time">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12 7 12 12 15.5 13.5" />
                                </svg>
                                <span>40 Phút</span>
                            </span>
                        </div>
                        <div class="svc-card-body">
                            <div class="svc-card-icon" aria-hidden="true">
                                <svg class="ico" viewBox="0 0 24 24">
                                    <path class="ico-tone"
                                        d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                    <path
                                        d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                    <path d="M7.8 12h2l1.4-2.8 1.6 5.4 1.4-2.6h2" />
                                </svg>
                            </div>
                            <span class="svc-card-cat">Tầm Soát Định Kỳ</span>
                            <h3 class="svc-card-title">Chăm sóc sức khỏe cơ bản</h3>
                            <p class="svc-card-desc">
                                Kiểm tra da liễu, tai, răng miệng, đo cân nặng, tư vấn chế độ dinh dưỡng và cập nhật sổ
                                theo dõi sức khỏe điện tử.
                            </p>
                            <ul class="svc-card-list">
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Soi da đèn Wood &amp; kiểm tra nấm rận</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Đo cân nặng, thân nhiệt &amp; vệ sinh răng</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Lưu hồ sơ y tế trên Cổng thành viên</span>
                                </li>
                            </ul>
                            <div class="svc-card-footer">
                                <div>
                                    <span class="svc-price-label">Chi phí trọn gói</span>
                                    <span class="svc-price">150.000đ <small>/ từ &lt; 5kg</small></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn-svc-book">
                                    <span>Đặt lịch</span>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- Card 6: Combo chăm sóc thú cưng VIP -->
                    <article class="svc-card">
                        <div class="svc-card-media">
                            <img src="${pageContext.request.contextPath}/assets/images/branch-hn.jpg" alt="Combo chăm sóc thú cưng VIP và Lưu trú" />
                            <span class="svc-card-tag is-hot">Tiết Kiệm 20%</span>
                            <span class="svc-card-time">
                                <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12 7 12 12 15.5 13.5" />
                                </svg>
                                <span>Trọn Gói VIP</span>
                            </span>
                        </div>
                        <div class="svc-card-body">
                            <div class="svc-card-icon" aria-hidden="true">
                                <svg class="ico" viewBox="0 0 24 24">
                                    <path class="ico-tone" d="M3.5 17L5.2 7.8l4.3 3.7L12 5.4l2.5 6.1 4.3-3.7L20.5 17H3.5z" />
                                    <path d="M3.5 17L5.2 7.8l4.3 3.7L12 5.4l2.5 6.1 4.3-3.7L20.5 17H3.5z" />
                                    <path d="M4.5 19.8h15" />
                                    <circle class="ico-solid" cx="12" cy="3.8" r="1" />
                                    <circle class="ico-solid" cx="4.8" cy="6.2" r="0.9" />
                                    <circle class="ico-solid" cx="19.2" cy="6.2" r="0.9" />
                                </svg>
                            </div>
                            <span class="svc-card-cat">Trọn Gói Cao Cấp</span>
                            <h3 class="svc-card-title">Combo chăm sóc thú cưng</h3>
                            <p class="svc-card-desc">
                                Kết hợp trọn gói Tắm sấy thảo mộc + Cắt tỉa tạo kiểu + Ngâm bồn sục Spa + Lưu trú phòng
                                VIP có camera 24/7.
                            </p>
                            <ul class="svc-card-list">
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Đầy đủ 12 bước Tắm + Cắt + Sục Ozone</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Tặng kèm khăn choàng cổ &amp; xịt nước hoa</span>
                                </li>
                                <li>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    <span>Ưu tiên phòng nghỉ VIP giữ bé trong ngày</span>
                                </li>
                            </ul>
                            <div class="svc-card-footer">
                                <div>
                                    <span class="svc-price-label">Trọn gói ưu đãi</span>
                                    <span class="svc-price">450.000đ <small>/ từ &lt; 5kg</small></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn-svc-book">
                                    <span>Đặt lịch</span>
                                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. BẢNG GIÁ CHI TIẾT THEO CÂN NẶNG (WEIGHT-TIER PRICING TABLE)
             ================================================================ -->
        <section class="svc-pricing-section" id="bang-gia-can-nang">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>NIÊM YẾT CÔNG KHAI TOÀN HỆ THỐNG</span>
                    </div>
                    <h2 class="section-title">Bảng Giá Chi Tiết Theo Cân Nặng</h2>
                    <p class="section-subtitle">
                        Áp dụng thống nhất tại tất cả các cơ sở Pet care Spa TP. Hồ Chí Minh và Hà Nội.
                    </p>
                </div>

                <div class="svc-table-card">
                    <div class="svc-table-scroll">
                        <table class="svc-table">
                            <thead>
                                <tr>
                                    <th class="svc-th-service">Hạng Mục Dịch Vụ Chăm Sóc</th>
                                    <th>
                                        <div class="svc-th-weight">
                                            <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                                <path class="ico-tone" d="M8.5 10h7l1 9.5h-9L8.5 10z" />
                                                <path d="M8.5 10h7l1 9.5h-9L8.5 10z" />
                                                <path d="M10 10V7.5a2 2 0 0 1 4 0V10" />
                                                <circle class="ico-solid" cx="12" cy="14.8" r="1.2" />
                                            </svg>
                                            <strong>Dưới 5kg</strong>
                                            <span>Mèo, Toy Poodle, Phốc</span>
                                        </div>
                                    </th>
                                    <th>
                                        <div class="svc-th-weight">
                                            <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                                <path class="ico-tone" d="M6.8 9.5h10.4l1.3 10H5.5l1.3-10z" />
                                                <path d="M6.8 9.5h10.4l1.3 10H5.5l1.3-10z" />
                                                <path d="M9.2 9.5V7.2a2.8 2.8 0 0 1 5.6 0v2.3" />
                                                <circle class="ico-solid" cx="9.8" cy="14.5" r="1.15" />
                                                <circle class="ico-solid" cx="14.2" cy="14.5" r="1.15" />
                                            </svg>
                                            <strong>5 &ndash; 10kg</strong>
                                            <span>Bichon, Pug, Shih Tzu</span>
                                        </div>
                                    </th>
                                    <th>
                                        <div class="svc-th-weight">
                                            <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                                <path class="ico-tone" d="M5.2 9h13.6L20 19.5H4L5.2 9z" />
                                                <path d="M5.2 9h13.6L20 19.5H4L5.2 9z" />
                                                <path d="M8.8 9V6.8a3.2 3.2 0 0 1 6.4 0V9" />
                                                <circle class="ico-solid" cx="8.5" cy="14.5" r="1.1" />
                                                <circle class="ico-solid" cx="12" cy="14.5" r="1.1" />
                                                <circle class="ico-solid" cx="15.5" cy="14.5" r="1.1" />
                                            </svg>
                                            <strong>10 &ndash; 20kg</strong>
                                            <span>Corgi, Shiba, Beagle</span>
                                        </div>
                                    </th>
                                    <th>
                                        <div class="svc-th-weight">
                                            <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                                                <path class="ico-tone" d="M3.8 8.8h16.4l1.5 11H2.3l1.5-11z" />
                                                <path d="M3.8 8.8h16.4l1.5 11H2.3l1.5-11z" />
                                                <path d="M8.5 8.8V6.3a3.5 3.5 0 0 1 7 0v2.5" />
                                                <path d="M7.5 14.5h9" />
                                                <path d="M12 11.8v5.4" />
                                            </svg>
                                            <strong>Trên 20kg</strong>
                                            <span>Golden, Husky, Samoyed</span>
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="svc-row-service">
                                            <span class="svc-row-icon" aria-hidden="true">
                                                <svg class="ico" viewBox="0 0 24 24">
                                                    <path class="ico-tone"
                                                        d="M12 11.8c-3 0-5.4 2.1-5.4 4.7 0 1.8 1.5 3.1 3.3 3.1.8 0 1.5-.3 2.1-.3s1.3.3 2.1.3c1.8 0 3.3-1.3 3.3-3.1 0-2.6-2.4-4.7-5.4-4.7z" />
                                                    <path
                                                        d="M12 11.8c-3 0-5.4 2.1-5.4 4.7 0 1.8 1.5 3.1 3.3 3.1.8 0 1.5-.3 2.1-.3s1.3.3 2.1.3c1.8 0 3.3-1.3 3.3-3.1 0-2.6-2.4-4.7-5.4-4.7z" />
                                                    <circle class="ico-tone" cx="5.2" cy="10.8" r="1.65" />
                                                    <circle cx="5.2" cy="10.8" r="1.65" />
                                                    <circle class="ico-tone" cx="9.2" cy="6.6" r="1.75" />
                                                    <circle cx="9.2" cy="6.6" r="1.75" />
                                                    <circle class="ico-tone" cx="14.8" cy="6.6" r="1.75" />
                                                    <circle cx="14.8" cy="6.6" r="1.75" />
                                                    <circle class="ico-tone" cx="18.8" cy="10.8" r="1.65" />
                                                    <circle cx="18.8" cy="10.8" r="1.65" />
                                                </svg>
                                            </span>
                                            <div>
                                                <strong>1. Vệ sinh tai, cắt mài móng &amp; cạo bàn</strong>
                                                <span>Gồm 7 bước vệ sinh cơ bản, nhổ lông tai, vắt tuyến hôi, dưỡng đệm chân</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="svc-cell-price">90.000đ<small>30 phút</small></td>
                                    <td class="svc-cell-price">120.000đ<small>30 phút</small></td>
                                    <td class="svc-cell-price">150.000đ<small>40 phút</small></td>
                                    <td class="svc-cell-price">190.000đ<small>45 phút</small></td>
                                </tr>

                                <tr>
                                    <td>
                                        <div class="svc-row-service">
                                            <span class="svc-row-icon" aria-hidden="true">
                                                <svg class="ico" viewBox="0 0 24 24">
                                                    <path class="ico-tone" d="M4 12.5h16V15a5 5 0 0 1-5 5H9a5 5 0 0 1-5-5v-2.5z" />
                                                    <path d="M2 12.5h20" />
                                                    <path d="M4 12.5V15a5 5 0 0 0 5 5h6a5 5 0 0 0 5-5v-2.5" />
                                                    <path d="M6 12.5V6.8A3.3 3.3 0 0 1 9.3 3.5c1.5 0 2.7 1 3.1 2.4" />
                                                    <circle class="ico-tone" cx="15.8" cy="7.5" r="1.5" />
                                                    <circle cx="15.8" cy="7.5" r="1.5" />
                                                    <circle cx="19" cy="5.2" r="1.1" />
                                                </svg>
                                            </span>
                                            <div>
                                                <strong>
                                                    2. Grooming &amp; Tắm sấy thảo mộc (Combo 10 bước)
                                                    <span class="svc-row-badge">Phổ biến</span>
                                                </strong>
                                                <span>Bao gồm vệ sinh 7 bước + Tắm 2 lần sữa tắm organic + Sấy đánh bông</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="svc-cell-price">180.000đ<small>60 phút</small></td>
                                    <td class="svc-cell-price">240.000đ<small>60 phút</small></td>
                                    <td class="svc-cell-price">320.000đ<small>75 phút</small></td>
                                    <td class="svc-cell-price">420.000đ<small>90 phút</small></td>
                                </tr>

                                <tr>
                                    <td>
                                        <div class="svc-row-service">
                                            <span class="svc-row-icon" aria-hidden="true">
                                                <svg class="ico" viewBox="0 0 24 24">
                                                    <path class="ico-tone" d="M12 3.2c2.8 3.1 4.1 6.1 4.1 9.1a4.1 4.1 0 0 1-8.2 0c0-3 1.3-6 4.1-9.1z" />
                                                    <path d="M12 3.2c2.8 3.1 4.1 6.1 4.1 9.1a4.1 4.1 0 0 1-8.2 0c0-3 1.3-6 4.1-9.1z" />
                                                    <path d="M8.2 14.2C4.9 13.4 3.1 10.9 3.4 7.7c2.8.3 4.8 1.9 5.6 4.3" />
                                                    <path d="M15.8 14.2c3.3-.8 5.1-3.3 4.8-6.5-2.8.3-4.8 1.9-5.6 4.3" />
                                                    <path d="M5 18.8c2.1.9 4.5 1.3 7 1.3s4.9-.4 7-1.3" />
                                                </svg>
                                            </span>
                                            <div>
                                                <strong>3. Spa Bồn Sục Micro-Bubble &amp; Ủ Bùn Khoáng</strong>
                                                <span>Tắm sục khí Ozone khử mùi + Ủ bùn khoáng thảo dược phục hồi da lông</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="svc-cell-price">280.000đ<small>75 phút</small></td>
                                    <td class="svc-cell-price">350.000đ<small>75 phút</small></td>
                                    <td class="svc-cell-price">440.000đ<small>90 phút</small></td>
                                    <td class="svc-cell-price">550.000đ<small>105 phút</small></td>
                                </tr>

                                <tr>
                                    <td>
                                        <div class="svc-row-service">
                                            <span class="svc-row-icon" aria-hidden="true">
                                                <svg class="ico" viewBox="0 0 24 24">
                                                    <circle class="ico-tone" cx="6.5" cy="6.5" r="2.7" />
                                                    <circle class="ico-tone" cx="6.5" cy="17.5" r="2.7" />
                                                    <circle cx="6.5" cy="6.5" r="2.7" />
                                                    <circle cx="6.5" cy="17.5" r="2.7" />
                                                    <path d="M8.6 8.3L19.5 18.8" />
                                                    <path d="M8.6 15.7L19.5 5.2" />
                                                    <circle class="ico-solid" cx="12.2" cy="12" r="1.05" />
                                                    <path d="M19.5 10l.5 1.5 1.5.5-1.5.5-.5 1.5-.5-1.5-1.5-.5 1.5-.5z" />
                                                </svg>
                                            </span>
                                            <div>
                                                <strong>4. Cắt Tỉa Tạo Kiểu Toàn Diện (Combo 12 bước)</strong>
                                                <span>Trọn gói Vệ sinh + Tắm sấy thảo mộc + Tạo kiểu kéo chuyên dụng</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="svc-cell-price">320.000đ<small>90 phút</small></td>
                                    <td class="svc-cell-price">400.000đ<small>105 phút</small></td>
                                    <td class="svc-cell-price">520.000đ<small>120 phút</small></td>
                                    <td class="svc-cell-price">650.000đ<small>140 phút</small></td>
                                </tr>

                                <tr class="is-featured">
                                    <td>
                                        <div class="svc-row-service">
                                            <span class="svc-row-icon" aria-hidden="true">
                                                <svg class="ico" viewBox="0 0 24 24">
                                                    <path class="ico-tone" d="M3.5 17L5.2 7.8l4.3 3.7L12 5.4l2.5 6.1 4.3-3.7L20.5 17H3.5z" />
                                                    <path d="M3.5 17L5.2 7.8l4.3 3.7L12 5.4l2.5 6.1 4.3-3.7L20.5 17H3.5z" />
                                                    <path d="M4.5 19.8h15" />
                                                    <circle class="ico-solid" cx="12" cy="3.8" r="1" />
                                                </svg>
                                            </span>
                                            <div>
                                                <strong>
                                                    5. Combo VIP (Tắm Sấy + Cắt Tỉa + Sục Spa Ozone)
                                                    <span class="svc-row-badge">Tiết kiệm 20%</span>
                                                </strong>
                                                <span>Trải nghiệm chăm sóc cao cấp nhất &bull; Tặng phụ kiện &amp; nước hoa</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="svc-cell-price">450.000đ<small>Trọn gói VIP</small></td>
                                    <td class="svc-cell-price">550.000đ<small>Trọn gói VIP</small></td>
                                    <td class="svc-cell-price">680.000đ<small>Trọn gói VIP</small></td>
                                    <td class="svc-cell-price">820.000đ<small>Trọn gói VIP</small></td>
                                </tr>

                                <tr>
                                    <td>
                                        <div class="svc-row-service">
                                            <span class="svc-row-icon" aria-hidden="true">
                                                <svg class="ico" viewBox="0 0 24 24">
                                                    <path class="ico-tone" d="M5 10l7-6 7 6v9.2A1.3 1.3 0 0 1 17.7 20.5H6.3A1.3 1.3 0 0 1 5 19.2V10z" />
                                                    <path d="M3 10.8L12 3.5l9 7.3" />
                                                    <path d="M5 9.5v9.7A1.3 1.3 0 0 0 6.3 20.5h11.4a1.3 1.3 0 0 0 1.3-1.3V9.5" />
                                                    <path class="ico-tone" d="M12 17s-2.8-1.7-2.8-3.4a1.55 1.55 0 0 1 2.8-.85 1.55 1.55 0 0 1 2.8.85C14.8 15.3 12 17 12 17z" />
                                                    <path d="M12 17s-2.8-1.7-2.8-3.4a1.55 1.55 0 0 1 2.8-.85 1.55 1.55 0 0 1 2.8.85C14.8 15.3 12 17 12 17z" />
                                                </svg>
                                            </span>
                                            <div>
                                                <strong>6. Khách Sạn Thú Cưng VIP (Lưu trú theo ngày)</strong>
                                                <span>Phòng kính điều hòa 24/7, camera trực tuyến, 3 bữa dinh dưỡng &amp; vận động</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="svc-cell-price">220.000đ<small>/ ngày</small></td>
                                    <td class="svc-cell-price">280.000đ<small>/ ngày</small></td>
                                    <td class="svc-cell-price">350.000đ<small>/ ngày</small></td>
                                    <td class="svc-cell-price">450.000đ<small>/ ngày</small></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="svc-table-note">
                        <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                            <circle class="ico-tone" cx="12" cy="12" r="9.5" />
                            <circle cx="12" cy="12" r="9.5" />
                            <line x1="12" y1="16" x2="12" y2="11.5" />
                            <circle class="ico-solid" cx="12" cy="8.2" r="1" />
                        </svg>
                        <span>
                            Mức giá trên đã bao gồm thuế VAT và kiểm tra tình trạng da lông miễn phí. Đối với các bé lông bị rối vón cục nặng, chuyên viên sẽ báo trước chi phí gỡ rối trước khi thực hiện.
                        </span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             5. DỊCH VỤ BỔ SUNG & TIỆN ÍCH RIÊNG LẺ (ADD-ONS)
             ================================================================ -->
        <section class="svc-addon-section">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>CHĂM SÓC CHUYÊN BIỆT THEO NHU CẦU</span>
                    </div>
                    <h2 class="section-title">Dịch Vụ Bổ Sung &amp; Tiện Ích Riêng</h2>
                    <p class="section-subtitle">
                        Dễ dàng kết hợp thêm khi đặt lịch hoặc sử dụng riêng lẻ cho bé cưng bất cứ lúc nào.
                    </p>
                </div>

                <div class="svc-addon-grid">
                    <div class="svc-addon">
                        <span class="svc-row-icon" aria-hidden="true">
                            <svg class="ico" viewBox="0 0 24 24">
                                <rect class="ico-tone" x="4" y="4" width="16" height="5.5" rx="2" />
                                <rect x="4" y="4" width="16" height="5.5" rx="2" />
                                <path d="M7 9.5v8.5" />
                                <path d="M10.3 9.5v9.5" />
                                <path d="M13.7 9.5v9.5" />
                                <path d="M17 9.5v8.5" />
                            </svg>
                        </span>
                        <div class="svc-addon-text">
                            <strong>Chải &amp; Gỡ Rối Lông Chuyên Sâu</strong>
                            <span>Sử dụng xịt dưỡng Keratin không gây đau rát</span>
                        </div>
                        <span class="svc-addon-price">60k &ndash; 120k</span>
                    </div>

                    <div class="svc-addon">
                        <span class="svc-row-icon" aria-hidden="true">
                            <svg class="ico" viewBox="0 0 24 24">
                                <path class="ico-tone" d="M12 3.2c3.5 4.2 5.8 7.6 5.8 10.6a5.8 5.8 0 0 1-11.6 0c0-3 2.3-6.4 5.8-10.6z" />
                                <path d="M12 3.2c3.5 4.2 5.8 7.6 5.8 10.6a5.8 5.8 0 0 1-11.6 0c0-3 2.3-6.4 5.8-10.6z" />
                                <path d="M9.5 14.5a2.5 2.5 0 0 0 2.5 2.5" />
                            </svg>
                        </span>
                        <div class="svc-addon-text">
                            <strong>Vắt Tuyến Hôi &amp; Khử Mùi</strong>
                            <span>Thao tác nhẹ nhàng, sạch sẽ vệ sinh vùng kín</span>
                        </div>
                        <span class="svc-addon-price">50.000đ</span>
                    </div>

                    <div class="svc-addon">
                        <span class="svc-row-icon" aria-hidden="true">
                            <svg class="ico" viewBox="0 0 24 24">
                                <path class="ico-tone" d="M7 4.5c2 0 3.2 1 5 1s3-1 5-1c2.4 0 4 2.1 3.7 5.2-.3 3.2-1.8 9.3-3.5 9.8-1.4.4-2.1-3.8-5.2-3.8s-3.8 4.2-5.2 3.8C5.1 19 3.6 12.9 3.3 9.7 3 6.6 4.6 4.5 7 4.5z" />
                                <path d="M7 4.5c2 0 3.2 1 5 1s3-1 5-1c2.4 0 4 2.1 3.7 5.2-.3 3.2-1.8 9.3-3.5 9.8-1.4.4-2.1-3.8-5.2-3.8s-3.8 4.2-5.2 3.8C5.1 19 3.6 12.9 3.3 9.7 3 6.6 4.6 4.5 7 4.5z" />
                            </svg>
                        </span>
                        <div class="svc-addon-text">
                            <strong>Đánh Răng &amp; Xịt Thơm Miệng</strong>
                            <span>Gel enzyme thiên nhiên loại bỏ mảng bám</span>
                        </div>
                        <span class="svc-addon-price">80.000đ</span>
                    </div>

                    <div class="svc-addon">
                        <span class="svc-row-icon" aria-hidden="true">
                            <svg class="ico" viewBox="0 0 24 24">
                                <path class="ico-tone" d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                <path d="M12 2.8L4.5 6v5.6c0 4.8 3.2 8.9 7.5 10.2 4.3-1.3 7.5-5.4 7.5-10.2V6L12 2.8z" />
                                <line x1="9" y1="12" x2="15" y2="12" />
                                <line x1="12" y1="9" x2="12" y2="15" />
                            </svg>
                        </span>
                        <div class="svc-addon-text">
                            <strong>Tắm Trị Liệu Ve Rận Sinh Học</strong>
                            <span>Tinh chất tràm trà &amp; sả chanh an toàn tuyệt đối</span>
                        </div>
                        <span class="svc-addon-price">120k &ndash; 180k</span>
                    </div>

                    <div class="svc-addon">
                        <span class="svc-row-icon" aria-hidden="true">
                            <svg class="ico" viewBox="0 0 24 24">
                                <path class="ico-tone" d="M12 3a9 9 0 0 0 0 18c1.1 0 1.8-.8 1.8-1.7 0-.5-.2-.9-.5-1.2-.3-.4-.5-.8-.5-1.3 0-1 .8-1.8 1.8-1.8h2.2A4.2 4.2 0 0 0 21 10.8C21 6.3 17 3 12 3z" />
                                <path d="M12 3a9 9 0 0 0 0 18c1.1 0 1.8-.8 1.8-1.7 0-.5-.2-.9-.5-1.2-.3-.4-.5-.8-.5-1.3 0-1 .8-1.8 1.8-1.8h2.2A4.2 4.2 0 0 0 21 10.8C21 6.3 17 3 12 3z" />
                                <circle class="ico-solid" cx="7.8" cy="10.5" r="1.1" />
                                <circle class="ico-solid" cx="11" cy="7.5" r="1.1" />
                                <circle class="ico-solid" cx="15.2" cy="8.5" r="1.1" />
                            </svg>
                        </span>
                        <div class="svc-addon-text">
                            <strong>Nhuộm Tai / Đuôi Thảo Mộc</strong>
                            <span>Màu thực vật bền 2 tháng, không amoniac</span>
                        </div>
                        <span class="svc-addon-price">Từ 150.000đ</span>
                    </div>

                    <div class="svc-addon">
                        <span class="svc-row-icon" aria-hidden="true">
                            <svg class="ico" viewBox="0 0 24 24">
                                <rect class="ico-tone" x="2.5" y="6.5" width="12.5" height="9.5" rx="1.5" />
                                <path d="M4.8 16H2.5V6.5H15V16H9.2" />
                                <path d="M15 9.2h3.7l2.8 3.2V16h-1.8" />
                                <path d="M15 16h.3" />
                                <circle class="ico-tone" cx="7" cy="17" r="2.2" />
                                <circle cx="7" cy="17" r="2.2" />
                                <circle class="ico-tone" cx="17.5" cy="17" r="2.2" />
                                <circle cx="17.5" cy="17" r="2.2" />
                            </svg>
                        </span>
                        <div class="svc-addon-text">
                            <strong>Đưa Đón Thú Cưng Tận Nhà</strong>
                            <span>Xe điều hòa riêng &bull; Miễn phí trong bán kính 3km</span>
                        </div>
                        <span class="svc-addon-price">Từ 40.000đ</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             6. BOOKING CTA SECTION
             ================================================================ -->
        <section class="booking-cta-section">
            <div class="container">
                <div class="booking-cta-card">
                    <div class="booking-cta-left">
                        <div class="booking-cta-badge">
                            <span>ƯU ĐÃI THÀNH VIÊN PET CARE</span>
                        </div>
                        <h2 class="booking-cta-title">
                            Đặt lịch chăm sóc cho bé ngay hôm nay
                        </h2>
                        <p class="booking-cta-desc">
                            Đăng ký tài khoản thành viên để nhận ngay ưu đãi giảm 15% cho lần trải nghiệm Spa &amp;
                            Grooming đầu tiên tại mọi cơ sở Pet care.
                        </p>
                    </div>

                    <div class="booking-cta-panel">
                        <h4>Đặt lịch nhanh qua Cổng Thành Viên</h4>
                        <p>Tự động lưu hồ sơ cân nặng và kiểu lông yêu thích của bé.</p>

                        <div class="booking-cta-perks">
                            <div class="booking-cta-perk">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span>Bảo hành chỉnh sửa form tỉa miễn phí 48h</span>
                            </div>
                            <div class="booking-cta-perk">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span>Tích điểm đổi quà &amp; voucher tắm spa miễn phí</span>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/register" class="btn-cta-book-now">
                            <span>Đăng ký thành viên &amp; Đặt lịch</span>
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
         7. FOOTER
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
                        Hệ thống Salon &amp; Spa Chăm Sóc Thú Cưng Tiêu Chuẩn Cao Cấp. Mang đến trải nghiệm làm đẹp thư
                        giãn, an toàn với mỹ phẩm thảo mộc organic 100%.
                    </p>
                </div>

                <div class="footer-col">
                    <h4>Liên Kết Nhanh</h4>
                    <ul class="footer-links-list">
                        <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a></li>
                        <li><a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a></li>
                        <li><a href="${pageContext.request.contextPath}/home#quy-trinh-section">Quy trình chăm sóc 4 bước</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h4>Dịch Vụ Chăm Sóc</h4>
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

</body>

</html>
