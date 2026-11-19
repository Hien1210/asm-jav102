<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thú cưng của tôi | PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=4" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer.css?v=1" />
</head>
<body data-ctx="${pageContext.request.contextPath}" data-user-id="${sessionScope.loggedInUserId}">
    <%@ include file="/WEB-INF/includes/customerNav.jspf" %>

    <main class="pc-main">
        <div class="pc-page-head">
            <div>
                <h1>Thú cưng của tôi</h1>
                <p class="pc-page-sub">Quản lý đầy đủ hồ sơ bé cưng (cân nặng, ngày sinh, ghi chú sức khỏe) để đặt lịch nhanh hơn.</p>
            </div>
            <a href="${pageContext.request.contextPath}/customer/dat-lich" class="pc-btn pc-btn-primary">
                + Đặt lịch chăm sóc
            </a>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="pc-alert pc-alert-error">${fn:escapeXml(errorMessage)}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="pc-alert pc-alert-success">${fn:escapeXml(successMessage)}</div>
        </c:if>

        <div class="pc-layout-split">
            <section class="pc-card">
                <div class="pc-card-head">
                    <h2>
                        <c:choose>
                            <c:when test="${not empty editingPet}">Cập nhật thú cưng #${editingPet.petId}</c:when>
                            <c:otherwise>Thêm thú cưng mới</c:otherwise>
                        </c:choose>
                    </h2>
                    <c:if test="${not empty editingPet}">
                        <a href="${pageContext.request.contextPath}/customer/thu-cung" class="pc-btn pc-btn-ghost pc-btn-sm">Hủy sửa</a>
                    </c:if>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/customer/thu-cung">
                    <c:choose>
                        <c:when test="${not empty editingPet}">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="petId" value="${editingPet.petId}" />
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="create" />
                        </c:otherwise>
                    </c:choose>

                    <div class="pc-form-group">
                        <label for="petName">Tên thú cưng <span class="pc-req">*</span></label>
                        <input id="petName" class="pc-input" type="text" name="name" required maxlength="100"
                               placeholder="Ví dụ: Bé Miu, Bơ, Mây..."
                               value="${not empty editingPet ? fn:escapeXml(editingPet.name) : ''}" />
                    </div>

                    <div class="pc-form-row">
                        <div class="pc-form-group">
                            <label for="petSpecies">Loài <span class="pc-req">*</span></label>
                            <input id="petSpecies" class="pc-input" type="text" name="species" required maxlength="50"
                                   list="speciesSuggestions" placeholder="Chó, Mèo..."
                                   value="${not empty editingPet ? fn:escapeXml(editingPet.species) : ''}" />
                            <datalist id="speciesSuggestions">
                                <option value="Chó"></option>
                                <option value="Mèo"></option>
                                <option value="Thỏ"></option>
                                <option value="Hamster"></option>
                            </datalist>
                        </div>

                        <div class="pc-form-group">
                            <label for="petBreed">Giống</label>
                            <input id="petBreed" class="pc-input" type="text" name="breed" maxlength="100"
                                   placeholder="Poodle, Corgi, Mèo Anh..."
                                   value="${not empty editingPet ? fn:escapeXml(editingPet.breed) : ''}" />
                        </div>
                    </div>

                    <div class="pc-form-row">
                        <div class="pc-form-group">
                            <label for="petWeight">Cân nặng (kg)</label>
                            <input id="petWeight" class="pc-input" type="number" name="weightKg" step="0.01" min="0.01" max="999.99"
                                   placeholder="Ví dụ: 4.5"
                                   value="${not empty editingPet and not empty editingPet.weightKg ? editingPet.weightKg : ''}" />
                        </div>

                        <div class="pc-form-group">
                            <label for="petBirthDate">Ngày sinh</label>
                            <input id="petBirthDate" class="pc-input" type="date" name="birthDate" max="${todayIso}"
                                   value="${not empty editingPet ? editingPet.birthDateIso : ''}" />
                        </div>
                    </div>

                    <div class="pc-form-group">
                        <label for="petMedicalNotes">Ghi chú sức khỏe / lịch sử khám</label>
                        <textarea id="petMedicalNotes" class="pc-textarea" name="medicalNotes" maxlength="4000"
                                  placeholder="Ví dụ: Dị ứng sữa tắm hương nồng, đã tiêm phòng 7 bệnh, hơi nhút nhát...">${not empty editingPet ? fn:escapeXml(editingPet.medicalNotes) : ''}</textarea>
                    </div>

                    <button type="submit" class="pc-btn pc-btn-primary" style="width: 100%;">
                        <c:choose>
                            <c:when test="${not empty editingPet}">Lưu thay đổi</c:when>
                            <c:otherwise>Thêm thú cưng</c:otherwise>
                        </c:choose>
                    </button>
                </form>
            </section>

            <section class="pc-card">
                <div class="pc-card-head">
                    <h2>Danh sách bé cưng (${fn:length(pets)})</h2>
                </div>

                <c:choose>
                    <c:when test="${empty pets}">
                        <div class="pc-empty">
                            <h3>Chưa có thú cưng nào</h3>
                            <p>Hãy thêm thông tin thú cưng đầu tiên ở biểu mẫu bên cạnh để bắt đầu đặt lịch chăm sóc hoặc lưu trú.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="pet" items="${pets}">
                            <article class="pc-item-card">
                                <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:12px;flex-wrap:wrap;">
                                    <div>
                                        <h3 style="margin:0;font-size:17px;">
                                            ${fn:escapeXml(pet.name)}
                                            <span class="pc-badge pc-badge-primary" style="margin-left:6px;">${fn:escapeXml(pet.species)}</span>
                                        </h3>
                                        <div style="font-size:13px;color:var(--pc-muted);margin-top:2px;">
                                            Mã bé #${pet.petId}
                                            <c:if test="${not empty pet.breed}"> &bull; Giống: ${fn:escapeXml(pet.breed)}</c:if>
                                        </div>
                                    </div>
                                    <div class="pc-btn-group">
                                        <a href="${pageContext.request.contextPath}/customer/dat-lich?petId=${pet.petId}"
                                           class="pc-btn pc-btn-primary pc-btn-sm">Đặt lịch</a>
                                        <a href="${pageContext.request.contextPath}/customer/thu-cung?editId=${pet.petId}"
                                           class="pc-btn pc-btn-outline pc-btn-sm">Chỉnh sửa</a>
                                        <c:choose>
                                            <c:when test="${pet.appointmentCount == 0}">
                                                <form method="post" action="${pageContext.request.contextPath}/customer/thu-cung"
                                                      style="display:inline;"
                                                      onsubmit="return confirm('Bạn chắc chắn muốn xóa thú cưng này?');">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="petId" value="${pet.petId}" />
                                                    <button type="submit" class="pc-btn pc-btn-danger-outline pc-btn-sm">Xóa</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="pc-badge pc-badge-neutral" title="Thú cưng đã có lịch hẹn nên không thể xóa">
                                                    ${pet.appointmentCount} lịch hẹn
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="pc-meta-grid">
                                    <div class="pc-meta-item">
                                        <span>Cân nặng</span>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty pet.weightKg}">${pet.weightKg} kg</c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                    <div class="pc-meta-item">
                                        <span>Ngày sinh</span>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty pet.formattedBirthDate}">${pet.formattedBirthDate}</c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                    <div class="pc-meta-item">
                                        <span>Số lịch hẹn</span>
                                        <strong>${pet.appointmentCount} lịch</strong>
                                    </div>
                                    <div class="pc-meta-item">
                                        <span>Ngày tạo hồ sơ</span>
                                        <strong>${not empty pet.formattedCreatedAt ? pet.formattedCreatedAt : '—'}</strong>
                                    </div>
                                </div>

                                <c:if test="${not empty pet.medicalNotes}">
                                    <div style="font-size:13.5px;background:#fffbeb;border:1px solid #fde68a;padding:10px 12px;border-radius:8px;">
                                        <strong>Ghi chú sức khỏe:</strong> ${fn:escapeXml(pet.medicalNotes)}
                                    </div>
                                </c:if>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
