/**
 * Pet care - Interactive Homepage Scripts
 */
document.addEventListener('DOMContentLoaded', function () {
    // Detailed expandable content for each service card
    const SERVICE_DETAILS = {
        'Tắm Spa Thảo Mộc & Vệ Sinh Toàn Diện': {
            fullDesc: 'Vệ sinh tai, vắt tuyến hôi, bấm mài móng êm ái, ngâm bồn tắm thảo mộc dưỡng ẩm lông và sấy phồng thơm mát lâu ngày.',
            items: [
                'Ngâm bồn sục thảo mộc thiên nhiên khử mùi & dưỡng ẩm da',
                'Vệ sinh tai chuyên sâu, nhổ lông tai & vắt tuyến hôi an toàn',
                'Cắt & mài nhẵn móng chân, cạo vệ sinh lông bàn chân, bụng',
                'Sấy phồng tạo độ tơi mượt, chải bung lông rụng & xịt dưỡng tinh dầu'
            ],
            tiers: [
                { label: 'Bé dưới 5 kg', price: '150.000 đ' },
                { label: 'Bé từ 5 - 10 kg', price: '220.000 đ' },
                { label: 'Bé trên 10 kg', price: '300.000 đ' }
            ]
        },
        'Grooming & Cắt Tỉa Lông Tạo Kiểu': {
            fullDesc: 'Cắt tỉa theo form dáng chuẩn (Teddy bear, sư tử, gấu tròn...), gỡ rối lông, tỉa gọn chân và mắt, tạo phồng chuẩn salon.',
            items: [
                'Bao gồm trọn bộ quy trình Tắm Spa Thảo Mộc & Vệ sinh 7 bước',
                'Cắt tỉa tạo form theo yêu cầu (Teddy Bear, Sư tử, Gấu tròn, Poodle...)',
                'Gỡ rối lông chuyên sâu bằng xịt dưỡng Keratin không gây đau rát',
                'Tỉa tròn mắt, tai, viền chân gọn gàng & tặng phụ kiện nơ/khăn cổ'
            ],
            tiers: [
                { label: 'Bé dưới 5 kg', price: '280.000 đ' },
                { label: 'Bé từ 5 - 10 kg', price: '360.000 đ' },
                { label: 'Bé trên 10 kg', price: '450.000 đ' }
            ]
        },
        'Spa Cắt Tỉa & Nhuộm Lông Thẩm Mỹ Cao Cấp': {
            fullDesc: 'Dưỡng lông tơ bóng mượt với collagen organic, tạo kiểu tai/đuôi thời thượng, xịt nước hoa cao cấp an toàn cho da nhạy cảm.',
            items: [
                'Ủ phục hồi lông hư tổn bằng tinh chất Collagen & dầu Argan hữu cơ',
                'Nhuộm thẩm mỹ tai, đuôi hoặc chân bằng màu thảo mộc 100% an toàn',
                'Cắt tỉa tạo kiểu thời trang bởi Master Groomer trên 5 năm kinh nghiệm',
                'Xịt nước hoa lưu hương 7 ngày & chụp ảnh kỷ niệm tại góc studio'
            ],
            tiers: [
                { label: 'Nhuộm thẩm mỹ tai / đuôi', price: '350.000 đ' },
                { label: 'Combo Cắt tỉa + Ủ Collagen + Nhuộm', price: '480.000 đ' }
            ]
        },
        'Cạo Lông Mát Mẻ & Phục Hồi Lông Rối': {
            fullDesc: 'Cạo lông sạch sẽ thoáng mát mùa nóng, gỡ búi lông rối bết không đau rát, vệ sinh kẽ móng và massage nhẹ nhàng.',
            items: [
                'Cạo lông gọn gàng bằng tông-đơ gốm êm ái, chừa độ dài bảo vệ da bé',
                'Xử lý các búi lông vón cục lâu ngày, làm dịu vùng da mẩn đỏ',
                'Tắm sạch sâu bằng sữa tắm yến mạch dịu nhẹ & vệ sinh tai, móng',
                'Massage thư giãn toàn thân với tinh dầu tràm trà chống ve rận'
            ],
            tiers: [
                { label: 'Bé dưới 5 kg', price: '180.000 đ' },
                { label: 'Bé từ 5 - 10 kg', price: '250.000 đ' },
                { label: 'Bé trên 10 kg', price: '320.000 đ' }
            ]
        },
        'Khách Sạn Thú Cưng Lưu Trú VIP': {
            fullDesc: 'Phòng riêng điều hòa 24/7, camera theo dõi trực tiếp cho chủ qua app, sân chơi vui nhộn 2 lần/ngày, khẩu phần dinh dưỡng riêng.',
            items: [
                'Phòng nghỉ riêng biệt khử khuẩn UV mỗi ngày, điều hòa mát mẻ 24/7',
                'Camera trực tuyến Full HD kết nối điện thoại giúp Sen ngắm bé mọi lúc',
                'Chế độ ăn 3 bữa/ngày đầy đủ dinh dưỡng (hạt cao cấp, pate tươi, ức gà)',
                'Vận động tại sân chơi cỏ nhân tạo 2 lần/ngày có nhân viên trông coi'
            ],
            tiers: [
                { label: 'Phòng Standard điều hòa', price: '200.000 đ/ngày' },
                { label: 'Phòng VIP Villa có camera riêng', price: '320.000 đ/ngày' }
            ]
        }
    };

    const serviceCards = document.querySelectorAll('.service-price-card[data-category]');

    function setCardExpanded(card, expanded) {
        const toggleSpan = card.querySelector('.spc-drawer-toggle-text');
        const toggleBtn = card.querySelector('.spc-drawer-toggle');
        if (expanded) {
            card.classList.add('is-expanded');
            if (toggleSpan) toggleSpan.textContent = 'Thu gọn chi tiết dịch vụ';
            if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'true');
        } else {
            card.classList.remove('is-expanded');
            if (toggleSpan) toggleSpan.textContent = 'Xem chi tiết gói dịch vụ';
            if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'false');
        }
    }

    // Initialize expandable drawer on each service card
    serviceCards.forEach(function (card) {
        const titleEl = card.querySelector('h3');
        const descEl = card.querySelector('p');
        const footerEl = card.querySelector('.spc-footer');
        if (!titleEl || !footerEl) return;

        const titleText = titleEl.textContent.replace(/\s+/g, ' ').trim();
        const detail = SERVICE_DETAILS[titleText];

        if (detail && descEl) {
            descEl.textContent = detail.fullDesc;
        }

        // Inject drawer markup if not already present in HTML
        if (!card.querySelector('.spc-drawer-wrap') && detail) {
            const toggleBtn = document.createElement('button');
            toggleBtn.type = 'button';
            toggleBtn.className = 'spc-drawer-toggle';
            toggleBtn.setAttribute('aria-expanded', 'false');
            toggleBtn.innerHTML =
                '<span class="spc-drawer-toggle-text">Xem chi tiết gói dịch vụ</span>' +
                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">' +
                '<polyline points="6 9 12 15 18 9"></polyline>' +
                '</svg>';

            const drawerWrap = document.createElement('div');
            drawerWrap.className = 'spc-drawer-wrap';

            const itemsHtml = detail.items.map(function (item) {
                return '<li><span>' + item + '</span></li>';
            }).join('');

            const tiersHtml = detail.tiers.map(function (t) {
                return '<div class="spc-tier-row"><span>' + t.label + '</span><strong>' + t.price + '</strong></div>';
            }).join('');

            drawerWrap.innerHTML =
                '<div class="spc-drawer-inner">' +
                '  <div class="spc-drawer-box">' +
                '    <div class="spc-drawer-title">✨ Quy trình &amp; Hạng mục bao gồm</div>' +
                '    <ul class="spc-drawer-list">' + itemsHtml + '</ul>' +
                '    <div class="spc-drawer-tiers">' + tiersHtml + '</div>' +
                '  </div>' +
                '</div>';

            card.insertBefore(toggleBtn, footerEl);
            card.insertBefore(drawerWrap, footerEl);
        }

        // Click on card or toggle button to slide open / close details
        card.addEventListener('click', function (e) {
            if (e.target.closest('[data-open-booking]')) {
                return; // Let booking button open modal
            }
            const isExpanded = card.classList.contains('is-expanded');
            setCardExpanded(card, !isExpanded);
        });
    });

    // 1. Category Filter Tabs for Services Section with Pull-Out Animation
    const filterBtns = document.querySelectorAll('[data-filter]');

    filterBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            filterBtns.forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            const filter = btn.getAttribute('data-filter');

            let visibleIndex = 0;
            serviceCards.forEach(function (card) {
                const matches = (filter === 'all' || card.getAttribute('data-category') === filter);
                card.classList.remove('is-pulling-out');

                if (matches) {
                    card.classList.remove('is-hidden-card');
                    card.style.display = 'flex';
                    card.style.animationDelay = (visibleIndex * 75) + 'ms';
                    // Trigger reflow so pull-out animation replays cleanly
                    void card.offsetWidth;
                    card.classList.add('is-pulling-out');
                    // Automatically pull out (expand) service details when filtering a specific category
                    setCardExpanded(card, filter !== 'all');
                    visibleIndex++;
                } else {
                    card.classList.add('is-hidden-card');
                    card.style.display = 'none';
                    setCardExpanded(card, false);
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
