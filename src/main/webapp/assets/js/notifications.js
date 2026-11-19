(function () {
    "use strict";

    var body = document.body;
    var userId = body.getAttribute("data-user-id");
    if (!userId) {
        return; // Chua dang nhap -> khong ket noi WebSocket.
    }
    var contextPath = body.getAttribute("data-ctx") || "";

    var container = null;
    function ensureContainer() {
        if (container) {
            return container;
        }
        container = document.createElement("div");
        container.id = "pc-toast-container";
        container.style.position = "fixed";
        container.style.top = "90px";
        container.style.right = "20px";
        container.style.zIndex = "99999";
        container.style.display = "flex";
        container.style.flexDirection = "column";
        container.style.gap = "10px";
        container.style.maxWidth = "320px";
        document.body.appendChild(container);
        return container;
    }

    function escapeHtml(value) {
        return String(value == null ? "" : value).replace(/[&<>"]/g, function (c) {
            return { "&": "&amp;", "<": "&lt;", ">": "&gt;", "\"": "&quot;" }[c];
        });
    }

    function showToast(data) {
        var box = ensureContainer();
        var toast = document.createElement("div");
        toast.style.background = "#0f766e";
        toast.style.color = "#fff";
        toast.style.padding = "12px 16px";
        toast.style.borderRadius = "10px";
        toast.style.boxShadow = "0 8px 24px rgba(0,0,0,.18)";
        toast.style.fontFamily = "'Segoe UI', Arial, sans-serif";
        toast.style.fontSize = "14px";
        toast.style.lineHeight = "1.4";
        toast.style.opacity = "0";
        toast.style.transition = "opacity .3s";
        toast.innerHTML =
            '<strong style="display:block;margin-bottom:4px;">' + escapeHtml(data.title || "Thông báo") + "</strong>" +
            escapeHtml(data.message || "");
        box.appendChild(toast);
        requestAnimationFrame(function () { toast.style.opacity = "1"; });

        setTimeout(function () {
            toast.style.opacity = "0";
            setTimeout(function () { toast.remove(); }, 300);
        }, 7000);
    }

    var reconnectDelayMs = 3000;
    function connect() {
        var proto = window.location.protocol === "https:" ? "wss://" : "ws://";
        var url = proto + window.location.host + contextPath + "/ws/notifications";
        var socket;
        try {
            socket = new WebSocket(url);
        } catch (e) {
            return;
        }

        socket.onmessage = function (event) {
            try {
                showToast(JSON.parse(event.data));
            } catch (e) {
                // Bo qua payload khong hop le.
            }
        };
        socket.onclose = function () {
            setTimeout(connect, reconnectDelayMs);
        };
        socket.onerror = function () {
            socket.close();
        };
    }

    connect();
})();
