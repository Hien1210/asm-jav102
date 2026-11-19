<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh toán lịch hẹn | PetCare</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; margin: 0; color: #1f2937; }
        .topbar { background: #0f766e; color: #fff; padding: 14px 24px; display: flex; align-items: center; justify-content: space-between; }
        .topbar .links { display: flex; align-items: center; gap: 16px; }
        .topbar a { color: #fff; font-weight: 700; text-decoration: none; font-size: 18px; }
        .topbar .links a.secondary { font-size: 14px; font-weight: 600; opacity: .9; }
        main { max-width: 720px; margin: 24px auto; padding: 0 16px 48px; }
        h1 { font-size: 22px; margin-bottom: 4px; }
        .sub { color: #6b7280; margin-bottom: 20px; }
        .alert { padding: 10px 14px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .card { background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; padding: 18px; margin-bottom: 20px; }
        .card h2 { margin: 0 0 8px; font-size: 16px; }
        .balance-row { display: flex; justify-content: space-between; font-size: 14px; color: #4b5563; margin: 4px 0; }
        .balance-row strong { color: #0f766e; }
        label { display: block; font-size: 12px; color: #4b5563; margin: 10px 0 4px; }
        input, select { width: 100%; padding: 9px 10px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; }
        .btn { display: inline-block; padding: 9px 16px; border-radius: 6px; border: none; font-size: 14px; cursor: pointer; font-weight: 600; margin-top: 14px; }
        .btn-primary { background: #0f766e; color: #fff; }
        .empty-note { color: #94a3b8; font-size: 13px; }
    </style>
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
    <div class="topbar">
        <a href="${pageContext.request.contextPath}/home">PetCare</a>
        <div class="links">
            <a class="secondary" href="${pageContext.request.contextPath}/customer/dat-lich">Đặt lịch</a>
            <span>Xin chào, ${fn:escapeXml(loggedInUser)}</span>
        </div>
    </div>
    <main>
        <h1>Thanh toán lịch hẹn</h1>
        <p class="sub">Chọn lịch hẹn còn phải thanh toán và ghi nhận thanh toán.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <c:if test="${empty appointments}">
            <div class="card">
                <p class="empty-note">Bạn không có lịch hẹn nào còn phải thanh toán.</p>
            </div>
        </c:if>

        <c:forEach var="appt" items="${appointments}">
            <div class="card">
                <h2>Lịch hẹn #${appt.appointmentId} — ${fn:escapeXml(appt.appointmentType)} (${fn:escapeXml(appt.status)})</h2>
                <p class="balance-row"><span>Tổng tiền</span>
                    <span><fmt:formatNumber value="${appt.totalAmount}" pattern="#,##0"/> đ</span></p>
                <p class="balance-row"><span>Còn phải thanh toán</span>
                    <strong><fmt:formatNumber value="${appt.remainingAmount}" pattern="#,##0"/> đ</strong></p>

                <form method="post" action="${pageContext.request.contextPath}/customer/thanh-toan">
                    <input type="hidden" name="appointmentId" value="${appt.appointmentId}" />

                    <label>Số tiền thanh toán</label>
                    <input type="number" name="amount" min="1" step="1"
                           max="${appt.remainingAmount}" value="${appt.remainingAmount}" required />

                    <label>Phương thức</label>
                    <select name="method" class="method-select" required>
                        <option value="CASH">Tiền mặt</option>
                        <option value="ONLINE">Chuyển khoản / Online</option>
                    </select>

                    <label>Mã giao dịch (bắt buộc nếu chọn Online)</label>
                    <input type="text" name="transactionRef" maxlength="100" placeholder="Chỉ cần khi chuyển khoản/online" />

                    <button type="submit" class="btn btn-primary">Xác nhận thanh toán</button>
                </form>
            </div>
        </c:forEach>
    </main>
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
