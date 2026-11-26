<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thu tiền mặt | PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>
    <c:set var="staffPage" value="cash"/>
    <%@ include file="/WEB-INF/includes/staffHeader.jspf" %>
    <main id="staff-main">
        <div class="page-heading"><h1>Thu tiền mặt</h1></div>
        <form method="get" action="${pageContext.request.contextPath}/staff/thu-tien">
            <label for="appointmentId">Mã lịch hẹn</label>
            <input type="number" min="1" max="2147483647" required id="appointmentId"
                   name="appointmentId" value="${appointmentId}">
            <button class="btn btn-primary" type="submit">Tra cứu</button>
        </form>
        <c:if test="${not empty error}">
            <p class="alert alert-error" role="alert"><c:out value="${error}"/></p>
        </c:if>
        <c:if test="${not empty cashReceipt}">
            <p role="status">Đã ghi nhận thu tiền cho giao dịch #${cashReceipt}.</p>
        </c:if>
        <c:if test="${not empty appointmentId and empty error}">
            <h2>Khoản chờ thu của lịch #${appointmentId}</h2>
            <c:if test="${empty pendingCash}">
                <p class="empty-note">Lịch này không có khoản tiền mặt đang chờ thu.</p>
            </c:if>
            <c:forEach items="${pendingCash}" var="payment">
                <form method="post" action="${pageContext.request.contextPath}/staff/thu-tien">
                    <input type="hidden" name="csrfToken" value="${sessionScope.staffCsrfToken}">
                    <input type="hidden" name="appointmentId" value="${appointmentId}">
                    <input type="hidden" name="paymentId" value="${payment.paymentId}">
                    <p>Giao dịch #${payment.paymentId} · <fmt:formatNumber value="${payment.amount}"/> đ</p>
                    <button class="btn btn-primary" type="submit">Xác nhận đã nhận tiền</button>
                </form>
            </c:forEach>
        </c:if>
    </main>
    <script src="${pageContext.request.contextPath}/assets/js/staff.js" defer></script>
</body>
</html>
