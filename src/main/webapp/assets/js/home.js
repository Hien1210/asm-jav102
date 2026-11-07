/**
 * Pet care - Interactive Homepage Scripts
 */
document.addEventListener('DOMContentLoaded', function () {
    // 1. Category Filter Tabs for Services Section
    const filterBtns = document.querySelectorAll('[data-filter]');
    const serviceCards = document.querySelectorAll('[data-category]');

    filterBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            filterBtns.forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            const filter = btn.getAttribute('data-filter');

            serviceCards.forEach(function (card) {
                if (filter === 'all' || card.getAttribute('data-category') === filter) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    // 2. Booking / Quick Action Modal
    const modal = document.getElementById('bookingModal');
    const closeBtn = document.getElementById('closeModalBtn');
    const serviceSelect = document.getElementById('modalServiceName');
    const modalTriggers = document.querySelectorAll('[data-open-booking]');

    modalTriggers.forEach(function (trigger) {
        trigger.addEventListener('click', function (e) {
            e.preventDefault();
            const srv = trigger.getAttribute('data-open-booking');
            if (serviceSelect && srv) {
                for (let i = 0; i < serviceSelect.options.length; i++) {
                    if (serviceSelect.options[i].value.indexOf(srv) !== -1 ||
                        srv.indexOf(serviceSelect.options[i].value) !== -1) {
                        serviceSelect.selectedIndex = i;
                        break;
                    }
                }
            }
            if (modal) {
                modal.classList.add('open');
            }
        });
    });

    if (closeBtn && modal) {
        closeBtn.addEventListener('click', function () {
            modal.classList.remove('open');
        });
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                modal.classList.remove('open');
            }
        });
    }

    // 3. Static preview form submission handler
    const staticAlert = document.getElementById('bookingSuccessStatic');
    const modalForm = document.getElementById('petcareBookingForm');
    if (staticAlert && modalForm) {
        modalForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const owner = document.getElementById('ownerName').value;
            const phone = document.getElementById('phone').value;
            const pet = document.getElementById('petName').value;
            const service = document.getElementById('modalServiceName').value;
            const branch = document.getElementById('branch').value;
            staticAlert.innerHTML = '<strong>Đã giữ chỗ 15 phút cho bé ' + pet + '!</strong> Cảm ơn <b>' + owner + '</b> (' + phone + '). Salon <b>Pet care</b> (' + branch + ') đã ghi nhận lịch <b>' + service + '</b>.';
            staticAlert.style.display = 'block';
        });
    }
});
