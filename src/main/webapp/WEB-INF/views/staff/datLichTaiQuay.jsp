<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %><fmt:setLocale value="vi_VN"/>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đặt lịch tại quầy | PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css?v=figma-20261128">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/workspace.css?v=20261128-popup1">
</head>
<body>
    <c:set var="staffPage" value="counter"/>
    <%@ include file="/WEB-INF/includes/staffHeader.jspf" %>
    <main id="staff-main">
        <div class="page-heading"><div><p class="eyebrow">ĐÓN TIẾP THẬT CHU ĐÁO</p><h1>Đặt lịch tại quầy</h1>
        <p class="sub">Tìm khách, chọn dịch vụ và hoàn tất thu tiền trong một quy trình.</p></div></div>
        <div class="counter-progress" aria-label="Các bước đặt lịch"><span class="${empty customer ? 'is-current' : ''}"><b>1</b>Khách hàng</span><i aria-hidden="true"></i><span class="${not empty customer && empty pets ? 'is-current' : ''}"><b>2</b>Thú cưng</span><i aria-hidden="true"></i><span class="${not empty pets ? 'is-current' : ''}"><b>3</b>Dịch vụ &amp; thu tiền</span></div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="status">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <div class="counter-layout"><section aria-label="Thông tin đặt lịch">
        <div class="card">
            <div class="step-heading"><span class="step-number">01</span><div><h2>Tìm khách hàng</h2><p>Tra cứu bằng số điện thoại hoặc tạo hồ sơ cho khách mới.</p></div></div>
            <form method="post" action="${pageContext.request.contextPath}/staff/dat-lich-tai-quay">
                        <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.staffCsrfToken)}">
                <input type="hidden" name="action" value="timKhach" />
                <div class="row">
                    <div>
                        <label for="counter-phone">Số điện thoại</label><input id="counter-phone" type="tel" name="phone" autocomplete="tel" placeholder="Nhập số điện thoại khách" required maxlength="20"
                               value="${fn:escapeXml(not empty customer ? customer.phone : param.phone)}" />
                    </div>
                    <div>
                        <label for="counter-fullName">Họ tên (bắt buộc nếu khách mới)</label><input id="counter-fullName" type="text" name="fullName" autocomplete="name" placeholder="Họ và tên khách hàng" maxlength="100"
                               value="${fn:escapeXml(not empty customer ? customer.fullName : param.fullName)}" />
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Tìm / Tạo khách <svg aria-hidden="true"><use href="#staff-arrow"/></svg></button>
            </form>
        </div>

        <c:if test="${not empty customer}">
            <div class="customer-badge">
                <svg aria-hidden="true"><use href="#staff-check"/></svg>
                Khách: <strong>${fn:escapeXml(customer.fullName)}</strong> — ${fn:escapeXml(customer.phone)}
            </div>

            <div class="card">
                <div class="step-heading"><span class="step-number">02</span><div><h2>Thú cưng của khách</h2><p>Chọn hồ sơ có sẵn ở bước đặt lịch hoặc thêm bé mới.</p></div></div>
                <div class="pet-chips"><c:forEach var="pet" items="${pets}"><button type="button" class="pet-chip" data-select-pet="${pet.petId}" aria-pressed="false"><span class="pet-initial" aria-hidden="true">${fn:escapeXml(fn:substring(pet.name,0,1))}</span><span>${fn:escapeXml(pet.name)} <small>${fn:escapeXml(pet.species)}</small></span></button></c:forEach></div>
                <c:if test="${empty pets}">
                    <p class="empty-note">Khách chưa có thú cưng nào. Vui lòng thêm trước khi đặt lịch.</p>
                </c:if>
                <details data-popup-editor data-popup-title="Thêm thú cưng cho ${fn:escapeXml(customer.fullName)}" data-popup-auto="${param.action == 'themThuCung' && not empty errorMessage}" ${empty pets ? 'open' : ''}>
                    <summary>+ Thêm thú cưng mới</summary>
                    <form method="post" action="${pageContext.request.contextPath}/staff/dat-lich-tai-quay">
                        <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.staffCsrfToken)}">
                        <input type="hidden" name="action" value="themThuCung" />
                        <input type="hidden" name="customerId" value="${customer.userId}" />
                        <label for="counter-petName">Tên thú cưng</label><input id="counter-petName" type="text" name="petName" value="${fn:escapeXml(param.petName)}" required maxlength="100" />
                        <label for="counter-petSpecies">Loài (chó, mèo, ...)</label><input id="counter-petSpecies" type="text" name="petSpecies" value="${fn:escapeXml(param.petSpecies)}" required maxlength="50" />
                        <label for="counter-petBreed">Giống (không bắt buộc)</label><input id="counter-petBreed" type="text" name="petBreed" value="${fn:escapeXml(param.petBreed)}" maxlength="100" />
                        <button type="submit" class="btn btn-ghost">Thêm thú cưng</button>
                    </form>
                </details>
            </div>

            <c:if test="${not empty pets}">
                <div class="card">
                    <div class="step-heading"><span class="step-number">03</span><div><h2>Dịch vụ &amp; thu tiền</h2><p>Kiểm tra thông tin trước khi xác nhận đặt lịch.</p></div></div><c:set var="availableAssignments" value="0"/><c:forEach var="entry" items="${staffByService}"><c:set var="availableAssignments" value="${availableAssignments + fn:length(entry.value)}"/></c:forEach>
                    <form method="post" action="${pageContext.request.contextPath}/staff/dat-lich-tai-quay">
                        <input type="hidden" name="csrfToken" value="${fn:escapeXml(sessionScope.staffCsrfToken)}">
                        <input type="hidden" name="action" value="datLichVaThu" />
                        <input type="hidden" name="customerId" value="${customer.userId}" />

                        <label for="counter-petId">Thú cưng</label><select id="counter-petId" name="petId" required>
                            <c:forEach var="pet" items="${pets}">
                                <option value="${pet.petId}" ${param.petId == pet.petId ? 'selected' : ''}>${fn:escapeXml(pet.name)} (${fn:escapeXml(pet.species)})</option>
                            </c:forEach>
                        </select>

                        <label for="counter-staffChoice">Dịch vụ &amp; nhân viên thực hiện</label>
                        <c:choose>
                            <c:when test="${empty staffByService}">
                                <p class="empty-note">Hiện chưa có dịch vụ nào mở để đặt lịch.</p>
                            </c:when>
                            <c:otherwise>
                                <select id="counter-staffChoice" name="staffChoice" required>
                                    <c:forEach var="entry" items="${staffByService}">
                                        <fmt:formatNumber var="counterServicePrice" value="${entry.key.price}" maxFractionDigits="2"/><optgroup label="${fn:escapeXml(entry.key.name)} (${entry.key.durationMinutes} phút - ${counterServicePrice} đ)">
                                            <c:forEach var="staff" items="${entry.value}">
                                                <c:set var="staffChoiceValue" value="${entry.key.serviceId}_${staff.staffId}"/><option value="${staffChoiceValue}" data-price="${entry.key.price}" data-service="${fn:escapeXml(entry.key.name)}" data-staff="${fn:escapeXml(staff.fullName)}" ${param.staffChoice == staffChoiceValue ? 'selected' : ''}>${fn:escapeXml(entry.key.name)} — ${fn:escapeXml(staff.fullName)}</option>
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
                                <label for="counter-bookingDate">Ngày hẹn</label><input id="counter-bookingDate" type="date" name="bookingDate" min="${minimumBookingDate}" value="${fn:escapeXml(param.bookingDate)}" required />
                            </div>
                            <div>
                                <label for="counter-bookingTime">Giờ hẹn</label><input id="counter-bookingTime" type="time" name="bookingTime" value="${fn:escapeXml(param.bookingTime)}" required />
                            </div>
                        </div>

                        <div class="row">
                            <div>
                                <label for="counter-method">Phương thức thu tiền</label><select id="counter-method" name="method" required>
                                    <option value="CASH" ${param.method != 'ONLINE' ? 'selected' : ''}>Tiền mặt</option>
                                    <option value="ONLINE" ${param.method == 'ONLINE' ? 'selected' : ''}>Chuyển khoản / Online</option>
                                </select>
                            </div>
                            <div>
                                <label for="counter-transactionRef">Mã giao dịch (bắt buộc nếu chọn Online)</label><input id="counter-transactionRef" type="text" name="transactionRef" value="${fn:escapeXml(param.transactionRef)}" maxlength="100" />
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary" id="counter-confirm" ${availableAssignments == 0 ? 'disabled' : ''}>Xác nhận đặt lịch &amp; thu tiền</button>
                    </form>
                </div>
            </c:if>
        </c:if>
        </section><aside class="workspace-rail counter-summary" aria-label="Tóm tắt đơn tại quầy"><div class="rail-card"><h2>Tóm tắt đơn tại quầy</h2><dl class="order-summary"><dt>Khách hàng</dt><dd><c:out value="${empty customer ? 'Chưa chọn khách' : customer.fullName}"/></dd><dt>Thú cưng</dt><dd data-summary-pet>Chưa chọn</dd><dt>Ngày hẹn</dt><dd data-summary-date>Chưa chọn</dd><dt>Giờ hẹn</dt><dd data-summary-time>Chưa chọn</dd><dt>Phụ trách</dt><dd data-summary-staff>Chưa chọn</dd><dt>Dịch vụ</dt><dd data-summary-service>Chưa chọn</dd></dl><div class="order-total"><span>Tổng tiền dự kiến</span><strong data-summary-price>—</strong></div><p class="support-note">Giá hiển thị theo dịch vụ đã chọn. Hệ thống kiểm tra lại khi xác nhận.</p><c:if test="${not empty pets}"><a class="btn btn-primary" href="#counter-confirm">Kiểm tra &amp; hoàn tất đơn</a></c:if></div><div class="rail-card accent"><h2>Trước khi hoàn tất</h2><p>Chỉ xác nhận thu tiền khi đã nhận tiền mặt hoặc kiểm tra giao dịch chuyển khoản. Với Online, hãy nhập mã giao dịch để đối soát.</p><p>Tại quầy hiện hỗ trợ một dịch vụ cho mỗi lần đặt.</p></div></aside></div>
        <footer class="page-footer"><span>PetCare · Không gian nhân viên</span><span>Đúng thông tin, trọn trải nghiệm.</span></footer>
    </main>
    <script src="${pageContext.request.contextPath}/assets/js/staff.js?v=figma-20261128" defer></script>
<script src="${pageContext.request.contextPath}/assets/js/workspace-dialog.js?v=1" defer></script>
</body>
</html>
