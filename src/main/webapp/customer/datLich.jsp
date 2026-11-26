<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lịch chăm sóc &amp; lưu trú | PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer.css?v=2" />
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
    <%@ include file="/WEB-INF/includes/customerNav.jspf" %>

    <c:set var="petCount" value="${fn:length(pets)}" />
    <c:set var="hasPets" value="${not empty pets}" />

    <main class="pc-main">
        <!-- BOOKING HERO BANNER + 2-STEP PROGRESS -->
        <section class="bk-hero" aria-label="Đặt lịch chăm sóc và lưu trú">
            <div class="bk-hero-accent">
                <svg class="bk-hero-paw" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                    <circle cx="7" cy="7.5" r="2.2" />
                    <circle cx="12" cy="5.2" r="2.2" />
                    <circle cx="17" cy="7.5" r="2.2" />
                    <circle cx="4.3" cy="12.2" r="2" />
                    <circle cx="19.7" cy="12.2" r="2" />
                    <path d="M12 11.2c-3.4 0-6.2 2.4-6.2 5.4 0 2 1.7 3.4 3.8 3.4 1 0 1.7-.3 2.4-.3s1.4.3 2.4.3c2.1 0 3.8-1.4 3.8-3.4 0-3-2.8-5.4-6.2-5.4z" />
                </svg>

                <div class="bk-hero-row">
                    <div>
                        <span class="bk-hero-kicker">
                            <span class="bk-hero-kicker-dot" aria-hidden="true"></span>
                            <span>TRUNG TÂM ĐẶT LỊCH SPA &amp; KHÁCH SẠN THÚ CƯNG</span>
                        </span>
                        <h1>Đặt lịch chăm sóc &amp; lưu trú</h1>
                        <p class="bk-hero-sub">Hỗ trợ đặt dịch vụ lẻ, gộp nhiều dịch vụ cùng lúc, gói Combo tiết kiệm và phòng lưu trú khách sạn thú cưng.</p>
                    </div>
                    <div class="bk-hero-actions">
                        <a href="${pageContext.request.contextPath}/customer/thu-cung" class="bk-btn-white">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <circle cx="11" cy="4" r="2"></circle>
                                <circle cx="18" cy="8" r="2"></circle>
                                <circle cx="20" cy="16" r="2"></circle>
                                <path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"></path>
                            </svg>
                            <span>Quản lý thú cưng</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/customer/lich-hen" class="bk-btn-glass">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" aria-hidden="true">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <polyline points="14 2 14 8 20 8"></polyline>
                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                <line x1="16" y1="17" x2="8" y2="17"></line>
                            </svg>
                            <span>Lịch hẹn của tôi</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="bk-stepper" aria-label="Tiến trình đặt lịch">
                <div class="bk-step ${hasPets ? 'is-done' : 'is-active'}">
                    <span class="bk-step-num" aria-hidden="true">
                        <c:choose>
                            <c:when test="${hasPets}">&#10003;</c:when>
                            <c:otherwise>1</c:otherwise>
                        </c:choose>
                    </span>
                    <div class="bk-step-text">
                        <strong>Bước 1: Hồ sơ thú cưng (${petCount} bé)</strong>
                        <span>
                            <c:choose>
                                <c:when test="${hasPets}">Đã sẵn sàng — chọn bé hoặc thêm bé mới</c:when>
                                <c:otherwise>Thêm bé cưng đầu tiên để bắt đầu đặt lịch</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                <div class="bk-step ${hasPets ? 'is-active' : ''}">
                    <span class="bk-step-num" aria-hidden="true">2</span>
                    <div class="bk-step-text">
                        <strong>Bước 2: Chọn dịch vụ &amp; khung giờ</strong>
                        <span>Dịch vụ lẻ, nhiều dịch vụ, gói Combo hoặc lưu trú</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ALERTS -->
        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error" role="alert">
                <span>${fn:escapeXml(errorMessage)}</span>
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="pc-alert pc-alert-success" role="status">
                <span>${fn:escapeXml(successMessage)}</span>
                <c:if test="${not empty createdAppointmentId}">
                    <span class="pc-btn-group">
                        <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-ghost pc-btn-sm">Xem lịch hẹn</a>
                        <a href="${pageContext.request.contextPath}/customer/thanh-toan?appointmentId=${createdAppointmentId}" class="pc-btn pc-btn-primary pc-btn-sm">Thanh toán ngay</a>
                    </span>
                </c:if>
            </div>
        </c:if>

        <div class="pc-layout-sidebar">
            <!-- LEFT MAIN COLUMN -->
            <div>
                <!-- Bước 1: Thú cưng của bạn -->
                <section class="pc-card">
                    <div class="pc-card-head">
                        <div class="bk-head-left">
                            <span class="bk-head-icon" aria-hidden="true">
                                <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <circle cx="11" cy="4" r="2"></circle>
                                    <circle cx="18" cy="8" r="2"></circle>
                                    <circle cx="20" cy="16" r="2"></circle>
                                    <path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"></path>
                                </svg>
                            </span>
                            <div>
                                <h2>1. Thú cưng của bạn (${petCount})</h2>
                                <p class="bk-head-sub">
                                    <c:choose>
                                        <c:when test="${hasPets}">Chọn nhanh bé cưng bên dưới hoặc thêm hồ sơ mới</c:when>
                                        <c:otherwise>Thêm nhanh thông tin bé cưng chỉ trong 10 giây</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/customer/thu-cung" class="bk-link-pill">
                            <span>Quản lý chi tiết</span>
                            <span>&rarr;</span>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${empty pets}">
                            <div class="bk-empty-callout">
                                <span class="bk-empty-callout-ico" aria-hidden="true">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="16" x2="12" y2="12"></line>
                                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                    </svg>
                                </span>
                                <div>
                                    <strong>Chưa có hồ sơ bé cưng nào</strong>
                                    <p>Hãy điền tên và loài của bé ở biểu mẫu bên dưới — ngay sau khi thêm, toàn bộ dịch vụ Spa, Combo và phòng lưu trú sẽ mở sẵn để bạn đặt lịch.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="bk-pet-chips" role="group" aria-label="Chọn nhanh thú cưng">
                                <c:forEach var="pet" items="${pets}" varStatus="pst">
                                    <c:set var="isSelectedPet" value="${(not empty preselectedPetId && preselectedPetId == pet.petId.toString()) || (empty preselectedPetId && pst.first)}" />
                                    <button type="button"
                                            class="bk-pet-chip${isSelectedPet ? ' is-selected' : ''}"
                                            data-quick-pet="${pet.petId}">
                                        <span class="bk-pet-chip-av" aria-hidden="true">
                                            ${fn:toUpperCase(fn:substring(fn:trim(pet.name), 0, 1))}
                                        </span>
                                        <span class="bk-pet-chip-info">
                                            <strong>${fn:escapeXml(pet.name)}</strong>
                                            <span class="bk-pet-chip-meta">${fn:escapeXml(pet.species)}<c:if test="${not empty pet.weightKg}"> &bull; ${pet.weightKg} kg</c:if></span>
                                        </span>
                                    </button>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <details class="bk-quick-add" ${empty pets ? 'open' : ''}>
                        <summary>
                            <span class="bk-summary-left">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" aria-hidden="true">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                <span>Thêm thú cưng nhanh</span>
                            </span>
                            <svg class="bk-summary-chev" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </summary>
                        <div class="bk-quick-add-body">
                            <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich">
                                <input type="hidden" name="action" value="addPet" />
                                <div class="pc-form-row">
                                    <div class="pc-form-group">
                                        <label for="quickPetName">Tên thú cưng <span class="pc-req">*</span></label>
                                        <input id="quickPetName" class="pc-input" type="text" name="petName" required maxlength="100" placeholder="Ví dụ: Bé Miu, Mochi..." />
                                    </div>
                                    <div class="pc-form-group">
                                        <label for="quickPetSpecies">
                                            Loài <span class="pc-req">*</span>
                                            <span class="bk-species-pills">
                                                <button type="button" class="bk-species-pill" data-fill-species="Chó">Chó</button>
                                                <button type="button" class="bk-species-pill" data-fill-species="Mèo">Mèo</button>
                                            </span>
                                        </label>
                                        <input id="quickPetSpecies" class="pc-input" type="text" name="petSpecies" required maxlength="50" placeholder="Chó / Mèo..." />
                                    </div>
                                </div>
                                <div class="pc-form-row">
                                    <div class="pc-form-group">
                                        <label for="quickPetBreed">Giống (không bắt buộc)</label>
                                        <input id="quickPetBreed" class="pc-input" type="text" name="petBreed" maxlength="100" placeholder="Poodle, Corgi, Anh Lông Ngắn..." />
                                    </div>
                                    <div class="pc-form-group">
                                        <label for="quickPetWeight">Cân nặng kg (không bắt buộc)</label>
                                        <input id="quickPetWeight" class="pc-input" type="number" name="petWeight" step="0.01" min="0.01" max="999.99" placeholder="Ví dụ: 4.5" />
                                    </div>
                                </div>
                                <div class="bk-form-footer">
                                    <span class="bk-form-note">Bạn có thể bổ sung ngày sinh và ghi chú sức khỏe sau tại mục Thú cưng của tôi.</span>
                                    <button type="submit" class="pc-btn pc-btn-primary">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" aria-hidden="true">
                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                        </svg>
                                        <span>Thêm thú cưng</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </details>
                </section>

                <!-- Bước 2: Đặt lịch theo 4 chế độ (hoặc xem trước khi chưa có thú cưng) -->
                <c:choose>
                    <c:when test="${empty pets}">
                        <section class="bk-preview-card" aria-label="Các hình thức đặt lịch hỗ trợ">
                            <div class="bk-head-left">
                                <span class="bk-head-icon" aria-hidden="true">
                                    <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                        <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </span>
                                <div>
                                    <h2 style="margin:0;font-size:1.03rem;">2. Sẵn sàng 4 hình thức đặt lịch linh hoạt</h2>
                                    <p class="bk-head-sub">Hoàn tất Bước 1 (thêm bé cưng) để mở khóa chọn dịch vụ, nhân viên và khung giờ mong muốn.</p>
                                </div>
                            </div>

                            <div class="bk-preview-grid">
                                <div class="bk-preview-item">
                                    <span class="bk-preview-item-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                                            <polyline points="2 17 12 22 22 17"></polyline>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong>Dịch vụ lẻ</strong>
                                        <span>Tắm thảo mộc, cắt tỉa lông, vệ sinh tai móng và chọn chuyên viên yêu thích.</span>
                                    </div>
                                </div>
                                <div class="bk-preview-item">
                                    <span class="bk-preview-item-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                                            <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                                            <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                                            <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong>Nhiều dịch vụ cùng lúc</strong>
                                        <span>Gộp tối đa 10 dịch vụ trong cùng 1 lịch hẹn, tự động kiểm tra tránh trùng giờ.</span>
                                    </div>
                                </div>
                                <div class="bk-preview-item">
                                    <span class="bk-preview-item-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="20 12 20 22 4 22 4 12"></polyline>
                                            <rect x="2" y="7" width="20" height="5"></rect>
                                            <line x1="12" y1="22" x2="12" y2="7"></line>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong>Gói Combo ưu đãi</strong>
                                        <span>Tiết kiệm chi phí hơn dịch vụ lẻ, tự động xếp giờ nối tiếp liền mạch.</span>
                                    </div>
                                </div>
                                <div class="bk-preview-item">
                                    <span class="bk-preview-item-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong>Phòng lưu trú khách sạn</strong>
                                        <span>Đặt phòng điều hòa sạch sẽ theo ngày Check-in / Check-out với báo giá tự động.</span>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </c:when>

                    <c:otherwise>
                        <section class="pc-card">
                            <div class="pc-card-head">
                                <div class="bk-head-left">
                                    <span class="bk-head-icon" aria-hidden="true">
                                        <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                            <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                    </span>
                                    <div>
                                        <h2>2. Chọn hình thức đặt lịch</h2>
                                        <p class="bk-head-sub">Chọn chế độ phù hợp với nhu cầu chăm sóc bé cưng</p>
                                    </div>
                                </div>
                            </div>

                            <div class="bk-mode-grid" role="tablist">
                                <button type="button" class="bk-mode-btn pc-tab-btn ${activeTab == 'service' || empty activeTab ? 'active' : ''}" data-tab="service">
                                    <span class="bk-mode-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                                            <polyline points="2 17 12 22 22 17"></polyline>
                                        </svg>
                                    </span>
                                    <strong>Dịch vụ lẻ</strong>
                                    <span>Tắm, cắt tỉa, spa</span>
                                </button>

                                <button type="button" class="bk-mode-btn pc-tab-btn ${activeTab == 'multi' ? 'active' : ''}" data-tab="multi">
                                    <span class="bk-mode-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
                                            <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
                                            <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
                                            <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
                                        </svg>
                                    </span>
                                    <strong>Nhiều dịch vụ</strong>
                                    <span>Gộp trong 1 lịch</span>
                                </button>

                                <button type="button" class="bk-mode-btn pc-tab-btn ${activeTab == 'combo' ? 'active' : ''}" data-tab="combo">
                                    <span class="bk-mode-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="20 12 20 22 4 22 4 12"></polyline>
                                            <rect x="2" y="7" width="20" height="5"></rect>
                                            <line x1="12" y1="22" x2="12" y2="7"></line>
                                        </svg>
                                    </span>
                                    <strong>Gói Combo</strong>
                                    <span>Ưu đãi tiết kiệm</span>
                                </button>

                                <button type="button" class="bk-mode-btn pc-tab-btn ${activeTab == 'boarding' ? 'active' : ''}" data-tab="boarding">
                                    <span class="bk-mode-ico" aria-hidden="true">
                                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                        </svg>
                                    </span>
                                    <strong>Phòng lưu trú</strong>
                                    <span>Khách sạn thú cưng</span>
                                </button>
                            </div>

                            <!-- TAB 1: Đặt 1 dịch vụ lẻ -->
                            <div class="pc-tab-panel ${activeTab == 'service' || empty activeTab ? 'active' : ''}" id="tab-service">
                                <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich">
                                    <input type="hidden" name="action" value="book" />

                                    <div class="pc-form-group">
                                        <label>Thú cưng <span class="pc-req">*</span></label>
                                        <select class="pc-select" name="petId" required>
                                            <c:forEach var="pet" items="${pets}">
                                                <option value="${pet.petId}"${preselectedPetId == pet.petId.toString() ? ' selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="pc-form-group">
                                        <label>Dịch vụ &amp; nhân viên thực hiện <span class="pc-req">*</span></label>
                                        <c:choose>
                                            <c:when test="${empty staffByService}">
                                                <p class="pc-hint">Hiện chưa có dịch vụ nào mở để đặt lịch.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <select class="pc-select" name="staffChoice" required>
                                                    <c:forEach var="entry" items="${staffByService}">
                                                        <optgroup label="${fn:escapeXml(entry.key.name)} (${entry.key.durationMinutes} phút - ${entry.key.formattedPrice})">
                                                            <c:forEach var="staff" items="${entry.value}">
                                                                <option value="${entry.key.serviceId}_${staff.staffId}">${fn:escapeXml(staff.fullName)}</option>
                                                            </c:forEach>
                                                            <c:if test="${empty entry.value}">
                                                                <option disabled>Chưa có nhân viên nhận dịch vụ này</option>
                                                            </c:if>
                                                        </optgroup>
                                                    </c:forEach>
                                                </select>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="pc-form-row">
                                        <div class="pc-form-group">
                                            <label>Ngày hẹn <span class="pc-req">*</span></label>
                                            <input class="pc-input" type="date" name="bookingDate" min="${todayIso}" value="${tomorrowIso}" required />
                                        </div>
                                        <div class="pc-form-group">
                                            <label>Giờ hẹn <span class="pc-req">*</span></label>
                                            <input class="pc-input" type="time" name="bookingTime" value="09:00" required />
                                        </div>
                                    </div>

                                    <div class="bk-form-footer">
                                        <span class="bk-form-note">Hệ thống kiểm tra tự động theo giờ mở cửa và ca trực nhân viên.</span>
                                        <button type="submit" class="pc-btn pc-btn-primary">Xác nhận đặt lịch</button>
                                    </div>
                                </form>
                            </div>

                            <!-- TAB 2: Đặt nhiều dịch vụ trong 1 lịch hẹn -->
                            <div class="pc-tab-panel ${activeTab == 'multi' ? 'active' : ''}" id="tab-multi">
                                <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich" id="multiServiceForm">
                                    <input type="hidden" name="action" value="bookMulti" />

                                    <div class="pc-form-group">
                                        <label>Thú cưng <span class="pc-req">*</span></label>
                                        <select class="pc-select" name="petId" required>
                                            <c:forEach var="pet" items="${pets}">
                                                <option value="${pet.petId}"${preselectedPetId == pet.petId.toString() ? ' selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <p class="pc-hint" style="margin-top:0;margin-bottom:14px;">
                                        Mỗi dịch vụ trong cùng lịch hẹn phải là dịch vụ khác nhau và khung giờ không chồng chéo nhau trên cùng thú cưng.
                                    </p>

                                    <div id="multiRowsContainer">
                                        <div class="pc-multi-row">
                                            <div class="pc-form-group">
                                                <label>Dịch vụ &amp; nhân viên #1 <span class="pc-req">*</span></label>
                                                <select class="pc-select" name="multiStaffChoice" required>
                                                    <c:forEach var="entry" items="${staffByService}">
                                                        <optgroup label="${fn:escapeXml(entry.key.name)} (${entry.key.durationMinutes} phút - ${entry.key.formattedPrice})">
                                                            <c:forEach var="staff" items="${entry.value}">
                                                                <option value="${entry.key.serviceId}_${staff.staffId}">${fn:escapeXml(staff.fullName)}</option>
                                                            </c:forEach>
                                                        </optgroup>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="pc-form-row">
                                                <div class="pc-form-group" style="margin-bottom:0;">
                                                    <label>Ngày hẹn</label>
                                                    <input class="pc-input" type="date" name="multiDate" min="${todayIso}" value="${tomorrowIso}" required />
                                                </div>
                                                <div class="pc-form-group" style="margin-bottom:0;">
                                                    <label>Giờ bắt đầu</label>
                                                    <input class="pc-input" type="time" name="multiTime" value="09:00" required />
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="bk-form-footer">
                                        <button type="button" class="pc-btn pc-btn-outline pc-btn-sm" id="btnAddServiceRow">+ Thêm dịch vụ khác</button>
                                        <button type="submit" class="pc-btn pc-btn-primary">Đặt lịch nhiều dịch vụ</button>
                                    </div>
                                </form>
                            </div>

                            <!-- TAB 3: Đặt gói Combo -->
                            <div class="pc-tab-panel ${activeTab == 'combo' ? 'active' : ''}" id="tab-combo">
                                <c:choose>
                                    <c:when test="${empty combos}">
                                        <div class="pc-empty">
                                            <p>Hiện chưa có gói Combo nào đang mở bán.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich" id="comboBookingForm">
                                            <input type="hidden" name="action" value="bookCombo" />

                                            <div class="pc-form-group">
                                                <label>Thú cưng <span class="pc-req">*</span></label>
                                                <select class="pc-select" name="petId" required>
                                                    <c:forEach var="pet" items="${pets}">
                                                        <option value="${pet.petId}"${preselectedPetId == pet.petId.toString() ? ' selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="pc-form-group">
                                                <label>Chọn gói Combo <span class="pc-req">*</span></label>
                                                <select class="pc-select" name="comboId" id="comboSelector" required>
                                                    <c:forEach var="combo" items="${combos}" varStatus="st">
                                                        <option value="${combo.comboId}"
                                                                ${(not empty preselectedComboId && preselectedComboId == combo.comboId.toString()) || (empty preselectedComboId && st.first) ? 'selected' : ''}>
                                                            ${fn:escapeXml(combo.name)} — ${combo.formattedPrice} (${combo.totalDurationMinutes} phút)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="pc-form-row">
                                                <div class="pc-form-group">
                                                    <label>Ngày hẹn <span class="pc-req">*</span></label>
                                                    <input class="pc-input" type="date" name="comboDate" min="${todayIso}" value="${tomorrowIso}" required />
                                                </div>
                                                <div class="pc-form-group">
                                                    <label>Giờ bắt đầu dịch vụ đầu tiên <span class="pc-req">*</span></label>
                                                    <input class="pc-input" type="time" name="comboTime" value="09:00" required />
                                                    <div class="pc-hint">Hệ thống tự động xếp nối tiếp thời lượng các dịch vụ trong gói.</div>
                                                </div>
                                            </div>

                                            <c:forEach var="combo" items="${combos}" varStatus="st">
                                                <div class="pc-item-card combo-detail-box" data-combo-id="${combo.comboId}"
                                                     style="${(not empty preselectedComboId && preselectedComboId == combo.comboId.toString()) || (empty preselectedComboId && st.first) ? '' : 'display:none;'}">
                                                    <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;margin-bottom:10px;">
                                                        <strong style="font-size:0.95rem;">${fn:escapeXml(combo.name)}</strong>
                                                        <div>
                                                            <c:if test="${combo.savingsAmount > 0}">
                                                                <span class="pc-price-strike">${combo.formattedOriginalTotalPrice}</span>
                                                            </c:if>
                                                            <span class="pc-price-highlight">${combo.formattedPrice}</span>
                                                            <c:if test="${combo.savingsAmount > 0}">
                                                                <span class="pc-badge pc-badge-completed" style="margin-left:6px;">Tiết kiệm ${combo.formattedSavingsAmount}</span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <c:if test="${not empty combo.description}">
                                                        <p style="margin:0 0 14px;font-size:0.82rem;color:var(--pc-muted);">${fn:escapeXml(combo.description)}</p>
                                                    </c:if>
                                                    <c:forEach var="svc" items="${combo.services}">
                                                        <div class="pc-form-group">
                                                            <label>
                                                                Nhân viên cho <strong>${fn:escapeXml(svc.name)}</strong> (${svc.durationMinutes} phút) <span class="pc-req">*</span>
                                                            </label>
                                                            <select class="pc-select combo-staff-select"
                                                                    name="comboStaff_${combo.comboId}_${svc.serviceId}">
                                                                <c:forEach var="staff" items="${staffByServiceId[svc.serviceId]}">
                                                                    <option value="${staff.staffId}">${fn:escapeXml(staff.fullName)}</option>
                                                                </c:forEach>
                                                                <c:if test="${empty staffByServiceId[svc.serviceId]}">
                                                                    <option value="" disabled selected>Chưa có nhân viên phụ trách dịch vụ này</option>
                                                                </c:if>
                                                            </select>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:forEach>

                                            <div class="bk-form-footer">
                                                <span class="bk-form-note">Giá ưu đãi của gói Combo được giữ cố định tại thời điểm đặt lịch.</span>
                                                <button type="submit" class="pc-btn pc-btn-primary">Xác nhận đặt gói Combo</button>
                                            </div>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- TAB 4: Đặt phòng lưu trú (Boarding) -->
                            <div class="pc-tab-panel ${activeTab == 'boarding' ? 'active' : ''}" id="tab-boarding">
                                <c:choose>
                                    <c:when test="${empty rooms}">
                                        <div class="pc-empty">
                                            <p>Hiện chưa có phòng lưu trú nào đang mở đặt.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich" id="boardingForm">
                                            <input type="hidden" name="action" value="bookBoarding" />

                                            <div class="pc-form-group">
                                                <label>Thú cưng <span class="pc-req">*</span></label>
                                                <select class="pc-select" name="petId" required>
                                                    <c:forEach var="pet" items="${pets}">
                                                        <option value="${pet.petId}"${preselectedPetId == pet.petId.toString() ? ' selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="pc-form-group">
                                                <label>Chọn phòng lưu trú <span class="pc-req">*</span></label>
                                                <select class="pc-select" name="roomId" id="boardingRoomSelect" required>
                                                    <c:forEach var="room" items="${rooms}">
                                                        <option value="${room.roomId}" data-rate="${room.dailyRate}"
                                                                ${preselectedRoomId == room.roomId.toString() ? 'selected' : ''}>
                                                            ${fn:escapeXml(room.roomCode)} — ${fn:escapeXml(room.roomType)} (${room.formattedDailyRate}/đêm)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="pc-form-row">
                                                <div class="pc-form-group">
                                                    <label>Ngày nhận phòng (Check-in) <span class="pc-req">*</span></label>
                                                    <input class="pc-input" type="date" name="checkInDate" id="checkInDate"
                                                           min="${todayIso}" value="${tomorrowIso}" required />
                                                </div>
                                                <div class="pc-form-group">
                                                    <label>Ngày trả phòng (Check-out) <span class="pc-req">*</span></label>
                                                    <input class="pc-input" type="date" name="checkOutDate" id="checkOutDate"
                                                           min="${tomorrowIso}" value="${dayAfterTomorrowIso}" required />
                                                </div>
                                            </div>

                                            <div class="bk-estimate-box" id="boardingEstimateBox">
                                                <span class="bk-estimate-label">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
                                                        <rect x="1" y="4" width="22" height="16" rx="2"></rect>
                                                        <line x1="1" y1="10" x2="23" y2="10"></line>
                                                    </svg>
                                                    <span>Ước tính chi phí lưu trú</span>
                                                </span>
                                                <span class="bk-estimate-val" id="boardingEstimateText">1 đêm</span>
                                            </div>

                                            <div class="bk-form-footer">
                                                <span class="bk-form-note">Phòng được vệ sinh khử khuẩn và theo dõi 24/7.</span>
                                                <button type="submit" class="pc-btn pc-btn-primary">Xác nhận đặt phòng lưu trú</button>
                                            </div>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </section>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- RIGHT SIDEBAR: Giờ mở cửa & Ca trực nhân viên -->
            <aside aria-label="Thông tin giờ mở cửa và ca trực">
                <section class="pc-card">
                    <div class="pc-card-head">
                        <div class="bk-head-left">
                            <span class="bk-head-icon" aria-hidden="true">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </span>
                            <div>
                                <h2>Giờ mở cửa cơ sở</h2>
                                <p class="bk-head-sub">Lịch phục vụ hằng tuần</p>
                            </div>
                        </div>
                        <span class="pc-badge pc-badge-primary">Mở cửa</span>
                    </div>
                    <c:choose>
                        <c:when test="${empty businessHours}">
                            <p class="pc-hint">Chưa cấu hình giờ mở cửa.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="bk-hours-list">
                                <c:forEach var="bh" items="${businessHours}">
                                    <div class="bk-hour-row">
                                        <span class="bk-hour-day">${bh.dayLabel}</span>
                                        <span class="bk-hour-pill${bh.closed ? ' is-closed' : ''}">${bh.formattedRange}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="pc-card">
                    <div class="pc-card-head">
                        <div class="bk-head-left">
                            <span class="bk-head-icon" aria-hidden="true">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                            </span>
                            <div>
                                <h2>Ca trực sắp tới</h2>
                                <p class="bk-head-sub">Lịch chuyên viên trong 7 ngày tới</p>
                            </div>
                        </div>
                        <c:if test="${not empty upcomingShifts}">
                            <span class="pc-badge pc-badge-primary">${fn:length(upcomingShifts)} ca</span>
                        </c:if>
                    </div>
                    <c:choose>
                        <c:when test="${empty upcomingShifts}">
                            <p class="pc-hint">Chưa có ca trực trong 7 ngày tới.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="bk-shift-list">
                                <c:forEach var="sh" items="${upcomingShifts}">
                                    <div class="bk-shift-item">
                                        <span class="bk-shift-av" aria-hidden="true">
                                            ${fn:toUpperCase(fn:substring(fn:trim(sh.staffName), 0, 1))}
                                        </span>
                                        <div class="bk-shift-body">
                                            <div class="bk-shift-name">${fn:escapeXml(sh.staffName)}</div>
                                            <div class="bk-shift-time">
                                                <span>${sh.formattedWorkDate}</span>
                                                <span>&bull;</span>
                                                <span>${sh.formattedRange}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="pc-card" style="margin-bottom:0;">
                    <div class="pc-card-head" style="margin-bottom:14px;padding-bottom:12px;">
                        <h2>Lưu ý khi đặt lịch</h2>
                    </div>
                    <ul class="bk-tips-list">
                        <li>
                            <span class="bk-tip-dot" aria-hidden="true">&#10003;</span>
                            <span>Vui lòng đưa bé đến trước giờ hẹn khoảng <strong>10 phút</strong> để nhân viên kiểm tra tình trạng lông &amp; da.</span>
                        </li>
                        <li>
                            <span class="bk-tip-dot" aria-hidden="true">&#10003;</span>
                            <span>Với gói <strong>Combo</strong>, hệ thống tự động sắp xếp giờ nối tiếp giữa các dịch vụ.</span>
                        </li>
                        <li>
                            <span class="bk-tip-dot" aria-hidden="true">&#10003;</span>
                            <span>Bạn có thể theo dõi trạng thái, thanh toán hoặc hủy lịch tại mục <strong>Lịch hẹn của tôi</strong>.</span>
                        </li>
                    </ul>
                </section>
            </aside>
        </div>
    </main>

    <script>
        (function () {
            // Quick species buttons in Add Pet form
            var speciesInput = document.getElementById("quickPetSpecies");
            document.querySelectorAll("[data-fill-species]").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    if (speciesInput) {
                        speciesInput.value = btn.getAttribute("data-fill-species");
                        speciesInput.focus();
                    }
                });
            });

            // Quick pet chip selection syncs all booking pet dropdowns
            var petChips = document.querySelectorAll("[data-quick-pet]");
            var petSelects = document.querySelectorAll('select[name="petId"]');
            petChips.forEach(function (chip) {
                chip.addEventListener("click", function () {
                    var pid = chip.getAttribute("data-quick-pet");
                    petChips.forEach(function (c) { c.classList.toggle("is-selected", c === chip); });
                    petSelects.forEach(function (sel) { sel.value = pid; });
                });
            });
            petSelects.forEach(function (sel) {
                sel.addEventListener("change", function () {
                    var pid = sel.value;
                    petChips.forEach(function (c) { c.classList.toggle("is-selected", c.getAttribute("data-quick-pet") === pid); });
                    petSelects.forEach(function (other) { if (other !== sel) other.value = pid; });
                });
            });

            // Booking mode tabs
            var tabButtons = document.querySelectorAll(".pc-tab-btn");
            var tabPanels = document.querySelectorAll(".pc-tab-panel");
            tabButtons.forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var target = btn.getAttribute("data-tab");
                    tabButtons.forEach(function (b) { b.classList.toggle("active", b === btn); });
                    tabPanels.forEach(function (p) { p.classList.toggle("active", p.id === "tab-" + target); });
                });
            });

            // Combo selector toggles detail card
            var comboSelect = document.getElementById("comboSelector");
            if (comboSelect) {
                var updateComboBoxes = function () {
                    var chosen = comboSelect.value;
                    document.querySelectorAll(".combo-detail-box").forEach(function (box) {
                        box.style.display = box.getAttribute("data-combo-id") === chosen ? "block" : "none";
                    });
                };
                comboSelect.addEventListener("change", updateComboBoxes);
                updateComboBoxes();
            }

            // Multi-service dynamic row cloning
            var addBtn = document.getElementById("btnAddServiceRow");
            var container = document.getElementById("multiRowsContainer");
            if (addBtn && container) {
                addBtn.addEventListener("click", function () {
                    var rows = container.querySelectorAll(".pc-multi-row");
                    if (rows.length >= 10) return;
                    var clone = rows[0].cloneNode(true);
                    var idx = rows.length + 1;
                    var lbl = clone.querySelector("label");
                    if (lbl) lbl.innerHTML = 'Dịch vụ &amp; nhân viên #' + idx + ' <span class="pc-req">*</span>';
                    var removeBtn = document.createElement("button");
                    removeBtn.type = "button";
                    removeBtn.className = "pc-btn pc-btn-danger-outline pc-btn-sm";
                    removeBtn.style.marginTop = "12px";
                    removeBtn.textContent = "Xóa dòng này";
                    removeBtn.addEventListener("click", function () { clone.remove(); });
                    clone.appendChild(removeBtn);
                    container.appendChild(clone);
                });
            }

            // Boarding price estimator
            var roomSel = document.getElementById("boardingRoomSelect");
            var inEl = document.getElementById("checkInDate");
            var outEl = document.getElementById("checkOutDate");
            var estText = document.getElementById("boardingEstimateText");
            function updateBoardingEstimate() {
                if (!roomSel || !inEl || !outEl || !estText) return;
                var opt = roomSel.options[roomSel.selectedIndex];
                var rate = opt ? parseFloat(opt.getAttribute("data-rate") || "0") : 0;
                var d1 = new Date(inEl.value);
                var d2 = new Date(outEl.value);
                var nights = Math.round((d2 - d1) / (1000 * 60 * 60 * 24));
                if (isNaN(nights) || nights <= 0) {
                    estText.textContent = "Ngày trả phòng phải sau ngày nhận phòng";
                } else {
                    var total = nights * rate;
                    estText.textContent = nights + " đêm × " + rate.toLocaleString("vi-VN") + " đ = " + total.toLocaleString("vi-VN") + " đ";
                }
            }
            if (roomSel && inEl && outEl) {
                roomSel.addEventListener("change", updateBoardingEstimate);
                inEl.addEventListener("change", updateBoardingEstimate);
                outEl.addEventListener("change", updateBoardingEstimate);
                updateBoardingEstimate();
            }
        })();
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
