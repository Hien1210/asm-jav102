<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh toán | PetCare</title>
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
                <h1>Thanh toán hóa đơn</h1>
                <p class="pc-page-sub">Thanh toán trực tuyến hoặc đăng ký thanh toán tiền mặt tại quầy và theo dõi toàn bộ lịch sử giao dịch.</p>
            </div>
            <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-outline">Xem lịch hẹn của tôi</a>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="pc-alert pc-alert-success">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <!-- KPI thanh toán -->
        <div class="pc-grid-3" style="margin-bottom:20px;">
            <div class="pc-kpi">
                <div class="pc-kpi-label">Còn phải thanh toán</div>
                <div class="pc-kpi-val warn">${formattedTotalRemaining}</div>
            </div>
            <div class="pc-kpi">
                <div class="pc-kpi-label">Tổng đã thanh toán</div>
                <div class="pc-kpi-val success">${formattedTotalPaid}</div>
            </div>
            <div class="pc-kpi">
                <div class="pc-kpi-label">Giao dịch đang chờ</div>
                <div class="pc-kpi-val primary">${pendingCount}</div>
            </div>
        </div>

        <!-- Giao dịch đang chờ xử lý (Online có thể xác nhận ngay / Cash chờ quầy) -->
        <c:set var="hasPending" value="false" />
        <c:forEach var="p" items="${paymentHistory}">
            <c:if test="${p.status == 'PENDING' && p.paymentType == 'CHARGE'}">
                <c:set var="hasPending" value="true" />
            </c:if>
        </c:forEach>

        <c:if test="${hasPending}">
            <section class="pc-card" style="border-color:#fcd34d;background:#fffdf5;">
                <div class="pc-card-head">
                    <h2>Giao dịch đang chờ xác nhận</h2>
                </div>
                <c:forEach var="p" items="${paymentHistory}">
                    <c:if test="${p.status == 'PENDING' && p.paymentType == 'CHARGE'}">
                        <div class="pc-item-card" style="display:flex;justify-content:space-between;align-items:center;gap:14px;flex-wrap:wrap;">
                            <div>
                                <div>
                                    <strong>Giao dịch #${p.paymentId}</strong> &bull; Lịch hẹn #${p.appointmentId}
                                    <span class="pc-badge pc-badge-pending" style="margin-left:6px;">${p.statusLabel}</span>
                                </div>
                                <div style="font-size:13.5px;margin-top:4px;">
                                    Số tiền: <strong style="color:var(--pc-primary);">${p.formattedAmount}</strong>
                                    &bull; Phương thức: <strong>${p.methodLabel}</strong>
                                    <c:if test="${not empty p.transactionRef}">
                                        &bull; Mã tham chiếu: <code>${fn:escapeXml(p.transactionRef)}</code>
                                    </c:if>
                                </div>
                                <c:if test="${p.method == 'ONLINE'}">
                                    <div class="pc-hint">
                                        Cổng thanh toán mô phỏng: Nội dung chuyển khoản <strong>${fn:escapeXml(p.transactionRef)}</strong> — nhấn xác nhận sau khi hoàn tất.
                                    </div>
                                </c:if>
                                <c:if test="${p.method == 'CASH'}">
                                    <div class="pc-hint">
                                        Vui lòng thanh toán trực tiếp tại quầy lễ tân PetCare để nhân viên xác nhận.
                                    </div>
                                </c:if>
                            </div>
                            <div class="pc-btn-group">
                                <c:if test="${p.method == 'ONLINE'}">
                                    <form method="post" action="${pageContext.request.contextPath}/customer/thanh-toan" style="display:inline;">
                                        <input type="hidden" name="action" value="confirmOnline" />
                                        <input type="hidden" name="paymentId" value="${p.paymentId}" />
                                        <button type="submit" class="pc-btn pc-btn-primary pc-btn-sm">Xác nhận đã thanh toán</button>
                                    </form>
                                </c:if>
                                <form method="post" action="${pageContext.request.contextPath}/customer/thanh-toan" style="display:inline;"
                                      onsubmit="return confirm('Hủy yêu cầu thanh toán đang chờ #' + ${p.paymentId} + '?');">
                                    <input type="hidden" name="action" value="cancelPending" />
                                    <input type="hidden" name="paymentId" value="${p.paymentId}" />
                                    <button type="submit" class="pc-btn pc-btn-danger-outline pc-btn-sm">Hủy yêu cầu</button>
                                </form>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </section>
        </c:if>

        <div class="pc-layout-split">
            <!-- Form tạo giao dịch mới -->
            <section class="pc-card">
                <div class="pc-card-head">
                    <h2>Tạo thanh toán mới</h2>
                </div>

                <c:set var="hasUnpaid" value="false" />
                <c:forEach var="a" items="${payableAppointments}">
                    <c:if test="${a.remainingAmount > 0}">
                        <c:set var="hasUnpaid" value="true" />
                    </c:if>
                </c:forEach>

                <c:choose>
                    <c:when test="${not hasUnpaid}">
                        <div class="pc-empty" style="padding:20px 10px;">
                            <p style="margin:0;">Tất cả lịch hẹn hợp lệ của bạn đã được thanh toán đủ hoặc đang chờ xác nhận.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="${pageContext.request.contextPath}/customer/thanh-toan" id="paymentForm">
                            <input type="hidden" name="action" value="pay" />
                            <input type="hidden" name="paymentKey" value="${fn:escapeXml(paymentKey)}" />

                            <div class="pc-form-group">
                                <label for="payApptSelect">Chọn lịch hẹn cần thanh toán <span class="pc-req">*</span></label>
                                <select id="payApptSelect" class="pc-select" name="appointmentId" required>
                                    <c:forEach var="appt" items="${payableAppointments}">
                                        <c:if test="${appt.remainingAmount > 0}">
                                            <option value="${appt.appointmentId}"
                                                    data-remaining="${appt.remainingAmount}"
                                                    ${selectedAppointmentId == appt.appointmentId.toString() ? 'selected' : ''}>
                                                #${appt.appointmentId} — ${fn:escapeXml(appt.petName)} (${appt.typeLabel}) — Còn ${appt.formattedRemainingAmount}
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="pc-form-group">
                                <label for="payAmount">Số tiền thanh toán (VNĐ) <span class="pc-req">*</span></label>
                                <input id="payAmount" class="pc-input" type="number" name="amount" min="1000" step="1000" required />
                                <div class="pc-hint">Có thể thanh toán toàn bộ hoặc một phần (không vượt quá số tiền còn lại).</div>
                            </div>

                            <div class="pc-form-group">
                                <label for="payMethod">Phương thức thanh toán <span class="pc-req">*</span></label>
                                <select id="payMethod" class="pc-select" name="method" required>
                                    <option value="ONLINE">Thanh toán trực tuyến (Chuyển khoản / QR Online)</option>
                                    <option value="CASH">Tiền mặt tại quầy lễ tân (CASH)</option>
                                </select>
                            </div>

                            <button type="submit" class="pc-btn pc-btn-primary" style="width:100%;">
                                Khởi tạo thanh toán
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Bảng công nợ lịch hẹn & Lịch sử giao dịch -->
            <div>
                <section class="pc-card">
                    <div class="pc-card-head">
                        <h2>Tổng hợp hóa đơn lịch hẹn</h2>
                    </div>
                    <c:choose>
                        <c:when test="${empty payableAppointments}">
                            <div class="pc-empty" style="padding:20px;">
                                <p>Chưa có hóa đơn lịch hẹn nào.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="pc-table-wrap">
                                <table class="pc-table">
                                    <thead>
                                        <tr>
                                            <th>Lịch hẹn</th>
                                            <th>Thú cưng</th>
                                            <th>Trạng thái</th>
                                            <th>Tổng tiền</th>
                                            <th>Đã trả / Chờ</th>
                                            <th>Còn lại</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="appt" items="${payableAppointments}">
                                            <tr>
                                                <td><strong>#${appt.appointmentId}</strong><br /><span style="font-size:12px;color:var(--pc-muted);">${appt.typeLabel}</span></td>
                                                <td>${fn:escapeXml(appt.petName)}</td>
                                                <td><span class="pc-badge pc-badge-${fn:toLowerCase(appt.status)}">${appt.statusLabel}</span></td>
                                                <td><strong>${appt.formattedTotalAmount}</strong></td>
                                                <td>${appt.formattedPaidOrPendingAmount}</td>
                                                <td>
                                                    <strong style="color:${appt.remainingAmount > 0 ? 'var(--pc-warn)' : 'var(--pc-success)'};">
                                                        ${appt.formattedRemainingAmount}
                                                    </strong>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="pc-card">
                    <div class="pc-card-head">
                        <h2>Lịch sử giao dịch (${fn:length(paymentHistory)})</h2>
                    </div>
                    <c:choose>
                        <c:when test="${empty paymentHistory}">
                            <div class="pc-empty" style="padding:20px;">
                                <p>Bạn chưa thực hiện giao dịch thanh toán nào.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="pc-table-wrap">
                                <table class="pc-table">
                                    <thead>
                                        <tr>
                                            <th>Mã GD</th>
                                            <th>Lịch hẹn</th>
                                            <th>Loại</th>
                                            <th>Số tiền</th>
                                            <th>Phương thức</th>
                                            <th>Trạng thái</th>
                                            <th>Mã tham chiếu / Thời gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${paymentHistory}">
                                            <tr>
                                                <td>#${p.paymentId}</td>
                                                <td>#${p.appointmentId}</td>
                                                <td>
                                                    <span class="pc-badge ${p.paymentType == 'REFUND' ? 'pc-badge-confirmed' : 'pc-badge-neutral'}">
                                                        ${p.paymentTypeLabel}
                                                    </span>
                                                </td>
                                                <td><strong>${p.formattedAmount}</strong></td>
                                                <td>${p.methodLabel}</td>
                                                <td><span class="pc-badge pc-badge-${fn:toLowerCase(p.status)}">${p.statusLabel}</span></td>
                                                <td style="font-size:12.5px;color:var(--pc-muted);">
                                                    <c:if test="${not empty p.transactionRef}">
                                                        <div><code>${fn:escapeXml(p.transactionRef)}</code></div>
                                                    </c:if>
                                                    <div>${not empty p.formattedPaidAt ? p.formattedPaidAt : '—'}</div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </div>
    </main>

    <script>
        (function () {
            var select = document.getElementById("payApptSelect");
            var amountInput = document.getElementById("payAmount");
            if (!select || !amountInput) return;
            function syncAmount() {
                var opt = select.options[select.selectedIndex];
                if (!opt) return;
                var rem = parseFloat(opt.getAttribute("data-remaining") || "0");
                if (!isNaN(rem) && rem > 0) {
                    amountInput.value = Math.round(rem);
                    amountInput.max = rem;
                }
            }
            select.addEventListener("change", syncAmount);
            syncAmount();
        })();
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
