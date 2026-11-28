/* Progressive enhancement: real forms move into native dialogs, never cloned. */
(() => {
    if (!('HTMLDialogElement' in window)) return;
    const registry = new Map();
    const context = document.querySelector('#popup-error-context')?.dataset;
    let serial = 0;
    for (const editor of document.querySelectorAll('[data-popup-editor]')) {
        const dialog = document.createElement('dialog');
        dialog.className = 'workspace-dialog';
        const headingId = `workspace-dialog-title-${++serial}`;
        dialog.setAttribute('aria-labelledby', headingId);
        const header = document.createElement('div');
        header.className = 'workspace-dialog-header';
        const heading = document.createElement('h2');
        heading.id = headingId;
        heading.textContent = editor.dataset.popupTitle || 'Chỉnh sửa thông tin';
        const close = document.createElement('button');
        close.type = 'button';
        close.className = 'workspace-dialog-close';
        close.textContent = '×';
        close.setAttribute('aria-label', 'Đóng biểu mẫu');
        header.append(heading, close);
        const body = document.createElement('div');
        body.className = 'workspace-dialog-body';
        dialog.append(header, body);
        document.body.append(dialog);
        const isDetails = editor.tagName === 'DETAILS';
        let trigger;
        if (isDetails) {
            const summary = editor.querySelector(':scope > summary');
            trigger = document.createElement('button');
            trigger.type = 'button';
            trigger.className = 'button secondary btn btn-ghost popup-trigger';
            trigger.textContent = summary?.querySelector('strong')?.textContent || summary?.textContent.trim() || heading.textContent;
            trigger.setAttribute('aria-haspopup', 'dialog');
            editor.before(trigger);
            for (const child of [...editor.children]) if (child !== summary) body.append(child);
            editor.hidden = true;
        } else {
            body.append(editor);
            document.body.classList.add('has-popup-editor');
        }
        let returnFocus = trigger;
        const open = opener => {
            returnFocus = opener || document.activeElement;
            if (dialog.open) return;
            dialog.showModal();
            document.body.classList.add('workspace-dialog-open');
            const field = body.querySelector('input:not([type=hidden]),select,textarea');
            field?.focus({ preventScroll: true });
        };
        const dismiss = () => dialog.close();
        close.addEventListener('click', dismiss);
        dialog.addEventListener('click', event => {
            if (event.target !== dialog) return;
            const box = dialog.getBoundingClientRect();
            if (event.clientX < box.left || event.clientX > box.right || event.clientY < box.top || event.clientY > box.bottom) dismiss();
        });
        dialog.addEventListener('close', () => {
            document.body.classList.remove('workspace-dialog-open');
            returnFocus?.focus({ preventScroll: true });
        });
        trigger?.addEventListener('click', () => open(trigger));
        if (editor.id) registry.set(editor.id, open);
        const form = body.querySelector('form');
        const action = form?.querySelector('[name=action]')?.value;
        const record = form?.querySelector('[name=userId]')?.value || '';
        const matchingError = context?.error === 'true' && context.action === action && context.record === record;
        const auto = editor.dataset.popupAuto === 'true' || matchingError;
        if (matchingError) {
            for (const [name, value] of Object.entries({ fullName: context.fullName, email: context.email, phone: context.phone, role: context.role })) {
                const field = form.elements.namedItem(name);
                if (field && value !== undefined) field.value = value;
            }
        }
        if (auto) {
            const alert = document.querySelector('main [role=alert]');
            if (alert) {
                const message = document.createElement('p');
                message.className = 'alert alert-error';
                message.setAttribute('role', 'alert');
                message.textContent = alert.textContent;
                body.prepend(message);
            }
            open();
        }
    }
    document.addEventListener('click', event => {
        const link = event.target.closest('a[href]');
        if (!link) return;
        const url = new URL(link.href, location.href);
        if (url.origin !== location.origin || url.pathname !== location.pathname || url.search !== location.search || url.hash !== '#editor') return;
        const open = registry.get('editor');
        if (open) { event.preventDefault(); open(link); }
    }, true);
    if (location.hash === '#editor') registry.get('editor')?.();
})();
