<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/><c:set var="adminPage" value="bao-cao"/><c:set var="adminTitle" value="Báo cáo hệ thống"/>
<!doctype html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Báo cáo hệ thống | PetCare</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css"></head><body>
<%@ include file="shell-start.jspf" %>
<main id="main-content">
    <div class="page-heading"><div><p class="eyebrow">TỔNG QUAN HOẠT ĐỘNG</p><h1>Báo cáo hệ thống</h1><p class="sub">Theo dõi lịch hẹn và dòng tiền đã xác nhận theo kỳ.</p></div><c:if test="${not empty report}"><c:url var="csvUrl" value="/admin/bao-cao"><c:param name="from" value="${fromDate}"/><c:param name="to" value="${toDate}"/><c:param name="format" value="csv"/></c:url><a class="button" href="${fn:escapeXml(csvUrl)}">Xuất CSV</a></c:if></div>
    <c:if test="${not empty errorMessage}"><p class="alert error" role="alert"><c:out value="${errorMessage}"/></p></c:if>
    <section class="card"><div class="card-body"><%@ include file="operations-filters.jspf" %><p class="form-hint">Số lịch/khách/thú cưng mới theo ngày tạo. Thu và hoàn tiền theo ngày xác nhận thanh toán, gồm trọn ngày cuối kỳ. Tối đa 366 ngày.</p></div></section>
    <c:if test="${not empty report}">
        <div class="report-metrics">
            <div class="overview-card"><div><small>Tiền đã thu</small><strong><fmt:formatNumber value="${report.charges}" maxFractionDigits="2"/> <small>đ</small></strong></div></div>
            <div class="overview-card"><div><small>Tiền đã hoàn</small><strong><fmt:formatNumber value="${report.refunds}" maxFractionDigits="2"/> <small>đ</small></strong></div></div>
            <div class="overview-card secondary-card"><div><small>Thực thu = thu − hoàn</small><strong><fmt:formatNumber value="${report.net}" maxFractionDigits="2"/> đ</strong></div></div>
            <div class="overview-card"><div><small>Lịch tạo trong kỳ</small><strong>${report.appointments}</strong></div></div>
        </div>
        <p class="report-caption">Trong số lịch tạo kỳ này: <strong>${report.completed}</strong> lịch hoàn thành · <strong>${report.customers}</strong> khách hàng mới · <strong>${report.pets}</strong> hồ sơ thú cưng mới. Giao dịch chờ xác nhận/thất bại không tính vào tiền đã thu.</p>
        <div class="report-columns">
            <section class="card"><div class="card-heading"><h2>Thực thu theo ngày</h2><span class="section-description">Tối đa 14 ngày cuối kỳ</span></div><div class="card-body net-chart">
                <c:forEach var="day" items="${report.days}" begin="${fn:length(report.days) > 14 ? fn:length(report.days) - 14 : 0}"><div class="net-chart-row"><span><c:out value="${day.day}"/></span><div class="net-chart-track"><div class="net-chart-bar ${day.net.signum() < 0 ? 'negative' : ''}" style="width:${day.barPercent}%"></div></div><strong><fmt:formatNumber value="${day.net}" maxFractionDigits="2"/> đ</strong></div></c:forEach>
            </div></section>
            <section class="card"><div class="card-heading"><h2>Trạng thái lịch tạo trong kỳ</h2></div><table><thead><tr><th scope="col">Trạng thái</th><th scope="col">Số lịch</th></tr></thead><tbody><c:forEach var="state" items="${statusLabels}"><tr><td><c:out value="${state.value}"/></td><td><c:out value="${report.statuses[state.key]}" default="0"/></td></tr></c:forEach></tbody></table></section>
        </div>
        <section class="card"><div class="card-heading"><h2>Dịch vụ được đặt nhiều</h2><span class="section-description">Không gồm lịch nháp/hủy/vắng mặt</span></div><table><thead><tr><th scope="col">Dịch vụ</th><th scope="col">Số lượt dịch vụ</th></tr></thead><tbody><c:forEach var="service" items="${report.services}"><tr><td><c:out value="${service.name}"/></td><td>${service.uses}</td></tr></c:forEach><c:if test="${empty report.services}"><tr><td colspan="2" class="empty-state">Chưa có lượt dịch vụ trong kỳ.</td></tr></c:if></tbody></table></section>
        <section class="card"><div class="card-heading"><h2>Chi tiết theo ngày</h2><span class="section-description">Dữ liệu dùng cho CSV</span></div><div class="table-scroll report-table" tabindex="0" role="region" aria-label="Báo cáo theo ngày"><table><thead><tr><th scope="col">Ngày</th><th scope="col">Lịch tạo</th><th scope="col">Tiền thu</th><th scope="col">Hoàn tiền</th><th scope="col">Thực thu</th></tr></thead><tbody><c:forEach var="day" items="${report.days}"><tr><td><c:out value="${day.day}"/></td><td>${day.appointments}</td><td class="numeric-cell"><fmt:formatNumber value="${day.charges}" maxFractionDigits="2"/> đ</td><td class="numeric-cell"><fmt:formatNumber value="${day.refunds}" maxFractionDigits="2"/> đ</td><td class="numeric-cell"><fmt:formatNumber value="${day.net}" maxFractionDigits="2"/> đ</td></tr></c:forEach></tbody></table></div></section>
    </c:if>
</main><%@ include file="shell-end.jspf" %></body></html>
