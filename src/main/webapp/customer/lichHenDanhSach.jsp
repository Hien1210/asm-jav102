<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch hẹn của tôi | PetCare</title>
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
                <h1>Lịch hẹn của tôi</h1>
                <p class="pc-page-sub">Theo dõi chi tiết lịch dịch vụ, gói combo, phòng lưu trú, trạng thái thanh toán và hủy lịch khi cần.</p>
            </div>
            <a href="${pageContext.request.contextPath}/customer/dat-lich" class="pc-btn pc-btn-primary">+ Đặt lịch mới</a>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="pc-alert pc-alert-success">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <!-- KPI tổng quan -->
        <div class="pc-grid-4">
            <div class="pc-kpi">
                <div class="pc-kpi-label">Tổng lịch hẹn</div>
                <div class="pc-kpi-val">${totalCount}</div>
            </div>
            <div class="pc-kpi">
                <div class="pc-kpi-label">Đang hoạt động</div>
                <div class="pc-kpi-val primary">${activeCount}</div>
            </div>
            <div class="pc-kpi">
                <div class="pc-kpi-label">Đã hoàn thành</div>
                <div class="pc-kpi-val success">${completedCount}</div>
            </div>
            <div class="pc-kpi">
                <div class="pc-kpi-label">Đã hủy / Vắng mặt</div>
                <div class="pc-kpi-val danger">${cancelledCount}</div>
            </div>
        </div>

        <!-- Bộ lọc -->
        <div class="pc-card" style="padding:14px 18px;">
            <form method="get" action="${pageContext.request.contextPath}/customer/lich-hen" class="pc-filter-bar" style="margin:0;">
                <label style="font-size:13px;font-weight:700;color:var(--pc-muted);">Lọc trạng thái:</label>
                <select name="status" class="pc-select" style="width:auto;min-width:170px;" onchange="this.form.submit()">
                    <option value="ALL" ${statusFilter == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                    <option value="CONFIRMED" ${statusFilter == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                    <option value="CHECKED_IN" ${statusFilter == 'CHECKED_IN' ? 'selected' : ''}>Đã check-in</option>
                    <option value="IN_PROGRESS" ${statusFilter == 'IN_PROGRESS' ? 'selected' : ''}>Đang thực hiện</option>
                    <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    <option value="NO_SHOW" ${statusFilter == 'NO_SHOW' ? 'selected' : ''}>Vắng mặt</option>
                </select>

                <label style="font-size:13px;font-weight:700;color:var(--pc-muted);margin-left:8px;">Loại:</label>
                <select name="type" class="pc-select" style="width:auto;min-width:160px;" onchange="this.form.submit()">
                    <option value="ALL" ${typeFilter == 'ALL' ? 'selected' : ''}>Tất cả loại</option>
                    <option value="SERVICE" ${typeFilter == 'SERVICE' ? 'selected' : ''}>Dịch vụ / Combo</option>
                    <option value="BOARDING" ${typeFilter == 'BOARDING' ? 'selected' : ''}>Lưu trú khách sạn</option>
                </select>

                <c:if test="${statusFilter != 'ALL' || typeFilter != 'ALL'}">
                    <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-ghost pc-btn-sm">Xóa bộ lọc</a>
                </c:if>
            </form>
        </div>

        <!-- Danh sách lịch hẹn -->
        <c:choose>
            <c:when test="${empty appointments}">
                <div class="pc-card pc-empty">
                    <h3>Chưa có lịch hẹn nào</h3>
                    <p>Bạn chưa có lịch hẹn phù hợp với bộ lọc hiện tại.</p>
                    <a href="${pageContext.request.contextPath}/customer/dat-lich" class="pc-btn pc-btn-primary">Đặt lịch ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="appt" items="${appointments}">
                    <article class="pc-card">
                        <div class="pc-card-head" style="flex-wrap:wrap;">
                            <div>
                                <h2 style="display:inline-flex;align-items:center;gap:8px;flex-wrap:wrap;">
                                    <span>Lịch hẹn #${appt.appointmentId}</span>
                                    <span class="pc-badge pc-badge-${fn:toLowerCase(appt.status)}">${appt.statusLabel}</span>
                                    <span class="pc-badge pc-badge-primary">${appt.typeLabel}</span>
                                </h2>
                                <div style="font-size:13px;color:var(--pc-muted);margin-top:4px;">
                                    Bé: <strong>${fn:escapeXml(appt.petName)}</strong> (${fn:escapeXml(appt.petSpecies)})
                                    &bull; Đặt lúc: ${appt.formattedCreatedAt}
                                    <c:if test="${not empty appt.comboName}">
                                        &bull; Combo: <strong>${fn:escapeXml(appt.comboName)}</strong>
                                    </c:if>
                                </div>
                            </div>

                            <div class="pc-btn-group">
                                <c:if test="${appt.payable}">
                                    <a href="${pageContext.request.contextPath}/customer/thanh-toan?appointmentId=${appt.appointmentId}"
                                       class="pc-btn pc-btn-primary pc-btn-sm">Thanh toán (${appt.formattedRemainingAmount})</a>
                                </c:if>
                                <c:if test="${appt.reviewable}">
                                    <a href="${pageContext.request.contextPath}/customer/danh-gia?appointmentId=${appt.appointmentId}"
                                       class="pc-btn pc-btn-outline pc-btn-sm">Viết đánh giá</a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Chi tiết dịch vụ hoặc lưu trú -->
                        <c:if test="${appt.appointmentType == 'SERVICE' && not empty appt.serviceLines}">
                            <div class="pc-table-wrap" style="margin-bottom:12px;">
                                <table class="pc-table">
                                    <thead>
                                        <tr>
                                            <th>Dịch vụ</th>
                                            <th>Nhân viên</th>
                                            <th>Thời gian</th>
                                            <th>Đơn giá lúc đặt</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="line" items="${appt.serviceLines}">
                                            <tr>
                                                <td><strong>${fn:escapeXml(line.serviceName)}</strong></td>
                                                <td>${fn:escapeXml(line.staffName)}</td>
                                                <td>${line.formattedStart} &ndash; ${line.formattedEndTime}</td>
                                                <td>${line.formattedPrice}</td>
                                                <td><span class="pc-badge pc-badge-${fn:toLowerCase(line.lineStatus)}">${line.lineStatusLabel}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>

                        <c:if test="${appt.appointmentType == 'BOARDING' && not empty appt.boardingDetail}">
                            <div class="pc-meta-grid">
                                <div class="pc-meta-item">
                                    <span>Phòng lưu trú</span>
                                    <strong>${fn:escapeXml(appt.boardingDetail.roomCode)} &mdash; ${fn:escapeXml(appt.boardingDetail.roomType)}</strong>
                                </div>
                                <div class="pc-meta-item">
                                    <span>Nhận phòng (Check-in)</span>
                                    <strong>${appt.boardingDetail.formattedCheckInDate}</strong>
                                </div>
                                <div class="pc-meta-item">
                                    <span>Trả phòng (Check-out)</span>
                                    <strong>${appt.boardingDetail.formattedCheckOutDate} (${appt.boardingDetail.nights} đêm)</strong>
                                </div>
                                <div class="pc-meta-item">
                                    <span>Giá phòng / đêm</span>
                                    <strong>${appt.boardingDetail.formattedDailyRate}</strong>
                                </div>
                                <c:if test="${not empty appt.boardingDetail.actualCheckIn}">
                                    <div class="pc-meta-item">
                                        <span>Check-in thực tế</span>
                                        <strong>${appt.boardingDetail.formattedActualCheckIn}</strong>
                                    </div>
                                </c:if>
                                <c:if test="${not empty appt.boardingDetail.actualCheckOut}">
                                    <div class="pc-meta-item">
                                        <span>Check-out thực tế</span>
                                        <strong>${appt.boardingDetail.formattedActualCheckOut}</strong>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

                        <!-- Tóm tắt tài chính -->
                        <div class="pc-meta-grid">
                            <div class="pc-meta-item">
                                <span>Tạm tính</span>
                                <strong>${appt.formattedSubtotalAmount}</strong>
                            </div>
                            <c:if test="${appt.adjustmentAmount > 0}">
                                <div class="pc-meta-item">
                                    <span>Phụ thu điều chỉnh</span>
                                    <strong>${appt.formattedAdjustmentAmount}</strong>
                                </div>
                            </c:if>
                            <div class="pc-meta-item">
                                <span>Tổng tiền hóa đơn</span>
                                <strong style="color:var(--pc-primary);">${appt.formattedTotalAmount}</strong>
                            </div>
                            <div class="pc-meta-item">
                                <span>Đã thanh toán / Đang chờ</span>
                                <strong>${appt.formattedPaidAmount} / ${appt.formattedPendingAmount}</strong>
                            </div>
                            <div class="pc-meta-item">
                                <span>Còn phải thanh toán</span>
                                <strong style="color:${appt.remainingAmount > 0 ? 'var(--pc-warn)' : 'var(--pc-success)'};">
                                    ${appt.formattedRemainingAmount}
                                </strong>
                            </div>
                        </div>

                        <c:if test="${appt.status == 'CANCELLED' && not empty appt.cancelReason}">
                            <div class="pc-alert pc-alert-error" style="margin-top:10px;margin-bottom:0;">
                                <span><strong>Lý do hủy:</strong> ${fn:escapeXml(appt.cancelReason)}</span>
                            </div>
                        </c:if>

                        <c:if test="${not empty appt.review}">
                            <div style="margin-top:10px;padding:10px 14px;background:#fffbeb;border:1px solid #fde68a;border-radius:8px;font-size:13.5px;">
                                <span class="pc-stars">
                                    <c:forEach begin="1" end="${appt.review.rating}">&#9733;</c:forEach>
                                </span>
                                <strong style="margin-left:6px;">Đánh giá của bạn (${appt.review.rating}/5):</strong>
                                <c:if test="${not empty appt.review.comment}">
                                    <span>${fn:escapeXml(appt.review.comment)}</span>
                                </c:if>
                            </div>
                        </c:if>

                        <c:if test="${appt.cancellable}">
                            <details style="margin-top:12px;">
                                <summary style="color:var(--pc-danger);">Hủy lịch hẹn này</summary>
                                <form method="post" action="${pageContext.request.contextPath}/customer/lich-hen"
                                      style="margin-top:10px;padding:12px;background:#fef2f2;border:1px solid #fecaca;border-radius:8px;"
                                      onsubmit="return confirm('Bạn chắc chắn muốn hủy lịch hẹn #${appt.appointmentId}?');">
                                    <input type="hidden" name="action" value="cancel" />
                                    <input type="hidden" name="appointmentId" value="${appt.appointmentId}" />
                                    <div class="pc-form-group" style="margin-bottom:10px;">
                                        <label>Lý do hủy lịch <span class="pc-req">*</span></label>
                                        <input class="pc-input" type="text" name="cancelReason" required maxlength="255"
                                               placeholder="Ví dụ: Bận công việc đột xuất, muốn đổi sang ngày khác..." />
                                    </div>
                                    <c:if test="${appt.paidAmount > 0}">
                                        <p class="pc-hint" style="color:#991b1b;margin-bottom:10px;">
                                            Lưu ý: Lịch hẹn này đã có khoản thanh toán ${appt.formattedPaidAmount}. Sau khi hủy, vui lòng liên hệ quầy PetCare để được hỗ trợ hoàn tiền.
                                        </p>
                                    </c:if>
                                    <button type="submit" class="pc-btn pc-btn-danger pc-btn-sm">Xác nhận hủy lịch</button>
                                </form>
                            </details>
                        </c:if>
                    </article>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
