<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý tài khoản | PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/workspace.css?v=20261128">
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
<c:set var="adminPage" value="tai-khoan"/>
<c:set var="adminTitle" value="Tài khoản"/>
<c:set var="activeAccounts" value="0"/>
<c:forEach var="account" items="${accounts}"><c:if test="${account.active}"><c:set var="activeAccounts" value="${activeAccounts + 1}"/></c:if></c:forEach>
<%@ include file="/WEB-INF/views/admin/shell-start.jspf" %>
    <main id="main-content">
        <div class="page-heading"><div><p class="eyebrow">QUẢN LÝ HỆ THỐNG</p><h1>Tài khoản</h1><p class="sub">Quản lý thành viên, vai trò và quyền truy cập PetCare.</p></div><a class="button" href="#editor"><span aria-hidden="true">＋</span> Thêm tài khoản</a></div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="status">${fn:escapeXml(successMessage)}</div>
        </c:if>

                <div class="overview">
            <div class="overview-card"><div><small>Tổng số tài khoản</small><strong>${fn:length(accounts)}</strong></div><span class="overview-icon"><svg aria-hidden="true"><use href="#i-users"/></svg></span></div>
            <div class="overview-card"><div><small>Đang hoạt động</small><strong>${activeAccounts}</strong></div><span class="overview-icon"><svg aria-hidden="true"><use href="#i-spark"/></svg></span></div>
        </div>
        <details class="card create-account" id="editor" ${not empty errorMessage ? 'open' : ''}>
            <summary class="create-summary"><span><strong>Tạo tài khoản mới</strong><small>Thêm thành viên và thiết lập vai trò truy cập</small></span><span aria-hidden="true">＋</span></summary>
            <div class="account-create">
            <form method="post" action="${pageContext.request.contextPath}/admin/tai-khoan">
                <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}" />
                <input type="hidden" name="action" value="create" />
                <div class="form-grid">
                    <div>
                        <label for="account-fullName-${acc.userId}">Họ tên</label><input id="account-fullName-${acc.userId}" type="text" name="fullName" required maxlength="100" />
                    </div>
                    <div>
                        <label for="account-email-${acc.userId}">Email</label><input id="account-email-${acc.userId}" type="email" name="email" required maxlength="100" />
                    </div>
                    <div>
                        <label for="account-phone-${acc.userId}">Số điện thoại</label><input id="account-phone-${acc.userId}" type="text" name="phone" maxlength="20" />
                    </div>
                    <div>
                        <label for="account-password-${acc.userId}">Mật khẩu (tối thiểu 8 ký tự)</label><input id="account-password-${acc.userId}" type="password" name="password" required minlength="8" />
                    </div>
                    <div>
                        <label for="account-role-${acc.userId}">Vai trò</label><select id="account-role-${acc.userId}" name="role">
                            <option value="CUSTOMER">Khách hàng</option>
                            <option value="STAFF">Nhân viên</option>
                            <option value="ADMIN">Quản trị viên</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
            </form>
        </div></details>

        <div class="card account-list"><div class="card-heading"><h2>Danh sách tài khoản <span class="count-pill">${fn:length(accounts)}</span></h2><span class="section-description">Thành viên PetCare</span></div><%@ include file="/WEB-INF/views/admin/table-tools.jspf" %><div class="table-scroll" tabindex="0" role="region" aria-label="Danh sách tài khoản">
            <table id="admin-table" class="account-table">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Họ tên</th>
                        <th scope="col">Email / SĐT</th>
                        <th scope="col">Vai trò</th>
                        <th scope="col">Trạng thái</th>
                        <th scope="col">Ngày tạo</th>
                        <th scope="col">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="acc" items="${accounts}">
                    <tr data-record data-filter="${acc.active ? 'Đang hoạt động' : 'Đã khóa'}">
                        <td>#${acc.userId}</td>
                        <td>${fn:escapeXml(acc.fullName)}</td>
                        <td>${fn:escapeXml(acc.email)}<br/><span class="muted">${fn:escapeXml(acc.phone)}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${fn:toUpperCase(acc.role) == 'ADMIN'}"><span class="badge badge-admin">Quản trị</span></c:when>
                                <c:when test="${acc.role == 'STAFF'}"><span class="badge badge-staff">Nhân viên</span></c:when>
                                <c:otherwise><span class="badge badge-customer">Khách hàng</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${acc.active}"><span class="badge badge-active">Hoạt động</span></c:if>
                            <c:if test="${!acc.active}"><span class="badge badge-inactive">Đã khóa</span></c:if>
                        </td>
                        <td><c:out value="${acc.createdAt.toLocalDate()}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${fn:toUpperCase(acc.role) == 'ADMIN'}">
                                    <span class="badge badge-protected" title="Không thể khóa, hạ quyền hoặc đặt lại mật khẩu ADMIN tại đây">Được bảo vệ</span>
                                    <c:if test="${acc.userId == sessionScope.currentUser.userId}"><a class="button secondary" href="${pageContext.request.contextPath}/profile">Hồ sơ của tôi</a></c:if>
                                </c:when>
                                <c:otherwise>
                            <div class="row-actions">
                                <form method="post" action="${pageContext.request.contextPath}/admin/tai-khoan" class="inline-form">
                                    <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}" />
                                    <input type="hidden" name="action" value="toggleActive" />
                                    <input type="hidden" name="userId" value="${acc.userId}" />
                                    <input type="hidden" name="active" value="${acc.active ? 'false' : 'true'}" />
                                    <button type="submit" class="btn btn-small ${acc.active ? 'btn-danger' : 'btn-warn'}">
                                        ${acc.active ? 'Khóa' : 'Mở khóa'}
                                    </button>
                                </form>
                                <details>
                                    <summary>Sửa</summary>
                                    <div class="edit-panel">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/tai-khoan">
                                            <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}" />
                                            <input type="hidden" name="action" value="update" />
                                            <input type="hidden" name="userId" value="${acc.userId}" />
                                            <label for="account-fullName-${acc.userId}">Họ tên</label><input id="account-fullName-${acc.userId}" type="text" name="fullName" value="${fn:escapeXml(acc.fullName)}" required />
                                            <label for="account-email-${acc.userId}">Email</label><input id="account-email-${acc.userId}" type="email" name="email" value="${fn:escapeXml(acc.email)}" required />
                                            <label for="account-phone-${acc.userId}">Số điện thoại</label><input id="account-phone-${acc.userId}" type="text" name="phone" value="${fn:escapeXml(acc.phone)}" />
                                            <label for="account-role-${acc.userId}">Vai trò</label><select id="account-role-${acc.userId}" name="role">
                                                <option value="CUSTOMER" ${acc.role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng</option>
                                                <option value="STAFF" ${acc.role == 'STAFF' ? 'selected' : ''}>Nhân viên</option>
                                                <option value="ADMIN" ${acc.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                                            </select>
                                            <button type="submit" class="btn btn-small btn-primary" style="margin-top:8px;">Lưu</button>
                                        </form>
                                    </div>
                                </details>
                                <details>
                                    <summary>Đổi mật khẩu</summary>
                                    <div class="edit-panel">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/tai-khoan">
                                            <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}" />
                                            <input type="hidden" name="action" value="resetPassword" />
                                            <input type="hidden" name="userId" value="${acc.userId}" />
                                            <label for="account-newPassword-${acc.userId}">Mật khẩu mới (tối thiểu 8 ký tự)</label><input id="account-newPassword-${acc.userId}" type="password" name="newPassword" minlength="8" required />
                                            <button type="submit" class="btn btn-small btn-ghost" style="margin-top:8px;">Đặt lại</button>
                                        </form>
                                    </div>
                                </details>
                            </div></c:otherwise></c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty accounts}">
                    <tr><td colspan="7" class="empty-state"><strong>Chưa có tài khoản</strong><p>Thêm tài khoản đầu tiên bằng biểu mẫu phía trên.</p></td></tr>
                </c:if>
                </tbody>
            </table></div><div class="no-results" hidden>Không tìm thấy tài khoản phù hợp.</div><div class="table-footer"><span class="visible-count">${fn:length(accounts)} bản ghi</span><span>Lọc theo trạng thái hoặc tìm tên, email</span></div>
        </div>
    </main>
<%@ include file="/WEB-INF/views/admin/shell-end.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
