<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lịch hẹn của tôi | PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>
    <c:set var="staffPage" value="appointments"/>
    <%@ include file="/WEB-INF/includes/staffHeader.jspf" %>
    <main id="staff-main">
        <div class="page-heading"><div><p class="eyebrow">CHĂM SÓC BẰNG CẢ SỰ TẬN TÂM</p><h1>Lịch hẹn của tôi</h1>
        <p class="sub">Theo dõi và thực hiện các lượt dịch vụ được giao trong 30 ngày tới.</p></div><a class="btn btn-primary" href="${pageContext.request.contextPath}/staff/dat-lich-tai-quay"><svg aria-hidden="true"><use href="#staff-plus"/></svg>Đặt lịch tại quầy</a></div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="status">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <c:if test="${empty errorMessage}">
        <c:set var="waitingCount" value="0"/><c:set var="progressCount" value="0"/>
        <c:forEach var="line" items="${appointments}"><c:if test="${line.appointmentStatus == 'PENDING' || line.appointmentStatus == 'CONFIRMED'}"><c:set var="waitingCount" value="${waitingCount + 1}"/></c:if><c:if test="${line.appointmentStatus == 'CHECKED_IN' || line.appointmentStatus == 'IN_PROGRESS'}"><c:set var="progressCount" value="${progressCount + 1}"/></c:if></c:forEach>
        <div class="overview" aria-label="Tổng quan lượt dịch vụ trong 30 ngày"><div class="overview-item"><span class="overview-icon"><svg aria-hidden="true"><use href="#staff-calendar"/></svg></span><div><strong>${fn:length(appointments)}</strong><small>Lượt dịch vụ được giao</small></div></div><div class="overview-item"><span class="overview-icon"><svg aria-hidden="true"><use href="#staff-clock"/></svg></span><div><strong>${waitingCount}</strong><small>Lượt đang chờ đón</small></div></div><div class="overview-item"><span class="overview-icon"><svg aria-hidden="true"><use href="#staff-paw"/></svg></span><div><strong>${progressCount}</strong><small>Đã đón / đang chăm sóc</small></div></div></div>
        </c:if>
        <div class="workspace-grid"><section aria-labelledby="assigned-title">
        <div class="section-heading"><h2 id="assigned-title">Danh sách được phân công</h2><span class="section-count">30 ngày tới</span></div>
        <c:if test="${empty appointments && empty errorMessage}"><div class="empty-note"><strong>Lịch của bạn đang trống</strong>Bạn chưa có lịch hẹn nào được giao trong 30 ngày tới.</div></c:if>

        <p class="notice">Trạng thái áp dụng cho cả lịch hẹn. Lịch có nhiều nhân viên cùng thực hiện cần quản trị viên cập nhật.</p>
        <c:forEach var="line" items="${appointments}">
            <div class="card appointment-card">
                <div class="appointment-time"><strong>${fn:substringBefore(line.formattedStart, ' ')}</strong><small>đến ${line.formattedEndTime}</small><span>${fn:substringAfter(line.formattedStart, ' ')}</span></div>
                <div class="info">
                    <div class="appointment-heading"><span class="appointment-id">LỊCH HẸN #${line.appointmentId}</span>
                    <c:choose>
                        <c:when test="${line.appointmentStatus == 'PENDING'}">
                            <span class="badge badge-pending">${line.appointmentStatusLabel}</span>
                        </c:when>
                        <c:when test="${line.appointmentStatus == 'CONFIRMED'}">
                            <span class="badge badge-confirmed">${line.appointmentStatusLabel}</span>
                        </c:when>
                        <c:when test="${line.appointmentStatus == 'CHECKED_IN' || line.appointmentStatus == 'IN_PROGRESS'}">
                            <span class="badge badge-progress">${line.appointmentStatusLabel}</span>
                        </c:when>
                        <c:when test="${line.appointmentStatus == 'COMPLETED'}">
                            <span class="badge badge-done">${line.appointmentStatusLabel}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-other">${line.appointmentStatusLabel}</span>
                        </c:otherwise>
                    </c:choose>
                    </div>
                    <h3>${fn:escapeXml(line.petName)}</h3><p class="service-name">${fn:escapeXml(line.serviceName)}</p>
                    <div class="appointment-footer"><div class="customer-info"><strong>${fn:escapeXml(line.customerName)}</strong><span>${fn:escapeXml(line.customerPhone)}</span></div>
                <c:if test="${line.appointmentStatus == 'CONFIRMED' || line.appointmentStatus == 'CHECKED_IN' || line.appointmentStatus == 'IN_PROGRESS'}">
                    <form method="post" action="${pageContext.request.contextPath}/staff/lich-hen">
                        <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.staffCsrfToken)}">
                        <input type="hidden" name="appointmentId" value="${line.appointmentId}" />
                        <c:choose>
                            <c:when test="${line.appointmentStatus == 'CONFIRMED'}">
                                <input type="hidden" name="newStatus" value="CHECKED_IN" />
                                <button type="submit" class="btn btn-primary">Check-in</button>
                            </c:when>
                            <c:when test="${line.appointmentStatus == 'CHECKED_IN'}">
                                <input type="hidden" name="newStatus" value="IN_PROGRESS" />
                                <button type="submit" class="btn btn-primary">Bắt đầu thực hiện</button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="newStatus" value="COMPLETED" />
                                <button type="submit" class="btn btn-primary">Hoàn thành</button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
        </section><aside class="workspace-rail" aria-label="Hướng dẫn công việc">
        <div class="rail-card"><h2>Một lượt chăm sóc</h2><ol class="workflow"><li><strong>Đón bé &amp; check-in</strong>Xác nhận khách và thú cưng khi đến.</li><li><strong>Bắt đầu thực hiện</strong>Cập nhật khi bạn bắt đầu dịch vụ.</li><li><strong>Hoàn thành</strong>Kiểm tra và bàn giao bé cho khách.</li></ol></div>
        <div class="rail-card accent"><svg aria-hidden="true"><use href="#staff-clock"/></svg><h2>Chủ động lịch làm việc</h2><p>Xem các ca được phân công để chuẩn bị cho ngày chăm sóc tiếp theo.</p><a class="btn btn-ghost" href="${pageContext.request.contextPath}/staff/lich-lam-viec">Xem ca làm việc <svg aria-hidden="true"><use href="#staff-arrow"/></svg></a></div>
        </aside></div>
        <footer class="page-footer"><span>PetCare · Không gian nhân viên</span><span>Mỗi bé cưng đều xứng đáng được yêu thương.</span></footer>
    </main>
</body>
</html>
