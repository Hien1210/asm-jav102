/**
 * Pet care — Modern Premium Pet Spa Interactive Scripts
 */
document.addEventListener('DOMContentLoaded', function () {
    // 1. Sticky Header Scroll Effect & Mobile Menu Toggle
    const siteHeader = document.querySelector('.site-header');
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const mainNav = document.querySelector('.main-nav');

    function handleHeaderScroll() {
        if (!siteHeader) return;
        if (window.scrollY > 12) {
            siteHeader.classList.add('is-scrolled');
        } else {
            siteHeader.classList.remove('is-scrolled');
        }
    }
    window.addEventListener('scroll', handleHeaderScroll, { passive: true });
    handleHeaderScroll();

    if (mobileMenuBtn && mainNav) {
        mobileMenuBtn.addEventListener('click', function () {
            const expanded = mainNav.classList.toggle('is-open');
            mobileMenuBtn.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        });

        mainNav.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                mainNav.classList.remove('is-open');
                mobileMenuBtn.setAttribute('aria-expanded', 'false');
            });
        });
    }

    // 2. Scroll Fade-Up Reveal Observer
    const revealEls = document.querySelectorAll('.reveal-up');
    if ('IntersectionObserver' in window && revealEls.length > 0) {
        const revealObserver = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('is-visible');
                    revealObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });

        revealEls.forEach(function (el) {
            revealObserver.observe(el);
        });
    } else {
        revealEls.forEach(function (el) {
            el.classList.add('is-visible');
        });
    }

    // 3. Detailed Expandable Content for Service Cards
    const SERVICE_DETAILS = {
        'Grooming & Tắm Sấy Thảo Mộc Toàn Diện': {
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
        'Cắt Tỉa Tạo Kiểu Chuẩn Salon': {
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
        'Spa Thảo Dược & Phục Hồi Da Lông': {
            items: [
                'Ủ phục hồi lông hư tổn bằng tinh chất Collagen & dầu Argan hữu cơ',
                'Ngâm bồn sục thảo dược giúp dịu da mẩn đỏ, ngăn ngừa nấm & viêm da',
                'Massage bấm huyệt thư giãn giúp bé giảm căng thẳng, ngủ ngon hơn',
                'Xịt dưỡng lưu hương 7 ngày & chụp ảnh kỷ niệm tại góc studio'
            ],
            tiers: [
                { label: 'Liệu trình Ủ Collagen & Thảo dược', price: '350.000 đ' },
                { label: 'Trọn gói Spa + Cắt tỉa tạo kiểu', price: '480.000 đ' }
            ]
        },
        'Vệ Sinh Tai, Móng & Tuyến Hôi Chuyên Sâu': {
            items: [
                'Nhổ lông tai nhẹ nhàng & lau sạch ống tai bằng dung dịch thảo dược',
                'Cắt móng và mài nhẵn đầu móng không gây xước sàn hay chảy máu',
                'Cạo gọn lông kẽ chân, vùng bụng và vệ sinh vắt tuyến hôi triệt để',
                'Xịt khử khuẩn bàn chân và thoa sáp dưỡng mềm đệm thịt cho bé'
            ],
            tiers: [
                { label: 'Bé dưới 10 kg', price: '120.000 đ' },
                { label: 'Bé trên 10 kg', price: '160.000 đ' }
            ]
        },
        'Kiểm Tra Sức Khỏe Cơ Bản & Gỡ Rối Lông': {
            items: [
                'Kiểm tra tổng quát tình trạng da, lông, tai, mắt và vệ sinh răng miệng',
                'Xử lý các búi lông vón cục lâu ngày bằng xịt dưỡng mượt chuyên dụng',
                'Tắm sạch sâu bằng sữa tắm yến mạch dịu nhẹ lành tính cho da',
                'Tư vấn chế độ dinh dưỡng và lịch chăm sóc lông định kỳ tại nhà'
            ],
            tiers: [
                { label: 'Bé dưới 5 kg', price: '180.000 đ' },
                { label: 'Bé từ 5 - 10 kg', price: '250.000 đ' },
                { label: 'Bé trên 10 kg', price: '320.000 đ' }
            ]
        },
        'Combo Chăm Sóc Toàn Diện & Lưu Trú VIP': {
            items: [
                'Trọn gói 9 bước: Tắm thảo mộc + Cắt tỉa tạo kiểu + Ủ dưỡng Collagen',
                'Vệ sinh tai, mài móng, vắt tuyến hôi & chải răng thơm miệng',
                'Ưu đãi phòng nghỉ VIP điều hòa 24/7 có camera trực tuyến Full HD',
                'Tặng kèm phụ kiện nơ/khăn cổ thiết kế & lưu album ảnh HD cho bé'
            ],
            tiers: [
                { label: 'Combo Spa + Grooming Trọn Gói (-20%)', price: '390.000 đ' },
                { label: 'Combo Spa + Lưu trú VIP Villa (1 ngày)', price: '490.000 đ' }
            ]
        }
    };

    const serviceCards = document.querySelectorAll('.service-price-card[data-category]');

    function setCardExpanded(card, expanded) {
        const toggleSpan = card.querySelector('.spc-drawer-toggle-text');
        const toggleBtn = card.querySelector('.spc-drawer-toggle');
        if (expanded) {
            card.classList.add('is-expanded');
            if (toggleSpan) toggleSpan.textContent = 'Thu gọn chi tiết';
            if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'true');
        } else {
            card.classList.remove('is-expanded');
            if (toggleSpan) toggleSpan.textContent = 'Xem chi tiết';
            if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'false');
        }
    }

    serviceCards.forEach(function (card) {
        const titleEl = card.querySelector('h3');
        const footerEl = card.querySelector('.spc-footer');
        if (!titleEl || !footerEl) return;

        const titleText = titleEl.textContent.replace(/\s+/g, ' ').trim();
        const detail = SERVICE_DETAILS[titleText];

        if (!card.querySelector('.spc-drawer-wrap') && detail) {
            const toggleBtn = document.createElement('button');
            toggleBtn.type = 'button';
            toggleBtn.className = 'spc-drawer-toggle';
            toggleBtn.setAttribute('aria-expanded', 'false');
            toggleBtn.innerHTML =
                '<span class="spc-drawer-toggle-text">Xem chi tiết</span>' +
                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">' +
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
                '    <div class="spc-drawer-title">Quy trình &amp; Hạng mục bao gồm</div>' +
                '    <ul class="spc-drawer-list">' + itemsHtml + '</ul>' +
                '    <div class="spc-drawer-tiers">' + tiersHtml + '</div>' +
                '  </div>' +
                '</div>';

            card.insertBefore(toggleBtn, footerEl);
            card.insertBefore(drawerWrap, footerEl);
        }

        card.addEventListener('click', function (e) {
            if (e.target.closest('[data-open-booking]')) {
                return;
            }
            const isExpanded = card.classList.contains('is-expanded');
            setCardExpanded(card, !isExpanded);
        });
    });

    // 4. Category Filter Tabs for Services Section
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
                    card.style.animationDelay = (visibleIndex * 60) + 'ms';
                    void card.offsetWidth;
                    card.classList.add('is-pulling-out');
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

    // 5. Booking Modal Trigger & Pre-selection
    const modal = document.getElementById('bookingModal');
    const closeBtn = document.getElementById('closeModalBtn');
    const serviceSelect = document.getElementById('modalServiceName');
    const branchSelect = document.getElementById('branch');
    const modalTriggers = document.querySelectorAll('[data-open-booking]');

    modalTriggers.forEach(function (trigger) {
        trigger.addEventListener('click', function (e) {
            e.preventDefault();
            const srv = trigger.getAttribute('data-open-booking');
            const br = trigger.getAttribute('data-booking-branch');

            if (serviceSelect && srv) {
                for (let i = 0; i < serviceSelect.options.length; i++) {
                    const optVal = serviceSelect.options[i].value.toLowerCase();
                    const targetVal = srv.toLowerCase();
                    if (optVal.indexOf(targetVal) !== -1 || targetVal.indexOf(optVal) !== -1) {
                        serviceSelect.selectedIndex = i;
                        break;
                    }
                }
            }

            if (branchSelect && br) {
                for (let i = 0; i < branchSelect.options.length; i++) {
                    if (branchSelect.options[i].value.indexOf(br) !== -1) {
                        branchSelect.selectedIndex = i;
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
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.classList.contains('open')) {
                modal.classList.remove('open');
            }
        });
    }

    // 6. Static Preview Form Submission Handler
    const staticAlert = document.getElementById('bookingSuccessStatic');
    const modalForm = document.getElementById('petcareBookingForm');
    if (staticAlert && modalForm && modalForm.getAttribute('data-static-preview') === 'true') {
        modalForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const owner = document.getElementById('ownerName').value;
            const phone = document.getElementById('phone').value;
            const pet = document.getElementById('petName').value;
            const service = document.getElementById('modalServiceName').value;
            const branch = document.getElementById('branch').value;
            staticAlert.innerHTML =
                '<strong>✓ Đã giữ chỗ 15 phút cho bé ' + pet + '!</strong><br/>' +
                'Cảm ơn <b>' + owner + '</b> (' + phone + '). Hệ thống <b>Pet care</b> tại cơ sở <b>' + branch + '</b> đã ghi nhận lịch hẹn gói <b>' + service + '</b>.';
            staticAlert.style.display = 'block';
        });
    }
});
