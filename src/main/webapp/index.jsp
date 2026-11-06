<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcare.controller.HomeServlet" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (request.getAttribute("services") == null) {
        request.setAttribute("services", HomeServlet.buildDefaultServices());
    }
    if (request.getAttribute("comparisons") == null) {
        request.setAttribute("comparisons", HomeServlet.buildDefaultComparisons());
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PetCare Vinh - Dịch vụ chăm sóc chó mèo tại TP. Vinh</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
</head>
<body>

    <!-- ====================================================================
         HEADER / NAVBAR
         ==================================================================== -->
    <header class="site-header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand-logo">
                <span class="brand-logo-icon" aria-hidden="true">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <circle cx="7" cy="7.5" r="2.2"/>
                        <circle cx="12" cy="5.5" r="2.2"/>
                        <circle cx="17" cy="7.5" r="2.2"/>
                        <circle cx="19.5" cy="12" r="2"/>
                        <circle cx="4.5" cy="12" r="2"/>
                        <path d="M12 11.5c-3.2 0-6 2.3-6 5.2 0 1.9 1.6 3.3 3.6 3.3 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2 0 3.6-1.4 3.6-3.3 0-2.9-2.8-5.2-6-5.2z"/>
                    </svg>
                </span>
                PetCare <span>Vinh</span>
            </a>

            <nav class="main-nav" aria-label="Điều hướng chính">
                <a href="#trang-chu" class="active">Trang chủ</a>
                <a href="#dich-vu-section">Dịch vụ</a>
                <a href="#pham-vi-section">Phạm vi nhận</a>
                <a href="#chon-dich-vu-section">Tư vấn chọn</a>
                <a href="#quy-trinh-section">Quy trình</a>
                <a href="#bang-gia-section">Bảng giá</a>
            </nav>

            <div class="header-actions">
                <a href="tel:0912345678" class="header-hotline">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M6.62 10.79a15.05 15.05 0 006.59 6.59l2.2-2.2a1 1 0 011.01-.24c1.12.37 2.33.57 3.58.57a1 1 0 011 1V20a1 1 0 01-1 1C10.61 21 3 13.39 3 4a1 1 0 011-1h3.5a1 1 0 011 1c0 1.25.2 2.46.57 3.58a1 1 0 01-.25 1.01l-2.2 2.2z"/>
                    </svg>
                    0912.345.678
                </a>
                <a href="#dat-lich-section" class="btn-header-cta">Đặt lịch ngay</a>
            </div>
        </div>
    </header>

    <main id="trang-chu">

        <!-- ================================================================
             1. HERO SECTION
             ================================================================ -->
        <section class="hero-section">
            <div class="container hero-grid">
                <div class="hero-content">
                    <div class="hero-badge">
                        <span class="hero-badge-dot"></span>
                        PETCARE VINH
                    </div>

                    <h1 class="hero-title">
                        Dịch vụ chăm sóc
                        <span class="text-highlight">chó mèo</span>
                    </h1>

                    <p class="hero-desc">
                        PetCare Vinh hỗ trợ các nhu cầu chăm sóc hằng ngày: tắm sấy, cắt tỉa lông
                        chó, cạo lông khi cần, hỗ trợ chọn sản phẩm ve rận phù hợp, nội trú ngắn ngày
                        và pet shop cho chó mèo.
                    </p>

                    <div class="hero-cta-group">
                        <a href="#dat-lich-section" class="btn-primary-orange">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                <path d="M9 16l2 2 4-4"></path>
                            </svg>
                            Đặt lịch dịch vụ
                        </a>

                        <a href="#chon-dich-vu-section" class="btn-secondary-white">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                            </svg>
                            Tư vấn nhanh
                        </a>
                    </div>

                    <div class="hero-mini-cards">
                        <div class="hero-mini-card">
                            <div class="hero-mini-card-head green">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                Dễ chọn dịch vụ
                            </div>
                            <p>Tắm, grooming, cạo lông, nội trú và pet shop</p>
                        </div>

                        <div class="hero-mini-card">
                            <div class="hero-mini-card-head amber">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                                </svg>
                                Thống nhất trước
                            </div>
                            <p>Báo giá và phạm vi chăm sóc theo tình trạng pet</p>
                        </div>
                    </div>
                </div>

                <div class="hero-visual">
                    <div class="hero-image-frame">
                        <img src="${pageContext.request.contextPath}/assets/images/hero-petcare.jpg" alt="Dịch vụ chăm sóc thú cưng PetCare Vinh" />
                    </div>
                    <div class="hero-floating-badge">
                        <div class="hero-floating-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            </svg>
                        </div>
                        <div class="hero-floating-text">
                            <strong>Chăm sóc yêu thương</strong>
                            <span>100% thảo dược thiên nhiên &amp; khử khuẩn</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             2. SERVICES GRID SECTION (CÁC DỊCH VỤ PETCARE ĐANG NHẬN)
             ================================================================ -->
        <section id="dich-vu-section" class="services-section">
            <div class="container">
                <div class="section-header-center">
                    <span class="section-eyebrow eyebrow-amber">DỊCH VỤ ĐANG NHẬN</span>
                    <h2 class="section-title">Các dịch vụ PetCare đang nhận</h2>
                    <p class="section-subtitle">
                        Từ tắm sấy, cắt tỉa đến nội trú ngắn ngày, PetCare tư vấn theo tình trạng từng pet.
                    </p>
                </div>

                <div class="services-grid">
                    <c:forEach var="srv" items="${services}">
                        <article class="service-card">
                            <div class="service-card-media">
                                <img src="${pageContext.request.contextPath}/${srv.image}" alt="${srv.title}" />
                                <span class="service-badge ${srv.badgeTheme}">${srv.badgeText}</span>
                                <span class="service-price-pill ${srv.priceTheme}">${srv.priceTag}</span>
                            </div>

                            <div class="service-card-body">
                                <h3 class="service-card-title">${srv.title}</h3>
                                <p class="service-card-desc">${srv.description}</p>

                                <ul class="service-bullet-list ${srv.bulletTheme}">
                                    <c:forEach var="b" items="${srv.bullets}">
                                        <li>
                                            <span class="bullet-dot"></span>
                                            <span>${b}</span>
                                        </li>
                                    </c:forEach>
                                </ul>

                                <div class="service-card-footer">
                                    <c:choose>
                                        <c:when test="${srv.external}">
                                            <a href="${srv.actionUrl}" target="_blank" rel="noopener" class="service-card-link ${srv.actionTheme}">
                                                <span>${srv.actionText}</span>
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                    <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                                                    <polyline points="15 3 21 3 21 9"></polyline>
                                                    <line x1="10" y1="14" x2="21" y2="3"></line>
                                                </svg>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${srv.actionUrl}" data-select-service="${srv.title}" class="service-card-link ${srv.actionTheme}">
                                                <span>${srv.actionText}</span>
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                    <polyline points="12 5 19 12 12 19"></polyline>
                                                </svg>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- ================================================================
             3. SCOPE SECTION (PHẠM VI DỊCH VỤ PETCARE)
             ================================================================ -->
        <section id="pham-vi-section" class="scope-section">
            <div class="container scope-grid">
                <div class="scope-intro">
                    <span class="section-eyebrow eyebrow-amber">PHẠM VI DỊCH VỤ PETCARE</span>
                    <h2 class="scope-intro-title">
                        PetCare chăm sóc pet khỏe mạnh, không thay thế phòng khám thú y
                    </h2>
                    <p class="scope-intro-desc">
                        PetCare Vinh tập trung vào dịch vụ chăm sóc thường ngày. Nếu pet có dấu hiệu bệnh rõ,
                        chủ nuôi nên đưa pet đi kiểm tra thú y trước khi đặt tắm, grooming, cạo lông hoặc nội trú.
                    </p>
                    <div class="scope-priority-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <rect x="3" y="6" width="18" height="14" rx="2"></rect>
                            <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            <line x1="12" y1="10" x2="12" y2="16"></line>
                            <line x1="9" y1="13" x2="15" y2="13"></line>
                        </svg>
                        <span>Ưu tiên hàng đầu là sự an toàn và sức khỏe của các bé</span>
                    </div>
                </div>

                <div class="scope-cards-row">
                    <div class="scope-card">
                        <div class="scope-card-num num-green">01</div>
                        <h3>Dịch vụ cho pet đang ổn định</h3>
                        <p>
                            PetCare ưu tiên tắm, grooming, cạo lông theo tình trạng, nội trú ngắn ngày,
                            ve rận theo sản phẩm và pet shop cho chó mèo khỏe mạnh.
                        </p>
                        <div class="scope-card-tag tag-green">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                            <span>An toàn &amp; thư giãn</span>
                        </div>
                    </div>

                    <div class="scope-card">
                        <div class="scope-card-num num-amber">02</div>
                        <h3>Không thay thế phòng khám thú y</h3>
                        <p>
                            PetCare hiện không cung cấp khám chữa bệnh, xét nghiệm, tiêm truyền,
                            phẫu thuật hoặc can thiệp y tế chuyên khoa sâu.
                        </p>
                        <div class="scope-card-tag tag-amber">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span>Chăm sóc phi lâm sàng</span>
                        </div>
                    </div>

                    <div class="scope-card">
                        <div class="scope-card-num num-red">03</div>
                        <h3>Có dấu hiệu bệnh nên hỏi trước</h3>
                        <p>
                            Nếu pet sốt, bỏ ăn, ho, tiêu chảy, nôn, mệt rõ hoặc nghi truyền nhiễm,
                            chủ nuôi nên đi khám thú y trước khi đặt dịch vụ.
                        </p>
                        <div class="scope-card-tag tag-red">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                <line x1="12" y1="9" x2="12" y2="13"></line>
                                <line x1="12" y1="17" x2="12.01" y2="17"></line>
                            </svg>
                            <span>Hỗ trợ tư vấn trước</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             4. COMPARISON TABLE SECTION (NÊN CHỌN DỊCH VỤ NÀO?)
             ================================================================ -->
        <section id="chon-dich-vu-section" class="comparison-section">
            <div class="container">
                <div class="section-header-center">
                    <span class="section-eyebrow eyebrow-green">CHỌN THEO TÌNH TRẠNG</span>
                    <h2 class="section-title">Nên chọn dịch vụ nào?</h2>
                    <p class="section-subtitle">
                        Chọn theo tình trạng da lông, nhu cầu chăm sóc và thời gian bạn cần gửi pet.
                    </p>
                </div>

                <div class="comparison-table-card">
                    <table class="comparison-table">
                        <thead>
                            <tr>
                                <th>Dịch vụ</th>
                                <th>Khi nên chọn</th>
                                <th>Bao gồm chính</th>
                                <th>Nên hỏi trước nếu</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${comparisons}">
                                <tr>
                                    <td class="service-col">${item.serviceName}</td>
                                    <td class="when-col">${item.whenToChoose}</td>
                                    <td class="include-col">${item.mainIncludes}</td>
                                    <td class="ask-col">${item.askBeforeIf}</td>
                                    <td>
                                        <button type="button"
                                                class="btn-table-action ${item.buttonTheme}"
                                                data-select-service="${item.targetService}">
                                            ${item.buttonText}
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- ================================================================
             5. PROCESS & PRE-VISIT CHECKLIST SECTION
             ================================================================ -->
        <section id="quy-trinh-section" class="process-section">
            <div class="container">
                <div class="section-header-center">
                    <span class="section-eyebrow eyebrow-green">QUY TRÌNH CHĂM SÓC TẠI PETCARE</span>
                    <h2 class="section-title">Khi đưa pet tới PetCare, quy trình ra sao?</h2>
                </div>

                <div class="process-steps-grid">
                    <div class="process-step-card">
                        <div class="process-step-badge">1</div>
                        <h3>Đặt lịch qua điện thoại hoặc Zalo</h3>
                        <p>Chọn trước khung giờ vắng hoặc thuận tiện để bé không phải đợi lâu.</p>
                    </div>

                    <div class="process-step-card">
                        <div class="process-step-badge">2</div>
                        <h3>Tiếp nhận &amp; kiểm tra lông da, tâm lý</h3>
                        <p>Quan sát phản xạ, thói quen và độ bết rối của bộ lông.</p>
                    </div>

                    <div class="process-step-card">
                        <div class="process-step-badge">3</div>
                        <h3>Tư vấn dịch vụ phù hợp từng pet</h3>
                        <p>Thống nhất kiểu cắt, gói tắm và chi phí dự trù minh bạch.</p>
                    </div>

                    <div class="process-step-card">
                        <div class="process-step-badge">4</div>
                        <h3>Thực hiện dịch vụ đã thống nhất</h3>
                        <p>Nhẹ nhàng, cẩn trọng với trang thiết bị chuyên dụng an toàn.</p>
                    </div>

                    <div class="process-step-card">
                        <div class="process-step-badge">5</div>
                        <h3>Bàn giao &amp; nhắc lưu ý chăm sóc</h3>
                        <p>Hướng dẫn chải lông, giữ gìn vệ sinh và lịch hẹn tiếp theo.</p>
                    </div>
                </div>

                <div class="before-visit-card">
                    <div class="before-visit-left">
                        <span class="section-eyebrow eyebrow-amber">TRƯỚC KHI ĐƯA PET ĐẾN</span>
                        <h3>Cần báo gì trước khi đưa pet đến?</h3>
                        <p>
                            Những thông tin này giúp nhân viên chọn cách tiếp cận phù hợp,
                            hạn chế căng thẳng cho pet và tránh phát sinh ngoài dự kiến.
                        </p>
                    </div>

                    <div class="before-visit-list">
                        <div class="before-visit-item">
                            <span class="before-visit-icon icon-green">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                                    <circle cx="7" cy="7.5" r="2"/>
                                    <circle cx="12" cy="5.5" r="2"/>
                                    <circle cx="17" cy="7.5" r="2"/>
                                    <circle cx="19" cy="12" r="1.8"/>
                                    <circle cx="5" cy="12" r="1.8"/>
                                    <path d="M12 11.5c-3 0-5.5 2.1-5.5 4.8 0 1.8 1.5 3.2 3.3 3.2.9 0 1.5-.3 2.2-.3s1.3.3 2.2.3c1.8 0 3.3-1.4 3.3-3.2 0-2.7-2.5-4.8-5.5-4.8z"/>
                                </svg>
                            </span>
                            <span>
                                Mô tả cân nặng, tình trạng lông, da và tính cách của pet trước khi đến;
                                có thể gửi ảnh qua Zalo nếu cần làm rõ tình trạng lông hoặc da.
                            </span>
                        </div>

                        <div class="before-visit-item">
                            <span class="before-visit-icon icon-green">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </span>
                            <span>
                                Nên đặt lịch trước để PetCare sắp xếp khung giờ, nhân sự và thời gian bàn giao phù hợp nhất.
                            </span>
                        </div>

                        <div class="before-visit-item">
                            <span class="before-visit-icon icon-amber">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                            </span>
                            <span>
                                Với pet dễ căng thẳng, nhát hoặc từng phản ứng khi tắm/grooming, hãy báo trước để nhân viên
                                tiếp cận nhẹ hơn và phân bổ thêm thời gian làm quen.
                            </span>
                        </div>

                        <div class="before-visit-item">
                            <span class="before-visit-icon icon-red">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <rect x="3" y="6" width="18" height="14" rx="2"></rect>
                                    <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                    <line x1="12" y1="10" x2="12" y2="16"></line>
                                    <line x1="9" y1="13" x2="15" y2="13"></line>
                                </svg>
                            </span>
                            <span>
                                Nếu pet đang có biểu hiện sức khỏe bất thường như ho, tiêu chảy, bỏ ăn hoặc mệt rõ,
                                nên trao đổi kỹ trước khi mang pet làm dịch vụ.
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ================================================================
             6. QUICK PRICING & BOOKING FORM SECTION
             ================================================================ -->
        <section id="bang-gia-section" class="booking-section">
            <div class="container booking-grid" id="dat-lich-section">

                <!-- Left Column: Quick Price Reference & Hotline -->
                <div class="pricing-column">
                    <span class="section-eyebrow eyebrow-amber">GIÁ THAM KHẢO NHANH</span>
                    <h2 class="pricing-title">Giá tham khảo để dễ dự trù trước</h2>
                    <p class="pricing-desc">
                        Giá cuối cùng phụ thuộc cân nặng, độ rối, tình trạng da lông, mức độ hợp tác và yêu cầu đi kèm.
                        Bảng chi tiết theo cân nặng nằm trong từng trang dịch vụ; PetCare sẽ báo rõ trước khi thực hiện.
                    </p>

                    <div class="pricing-list">
                        <div class="pricing-item">
                            <div class="pricing-item-info">
                                <h4>Tắm chó mèo</h4>
                                <p>Theo cân nặng, tình trạng lông và dịch vụ kèm</p>
                            </div>
                            <span class="pricing-item-value val-green">Từ 60.000đ</span>
                        </div>

                        <div class="pricing-item">
                            <div class="pricing-item-info">
                                <h4>Grooming / cắt tỉa</h4>
                                <p>Theo cân nặng, độ rối, form cắt và nhu cầu tạo kiểu</p>
                            </div>
                            <span class="pricing-item-value val-amber">Từ 250.000đ</span>
                        </div>

                        <div class="pricing-item">
                            <div class="pricing-item-info">
                                <h4>Cạo lông chó mèo</h4>
                                <p>Combo cạo + tắm tính giá cạo và 1/2 giá tắm theo cân</p>
                            </div>
                            <span class="pricing-item-value val-dark">Từ 60.000đ</span>
                        </div>

                        <div class="pricing-item">
                            <div class="pricing-item-info">
                                <h4>Nội trú chó mèo</h4>
                                <p>Theo cân nặng, thời gian gửi và nhu cầu chăm sóc riêng</p>
                            </div>
                            <span class="pricing-item-value val-amber">Từ 60.000đ/ngày</span>
                        </div>

                        <div class="pricing-item">
                            <div class="pricing-item-info">
                                <h4>Ve rận, bọ chét</h4>
                                <p>Cần biết cân nặng, độ tuổi, da lông và sản phẩm gần đây</p>
                            </div>
                            <span class="pricing-item-value val-sky">Theo sản phẩm</span>
                        </div>
                    </div>

                    <a href="tel:0912345678" class="hotline-banner-card">
                        <div>
                            <span class="hotline-label">HOTLINE ĐẶT HẸN NHANH</span>
                            <strong class="hotline-number">0912.345.678</strong>
                            <span class="hotline-sub">Nhân viên trực máy 08:00 - 20:30 hằng ngày, tư vấn và giữ chỗ ngay.</span>
                        </div>
                        <div class="hotline-phone-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M6.62 10.79a15.05 15.05 0 006.59 6.59l2.2-2.2a1 1 0 011.01-.24c1.12.37 2.33.57 3.58.57a1 1 0 011 1V20a1 1 0 01-1 1C10.61 21 3 13.39 3 4a1 1 0 011-1h3.5a1 1 0 011 1c0 1.25.2 2.46.57 3.58a1 1 0 01-.25 1.01l-2.2 2.2z"/>
                            </svg>
                        </div>
                    </a>
                </div>

                <!-- Right Column: Booking Form Card -->
                <div class="booking-form-card">
                    <h3>Đăng ký lịch dịch vụ tại PetCare</h3>
                    <p class="booking-form-sub">
                        Vui lòng điền thông tin bên dưới, nhân viên cơ sở sẽ gọi điện hoặc nhắn Zalo xác nhận trong 10 phút.
                    </p>

                    <c:if test="${bookingSuccess}">
                        <div class="booking-alert-success" id="bookingSuccessAlert">
                            <strong>Đã tiếp nhận yêu cầu đặt lịch cho bé ${bookingData.petName}!</strong>
                            Cảm ơn <b>${bookingData.ownerName}</b> (${bookingData.phone}). Nhân viên PetCare Vinh tại
                            <b>${bookingData.branch}</b> sẽ liên hệ xác nhận dịch vụ <b>${bookingData.serviceName}</b>
                            (Khung giờ: ${bookingData.timeSlot} - Ngày: ${bookingData.bookingDate}) trong ít phút.
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/dat-lich" method="post">
                        <div class="form-row-2">
                            <div class="form-group">
                                <label for="ownerName">Họ và tên chủ nuôi *</label>
                                <input type="text" id="ownerName" name="ownerName" class="form-control"
                                       placeholder="Nguyễn Văn A" required value="${bookingData.ownerName}" />
                            </div>
                            <div class="form-group">
                                <label for="phone">Số điện thoại / Zalo *</label>
                                <input type="tel" id="phone" name="phone" class="form-control"
                                       placeholder="0912 345 678" required value="${bookingData.phone}" />
                            </div>
                        </div>

                        <div class="form-row-3">
                            <div class="form-group">
                                <label for="petName">Tên bé cưng *</label>
                                <input type="text" id="petName" name="petName" class="form-control"
                                       placeholder="Bông, Miu..." required value="${bookingData.petName}" />
                            </div>
                            <div class="form-group">
                                <label for="petType">Loài thú cưng *</label>
                                <select id="petType" name="petType" class="form-control">
                                    <option value="Chó" ${bookingData.petType == 'Chó' ? 'selected' : ''}>Chó</option>
                                    <option value="Mèo" ${bookingData.petType == 'Mèo' ? 'selected' : ''}>Mèo</option>
                                    <option value="Cả chó và mèo" ${bookingData.petType == 'Cả chó và mèo' ? 'selected' : ''}>Cả chó và mèo</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="weightRange">Cân nặng ước tính *</label>
                                <select id="weightRange" name="weightRange" class="form-control">
                                    <option value="2 - 5 kg" ${bookingData.weightRange == '2 - 5 kg' ? 'selected' : ''}>2 - 5 kg</option>
                                    <option value="Dưới 2 kg" ${bookingData.weightRange == 'Dưới 2 kg' ? 'selected' : ''}>Dưới 2 kg</option>
                                    <option value="5 - 10 kg" ${bookingData.weightRange == '5 - 10 kg' ? 'selected' : ''}>5 - 10 kg</option>
                                    <option value="10 - 20 kg" ${bookingData.weightRange == '10 - 20 kg' ? 'selected' : ''}>10 - 20 kg</option>
                                    <option value="Trên 20 kg" ${bookingData.weightRange == 'Trên 20 kg' ? 'selected' : ''}>Trên 20 kg</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row-2">
                            <div class="form-group">
                                <label for="serviceName">Dịch vụ quan tâm *</label>
                                <select id="serviceName" name="serviceName" class="form-control">
                                    <option value="Tắm chó mèo (Spa vệ sinh)">Tắm chó mèo (Spa vệ sinh)</option>
                                    <option value="Grooming / cắt tỉa lông chó">Grooming / cắt tỉa lông chó</option>
                                    <option value="Cạo lông chó mèo">Cạo lông chó mèo</option>
                                    <option value="Tư vấn sản phẩm ve rận, bọ chét">Tư vấn sản phẩm ve rận, bọ chét</option>
                                    <option value="Nội trú chó mèo">Nội trú chó mèo</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="branch">Chọn cơ sở thuận tiện *</label>
                                <select id="branch" name="branch" class="form-control">
                                    <option value="Cơ sở 1: 86 Nguyễn Văn Cừ, P. Trường Thi">Cơ sở 1: 86 Nguyễn Văn Cừ, P. Trường Thi</option>
                                    <option value="Cơ sở 2: 120 Lê Lợi, TP. Vinh">Cơ sở 2: 120 Lê Lợi, TP. Vinh</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row-2">
                            <div class="form-group">
                                <label for="bookingDate">Ngày mong muốn *</label>
                                <input type="date" id="bookingDate" name="bookingDate" class="form-control"
                                       required value="${bookingData.bookingDate}" />
                            </div>
                            <div class="form-group">
                                <label for="timeSlot">Khung giờ hẹn *</label>
                                <select id="timeSlot" name="timeSlot" class="form-control">
                                    <option value="08:00 - 09:30 (Sáng sớm)">08:00 - 09:30 (Sáng sớm)</option>
                                    <option value="09:30 - 11:30 (Buổi sáng)">09:30 - 11:30 (Buổi sáng)</option>
                                    <option value="13:30 - 15:30 (Buổi chiều)">13:30 - 15:30 (Buổi chiều)</option>
                                    <option value="15:30 - 17:30 (Chiều muộn)">15:30 - 17:30 (Chiều muộn)</option>
                                    <option value="17:30 - 19:30 (Buổi tối)">17:30 - 19:30 (Buổi tối)</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="notes">Ghi chú tình trạng của pet (tính cách, lông rối, nhát nước...)</label>
                            <textarea id="notes" name="notes" class="form-control"
                                      placeholder="Ví dụ: Bé Poodle 3kg, lông hơi bết ở đuôi, tính nhát người lạ mong làm nhẹ nhàng...">${bookingData.notes}</textarea>
                        </div>

                        <button type="submit" class="btn-submit-booking">
                            <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                            Gửi thông tin đặt lịch ngay
                        </button>
                    </form>
                </div>
            </div>
        </section>

    </main>

    <!-- ====================================================================
         FOOTER
         ==================================================================== -->
    <footer class="site-footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <div class="footer-brand">
                        PetCare <span>Vinh</span>
                    </div>
                    <p>
                        Hệ thống chăm sóc thú cưng chuyên nghiệp tại TP. Vinh: Tắm spa thảo dược,
                        Grooming tạo kiểu, Cạo lông, Tư vấn ve rận, Nội trú ngắn ngày &amp; Pet Shop.
                    </p>
                </div>
                <div class="footer-col">
                    <h4>Dịch vụ chính</h4>
                    <ul>
                        <li><a href="#dich-vu-section">Tắm chó mèo (Spa vệ sinh)</a></li>
                        <li><a href="#dich-vu-section">Grooming / Cắt tỉa lông chó</a></li>
                        <li><a href="#dich-vu-section">Cạo lông chó mèo</a></li>
                        <li><a href="#dich-vu-section">Nội trú chó mèo ngắn ngày</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Thông tin hỗ trợ</h4>
                    <ul>
                        <li><a href="#pham-vi-section">Phạm vi nhận chăm sóc</a></li>
                        <li><a href="#chon-dich-vu-section">Bảng chọn theo tình trạng</a></li>
                        <li><a href="#quy-trinh-section">Quy trình 5 bước</a></li>
                        <li><a href="#bang-gia-section">Bảng giá tham khảo</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Liên hệ</h4>
                    <ul>
                        <li>Cơ sở 1: 86 Nguyễn Văn Cừ, P. Trường Thi, TP. Vinh</li>
                        <li>Hotline / Zalo: 0912.345.678</li>
                        <li>Giờ mở cửa: 08:00 - 20:30 hằng ngày</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <span>&copy; 2026 PetCare Vinh. All rights reserved.</span>
                <span>Chăm sóc yêu thương - Ưu tiên sự an toàn và sức khỏe của các bé</span>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>

