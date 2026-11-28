const paymentMethod = document.querySelector('#counter-method');
const transactionReference = document.querySelector('#counter-transactionRef');
if (paymentMethod && transactionReference) {
    const updateRequirement = () => {
        transactionReference.required = paymentMethod.value === 'ONLINE';
    };
    paymentMethod.addEventListener('change', updateRequirement);
    updateRequirement();
}

// Appointment filters apply only to the staff member's server-authorized daily list.
const appointmentCards = [...document.querySelectorAll('[data-staff-appointment]')];
const searchField = document.querySelector('[data-staff-search]');
const statusButtons = [...document.querySelectorAll('[data-status-filter]')];
let selectedStatus = 'ALL';
const normalizeSearch = value => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D').toLocaleLowerCase('vi');
const filterAppointments = () => {
    const query = normalizeSearch(searchField?.value.trim() || '');
    let visible = 0;
    for (const card of appointmentCards) {
        const matches = (selectedStatus === 'ALL' || card.dataset.status === selectedStatus)
            && normalizeSearch(card.textContent).includes(query);
        card.hidden = !matches;
        if (matches) visible++;
    }
    const count = document.querySelector('[data-result-count]');
    if (count) count.textContent = `${visible} lượt`;
    const empty = document.querySelector('[data-filter-empty]');
    if (empty) empty.hidden = visible !== 0 || appointmentCards.length === 0;
};
searchField?.addEventListener('input', filterAppointments);
for (const button of statusButtons) button.addEventListener('click', () => {
    selectedStatus = button.dataset.statusFilter;
    for (const item of statusButtons) item.setAttribute('aria-pressed', String(item === button));
    filterAppointments();
});

const petSelect = document.querySelector('#counter-petId');
const serviceSelect = document.querySelector('#counter-staffChoice');
const bookingDate = document.querySelector('#counter-bookingDate');
const bookingTime = document.querySelector('#counter-bookingTime');
const writeSummary = (key, value) => {
    const target = document.querySelector(`[data-summary-${key}]`);
    if (target) target.textContent = value || 'Chưa chọn';
};
const updateOrderSummary = () => {
    const service = serviceSelect?.selectedOptions[0];
    writeSummary('pet', petSelect?.selectedOptions[0]?.textContent.trim());
    writeSummary('service', service?.dataset.service);
    writeSummary('staff', service?.dataset.staff);
    writeSummary('date', bookingDate?.value ? bookingDate.value.split('-').reverse().join('/') : '');
    writeSummary('time', bookingTime?.value);
    const price = service?.dataset.price;
    writeSummary('price', price && Number.isFinite(Number(price))
        ? new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(Number(price)) : '—');
    for (const chip of document.querySelectorAll('[data-select-pet]')) {
        chip.setAttribute('aria-pressed', String(chip.dataset.selectPet === petSelect?.value));
    }
};
for (const control of [petSelect, serviceSelect, bookingDate, bookingTime]) control?.addEventListener('change', updateOrderSummary);
for (const chip of document.querySelectorAll('[data-select-pet]')) chip.addEventListener('click', () => {
    if (petSelect) { petSelect.value = chip.dataset.selectPet; updateOrderSummary(); }
});
updateOrderSummary();
