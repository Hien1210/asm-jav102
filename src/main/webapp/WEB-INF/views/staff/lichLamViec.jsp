<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lịch làm việc | PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>
    <c:set var="staffPage" value="shifts"/>
    <%@ include file="/WEB-INF/includes/staffHeader.jspf" %>
    <main id="staff-main">
        <div class="page-heading"><div><p class="eyebrow">SẴN SÀNG CHO MỘT NGÀY TỐT LÀNH</p><h1>Lịch làm việc</h1>
        <p class="sub">Các ca được phân công cho bạn trong 14 ngày tới.</p></div><a class="btn btn-ghost" href="${pageContext.request.contextPath}/staff/lich-hen">Xem lịch hẹn <svg aria-hidden="true"><use href="#staff-arrow"/></svg></a></div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert">${fn:escapeXml(errorMessage)}</div>
        </c:if>

        <div class="workspace-grid"><section aria-labelledby="shifts-title"><div class="section-heading"><h2 id="shifts-title">Ca làm việc của bạn</h2><c:if test="${empty errorMessage}"><span class="section-count">${fn:length(shifts)} ca / 14 ngày</span></c:if></div>
        <c:choose>
            <c:when test="${not empty errorMessage}"></c:when><c:when test="${empty shifts}">
                <div class="empty-note"><strong>Chưa có ca được phân công</strong>Bạn chưa được xếp ca làm việc nào trong 14 ngày tới.</div>
            </c:when>
            <c:otherwise>
                <div class="table-scroll" tabindex="0" role="region" aria-label="Các ca làm việc"><table>
                    <thead>
                        <tr>
                            <th scope="col">Ngày</th>
                            <th scope="col">Giờ làm việc</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="shift" items="${shifts}">
                            <tr>
                                <td class="shift-date">${shift.formattedWorkDate}</td>
                                <td><span class="shift-range"><svg aria-hidden="true"><use href="#staff-clock"/></svg>${shift.formattedRange}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table></div>
            </c:otherwise>
        </c:choose>
        </section><aside class="workspace-rail" aria-label="Thông tin ca làm việc"><div class="rail-card accent"><svg aria-hidden="true"><use href="#staff-calendar"/></svg><h2>Lịch trình rõ ràng</h2><p>Ca làm việc hiển thị theo ngày. Đối chiếu với lịch hẹn để chuẩn bị dụng cụ và khu vực chăm sóc trước khi đón bé.</p></div><div class="rail-card"><h2>Cần điều chỉnh ca?</h2><p>Liên hệ quản trị viên để được hỗ trợ thay đổi phân công. Bạn có thể xem thông tin cá nhân tại đây.</p><a class="btn btn-ghost" href="${pageContext.request.contextPath}/profile">Hồ sơ của tôi <svg aria-hidden="true"><use href="#staff-arrow"/></svg></a></div></aside></div>
        <footer class="page-footer"><span>PetCare · Không gian nhân viên</span><span>Chuẩn bị chu đáo, chăm sóc tận tâm.</span></footer>
    </main>
</body>
</html>
