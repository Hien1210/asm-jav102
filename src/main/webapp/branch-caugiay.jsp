<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cơ sở Cầu Giấy (Hà Nội) — Pet care | Pet Spa &amp; Grooming Lounge</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=6" />
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
             2. HERO CHI TIẾT CƠ SỞ CẦU GIẤY (HÀ NỘI)
             ================================================================ -->
        <section class="subpage-hero">
            <div class="container">
                <div class="subpage-breadcrumb">
                    <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    <span>/</span>
                    <a href="${pageContext.request.contextPath}/branches.jsp">Giới thiệu &amp; Cơ sở</a>
                    <span>/</span>
                    <span>Cơ sở Trần Thái Tông, Cầu Giấy</span>
                </div>

                <!-- Chuyển nhanh giữa các trang cơ sở riêng -->
                <div class="branch-switcher-pills" aria-label="Chuyển đổi giữa các cơ sở">
                    <a href="${pageContext.request.contextPath}/branch-q3.jsp" class="branch-switch-pill">&#128205; Cơ sở Quận 3 (TP.HCM)</a>
                    <a href="${pageContext.request.contextPath}/branch-dongda.jsp" class="branch-switch-pill">&#128205; Cơ sở Đống Đa (Hà Nội)</a>
                    <a href="${pageContext.request.contextPath}/branch-thaodien.jsp" class="branch-switch-pill">&#128205; Cơ sở Thảo Điền (TP.HCM)</a>
                    <a href="${pageContext.request.contextPath}/branch-caugiay.jsp" class="branch-switch-pill active">&#128205; Cơ sở Cầu Giấy (Hà
                        Nội)</a>
                </div>

                <div class="branch-detail-block" style="margin-bottom: 0;">
                    <div class="branch-detail-top">
                        <div class="branch-detail-photo">
                            <img src="${pageContext.request.contextPath}/assets/images/service-grooming.jpg"
                                alt="Pet care Spa 106 Trần Thái Tông Cầu Giấy Hà Nội" />
                            <span class="branch-detail-badge">Cơ sở Cầu Giấy &bull; Đang mở cửa đón bé</span>
                        </div>
                        <div class="branch-detail-content">
                            <div>
                                <div class="section-eyebrow" style="margin-bottom: 10px;">
                                    <span>TRUNG TÂM QUẬN CẦU GIẤY, HÀ NỘI</span>
                                </div>
                                <h1 class="branch-detail-title">Pet care Spa &mdash; 106 Trần Thái Tông, Cầu Giấy</h1>
                                <p class="branch-detail-desc">
                                    Tọa lạc tại trục đường lớn Trần Thái Tông sầm uất, cơ sở Cầu Giấy rộng
                                    <strong>260m²</strong> là trung tâm chuyên sâu về <strong>Spa Thảo Dược Phục Hồi Da
                                        Lông</strong> và tạo kiểu Grooming chuẩn Hàn Quốc, phục vụ nhanh chóng cho cộng
                                    đồng nuôi thú cưng khu vực Cầu Giấy, Mỹ Đình và Tây Hồ.
                                </p>

                                <div class="branch-specs-grid">
                                    <div class="branch-spec-item">
                                        <strong>Địa chỉ chi nhánh</strong>
                                        <span>106 Trần Thái Tông, P. Dịch Vọng Hậu, Q. Cầu Giấy, Hà Nội</span>
                                    </div>
                                    <div class="branch-spec-item">
                                        <strong>Giờ mở cửa phục vụ</strong>
                                        <span>08:00 &ndash; 20:30 (Thứ 2 &ndash; Chủ Nhật)</span>
                                    </div>
                                    <div class="branch-spec-item">
                                        <strong>Quy mô &amp; Công suất</strong>
                                        <span>Diện tích 260m² &bull; 6 bàn Grooming &bull; 14 phòng VIP</span>
                                    </div>
                                    <div class="branch-spec-item">
                                        <strong>Hotline chi nhánh Cầu Giấy</strong>
                                        <span>024 3795 6868 &bull; Bãi đỗ ô tô rộng ngay mặt tiền</span>
                                    </div>
                                </div>
                            </div>

                            <div class="branch-actions">
                                <a href="${pageContext.request.contextPath}/branches.jsp" class="btn-branch-outline">&larr; Tất cả cơ sở</a>
                                <a href="${pageContext.request.contextPath}/login" class="btn-branch-solid">
                                    <span>Đặt lịch tại Cơ sở Cầu Giấy</span>
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
                                Trung Tâm Ủ Bùn Khoáng Biển Chết
                            </span>
                            <span class="branch-zone-chip">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.4">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                Hệ Thống Lồng Sấy Tĩnh Âm Ion Âm
                            </span>
                            <span class="branch-zone-chip">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.4">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                Sảnh Cafe Chờ Nhìn Thẳng Phòng Spa
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             3. 4 PHÂN KHU CHỨC NĂNG TẠI CƠ SỞ CẦU GIẤY
             ================================================================ -->
        <section style="padding: 72px 0; background: var(--white);">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>KHÔNG GIAN CHUYÊN BIỆT TẠI CƠ SỞ CẦU GIẤY</span>
                    </div>
                    <h2 class="section-title">4 Phân Khu Spa &amp; Grooming Hiện Đại</h2>
                    <p class="section-subtitle">
                        Trang thiết bị đồng bộ 100% nhập khẩu giúp rút ngắn thời gian chờ và nâng cao trải nghiệm cho
                        bé.
                    </p>
                </div>

                <div class="branch-zones-4-grid">
                    <article class="branch-zone-card">
                        <span class="branch-zone-num">01</span>
                        <h3>Khu Sảnh Chờ Cafe &amp; Quan Sát Trực Tiếp</h3>
                        <p>
                            Quầy nước miễn phí dành cho khách hàng với vách kính lớn nhìn thẳng vào khu vực tắm sấy và
                            cắt tỉa của các bé cưng.
                        </p>
                    </article>

                    <article class="branch-zone-card">
                        <span class="branch-zone-num">02</span>
                        <h3>Phòng Spa Bùn Khoáng &amp; Tinh Dầu Thảo Mộc</h3>
                        <p>
                            Chuyên sâu các liệu trình ủ dưỡng Keratin, Collagen và tắm sục khí Ozone hỗ trợ điều trị
                            viêm da, nấm ngứa và giảm rụng lông theo mùa.
                        </p>
                    </article>

                    <article class="branch-zone-card">
                        <span class="branch-zone-num">03</span>
                        <h3>Phòng Cắt Tỉa Tạo Kiểu Chuẩn Salon</h3>
                        <p>
                            6 bàn Grooming chuyên nghiệp với ánh sáng chuẩn studio, giúp các Stylist cắt tỉa tỉ mỉ từng
                            đường nét cho Poodle, Bichon, Corgi và Mèo cảnh.
                        </p>
                    </article>

                    <article class="branch-zone-card">
                        <span class="branch-zone-num">04</span>
                        <h3>Studio Chụp Ảnh Kỷ Niệm Sau Grooming</h3>
                        <p>
                            Sau mỗi buổi làm đẹp, bé cưng được đeo phụ kiện nơ/khăn cổ xinh xắn và chụp ảnh kỷ niệm
                            lưu trực tiếp vào sổ sức khỏe điện tử.
                        </p>
                    </article>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. ĐỘI NGŨ CHUYÊN VIÊN TẠI CƠ SỞ CẦU GIẤY
             ================================================================ -->
        <section style="padding: 72px 0; background: var(--light-mint); border-top: 1px solid var(--border-subtle);">
            <div class="container">
                <div class="section-header-center">
                    <div class="section-eyebrow">
                        <span>ĐỘI NGŨ CHUYÊN VIÊN CƠ SỞ CẦU GIẤY</span>
                    </div>
                    <h2 class="section-title">Master Groomer Phụ Trách Tại Chi Nhánh</h2>
                    <p class="section-subtitle">
                        Đội ngũ Stylist trẻ trung, tỉ mỉ và giàu tình yêu thương thú cưng tại 106 Trần Thái Tông.
                    </p>
                </div>

                <div class="branch-team-3-grid">
                    <article class="groomer-card">
                        <div class="groomer-avatar-badge">TH</div>
                        <span class="groomer-role-tag">Master Groomer &bull; Trưởng Cơ Sở</span>
                        <h3>Chuyên viên Tuấn Hưng</h3>
                        <p>
                            6 năm kinh nghiệm Grooming chuyên nghiệp, giảng viên đào tạo kỹ thuật cắt tỉa Poodle Teddy
                            Bear và Bichon tròn chuẩn Hàn Quốc.
                        </p>
                    </article>

                    <article class="groomer-card">
                        <div class="groomer-avatar-badge">LA</div>
                        <span class="groomer-role-tag">Senior Stylist Groomer</span>
                        <h3>Chuyên viên Lan Anh</h3>
                        <p>
                            5 năm kinh nghiệm tạo kiểu và chăm sóc da lông chuyên sâu cho các giống chó nhỏ (Pomeranian,
                            Maltese, Yorkshire Terrier).
                        </p>
                    </article>

                    <article class="groomer-card">
                        <div class="groomer-avatar-badge">ĐM</div>
                        <span class="groomer-role-tag">Chuyên Viên Spa &amp; Tầm Soát Sức Khỏe</span>
                        <h3>Chuyên viên Đức Minh</h3>
                        <p>
                            Phụ trách kiểm tra sức khỏe tổng quát 5 bước, vệ sinh tuyến hôi, nhổ lông tai êm ái và
                            chăm sóc các bé mèo nhút nhát.
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
                            <span>&#10024; CƠ SỞ CẦU GIẤY &bull; 106 TRẦN THÁI TÔNG</span>
                        </div>
                        <h2 class="booking-cta-title">
                            Đặt lịch hẹn tại Pet care Spa Cầu Giấy
                        </h2>
                        <p class="booking-cta-desc">
                            Đặt lịch trước chỉ trong 30 giây để giữ chỗ ưu tiên cho bé tại chi nhánh 106 Trần Thái Tông,
                            Cầu Giấy.
                        </p>
                    </div>

                    <div class="booking-cta-panel">
                        <h4>Thông tin đặt lịch Cơ sở Cầu Giấy</h4>
                        <p>106 Trần Thái Tông, P. Dịch Vọng Hậu, Q. Cầu Giấy, Hà Nội</p>

                        <div class="booking-cta-perks">
                            <div class="booking-cta-perk">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span>Đỗ xe ô tô miễn phí ngay trước cửa Salon</span>
                            </div>
                            <div class="booking-cta-perk">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span>Tặng chụp ảnh Studio kỷ niệm sau mỗi buổi Grooming</span>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/login" class="btn-cta-book-now">
                            <span>Đặt lịch tại Cơ sở Cầu Giấy &rarr;</span>
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
