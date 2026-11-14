(function () {
    document.addEventListener('click', function (event) {
        var btn = event.target.closest('.pw-toggle-btn');
        if (!btn) {
            return;
        }

        var wrapper = btn.closest('.input-wrapper');
        if (!wrapper) {
            return;
        }

        var input = wrapper.querySelector('input');
        if (!input) {
            return;
        }

        var showPassword = input.type === 'password';
        input.type = showPassword ? 'text' : 'password';

        btn.classList.toggle('is-visible', showPassword);
        btn.setAttribute('aria-pressed', showPassword ? 'true' : 'false');

        var label = showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu';
        btn.setAttribute('aria-label', label);
        btn.setAttribute('title', label);
    });
})();
