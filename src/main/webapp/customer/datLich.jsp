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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer.css?v=1" />
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
    <%@ include file="/WEB-INF/includes/customerNav.jspf" %>

    <main class="pc-main">
        <div class="pc-page-head">
            <div>
                <h1>Đặt lịch chăm sóc &amp; lưu trú</h1>
                <p class="pc-page-sub">Hỗ trợ đặt dịch vụ lẻ, nhiều dịch vụ cùng lúc, gói Combo tiết kiệm và phòng lưu trú khách sạn thú cưng.</p>
            </div>
            <div class="pc-btn-group">
                <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pc-btn pc-btn-outline">Quản lý thú cưng</a>
                <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-ghost">Xem lịch hẹn của tôi</a>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="pc-alert pc-alert-success">
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
            <div>
                <!-- Bước 1: Thêm thú cưng nhanh -->
                <div class="pc-card">
                    <div class="pc-card-head">
                        <h2>1. Thú cưng của bạn (${fn:length(pets)})</h2>
                        <a href="${pageContext.request.contextPath}/customer/thu-cung" style="font-size:13px;font-weight:600;">Quản lý chi tiết &rarr;</a>
                    </div>
                    <c:if test="${empty pets}">
                        <p style="color:var(--pc-muted);font-size:13.5px;margin-top:0;">Bạn chưa có thú cưng nào. Vui lòng thêm trước khi đặt lịch.</p>
                    </c:if>
                    <details ${empty pets ? 'open' : ''}>
                        <summary>+ Thêm thú cưng nhanh</summary>
                        <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich" style="margin-top:12px;">
                            <input type="hidden" name="action" value="addPet" />
                            <div class="pc-form-row">
                                <div class="pc-form-group">
                                    <label>Tên thú cưng <span class="pc-req">*</span></label>
                                    <input class="pc-input" type="text" name="petName" required maxlength="100" placeholder="Ví dụ: Bé Miu" />
                                </div>
                                <div class="pc-form-group">
                                    <label>Loài (chó, mèo, ...) <span class="pc-req">*</span></label>
                                    <input class="pc-input" type="text" name="petSpecies" required maxlength="50" placeholder="Chó / Mèo" />
                                </div>
                            </div>
                            <div class="pc-form-row">
                                <div class="pc-form-group">
                                    <label>Giống (không bắt buộc)</label>
                                    <input class="pc-input" type="text" name="petBreed" maxlength="100" placeholder="Poodle, Corgi..." />
                                </div>
                                <div class="pc-form-group">
                                    <label>Cân nặng kg (không bắt buộc)</label>
                                    <input class="pc-input" type="number" name="petWeight" step="0.01" min="0.01" max="999.99" placeholder="4.5" />
                                </div>
                            </div>
                            <button type="submit" class="pc-btn pc-btn-ghost">Thêm thú cưng</button>
                        </form>
                    </details>
                </div>

                <!-- Bước 2: Đặt lịch theo 4 chế độ -->
                <c:if test="${not empty pets}">
                    <div class="pc-card">
                        <div class="pc-card-head">
                            <h2>2. Chọn hình thức đặt lịch</h2>
                        </div>

                        <div class="pc-tabs" role="tablist">
                            <button type="button" class="pc-tab-btn ${activeTab == 'service' || empty activeTab ? 'active' : ''}" data-tab="service">Dịch vụ lẻ</button>
                            <button type="button" class="pc-tab-btn ${activeTab == 'multi' ? 'active' : ''}" data-tab="multi">Nhiều dịch vụ</button>
                            <button type="button" class="pc-tab-btn ${activeTab == 'combo' ? 'active' : ''}" data-tab="combo">Gói Combo ưu đãi</button>
                            <button type="button" class="pc-tab-btn ${activeTab == 'boarding' ? 'active' : ''}" data-tab="boarding">Phòng lưu trú</button>
                        </div>

                        <!-- TAB 1: Đặt 1 dịch vụ lẻ -->
                        <div class="pc-tab-panel ${activeTab == 'service' || empty activeTab ? 'active' : ''}" id="tab-service">
                            <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich">
                                <input type="hidden" name="action" value="book" />

                                <div class="pc-form-group">
                                    <label>Thú cưng <span class="pc-req">*</span></label>
                                    <select class="pc-select" name="petId" required>
                                        <c:forEach var="pet" items="${pets}">
                                            <option value="${pet.petId}" ${preselectedPetId == pet.petId.toString() ? 'selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
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

                                <button type="submit" class="pc-btn pc-btn-primary">Xác nhận đặt lịch</button>
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
                                            <option value="${pet.petId}" ${preselectedPetId == pet.petId.toString() ? 'selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <p class="pc-hint" style="margin-top:0;margin-bottom:12px;">
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

                                <div class="pc-btn-group" style="margin-top:12px;">
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
                                                    <option value="${pet.petId}" ${preselectedPetId == pet.petId.toString() ? 'selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
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
                                                <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;margin-bottom:8px;">
                                                    <strong>${fn:escapeXml(combo.name)}</strong>
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
                                                    <p style="margin:0 0 12px;font-size:13px;color:var(--pc-muted);">${fn:escapeXml(combo.description)}</p>
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

                                        <button type="submit" class="pc-btn pc-btn-primary">Xác nhận đặt gói Combo</button>
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
                                                    <option value="${pet.petId}" ${preselectedPetId == pet.petId.toString() ? 'selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
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

                                        <div class="pc-alert pc-alert-info" id="boardingEstimateBox" style="margin-bottom:14px;">
                                            <span>Ước tính lưu trú: <strong id="boardingEstimateText">1 đêm</strong></span>
                                        </div>

                                        <button type="submit" class="pc-btn pc-btn-primary">Xác nhận đặt phòng lưu trú</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Cột phải: Giờ mở cửa & Ca làm việc nhân viên từ DB -->
            <aside>
                <div class="pc-card">
                    <div class="pc-card-head">
                        <h2>Giờ mở cửa cơ sở</h2>
                    </div>
                    <c:choose>
                        <c:when test="${empty businessHours}">
                            <p class="pc-hint">Chưa cấu hình giờ mở cửa.</p>
                        </c:when>
                        <c:otherwise>
                            <div style="font-size:13.5px;">
                                <c:forEach var="bh" items="${businessHours}">
                                    <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #f1f5f9;">
                                        <span>${bh.dayLabel}</span>
                                        <strong style="color:${bh.closed ? 'var(--pc-danger)' : 'var(--pc-primary)'};">${bh.formattedRange}</strong>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="pc-card">
                    <div class="pc-card-head">
                        <h2>Ca trực sắp tới (7 ngày)</h2>
                    </div>
                    <c:choose>
                        <c:when test="${empty upcomingShifts}">
                            <p class="pc-hint">Chưa có ca trực trong 7 ngày tới.</p>
                        </c:when>
                        <c:otherwise>
                            <div style="max-height:280px;overflow-y:auto;font-size:13px;">
                                <c:forEach var="sh" items="${upcomingShifts}">
                                    <div style="padding:7px 0;border-bottom:1px solid #f1f5f9;">
                                        <div style="font-weight:700;">${fn:escapeXml(sh.staffName)}</div>
                                        <div style="color:var(--pc-muted);">${sh.formattedWorkDate} &bull; ${sh.formattedRange}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </aside>
        </div>
    </main>

    <script>
        (function () {
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
                    removeBtn.style.marginTop = "10px";
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
