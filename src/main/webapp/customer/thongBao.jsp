<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thông báo của tôi | PetCare</title>
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
                <h1>Thông báo của tôi</h1>
                <p class="pc-page-sub">Lưu trữ tất cả thông báo xác nhận đặt lịch, nhắc lịch, hủy lịch và thanh toán dành cho bạn.</p>
            </div>
            <a href="${pageContext.request.contextPath}/customer/lich-hen" class="pc-btn pc-btn-outline">Xem lịch hẹn</a>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>

        <div class="pc-filter-bar">
            <a href="${pageContext.request.contextPath}/customer/thong-bao?type=ALL"
               class="pc-chip ${typeFilter == 'ALL' ? 'active' : ''}">Tất cả</a>
            <a href="${pageContext.request.contextPath}/customer/thong-bao?type=CONFIRMATION"
               class="pc-chip ${typeFilter == 'CONFIRMATION' ? 'active' : ''}">Xác nhận lịch</a>
            <a href="${pageContext.request.contextPath}/customer/thong-bao?type=REMINDER"
               class="pc-chip ${typeFilter == 'REMINDER' ? 'active' : ''}">Nhắc lịch</a>
            <a href="${pageContext.request.contextPath}/customer/thong-bao?type=CANCELLATION"
               class="pc-chip ${typeFilter == 'CANCELLATION' ? 'active' : ''}">Hủy lịch</a>
            <a href="${pageContext.request.contextPath}/customer/thong-bao?type=OTHER"
               class="pc-chip ${typeFilter == 'OTHER' ? 'active' : ''}">Hệ thống / Thanh toán</a>
        </div>

        <section class="pc-card">
            <div class="pc-card-head">
                <h2>Danh sách thông báo (${fn:length(notifications)})</h2>
            </div>

            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="pc-empty">
                        <h3>Chưa có thông báo nào</h3>
                        <p>Các thông báo về lịch hẹn, thanh toán và đánh giá sẽ xuất hiện tại đây.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="n" items="${notifications}">
                        <article class="pc-item-card">
                            <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;margin-bottom:6px;">
                                <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
                                    <span class="pc-badge ${n.type == 'CANCELLATION' ? 'pc-badge-cancelled' : (n.type == 'CONFIRMATION' ? 'pc-badge-completed' : 'pc-badge-confirmed')}">
                                        ${n.typeLabel}
                                    </span>
                                    <span class="pc-badge pc-badge-neutral">${fn:escapeXml(n.channel)}</span>
                                    <c:if test="${not empty n.appointmentId}">
                                        <a href="${pageContext.request.contextPath}/customer/lich-hen" style="font-size:13px;font-weight:700;">
                                            Lịch hẹn #${n.appointmentId}
                                        </a>
                                    </c:if>
                                </div>
                                <span style="font-size:12.5px;color:var(--pc-muted);">${n.formattedCreatedAt}</span>
                            </div>
                            <p style="margin:0;font-size:14px;">${fn:escapeXml(n.content)}</p>
                        </article>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
