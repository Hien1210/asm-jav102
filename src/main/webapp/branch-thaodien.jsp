<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cơ sở Thảo Điền (TP.HCM) — Pet care | Pet Spa &amp; Grooming Lounge</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=5" />
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
                <a href="${pageContext.request.contextPath}/branches.jsp" class="active">Giới thiệu &amp; Cơ sở</a>
                <a href="${pageContext.request.contextPath}/services.jsp">Bảng giá &amp; Dịch vụ</a>
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
             2. HERO CHI TIẾT CƠ SỞ THẢO ĐIỀN (TP.HCM)
             ================================================================ -->
        <section class="subpage-hero">
            <div class="container">
                <div class="subpage-breadcrumb">
                    <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    <span>/</span>
                    <a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a>
                    <span>/</span>
                    <span>Cơ sở Xuân Thủy, Thảo Điền</span>
                </div>

                <!-- Chuyển nhanh giữa các trang cơ sở riêng -->
                <div class="branch-switcher-pills" aria-label="Chuyển đổi giữa các cơ sở">
                    <a href="${pageContext.request.contextPath}/branch-q3.jsp" class="branch-switch-pill">&#128205; Cơ sở Quận 3 (TP.HCM)</a>
                    <a href="${pageContext.request.contextPath}/branch-dongda.jsp" class="branch-switch-pill">&#128205; Cơ sở Đống Đa (Hà Nội)</a>
                    <a href="${pageContext.request.contextPath}/branch-thaodien.jsp" class="branch-switch-pill active">&#128205; Cơ sở Thảo Điền
                        (TP.HCM)</a>
                    <a href="${pageContext.request.contextPath}/branch-caugiay.jsp" class="branch-switch-pill">&#128205; Cơ sở Cầu Giấy (Hà Nội)</a>
                </div>

                <div class="branch-detail-block" style="margin-bottom: 0;">
                    <div class="branch-detail-top">
                        <div class="branch-detail-photo">
                            <img src="${pageContext.request.contextPath}/assets/images/hero-petcare-spa.jpg"
                                alt="Pet care Spa 82 Xuân Thủy Thảo Điền TP.HCM" />
                            <span class="branch-detail-badge">Garden Resort Spa &bull; Đang mở cửa đón bé</span>
                        </div>
                        <div class="branch-detail-content">
                            <div>
                                <div class="section-eyebrow" style="margin-bottom: 10px;">
                                    <span>KHU BIỆT THỰ SÂN VƯỜN THẢO ĐIỀN, TP.HCM</span>
                                </div>
                                <h1 class="branch-detail-title">Pet care Spa &mdash; 82 Xuân Thủy, Thảo Điền</h1>
                                <p class="branch-detail-desc">
                                    Được thiết kế theo mô hình <strong>Garden Pet Resort &amp; Grooming Villa</strong>
                                    rộng hơn <strong>450m²</strong> ngay trung tâm Thảo Điền, cơ sở Xuân Thủy sở hữu sân
                                    cỏ tự nhiên ngoài trời, hồ bơi thủy liệu pháp cho thú cưng và dịch vụ xe Pet Taxi
                                    đưa đón tận nhà.
                                </p>

                                <div class="branch-specs-grid">
                                    <div class="branch-spec-item">
                                        <strong>Địa chỉ chi nhánh</strong>
                                        <span>82 Xuân Thủy, P. Thảo Điền, TP. Thủ Đức, TP.HCM</span>
                                    </div>
                                    <div class="branch-spec-item">
                                        <strong>Giờ mở cửa phục vụ</strong>
                                        <span>08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ Nhật)</span>
                                    </div>
                                    <div class="branch-spec-item">
                                        <strong>Quy mô &amp; Công suất</strong>
                                        <span>Khuôn viên 450m² &bull; Sân vườn &amp; Hồ bơi &bull; 15 phòng Villa</span>
                                    </div>
                                    <div class="branch-spec-item">
                                        <strong>Hotline chi nhánh Thảo Điền</strong>
                                        <span>028 3744 6868 &bull; Hỗ trợ xe đưa đón tận nơi</span>
                                    </div>
                                </div>
                            </div>

                            <div class="branch-actions">
                                <a href="${pageContext.request.contextPath}/branches.jsp" class="btn-branch-outline">&larr; Tất cả cơ sở</a>
                                <a href="${pageContext.request.contextPath}/login" class="btn-branch-solid">
                                    <span>Đặt lịch tại Cơ sở Thảo Điền</span>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.3">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="branch-zones-row">
                        <div class="branch-zones-list">
                            <span class="branch-zone-chip">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.4">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                Sân Cỏ Tự Nhiên &amp; Hồ Bơi Thú Cưng
                            </span>
                            <span class="branch-zone-chip">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.4">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                Dịch Vụ Pet Taxi Đưa Đón Tận Nhà
                            </span>
                            <span class="branch-zone-chip">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.4">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                Đội Ngũ Tư Vấn Song Ngữ Việt &ndash; Anh
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             3. 4 PHÂN KHU CHỨC NĂNG TẠI CƠ SỞ THẢO ĐIỀN
             ================================================================ -->
        <section style="padding: 72px 0; background: var(--white);">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>KHÔNG GIAN BIỆT THỰ SÂN VƯỜN THẢO ĐIỀN</span>
                    </div>
                    <h2 class="section-title">4 Phân Khu Nghỉ Dưỡng &amp; Grooming Cao Cấp</h2>
                    <p class="section-subtitle">
                        Không gian xanh mát, yên tĩnh giúp các bé tận hưởng một ngày đi Spa thư giãn trọn vẹn.
                    </p>
                </div>

                <div class="branch-zones-4-grid">
                    <article class="branch-zone-card">
                        <span class="branch-zone-num">01</span>
                        <h3>Khu Sân Vườn Cỏ Tự Nhiên &amp; Cafe Thú Cưng</h3>
                        <p>
                            Khuôn viên sân vườn rộng rãi có rào chắn an toàn 2 lớp, nơi các bé làm quen với môi trường
                            và chạy nhảy thư giãn trước khi bước vào liệu trình tắm sấy.
                        </p>
                    </article>

                    <article class="branch-zone-card">
                        <span class="branch-zone-num">02</span>
                        <h3>Phòng Grooming Ánh Sáng Tự Nhiên</h3>
                        <p>
                            Thiết kế cửa kính lớn đón nắng sớm cùng hệ thống bàn cắt tỉa êm ái, chuyên sâu các kiểu cắt
                            Asian Fusion, Teddy Bear và chăm sóc lông dài.
                        </p>
                    </article>

                    <article class="branch-zone-card">
                        <span class="branch-zone-num">03</span>
                        <h3>Khu Thủy Liệu Pháp &amp; Tắm Sục Khoáng</h3>
                        <p>
                            Bể bơi nước ấm lọc tuần hoàn và bồn sục Micro-bubble giúp hỗ trợ vận động xương khớp cho các
                            dòng chó Corgi, Golden, Labrador và Poodle.
                        </p>
                    </article>

                    <article class="branch-zone-card">
                        <span class="branch-zone-num">04</span>
                        <h3>Khu Villa Lưu Trú Nghỉ Dưỡng</h3>
                        <p>
                            15 phòng Villa có ban công nhìn ra vườn cây xanh mát, kèm chế độ ăn tươi nấu mới mỗi ngày
                            và người chăm sóc túc trực 24/24.
                        </p>
                    </article>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. ĐỘI NGŨ CHUYÊN VIÊN TẠI CƠ SỞ THẢO ĐIỀN
             ================================================================ -->
        <section style="padding: 72px 0; background: var(--light-mint); border-top: 1px solid var(--border-subtle);">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>ĐỘI NGŨ CHUYÊN VIÊN CƠ SỞ THẢO ĐIỀN</span>
                    </div>
                    <h2 class="section-title">Master Groomer Phụ Trách Tại Chi Nhánh</h2>
                    <p class="section-subtitle">
                        Đội ngũ Stylist giao tiếp song ngữ Việt &ndash; Anh, tận tâm và yêu thương thú cưng.
                    </p>
                </div>

                <div class="branch-team-3-grid">
                    <article class="groomer-card">
                        <div class="groomer-avatar-badge">BV</div>
                        <span class="groomer-role-tag">Master Groomer &bull; Trưởng Chi Nhánh</span>
                        <h3>Chuyên viên Bảo Vy</h3>
                        <p>
                            6 năm kinh nghiệm tu nghiệp tại Hàn Quốc và Thái Lan về kỹ thuật cắt tỉa tạo kiểu Asian
                            Fusion và nhuộm lông thảo mộc an toàn.
                        </p>
                    </article>

                    <article class="groomer-card">
                        <div class="groomer-avatar-badge">KP</div>
                        <span class="groomer-role-tag">Senior Stylist Groomer</span>
                        <h3>Chuyên viên Khánh Phong</h3>
                        <p>
                            Chuyên gia chăm sóc các dòng chó lông kép (Pomeranian, Husky, Alaska, Corgi) và kỹ thuật
                            tắm sấy đánh bông chuẩn Show Dog.
                        </p>
                    </article>

                    <article class="groomer-card">
                        <div class="groomer-avatar-badge">NH</div>
                        <span class="groomer-role-tag">Chuyên Viên Thủy Liệu &amp; Spa</span>
                        <h3>Chuyên viên Ngọc Hân</h3>
                        <p>
                            Phụ trách liệu trình tắm bùn khoáng biển chết, massage tinh dầu thư giãn và hướng dẫn bơi
                            vận động cho các bé cưng.
                        </p>
                    </article>
                </div>
            </div>
        </section>

        <!-- ================================================================
             5. BOOKING CTA SECTION
             ================================================================ -->
        <section class="booking-cta-section">
            <div class="container">
                <div class="booking-cta-card">
                    <div class="booking-cta-left">
                        <div class="booking-cta-badge">
                            <span>&#10024; CƠ SỞ THẢO ĐIỀN &bull; 82 XUÂN THỦY</span>
                        </div>
                        <h2 class="booking-cta-title">
                            Đặt lịch hẹn tại Pet care Spa Thảo Điền
                        </h2>
                        <p class="booking-cta-desc">
                            Đặt lịch trực tuyến để giữ chỗ ưu tiên hoặc đăng ký dịch vụ xe Pet Taxi đón bé tận nhà tại
                            khu vực Thảo Điền, Quận 2 và Bình Thạnh.
                        </p>
                    </div>

                    <div class="booking-cta-panel">
                        <h4>Thông tin đặt lịch Cơ sở Thảo Điền</h4>
                        <p>82 Xuân Thủy, P. Thảo Điền, TP. Thủ Đức, TP.HCM</p>

                        <div class="booking-cta-perks">
                            <div class="booking-cta-perk">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span>Miễn phí vui chơi tại sân cỏ tự nhiên 30 phút</span>
                            </div>
                            <div class="booking-cta-perk">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span>Hỗ trợ xe đưa đón thú cưng tận nhà an toàn</span>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/login" class="btn-cta-book-now">
                            <span>Đặt lịch tại Cơ sở Thảo Điền &rarr;</span>
                        </a>
                    </div>
                </div>
            </div>
        </section>
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
                    <h4>Hệ Thống Cơ Sở</h4>
                    <ul class="footer-links-list">
                        <li><a href="${pageContext.request.contextPath}/branch-q3.jsp">Cơ sở Quận 3, TP.HCM</a></li>
                        <li><a href="${pageContext.request.contextPath}/branch-dongda.jsp">Cơ sở Đống Đa, Hà Nội</a></li>
                        <li><a href="${pageContext.request.contextPath}/branch-thaodien.jsp">Cơ sở Thảo Điền, TP.HCM</a></li>
                        <li><a href="${pageContext.request.contextPath}/branch-caugiay.jsp">Cơ sở Cầu Giấy, Hà Nội</a></li>
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
