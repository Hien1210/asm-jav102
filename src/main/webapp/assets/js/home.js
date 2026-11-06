/**
 * PetCare Vinh - Homepage Interactive Scripts
 */
document.addEventListener('DOMContentLoaded', function () {
    // 1. Pre-select service in booking form when clicking "Đặt lịch" / "Tư vấn" buttons
    const serviceTriggers = document.querySelectorAll('[data-select-service]');
    const serviceSelect = document.getElementById('serviceName');
    const bookingSection = document.getElementById('dat-lich-section');
    const ownerInput = document.getElementById('ownerName');

    serviceTriggers.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            const targetService = btn.getAttribute('data-select-service');
            if (targetService === 'Pet shop tại Vinh') {
                window.open('https://petshopvinh.vn', '_blank', 'noopener');
                return;
            }
            if (serviceSelect && targetService) {
                for (let i = 0; i < serviceSelect.options.length; i++) {
                    if (serviceSelect.options[i].value.indexOf(targetService) !== -1 ||
                        targetService.indexOf(serviceSelect.options[i].value) !== -1) {
                        serviceSelect.selectedIndex = i;
                        break;
                    }
                }
            }
            if (bookingSection) {
                e.preventDefault();
                bookingSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                setTimeout(function () {
                    if (ownerInput) ownerInput.focus();
                }, 500);
            }
        });
    });

    // 2. Default booking date to tomorrow if empty
    const dateInput = document.getElementById('bookingDate');
    if (dateInput && !dateInput.value) {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const yyyy = tomorrow.getFullYear();
        const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
        const dd = String(tomorrow.getDate()).padStart(2, '0');
        dateInput.min = `${yyyy}-${mm}-${dd}`;
    }

    // 3. Scroll to booking alert if form was just submitted
    const successAlert = document.getElementById('bookingSuccessAlert');
    if (successAlert) {
        successAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // 4. Static preview form submission handler (when opened via index.html / preview.html without Tomcat)
    const staticAlert = document.getElementById('bookingSuccessStatic');
    const bookingForm = document.querySelector('.booking-form-card form');
    if (staticAlert && bookingForm) {
        bookingForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const owner = document.getElementById('ownerName').value;
            const phone = document.getElementById('phone').value;
            const pet = document.getElementById('petName').value;
            const service = document.getElementById('serviceName').value;
            const branch = document.getElementById('branch').value;
            const date = document.getElementById('bookingDate').value;
            const time = document.getElementById('timeSlot').value;
            staticAlert.innerHTML = `<strong>Đã tiếp nhận yêu cầu đặt lịch cho bé ${pet}!</strong>Cảm ơn <b>${owner}</b> (${phone}). Nhân viên PetCare Vinh tại <b>${branch}</b> sẽ liên hệ xác nhận dịch vụ <b>${service}</b> (Khung giờ: ${time} - Ngày: ${date}) trong ít phút.`;
            staticAlert.style.display = 'block';
            staticAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
        });
    }
});

