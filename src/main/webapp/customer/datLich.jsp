<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đặt lịch chăm sóc | PetCare</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; margin: 0; color: #1f2937; }
        .topbar { background: #0f766e; color: #fff; padding: 14px 24px; display: flex; align-items: center; justify-content: space-between; }
        .topbar a { color: #fff; font-weight: 700; text-decoration: none; font-size: 18px; }
        main { max-width: 720px; margin: 24px auto; padding: 0 16px 48px; }
        h1 { font-size: 22px; margin-bottom: 4px; }
        .sub { color: #6b7280; margin-bottom: 20px; }
        .alert { padding: 10px 14px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .card { background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; padding: 18px; margin-bottom: 20px; }
        .card h2 { margin: 0 0 12px; font-size: 16px; }
        label { display: block; font-size: 12px; color: #4b5563; margin: 10px 0 4px; }
        input, select { width: 100%; padding: 9px 10px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; }
        .btn { display: inline-block; padding: 9px 16px; border-radius: 6px; border: none; font-size: 14px; cursor: pointer; font-weight: 600; margin-top: 14px; }
        .btn-primary { background: #0f766e; color: #fff; }
        .btn-ghost { background: #e5e7eb; color: #374151; }
        details > summary { cursor: pointer; color: #0f766e; font-size: 13px; font-weight: 600; margin-top: 6px; }
        .row { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .empty-note { color: #94a3b8; font-size: 13px; }
    </style>
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
    <div class="topbar">
        <a href="${pageContext.request.contextPath}/home">PetCare</a>
        <span>Xin chào, ${loggedInUser}</span>
    </div>
    <main>
        <h1>Đặt lịch chăm sóc</h1>
        <p class="sub">Chọn thú cưng, dịch vụ, nhân viên và thời gian bạn muốn đặt.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>

        <div class="card">
            <h2>1. Thú cưng của bạn</h2>
            <c:if test="${empty pets}">
                <p class="empty-note">Bạn chưa có thú cưng nào. Vui lòng thêm trước khi đặt lịch.</p>
            </c:if>
            <details ${empty pets ? 'open' : ''}>
                <summary>+ Thêm thú cưng mới</summary>
                <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich">
                    <input type="hidden" name="action" value="addPet" />
                    <label>Tên thú cưng</label>
                    <input type="text" name="petName" required maxlength="100" />
                    <label>Loài (chó, mèo, ...)</label>
                    <input type="text" name="petSpecies" required maxlength="50" />
                    <label>Giống (không bắt buộc)</label>
                    <input type="text" name="petBreed" maxlength="100" />
                    <button type="submit" class="btn btn-ghost">Thêm thú cưng</button>
                </form>
            </details>
        </div>

        <c:if test="${not empty pets}">
            <div class="card">
                <h2>2. Đặt lịch hẹn</h2>
                <form method="post" action="${pageContext.request.contextPath}/customer/dat-lich">
                    <input type="hidden" name="action" value="book" />

                    <label>Thú cưng</label>
                    <select name="petId" required>
                        <c:forEach var="pet" items="${pets}">
                            <option value="${pet.petId}">${pet.name} (${pet.species})</option>
                        </c:forEach>
                    </select>

                    <label>Dịch vụ &amp; nhân viên thực hiện</label>
                    <c:choose>
                        <c:when test="${empty staffByService}">
                            <p class="empty-note">Hiện chưa có dịch vụ nào mở để đặt lịch.</p>
                        </c:when>
                        <c:otherwise>
                            <select name="staffChoice" required>
                                <c:forEach var="entry" items="${staffByService}">
                                    <optgroup label="${entry.key.name} (${entry.key.durationMinutes} phút - ${entry.key.price} đ)">
                                        <c:forEach var="staff" items="${entry.value}">
                                            <option value="${entry.key.serviceId}_${staff.staffId}">${staff.fullName}</option>
                                        </c:forEach>
                                        <c:if test="${empty entry.value}">
                                            <option disabled>Chưa có nhân viên nhận dịch vụ này</option>
                                        </c:if>
                                    </optgroup>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>

                    <div class="row">
                        <div>
                            <label>Ngày hẹn</label>
                            <input type="date" name="bookingDate" required />
                        </div>
                        <div>
                            <label>Giờ hẹn</label>
                            <input type="time" name="bookingTime" required />
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">Xác nhận đặt lịch</button>
                </form>
            </div>
        </c:if>
    </main>
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
