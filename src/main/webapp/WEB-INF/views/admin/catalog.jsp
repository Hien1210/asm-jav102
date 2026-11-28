<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="adminPage" value="${module.path}"/>
<c:set var="adminTitle" value="${module.title}"/>
<c:set var="valueLabels" value="${{'GROOMING':'Tắm & cắt tỉa','MEDICAL':'Khám & điều trị','VACCINATION':'Tiêm phòng','BOARDING':'Lưu trú','OTHER':'Dịch vụ khác','AVAILABLE':'Sẵn sàng','OCCUPIED':'Đang sử dụng','MAINTENANCE':'Bảo trì','1':'Đang hoạt động','0':'Đã ngừng'}}"/>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${module.title}"/> | Quản trị PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/workspace.css?v=20261128-popup1">
</head>
<body>
<%@ include file="shell-start.jspf" %>
<main id="main-content">
    <div class="page-heading">
        <div><p class="eyebrow">KHÔNG GIAN QUẢN TRỊ</p><h1><c:out value="${module.title}"/></h1><p class="sub"><c:choose><c:when test="${module.path == 'thu-cung'}">Hồ sơ thú cưng của khách hàng, dùng để đặt lịch dịch vụ và lưu trú.</c:when><c:otherwise>Quản lý thông tin <c:out value="${fn:toLowerCase(module.title)}"/> và cập nhật dữ liệu tại một nơi.</c:otherwise></c:choose></p></div>
        <a class="button" href="${pageContext.request.contextPath}/admin/${module.path}#editor"><span aria-hidden="true">＋</span> Thêm mới</a>
    </div>
    <c:if test="${not empty errorMessage}"><p class="alert error" role="alert"><c:out value="${errorMessage}"/></p></c:if>
    <c:if test="${not empty successMessage}"><p class="alert success" role="status"><c:out value="${successMessage}"/></p></c:if>
    <div class="overview">
        <div class="overview-card"><div><small>Tổng số bản ghi</small><strong>${fn:length(rows)}</strong></div><span class="overview-icon"><svg aria-hidden="true"><use href="#i-grid"/></svg></span></div>
        <div class="overview-card secondary-card"><div><small>Quản lý tập trung</small><strong>Thông tin & trạng thái</strong></div><span class="overview-icon"><svg aria-hidden="true"><use href="#i-spark"/></svg></span></div>
    </div>
    <div class="catalog-layout">
        <section class="card form-card" id="editor" aria-labelledby="form-title" data-popup-editor data-popup-title="${empty edit[module.id] ? 'Thêm mới' : 'Chỉnh sửa'} · ${fn:escapeXml(module.title)}" data-popup-auto="${not empty edit[module.id] || (not empty errorMessage && param.action == 'save')}">
            <div class="card-heading"><h2 id="form-title">${empty edit[module.id] ? 'Thêm mới' : 'Chỉnh sửa bản ghi'} <c:if test="${not empty edit[module.id]}"><span class="count-pill">#<c:out value="${edit[module.id]}"/></span></c:if></h2></div>
            <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/${module.path}">
                <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="id" value="${fn:escapeXml(edit[module.id])}">
                <div class="form-grid">
                <c:forEach var="field" items="${module.fields}">
                    <div>
                        <label for="field-${field.name}"><c:out value="${field.label}"/>${field.required ? ' *' : ''}</label>
                        <c:choose>
                            <c:when test="${field.type == 'select'}">
                                <select id="field-${field.name}" name="${field.name}" required>
                                    <c:forEach var="option" items="${field.options}"><option value="${option}" ${edit[field.name] == option ? 'selected' : ''}><c:out value="${empty valueLabels[option] ? option : valueLabels[option]}"/></option></c:forEach>
                                </select>
                            </c:when>
                            <c:when test="${field.type == 'staff' || field.type == 'customer'}">
                                <select id="field-${field.name}" name="${field.name}" required><option value="">Chọn tài khoản</option>
                                    <c:forEach var="person" items="${people}"><option value="${person.user_id}" ${edit[field.name] == person.user_id ? 'selected' : ''}><c:out value="${person.full_name}"/> — <c:out value="${person.email}"/></option></c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <input id="field-${field.name}" name="${field.name}" type="${field.type == 'decimal' ? 'number' : field.type}"
                                       value="${fn:escapeXml(edit[field.name])}" ${field.required ? 'required' : ''}
                                       <c:if test="${field.type == 'text'}">maxlength="${field.max}" placeholder="Nhập ${fn:escapeXml(fn:toLowerCase(field.label))}"</c:if>
                                       <c:if test="${field.type == 'decimal'}">min="${field.name == 'weight_kg' ? '0.01' : '0'}" step="0.01"</c:if>
                                       <c:if test="${field.type == 'number'}">min="1" step="1"</c:if>>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
                </div>
                <c:if test="${module.path == 'combo'}">
                    <fieldset><legend>Dịch vụ trong combo *</legend>
                        <c:forEach var="service" items="${services}"><c:if test="${service.category != 'BOARDING'}">
                            <label class="check"><input type="checkbox" name="serviceIds" value="${service.service_id}" ${selectedServices.contains(service.service_id) ? 'checked' : ''}><span><c:out value="${service.name}"/>${service.is_active == 0 ? ' (đã ngừng)' : ''}</span></label>
                        </c:if></c:forEach>
                        <c:if test="${empty services}"><p class="form-hint">Thêm dịch vụ trước khi tạo combo.</p></c:if>
                    </fieldset>
                </c:if>
                <div class="form-actions"><button type="submit">${empty edit[module.id] ? 'Thêm mới' : 'Lưu thay đổi'}</button><a class="button secondary" href="${pageContext.request.contextPath}/admin/${module.path}">Làm mới</a></div>
                <p class="form-hint">Các trường có dấu * là bắt buộc. Kiểm tra thông tin trước khi lưu.</p>
            </form>
            </div>
        </section>
        <section class="card list-card" aria-labelledby="list-title">
            <div class="card-heading"><h2 id="list-title">Danh sách <span class="count-pill">${fn:length(rows)}</span></h2><span class="muted section-description">${module.title}</span></div>
            <%@ include file="table-tools.jspf" %>
            <div class="table-scroll" tabindex="0" role="region" aria-label="Danh sách ${module.title}">
                <table id="admin-table" class="catalog-table catalog-${module.path}">
                    <thead><tr><th scope="col">ID</th><c:forEach var="field" items="${module.fields}"><th scope="col" class="${field.name == 'description' || field.name == 'medical_notes' ? 'optional-col' : ''}"><c:out value="${field.label}"/></th></c:forEach><th scope="col">Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach var="row" items="${rows}">
                        <c:set var="filterLabel" value="${module.path == 'phong' ? valueLabels[row.status] : module.path == 'thu-cung' ? row.species : module.path == 'ca-lam-viec' ? row.work_date : row.is_active == 1 ? 'Đang hoạt động' : 'Đã ngừng'}"/>
                        <tr data-record data-filter="${fn:escapeXml(filterLabel)}"><td>#${row[module.id]}</td>
                            <c:forEach var="field" items="${module.fields}"><td class="${field.name == 'description' || field.name == 'medical_notes' ? 'optional-col' : field.type == 'decimal' || field.type == 'date' || field.type == 'time' ? 'numeric-cell' : ''}">
                                <c:choose>
                                    <c:when test="${field.type == 'select'}"><span class="badge ${field.name == 'is_active' && row[field.name] == 1 || field.name == 'status' && row.status == 'AVAILABLE' ? 'badge-active' : ''}"><c:out value="${valueLabels[row[field.name].toString()]}"/></span></c:when>
                                    <c:when test="${field.name == 'price' || field.name == 'daily_rate'}"><fmt:formatNumber value="${row[field.name]}" maxFractionDigits="0"/> <span class="muted">đ</span></c:when>
                                    <c:when test="${field.type == 'staff' || field.type == 'customer'}"><c:set var="personFound" value="false"/><c:forEach var="person" items="${people}"><c:if test="${person.user_id == row[field.name]}"><c:out value="${person.full_name}"/><c:set var="personFound" value="true"/></c:if></c:forEach><c:if test="${not personFound}">#<c:out value="${row[field.name]}"/></c:if></c:when>
                                    <c:otherwise><c:out value="${row[field.name]}" default="—"/></c:otherwise>
                                </c:choose>
                            </td></c:forEach>
                            <td class="actions"><a class="button secondary" href="${pageContext.request.contextPath}/admin/${module.path}?id=${row[module.id]}#editor" aria-label="Sửa bản ghi ${row[module.id]}">Sửa</a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/${module.path}" class="delete-form">
                                    <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.adminCsrfToken)}"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${row[module.id]}">
                                    <button class="danger" type="submit" aria-label="Xóa bản ghi ${row[module.id]}">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rows}"><tr><td class="empty-state" colspan="${fn:length(module.fields) + 2}"><svg aria-hidden="true"><use href="#i-box"/></svg><strong>Chưa có dữ liệu</strong><p>Thêm bản ghi đầu tiên bằng biểu mẫu bên cạnh.</p></td></tr></c:if>
                    </tbody>
                </table>
            </div>
            <div class="no-results" hidden>Không tìm thấy kết quả. Thử từ khóa hoặc bộ lọc khác.</div>
            <div class="table-footer"><span class="visible-count">${fn:length(rows)} bản ghi</span><span>Cuộn ngang để xem thêm thông tin</span></div>
        </section>
    </div>
</main>
<%@ include file="shell-end.jspf" %>
</body>
</html>
