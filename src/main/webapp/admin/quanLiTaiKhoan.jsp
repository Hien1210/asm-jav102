<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý tài khoản | PetCare</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; margin: 0; color: #1f2937; }
        .topbar { background: #0f766e; color: #fff; padding: 14px 24px; display: flex; align-items: center; justify-content: space-between; }
        .topbar a { color: #fff; font-weight: 700; text-decoration: none; font-size: 18px; }
        main { max-width: 1080px; margin: 24px auto; padding: 0 16px 48px; }
        h1 { font-size: 22px; margin-bottom: 4px; }
        .sub { color: #6b7280; margin-bottom: 20px; }
        .alert { padding: 10px 14px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .card { background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; padding: 18px; margin-bottom: 20px; }
        .card h2 { margin: 0 0 12px; font-size: 16px; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 10px; }
        label { display: block; font-size: 12px; color: #4b5563; margin-bottom: 4px; }
        input, select { width: 100%; padding: 8px 10px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; }
        .btn { display: inline-block; padding: 8px 14px; border-radius: 6px; border: none; font-size: 13px; cursor: pointer; font-weight: 600; }
        .btn-primary { background: #0f766e; color: #fff; margin-top: 10px; }
        .btn-small { padding: 5px 10px; font-size: 12px; }
        .btn-warn { background: #f59e0b; color: #fff; }
        .btn-danger { background: #dc2626; color: #fff; }
        .btn-ghost { background: #e5e7eb; color: #374151; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #f1f5f9; text-align: left; font-size: 13px; vertical-align: top; }
        th { background: #f8fafc; color: #475569; font-weight: 600; }
        .badge { padding: 2px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
        .badge-admin { background: #ede9fe; color: #6d28d9; }
        .badge-staff { background: #dbeafe; color: #1d4ed8; }
        .badge-customer { background: #f1f5f9; color: #334155; }
        .badge-active { background: #dcfce7; color: #166534; }
        .badge-inactive { background: #fee2e2; color: #991b1b; }
        details > summary { cursor: pointer; color: #0f766e; font-size: 12px; font-weight: 600; list-style: none; }
        details[open] summary { margin-bottom: 8px; }
        .row-actions { display: flex; flex-wrap: wrap; gap: 6px; align-items: center; }
        .inline-form { display: inline; }
        .edit-panel { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; margin-top: 6px; }
    </style>
</head>
<body>
    <div class="topbar">
        <a href="${pageContext.request.contextPath}/home">PetCare</a>
        <span>Xin chào, ${loggedInUser}</span>
    </div>
    <main>
        <h1>Quản lý tài khoản</h1>
        <p class="sub">Tạo, chỉnh sửa vai trò, khóa/mở và đặt lại mật khẩu cho tài khoản người dùng.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>

        <div class="card">
            <h2>Tạo tài khoản mới</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/tai-khoan">
                <input type="hidden" name="action" value="create" />
                <div class="form-grid">
                    <div>
                        <label>Họ tên</label>
                        <input type="text" name="fullName" required maxlength="100" />
                    </div>
                    <div>
                        <label>Email</label>
                        <input type="email" name="email" required maxlength="100" />
                    </div>
                    <div>
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" maxlength="20" />
                    </div>
                    <div>
                        <label>Mật khẩu (tối thiểu 8 ký tự)</label>
                        <input type="password" name="password" required minlength="8" />
                    </div>
                    <div>
                        <label>Vai trò</label>
                        <select name="role">
                            <option value="CUSTOMER">Khách hàng</option>
                            <option value="STAFF">Nhân viên</option>
                            <option value="ADMIN">Quản trị viên</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
            </form>
        </div>

        <div class="card">
            <h2>Danh sách tài khoản (${accounts.size()})</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email / SĐT</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="acc" items="${accounts}">
                    <tr>
                        <td>${acc.userId}</td>
                        <td>${acc.fullName}</td>
                        <td>${acc.email}<br/><span style="color:#94a3b8">${acc.phone}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${acc.role == 'ADMIN'}"><span class="badge badge-admin">Quản trị</span></c:when>
                                <c:when test="${acc.role == 'STAFF'}"><span class="badge badge-staff">Nhân viên</span></c:when>
                                <c:otherwise><span class="badge badge-customer">Khách hàng</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${acc.active}"><span class="badge badge-active">Hoạt động</span></c:if>
                            <c:if test="${!acc.active}"><span class="badge badge-inactive">Đã khóa</span></c:if>
                        </td>
                        <td><fmt:formatDate value="${acc.createdAt}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <div class="row-actions">
                                <form method="post" action="${pageContext.request.contextPath}/admin/tai-khoan" class="inline-form">
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
                                            <input type="hidden" name="action" value="update" />
                                            <input type="hidden" name="userId" value="${acc.userId}" />
                                            <label>Họ tên</label>
                                            <input type="text" name="fullName" value="${acc.fullName}" required />
                                            <label>Email</label>
                                            <input type="email" name="email" value="${acc.email}" required />
                                            <label>Số điện thoại</label>
                                            <input type="text" name="phone" value="${acc.phone}" />
                                            <label>Vai trò</label>
                                            <select name="role">
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
                                            <input type="hidden" name="action" value="resetPassword" />
                                            <input type="hidden" name="userId" value="${acc.userId}" />
                                            <label>Mật khẩu mới (tối thiểu 8 ký tự)</label>
                                            <input type="password" name="newPassword" minlength="8" required />
                                            <button type="submit" class="btn btn-small btn-ghost" style="margin-top:8px;">Đặt lại</button>
                                        </form>
                                    </div>
                                </details>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty accounts}">
                    <tr><td colspan="7" style="text-align:center;color:#94a3b8;">Chưa có tài khoản nào.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
