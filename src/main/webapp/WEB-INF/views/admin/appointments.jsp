<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="adminPage" value="lich-hen"/><c:set var="adminTitle" value="Lịch hẹn"/>
<!doctype html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Quản lý lịch hẹn | PetCare</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/workspace.css?v=20261128-popup1">
</head><body>
<%@ include file="shell-start.jspf" %>
<main id="main-content">
    <div class="page-heading"><div><p class="eyebrow">VẬN HÀNH HỆ THỐNG</p><h1>Lịch hẹn</h1><p class="sub">Theo dõi lịch chăm sóc và lưu trú trên toàn hệ thống.</p></div><a class="button" href="${pageContext.request.contextPath}/staff/dat-lich-tai-quay">＋ Tạo lịch tại quầy</a></div>
    <c:if test="${not empty errorMessage}"><p class="alert error" role="alert"><c:out value="${errorMessage}"/></p></c:if>
    <c:if test="${not empty successMessage}"><p class="alert success" role="status"><c:out value="${successMessage}"/></p></c:if>
    <section class="card"><div class="card-body"><%@ include file="operations-filters.jspf" %><p class="form-hint">Lọc theo ngày bắt đầu dịch vụ / nhận phòng. Lịch nháp chưa có giờ dùng ngày tạo. Tối đa 366 ngày.</p></div></section>
    <section class="card" aria-labelledby="appointment-list-title">
        <div class="card-heading"><h2 id="appointment-list-title">Danh sách lịch hẹn <span class="count-pill"><c:out value="${pageData.total}" default="0"/></span></h2><span class="section-description">25 lịch mỗi trang</span></div>
        <div class="table-scroll" tabindex="0" role="region" aria-label="Lịch hẹn toàn hệ thống"><table class="appointments-table"><thead><tr><th scope="col">Mã lịch</th><th scope="col">Khách hàng</th><th scope="col">Thú cưng</th><th scope="col">Ngày hẹn</th><th scope="col">Loại</th><th scope="col">Tổng tiền</th><th scope="col">Trạng thái</th><th scope="col">Chi tiết</th></tr></thead><tbody>
        <c:forEach var="row" items="${pageData.rows}">
            <c:url var="detailUrl" value="/admin/lich-hen"><c:param name="from" value="${fromDate}"/><c:param name="to" value="${toDate}"/><c:param name="status" value="${statusFilter}"/><c:param name="type" value="${typeFilter}"/><c:param name="q" value="${query}"/><c:param name="page" value="${pageData.page}"/><c:param name="id" value="${row.appointment_id}"/></c:url>
            <tr data-appointment-id="${row.appointment_id}"><td>#${row.appointment_id}</td><td><c:out value="${row.customer_name}"/><small class="cell-sub"><c:out value="${row.phone}"/></small></td><td><c:out value="${row.pet_name}"/><small class="cell-sub"><c:out value="${row.species}"/></small></td><td class="numeric-cell"><fmt:formatDate value="${row.starts}" pattern="HH:mm dd/MM/yyyy"/></td><td>${row.appointment_type == 'BOARDING' ? 'Lưu trú' : 'Dịch vụ'}</td><td class="numeric-cell"><fmt:formatNumber value="${row.total_amount}" maxFractionDigits="2"/> đ</td><td><span class="badge ${row.status == 'COMPLETED' ? 'badge-active' : row.status == 'CANCELLED' || row.status == 'NO_SHOW' ? 'badge-inactive' : ''}"><c:out value="${statusLabels[row.status]}"/></span></td><td><a class="button secondary" href="${fn:escapeXml(detailUrl)}#appointment-detail">Xem #${row.appointment_id}</a></td></tr>
        </c:forEach>
        <c:if test="${empty pageData.rows && empty errorMessage}"><tr><td colspan="8" class="empty-state"><strong>Chưa có lịch phù hợp</strong><p>Thử thay đổi khoảng ngày, trạng thái hoặc từ khóa.</p></td></tr></c:if>
        </tbody></table></div>
        <c:if test="${not empty pageData}"><div class="table-footer"><span>Trang ${pageData.page} / ${pageData.pages} · ${pageData.total} lịch</span><div class="pagination">
            <c:if test="${pageData.page > 1}"><c:url var="prevUrl" value="/admin/lich-hen"><c:param name="from" value="${fromDate}"/><c:param name="to" value="${toDate}"/><c:param name="status" value="${statusFilter}"/><c:param name="type" value="${typeFilter}"/><c:param name="q" value="${query}"/><c:param name="page" value="${pageData.page - 1}"/></c:url><a href="${fn:escapeXml(prevUrl)}">← Trang trước</a></c:if>
            <c:if test="${pageData.page < pageData.pages}"><c:url var="nextUrl" value="/admin/lich-hen"><c:param name="from" value="${fromDate}"/><c:param name="to" value="${toDate}"/><c:param name="status" value="${statusFilter}"/><c:param name="type" value="${typeFilter}"/><c:param name="q" value="${query}"/><c:param name="page" value="${pageData.page + 1}"/></c:url><a href="${fn:escapeXml(nextUrl)}">Trang sau →</a></c:if>
        </div></div></c:if>
    </section>
    <c:if test="${not empty detail}">
        <section class="card appointment-detail" id="appointment-detail" aria-labelledby="detail-title">
            <div class="card-heading"><h2 id="detail-title">Chi tiết lịch #${detail.appointment_id}</h2><span class="badge"><c:out value="${statusLabels[detail.status]}"/></span></div>
            <div class="card-body">
                <dl class="detail-grid"><div><dt>Khách hàng</dt><dd><c:out value="${detail.customer_name}"/></dd></div><div><dt>Liên hệ</dt><dd><c:out value="${detail.phone}"/> · <c:out value="${detail.email}"/></dd></div><div><dt>Thú cưng</dt><dd><c:out value="${detail.pet_name}"/> — <c:out value="${detail.species}"/></dd></div><div><dt>Tổng giá đặt lịch</dt><dd><fmt:formatNumber value="${detail.total_amount}" maxFractionDigits="2"/> đ</dd></div><div><dt>Bắt đầu</dt><dd><fmt:formatDate value="${detail.starts}" pattern="HH:mm dd/MM/yyyy"/></dd></div><div><dt>Kết thúc dự kiến</dt><dd><fmt:formatDate value="${detail.ends}" pattern="HH:mm dd/MM/yyyy"/></dd></div></dl>
                <c:if test="${not empty detail.cancel_reason}"><p class="alert error">Lý do hủy: <c:out value="${detail.cancel_reason}"/></p></c:if>
                <c:if test="${not empty nextStatuses}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/lich-hen" class="operations-filters status-form">
                        <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}"><input type="hidden" name="action" value="status"><input type="hidden" name="appointmentId" value="${detail.appointment_id}"><input type="hidden" name="expectedStatus" value="${detail.status}">
                        <div><label for="appointment-status">Trạng thái tiếp theo</label><select name="status" id="appointment-status" required><option value="">Chọn trạng thái</option><c:forEach var="state" items="${nextStatuses}"><option value="${state}"><c:out value="${statusLabels[state]}"/></option></c:forEach></select></div>
                        <div class="operations-search"><label for="cancel-reason">Lý do (bắt buộc khi hủy)</label><input id="cancel-reason" name="cancelReason" maxlength="255" placeholder="Nhập lý do nếu hủy lịch"></div><button type="submit">Cập nhật trạng thái</button>
                    </form>
                </c:if>
                <c:if test="${empty nextStatuses}"><p class="form-hint">Lịch ở trạng thái này không có bước chuyển tiếp trong trang quản trị.</p></c:if>
            </div>
            <c:if test="${not empty detail.services}"><div class="table-scroll"><table><thead><tr><th scope="col">Dịch vụ</th><th scope="col">Nhân viên</th><th scope="col">Thời gian</th><th scope="col">Giá đã đặt</th><th scope="col">Trạng thái</th></tr></thead><tbody><c:forEach var="line" items="${detail.services}"><tr><td><c:out value="${line.service_name}"/></td><td><c:out value="${line.staff_name}"/></td><td><fmt:formatDate value="${line.scheduled_start}" pattern="HH:mm dd/MM/yyyy"/> – <fmt:formatDate value="${line.scheduled_end}" pattern="HH:mm"/></td><td><fmt:formatNumber value="${line.price_at_booking}" maxFractionDigits="2"/> đ</td><td><c:out value="${statusLabels[line.line_status]}"/></td></tr></c:forEach></tbody></table></div></c:if>
            <c:if test="${not empty detail.boarding}"><div class="card-body"><h3>Lưu trú · <c:out value="${detail.boarding.room_code}"/></h3><p class="section-description">Nhận phòng: <fmt:formatDate value="${detail.boarding.check_in_date}" pattern="dd/MM/yyyy"/> · Trả phòng: <fmt:formatDate value="${detail.boarding.check_out_date}" pattern="dd/MM/yyyy"/> · <fmt:formatNumber value="${detail.boarding.daily_rate_at_booking}" maxFractionDigits="2"/> đ/ngày</p><p class="section-description">Nhận thực tế: <c:out value="${detail.boarding.actual_check_in}" default="Chưa nhận"/> · Trả thực tế: <c:out value="${detail.boarding.actual_check_out}" default="Chưa trả"/></p></div></c:if>
            <div class="card-heading"><h2>Giao dịch thanh toán</h2><span class="section-description">Giao dịch đã xác nhận / đang chờ</span></div>
            <div class="table-scroll"><table><thead><tr><th scope="col">Mã</th><th scope="col">Loại</th><th scope="col">Phương thức</th><th scope="col">Số tiền</th><th scope="col">Trạng thái</th><th scope="col">Xác nhận lúc</th></tr></thead><tbody><c:forEach var="payment" items="${detail.payments}"><tr><td>#${payment.payment_id}</td><td>${payment.payment_type == 'REFUND' ? 'Hoàn tiền' : 'Thu tiền'}</td><td>${payment.method == 'CASH' ? 'Tiền mặt' : 'Trực tuyến'}</td><td><fmt:formatNumber value="${payment.amount}" maxFractionDigits="2"/> đ</td><td>${payment.status == 'PAID' ? 'Đã xác nhận' : payment.status == 'PENDING' ? 'Chờ xác nhận' : 'Thất bại'}</td><td><fmt:formatDate value="${payment.paid_at}" pattern="HH:mm dd/MM/yyyy"/></td></tr></c:forEach><c:if test="${empty detail.payments}"><tr><td class="empty-state" colspan="6">Chưa có giao dịch.</td></tr></c:if></tbody></table></div>
        </section>
    </c:if>
</main><%@ include file="shell-end.jspf" %></body></html>
