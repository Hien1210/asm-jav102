<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đánh giá dịch vụ | PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer.css?v=2" />
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
    <%@ include file="/WEB-INF/includes/customerNav.jspf" %>

    <main class="pc-main">
        <div class="pc-page-head">
            <div>
                <h1>Đánh giá dịch vụ</h1>
                <p class="pc-page-sub">Chia sẻ trải nghiệm sau các lịch hẹn đã hoàn thành để PetCare phục vụ bé cưng ngày càng tốt hơn.</p>
            </div>
            <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-outline">Xem lịch hẹn</a>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="pc-alert pc-alert-success">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <div class="pc-layout-split">
            <!-- Form đánh giá lịch hẹn đã hoàn thành -->
            <section class="pc-card">
                <div class="pc-card-head">
                    <h2>Gửi đánh giá mới</h2>
                </div>

                <c:choose>
                    <c:when test="${empty reviewableAppointments}">
                        <div class="pc-empty" style="padding:24px 12px;">
                            <h3>Chưa có lịch hẹn chờ đánh giá</h3>
                            <p>Chỉ các lịch hẹn đã ở trạng thái <strong>Hoàn thành (COMPLETED)</strong> và chưa đánh giá mới có thể gửi nhận xét.</p>
                            <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-ghost pc-btn-sm">Xem lịch hẹn của tôi</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="${pageContext.request.contextPath}/customer/danh-gia">
                            <input type="hidden" name="action" value="submit" />

                            <div class="pc-form-group">
                                <label for="reviewAppt">Chọn lịch hẹn đã hoàn thành <span class="pc-req">*</span></label>
                                <select id="reviewAppt" class="pc-select" name="appointmentId" required>
                                    <c:forEach var="appt" items="${reviewableAppointments}">
                                        <option value="${appt.appointmentId}"
                                                ${selectedAppointmentId == appt.appointmentId.toString() ? 'selected' : ''}>
                                            #${appt.appointmentId} — Bé ${fn:escapeXml(appt.petName)} (${appt.typeLabel} — ${appt.formattedTotalAmount})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="pc-form-group">
                                <label>Mức độ hài lòng (1 đến 5 sao) <span class="pc-req">*</span></label>
                                <div class="pc-star-radio" role="radiogroup" aria-label="Chọn số sao">
                                    <input type="radio" id="star5" name="rating" value="5" checked />
                                    <label for="star5" title="5 sao - Tuyệt vời">&#9733;</label>
                                    <input type="radio" id="star4" name="rating" value="4" />
                                    <label for="star4" title="4 sao - Hài lòng">&#9733;</label>
                                    <input type="radio" id="star3" name="rating" value="3" />
                                    <label for="star3" title="3 sao - Bình thường">&#9733;</label>
                                    <input type="radio" id="star2" name="rating" value="2" />
                                    <label for="star2" title="2 sao - Chưa hài lòng">&#9733;</label>
                                    <input type="radio" id="star1" name="rating" value="1" />
                                    <label for="star1" title="1 sao - Rất tệ">&#9733;</label>
                                </div>
                            </div>

                            <div class="pc-form-group">
                                <label for="reviewComment">Nhận xét của bạn (tối đa 1000 ký tự)</label>
                                <textarea id="reviewComment" class="pc-textarea" name="comment" maxlength="1000"
                                          placeholder="Nhân viên có nhẹ nhàng không? Lông bé sau khi tắm sấy thế nào?"></textarea>
                            </div>

                            <button type="submit" class="pc-btn pc-btn-primary" style="width:100%;">Gửi đánh giá</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Lịch sử đánh giá đã gửi -->
            <section class="pc-card">
                <div class="pc-card-head">
                    <h2>Đánh giá đã gửi (${fn:length(myReviews)})</h2>
                </div>

                <c:choose>
                    <c:when test="${empty myReviews}">
                        <div class="pc-empty">
                            <h3>Bạn chưa gửi đánh giá nào</h3>
                            <p>Các đánh giá sau khi hoàn thành dịch vụ sẽ hiển thị tại đây.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rev" items="${myReviews}">
                            <article class="pc-item-card">
                                <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;">
                                    <div>
                                        <strong>Lịch hẹn #${rev.appointmentId}</strong>
                                        &bull; Bé <strong>${fn:escapeXml(rev.petName)}</strong> (${fn:escapeXml(rev.petSpecies)})
                                        &bull; <span class="pc-badge pc-badge-primary">${fn:escapeXml(rev.summaryLabel)}</span>
                                    </div>
                                    <span style="font-size:12.5px;color:var(--pc-muted);">${rev.formattedCreatedAt}</span>
                                </div>

                                <div style="margin:8px 0;">
                                    <span class="pc-stars">
                                        <c:forEach begin="1" end="${rev.rating}">&#9733;</c:forEach>
                                    </span>
                                    <strong style="margin-left:6px;font-size:14px;">${rev.rating}/5 sao</strong>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty rev.comment}">
                                        <p style="margin:0;font-size:14px;color:var(--pc-text);">${fn:escapeXml(rev.comment)}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="margin:0;font-size:13.5px;color:var(--pc-muted);font-style:italic;">Không có nhận xét kèm theo.</p>
                                    </c:otherwise>
                                </c:choose>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
