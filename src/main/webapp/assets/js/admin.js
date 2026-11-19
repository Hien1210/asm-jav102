(() => {
    document.querySelectorAll('.delete-form').forEach(form => {
        form.addEventListener('submit', event => {
            if (!window.confirm('Xóa dữ liệu này? Thao tác không thể hoàn tác.')) event.preventDefault();
        });
    });

    const table = document.querySelector('#admin-table');
    const search = document.querySelector('#admin-search');
    const filter = document.querySelector('#admin-filter');
    const rows = table ? Array.from(table.querySelectorAll('tbody tr[data-record]')) : [];
    const normalize = text => text.toLocaleLowerCase('vi').normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd');
    if (table && search && filter) {
        const labels = Array.from(new Set(rows.map(row => row.dataset.filter).filter(Boolean))).sort((a, b) => a.localeCompare(b, 'vi'));
        labels.forEach(label => {
            const option = document.createElement('option');
            option.value = label;
            option.textContent = label;
            filter.append(option);
        });
        const indexedRows = rows.map(row => ({ row, text: normalize(row.textContent) }));
        const applyFilters = () => {
            const query = normalize(search.value.trim());
            let visible = 0;
            indexedRows.forEach(({ row, text }) => {
                const match = text.includes(query) && (!filter.value || row.dataset.filter === filter.value);
                row.hidden = !match;
                if (match) visible++;
            });
            const message = `${visible} / ${rows.length} bản ghi`;
            document.querySelector('.visible-count').textContent = message;
            document.querySelector('.search-result').textContent = `Hiển thị ${message}`;
            document.querySelector('.no-results').hidden = visible > 0 || rows.length === 0;
        };
        search.addEventListener('input', applyFilters);
        filter.addEventListener('change', applyFilters);
        applyFilters();
    }

    const openEditor = () => {
        const editor = document.querySelector('#editor');
        if (!editor) return;
        if (editor.tagName === 'DETAILS') editor.open = true;
        const input = editor.querySelector('input:not([type=hidden]), select');
        if (input) input.focus({ preventScroll: true });
    };
    document.querySelectorAll('a[href="#editor"]').forEach(link => link.addEventListener('click', event => { event.preventDefault(); openEditor(); document.querySelector('#editor').scrollIntoView({ block: 'start' }); }));
    if (location.hash === '#editor') openEditor();
})();