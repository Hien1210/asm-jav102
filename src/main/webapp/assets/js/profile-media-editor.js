(function () {
    "use strict";

    var modal = document.getElementById("pfMediaModal");
    if (!modal) return;

    var ctx = document.body.getAttribute("data-ctx") || "";
    var mediaEndpoint = ctx + "/profile/media";

    /* Modal elements */
    var titleEl = document.getElementById("pfMediaTitle");
    var subEl = document.getElementById("pfMediaSub");
    var fileInput = document.getElementById("pfMediaFileInput");
    var dropzone = document.getElementById("pfMediaDropzone");
    var editorWrap = document.getElementById("pfMediaEditorWrap");
    var stageEl = document.getElementById("pfCropStage");
    var canvas = document.getElementById("pfCropCanvas");
    var c2d = canvas ? canvas.getContext("2d") : null;
    var previewCanvas = document.getElementById("pfLivePreviewCanvas");
    var previewCtx = previewCanvas ? previewCanvas.getContext("2d") : null;
    var previewWrap = document.getElementById("pfLivePreviewWrap");

    var zoomSlider = document.getElementById("pfZoomRange");
    var zoomVal = document.getElementById("pfZoomVal");
    var rotateSlider = document.getElementById("pfRotateRange");
    var rotateVal = document.getElementById("pfRotateVal");
    var brightSlider = document.getElementById("pfBrightRange");
    var brightVal = document.getElementById("pfBrightVal");
    var contrastSlider = document.getElementById("pfContrastRange");
    var contrastVal = document.getElementById("pfContrastVal");

    var btnChooseAnother = document.getElementById("pfBtnChooseAnother");
    var btnRemove = document.getElementById("pfBtnRemoveMedia");
    var btnSave = document.getElementById("pfBtnSaveMedia");
    var btnCancel = document.getElementById("pfBtnCancelMedia");
    var btnReset = document.getElementById("pfBtnResetCrop");
    var btnCenter = document.getElementById("pfBtnCenterCrop");
    var btnRotLeft = document.getElementById("pfBtnRotLeft");
    var btnRotRight = document.getElementById("pfBtnRotRight");
    var btnFlipH = document.getElementById("pfBtnFlipH");
    var btnFlipV = document.getElementById("pfBtnFlipV");
    var btnZoomIn = document.getElementById("pfBtnZoomIn");
    var btnZoomOut = document.getElementById("pfBtnZoomOut");
    var errorEl = document.getElementById("pfMediaError");
    var posReadout = document.getElementById("pfPosReadout");

    var MODES = {
        avatar: {
            title: "Chỉnh sửa ảnh đại diện",
            sub: "Kéo thả, phóng to/thu nhỏ, xoay và canh khung vuông chuẩn trước khi lưu lên Cloudinary.",
            cropW: 260,
            cropH: 260,
            stageW: 480,
            stageH: 340,
            exportW: 512,
            exportH: 512,
            radius: 68,
            previewW: 76,
            previewH: 76
        },
        banner: {
            title: "Chỉnh sửa ảnh bìa hồ sơ",
            sub: "Canh chi tiết vị trí, góc xoay và ánh sáng cho ảnh bìa ngang trước khi tải lên Cloudinary.",
            cropW: 480,
            cropH: 112,
            stageW: 540,
            stageH: 300,
            exportW: 1600,
            exportH: 374,
            radius: 16,
            previewW: 240,
            previewH: 56
        }
    };

    var state = {
        type: "avatar",
        img: null,
        baseScale: 1,
        zoom: 1,
        rotBase: 0,      // multiples of 90
        rotFine: 0,      // -45..45
        flipH: false,
        flipV: false,
        brightness: 100,
        contrast: 100,
        offsetX: 0,      // in stage pixels relative to crop center
        offsetY: 0,
        dragging: false,
        dragStartX: 0,
        dragStartY: 0,
        startOffsetX: 0,
        startOffsetY: 0,
        uploading: false
    };

    function currentMode() {
        return MODES[state.type] || MODES.avatar;
    }

    function showError(msg) {
        if (!errorEl) return;
        if (!msg) {
            errorEl.hidden = true;
            errorEl.textContent = "";
        } else {
            errorEl.textContent = msg;
            errorEl.hidden = false;
        }
    }

    function hasCurrentMedia(type) {
        var card = document.querySelector(".pf-identity-card");
        if (!card) return false;
        var val = card.getAttribute(type === "avatar" ? "data-avatar-url" : "data-banner-url");
        return !!(val && val.trim());
    }

    function openModal(type) {
        state.type = (type === "banner") ? "banner" : "avatar";
        state.img = null;
        state.uploading = false;
        resetTransformState();
        showError("");

        var cfg = currentMode();
        if (titleEl) titleEl.textContent = cfg.title;
        if (subEl) subEl.textContent = cfg.sub;

        modal.setAttribute("data-media-type", state.type);
        if (c2d && canvas) c2d.clearRect(0, 0, canvas.width, canvas.height);
        if (previewCtx && previewCanvas) previewCtx.clearRect(0, 0, previewCanvas.width, previewCanvas.height);
        if (dropzone) dropzone.hidden = false;
        if (editorWrap) editorWrap.hidden = true;
        if (btnChooseAnother) btnChooseAnother.hidden = true;
        if (btnSave) {
            btnSave.disabled = true;
            btnSave.classList.remove("is-loading");
            btnSave.querySelector("span").textContent = "Lưu & tải lên Cloudinary";
        }
        if (btnRemove) {
            btnRemove.hidden = !hasCurrentMedia(state.type);
            btnRemove.disabled = false;
        }
        if (fileInput) fileInput.value = "";

        modal.hidden = false;
        document.body.classList.add("pf-modal-open");
        requestAnimationFrame(function () {
            modal.classList.add("is-open");
        });
    }

    function closeModal() {
        if (state.uploading) return;
        modal.classList.remove("is-open");
        document.body.classList.remove("pf-modal-open");
        setTimeout(function () {
            if (!modal.classList.contains("is-open")) {
                modal.hidden = true;
            }
        }, 180);
    }

    function resetTransformState() {
        state.zoom = 1;
        state.rotBase = 0;
        state.rotFine = 0;
        state.flipH = false;
        state.flipV = false;
        state.brightness = 100;
        state.contrast = 100;
        state.offsetX = 0;
        state.offsetY = 0;
        syncControlsFromState();
    }

    function syncControlsFromState() {
        if (zoomSlider) zoomSlider.value = String(Math.round(state.zoom * 100));
        if (zoomVal) zoomVal.textContent = Math.round(state.zoom * 100) + "%";
        if (rotateSlider) rotateSlider.value = String(state.rotFine);
        var totalRot = state.rotBase + state.rotFine;
        if (rotateVal) rotateVal.textContent = (totalRot > 0 ? "+" : "") + totalRot + "°";
        if (brightSlider) brightSlider.value = String(state.brightness);
        if (brightVal) brightVal.textContent = state.brightness + "%";
        if (contrastSlider) contrastSlider.value = String(state.contrast);
        if (contrastVal) contrastVal.textContent = state.contrast + "%";
        if (btnFlipH) btnFlipH.classList.toggle("is-active", state.flipH);
        if (btnFlipV) btnFlipV.classList.toggle("is-active", state.flipV);
        if (posReadout) {
            posReadout.textContent = "X: " + Math.round(state.offsetX) + "px · Y: " + Math.round(state.offsetY) + "px";
        }
    }

    function computeBaseScale(img) {
        var cfg = currentMode();
        var rotated90 = Math.abs(state.rotBase % 180) === 90;
        var iw = rotated90 ? img.naturalHeight : img.naturalWidth;
        var ih = rotated90 ? img.naturalWidth : img.naturalHeight;
        // Cover the crop frame completely at zoom = 1
        return Math.max(cfg.cropW / iw, cfg.cropH / ih);
    }

    function loadFile(file) {
        showError("");
        if (!file) return;
        if (!/^image\/(jpeg|png|webp|gif)$/i.test(file.type)) {
            showError("Định dạng không hỗ trợ. Vui lòng chọn ảnh JPG, PNG, WebP hoặc GIF.");
            return;
        }
        if (file.size > 8 * 1024 * 1024) {
            showError("Ảnh vượt quá dung lượng tối đa 8 MB. Vui lòng chọn ảnh nhẹ hơn.");
            return;
        }

        var reader = new FileReader();
        reader.onload = function (ev) {
            var img = new Image();
            img.onload = function () {
                state.img = img;
                resetTransformState();
                state.baseScale = computeBaseScale(img);
                configureCanvasSizes();
                if (dropzone) dropzone.hidden = true;
                if (editorWrap) editorWrap.hidden = false;
                if (btnChooseAnother) btnChooseAnother.hidden = false;
                if (btnSave) btnSave.disabled = false;
                renderAll();
            };
            img.onerror = function () {
                showError("Không thể đọc tệp ảnh này. Vui lòng thử ảnh khác.");
            };
            img.src = ev.target.result;
        };
        reader.readAsDataURL(file);
    }

    function configureCanvasSizes() {
        if (!canvas || !previewCanvas) return;
        var cfg = currentMode();
        var dpr = Math.min(window.devicePixelRatio || 1, 2);
        canvas.width = cfg.stageW * dpr;
        canvas.height = cfg.stageH * dpr;
        canvas.style.aspectRatio = cfg.stageW + " / " + cfg.stageH;

        previewCanvas.width = cfg.previewW * dpr;
        previewCanvas.height = cfg.previewH * dpr;
        if (previewWrap) {
            previewWrap.classList.toggle("is-banner", state.type === "banner");
        }
    }

    function drawTransformedImage(targetCtx, img, centerX, centerY, scale) {
        var totalRad = ((state.rotBase + state.rotFine) * Math.PI) / 180;
        targetCtx.save();
        targetCtx.translate(centerX, centerY);
        targetCtx.rotate(totalRad);
        targetCtx.scale(state.flipH ? -1 : 1, state.flipV ? -1 : 1);
        if ("filter" in targetCtx) {
            targetCtx.filter = "brightness(" + state.brightness + "%) contrast(" + state.contrast + "%)";
        }
        var dw = img.naturalWidth * scale;
        var dh = img.naturalHeight * scale;
        targetCtx.drawImage(img, -dw / 2, -dh / 2, dw, dh);
        targetCtx.restore();
    }

    function traceRoundedRect(ctx2, x, y, w, h, r) {
        var rr = Math.min(r, w / 2, h / 2);
        ctx2.moveTo(x + rr, y);
        ctx2.arcTo(x + w, y, x + w, y + h, rr);
        ctx2.arcTo(x + w, y + h, x, y + h, rr);
        ctx2.arcTo(x, y + h, x, y, rr);
        ctx2.arcTo(x, y, x + w, y, rr);
        ctx2.closePath();
    }

    function renderAll() {
        if (!state.img || !c2d) return;
        var cfg = currentMode();
        var dpr = Math.min(window.devicePixelRatio || 1, 2);
        var sw = cfg.stageW;
        var sh = cfg.stageH;
        var cropX = (sw - cfg.cropW) / 2;
        var cropY = (sh - cfg.cropH) / 2;
        var scale = state.baseScale * state.zoom;

        c2d.save();
        c2d.setTransform(dpr, 0, 0, dpr, 0, 0);
        c2d.clearRect(0, 0, sw, sh);

        // Dark studio background
        c2d.fillStyle = "#0b1412";
        c2d.fillRect(0, 0, sw, sh);

        // Draw transformed image
        drawTransformedImage(c2d, state.img, sw / 2 + state.offsetX, sh / 2 + state.offsetY, scale);

        // Outer dim mask with bright cutout matching crop frame
        c2d.save();
        c2d.fillStyle = "rgba(5, 14, 11, 0.64)";
        c2d.beginPath();
        c2d.rect(0, 0, sw, sh);
        traceRoundedRect(c2d, cropX, cropY, cfg.cropW, cfg.cropH, cfg.radius);
        c2d.fill("evenodd");
        c2d.restore();

        // Crisp crop border & rule-of-thirds gridlines
        c2d.save();
        c2d.beginPath();
        traceRoundedRect(c2d, cropX, cropY, cfg.cropW, cfg.cropH, cfg.radius);
        c2d.clip();

        c2d.strokeStyle = state.dragging ? "rgba(255,255,255,0.52)" : "rgba(255,255,255,0.28)";
        c2d.lineWidth = 1;
        c2d.beginPath();
        for (var i = 1; i <= 2; i++) {
            var gx = cropX + (cfg.cropW * i) / 3;
            var gy = cropY + (cfg.cropH * i) / 3;
            c2d.moveTo(gx, cropY);
            c2d.lineTo(gx, cropY + cfg.cropH);
            c2d.moveTo(cropX, gy);
            c2d.lineTo(cropX + cfg.cropW, gy);
        }
        c2d.stroke();
        c2d.restore();

        // Crop frame outline
        c2d.beginPath();
        traceRoundedRect(c2d, cropX + 0.75, cropY + 0.75, cfg.cropW - 1.5, cfg.cropH - 1.5, cfg.radius);
        c2d.strokeStyle = "rgba(255, 255, 255, 0.94)";
        c2d.lineWidth = 2;
        c2d.stroke();

        // Center crosshair dot when dragging
        if (state.dragging) {
            c2d.fillStyle = "rgba(52, 211, 153, 0.9)";
            c2d.beginPath();
            c2d.arc(sw / 2, sh / 2, 3, 0, Math.PI * 2);
            c2d.fill();
        }
        c2d.restore();

        // Render real-time live context thumbnail
        if (previewCtx) {
            var ratioX = cfg.previewW / cfg.cropW;
            var ratioY = cfg.previewH / cfg.cropH;
            previewCtx.save();
            previewCtx.setTransform(dpr, 0, 0, dpr, 0, 0);
            previewCtx.clearRect(0, 0, cfg.previewW, cfg.previewH);
            previewCtx.fillStyle = "#075c45";
            previewCtx.fillRect(0, 0, cfg.previewW, cfg.previewH);
            drawTransformedImage(
                previewCtx,
                state.img,
                cfg.previewW / 2 + state.offsetX * ratioX,
                cfg.previewH / 2 + state.offsetY * ratioY,
                scale * ratioX
            );
            previewCtx.restore();
        }

        syncControlsFromState();
    }

    function exportCroppedBlob(callback) {
        if (!state.img) return;
        var cfg = currentMode();
        var out = document.createElement("canvas");
        out.width = cfg.exportW;
        out.height = cfg.exportH;
        var octx = out.getContext("2d");

        octx.fillStyle = "#075c45";
        octx.fillRect(0, 0, cfg.exportW, cfg.exportH);

        var exportRatio = cfg.exportW / cfg.cropW;
        var scale = state.baseScale * state.zoom * exportRatio;
        drawTransformedImage(
            octx,
            state.img,
            cfg.exportW / 2 + state.offsetX * exportRatio,
            cfg.exportH / 2 + state.offsetY * exportRatio,
            scale
        );

        out.toBlob(function (blob) {
            callback(blob);
        }, "image/jpeg", 0.92);
    }

    /* Update live DOM after upload/remove without losing unsaved form input */
    function applyMediaToPage(type, url) {
        var card = document.querySelector(".pf-identity-card");
        if (card) {
            card.setAttribute(type === "avatar" ? "data-avatar-url" : "data-banner-url", url || "");
        }
        if (type === "avatar") {
            var initial = card ? (card.getAttribute("data-user-initial") || "U") : "U";
            var targets = document.querySelectorAll("[data-pf-avatar-slot]");
            targets.forEach(function (el) {
                var existingImg = el.querySelector("img");
                var textNode = el.querySelector("[data-pf-avatar-letter]");
                if (url) {
                    if (!existingImg) {
                        existingImg = document.createElement("img");
                        existingImg.alt = "Ảnh đại diện";
                        existingImg.className = "pf-avatar-img";
                        el.appendChild(existingImg);
                    }
                    existingImg.src = url;
                    el.classList.add("has-photo");
                    if (textNode) textNode.hidden = true;
                } else {
                    if (existingImg) existingImg.remove();
                    el.classList.remove("has-photo");
                    if (textNode) {
                        textNode.textContent = initial;
                        textNode.hidden = false;
                    }
                }
            });
        } else {
            var cover = document.getElementById("pfCoverBanner");
            if (cover) {
                var bgImg = cover.querySelector(".pf-cover-photo");
                if (url) {
                    if (!bgImg) {
                        bgImg = document.createElement("img");
                        bgImg.alt = "Ảnh bìa hồ sơ";
                        bgImg.className = "pf-cover-photo";
                        cover.insertBefore(bgImg, cover.firstChild);
                    }
                    bgImg.src = url;
                    cover.classList.add("has-banner-photo");
                } else {
                    if (bgImg) bgImg.remove();
                    cover.classList.remove("has-banner-photo");
                }
            }
        }
    }

    function showPageToast(message, isError) {
        var existing = document.getElementById("pfMediaDynamicAlert");
        if (existing) existing.remove();

        var identityCard = document.querySelector(".pf-identity-card");
        if (!identityCard || !identityCard.parentNode) return;

        var box = document.createElement("div");
        box.id = "pfMediaDynamicAlert";
        box.className = "pf-alert " + (isError ? "pf-alert-error" : "pf-alert-success");
        box.setAttribute("role", isError ? "alert" : "status");

        var content = document.createElement("div");
        content.className = "pf-alert-content";
        var icon = document.createElement("span");
        icon.className = "pf-alert-icon";
        icon.setAttribute("aria-hidden", "true");
        icon.innerHTML = isError
            ? '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>'
            : '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>';
        var span = document.createElement("span");
        span.textContent = message;
        content.appendChild(icon);
        content.appendChild(span);

        var closeBtn = document.createElement("button");
        closeBtn.type = "button";
        closeBtn.className = "pf-alert-close";
        closeBtn.setAttribute("aria-label", "Đóng thông báo");
        closeBtn.innerHTML = '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>';
        closeBtn.addEventListener("click", function () { box.remove(); });

        box.appendChild(content);
        box.appendChild(closeBtn);
        identityCard.parentNode.insertBefore(box, identityCard.nextSibling);
    }

    function setBusy(busy, labelText) {
        state.uploading = busy;
        if (btnSave) {
            btnSave.disabled = busy || !state.img;
            btnSave.classList.toggle("is-loading", busy);
            var sp = btnSave.querySelector("span");
            if (sp && labelText) sp.textContent = labelText;
        }
        if (btnCancel) btnCancel.disabled = busy;
        if (btnRemove) btnRemove.disabled = busy;
        if (btnChooseAnother) btnChooseAnother.disabled = busy;
    }

    /* Event bindings: Open Triggers */
    document.querySelectorAll("[data-open-media-editor]").forEach(function (trigger) {
        trigger.addEventListener("click", function (e) {
            e.preventDefault();
            openModal(trigger.getAttribute("data-open-media-editor"));
        });
    });

    /* Close triggers */
    document.querySelectorAll("[data-close-media-modal]").forEach(function (el) {
        el.addEventListener("click", closeModal);
    });
    document.addEventListener("keydown", function (e) {
        if (modal.hidden) return;
        if (e.key === "Escape") {
            closeModal();
            return;
        }
        // Fine arrow-key pixel nudging when image is loaded
        if (state.img && !state.uploading && document.activeElement.tagName !== "INPUT") {
            var step = e.shiftKey ? 10 : 2;
            if (e.key === "ArrowLeft")  { e.preventDefault(); state.offsetX -= step; renderAll(); }
            if (e.key === "ArrowRight") { e.preventDefault(); state.offsetX += step; renderAll(); }
            if (e.key === "ArrowUp")    { e.preventDefault(); state.offsetY -= step; renderAll(); }
            if (e.key === "ArrowDown")  { e.preventDefault(); state.offsetY += step; renderAll(); }
        }
    });

    /* File selection & drag-and-drop */
    if (fileInput) {
        fileInput.addEventListener("change", function () {
            if (fileInput.files && fileInput.files[0]) {
                loadFile(fileInput.files[0]);
            }
        });
    }
    if (dropzone) {
        dropzone.addEventListener("click", function () {
            if (fileInput) fileInput.click();
        });
        dropzone.addEventListener("keydown", function (e) {
            if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                if (fileInput) fileInput.click();
            }
        });
        ["dragenter", "dragover"].forEach(function (evtName) {
            dropzone.addEventListener(evtName, function (e) {
                e.preventDefault();
                dropzone.classList.add("is-dragover");
            });
        });
        ["dragleave", "drop"].forEach(function (evtName) {
            dropzone.addEventListener(evtName, function (e) {
                e.preventDefault();
                dropzone.classList.remove("is-dragover");
            });
        });
        dropzone.addEventListener("drop", function (e) {
            if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]) {
                loadFile(e.dataTransfer.files[0]);
            }
        });
    }
    if (btnChooseAnother) {
        btnChooseAnother.addEventListener("click", function () {
            if (fileInput) fileInput.click();
        });
    }

    /* Pointer Drag + Wheel Zoom on Canvas */
    if (canvas) {
        canvas.addEventListener("pointerdown", function (e) {
            if (!state.img || state.uploading) return;
            state.dragging = true;
            canvas.setPointerCapture(e.pointerId);
            state.dragStartX = e.clientX;
            state.dragStartY = e.clientY;
            state.startOffsetX = state.offsetX;
            state.startOffsetY = state.offsetY;
            if (stageEl) stageEl.classList.add("is-dragging");
            renderAll();
        });
        canvas.addEventListener("pointermove", function (e) {
            if (!state.dragging || !state.img) return;
            var rect = canvas.getBoundingClientRect();
            var cfg = currentMode();
            var scaleRatio = cfg.stageW / Math.max(rect.width, 1);
            state.offsetX = state.startOffsetX + (e.clientX - state.dragStartX) * scaleRatio;
            state.offsetY = state.startOffsetY + (e.clientY - state.dragStartY) * scaleRatio;
            renderAll();
        });
        var endDrag = function () {
            if (!state.dragging) return;
            state.dragging = false;
            if (stageEl) stageEl.classList.remove("is-dragging");
            renderAll();
        };
        canvas.addEventListener("pointerup", endDrag);
        canvas.addEventListener("pointercancel", endDrag);

        canvas.addEventListener("wheel", function (e) {
            if (!state.img || state.uploading) return;
            e.preventDefault();
            var delta = e.deltaY < 0 ? 0.08 : -0.08;
            state.zoom = Math.min(3, Math.max(1, +(state.zoom + delta).toFixed(2)));
            renderAll();
        }, { passive: false });
    }

    /* Sliders & Studio Buttons */
    if (zoomSlider) {
        zoomSlider.addEventListener("input", function () {
            state.zoom = Math.min(3, Math.max(1, parseInt(zoomSlider.value, 10) / 100));
            renderAll();
        });
    }
    if (btnZoomIn) {
        btnZoomIn.addEventListener("click", function () {
            state.zoom = Math.min(3, +(state.zoom + 0.1).toFixed(2));
            renderAll();
        });
    }
    if (btnZoomOut) {
        btnZoomOut.addEventListener("click", function () {
            state.zoom = Math.max(1, +(state.zoom - 0.1).toFixed(2));
            renderAll();
        });
    }
    if (rotateSlider) {
        rotateSlider.addEventListener("input", function () {
            state.rotFine = parseInt(rotateSlider.value, 10) || 0;
            renderAll();
        });
    }
    if (btnRotLeft) {
        btnRotLeft.addEventListener("click", function () {
            state.rotBase = (state.rotBase - 90) % 360;
            if (state.img) state.baseScale = computeBaseScale(state.img);
            renderAll();
        });
    }
    if (btnRotRight) {
        btnRotRight.addEventListener("click", function () {
            state.rotBase = (state.rotBase + 90) % 360;
            if (state.img) state.baseScale = computeBaseScale(state.img);
            renderAll();
        });
    }
    if (btnFlipH) {
        btnFlipH.addEventListener("click", function () {
            state.flipH = !state.flipH;
            renderAll();
        });
    }
    if (btnFlipV) {
        btnFlipV.addEventListener("click", function () {
            state.flipV = !state.flipV;
            renderAll();
        });
    }
    if (brightSlider) {
        brightSlider.addEventListener("input", function () {
            state.brightness = parseInt(brightSlider.value, 10) || 100;
            renderAll();
        });
    }
    if (contrastSlider) {
        contrastSlider.addEventListener("input", function () {
            state.contrast = parseInt(contrastSlider.value, 10) || 100;
            renderAll();
        });
    }
    if (btnCenter) {
        btnCenter.addEventListener("click", function () {
            state.offsetX = 0;
            state.offsetY = 0;
            renderAll();
        });
    }
    if (btnReset) {
        btnReset.addEventListener("click", function () {
            resetTransformState();
            if (state.img) state.baseScale = computeBaseScale(state.img);
            renderAll();
        });
    }
    /* Fine nudge buttons */
    document.querySelectorAll("[data-nudge]").forEach(function (btn) {
        btn.addEventListener("click", function () {
            if (!state.img) return;
            var dir = btn.getAttribute("data-nudge");
            if (dir === "up") state.offsetY -= 6;
            if (dir === "down") state.offsetY += 6;
            if (dir === "left") state.offsetX -= 6;
            if (dir === "right") state.offsetX += 6;
            renderAll();
        });
    });

    /* Upload Cropped Image -> /profile/media -> Cloudinary */
    if (btnSave) {
        btnSave.addEventListener("click", function () {
            if (!state.img || state.uploading) return;
            showError("");
            setBusy(true, "Đang tải lên Cloudinary...");

            exportCroppedBlob(function (blob) {
                if (!blob) {
                    setBusy(false, "Lưu & tải lên Cloudinary");
                    showError("Không thể xuất ảnh đã chỉnh sửa. Vui lòng thử lại.");
                    return;
                }
                var fd = new FormData();
                fd.append("action", "upload");
                fd.append("type", state.type);
                fd.append("file", blob, state.type + ".jpg");

                fetch(mediaEndpoint, {
                    method: "POST",
                    body: fd,
                    credentials: "same-origin"
                })
                    .then(function (resp) {
                        return resp.json().catch(function () {
                            return { ok: false, message: "Phản hồi máy chủ không hợp lệ (HTTP " + resp.status + ")." };
                        });
                    })
                    .then(function (data) {
                        if (data && data.ok) {
                            applyMediaToPage(state.type, data.url);
                            setBusy(false, "Lưu & tải lên Cloudinary");
                            closeModal();
                            showPageToast(data.message || "Cập nhật ảnh thành công!", false);
                        } else {
                            setBusy(false, "Lưu & tải lên Cloudinary");
                            showError((data && data.message) || "Không thể tải ảnh lên Cloudinary.");
                        }
                    })
                    .catch(function () {
                        setBusy(false, "Lưu & tải lên Cloudinary");
                        showError("Lỗi kết nối máy chủ khi tải ảnh lên Cloudinary.");
                    });
            });
        });
    }

    /* Remove / Restore default */
    if (btnRemove) {
        btnRemove.addEventListener("click", function () {
            if (state.uploading) return;
            showError("");
            setBusy(true, "Đang khôi phục...");

            var fd = new FormData();
            fd.append("action", "remove");
            fd.append("type", state.type);

            fetch(mediaEndpoint, {
                method: "POST",
                body: fd,
                credentials: "same-origin"
            })
                .then(function (resp) {
                    return resp.json().catch(function () {
                        return { ok: false, message: "Không thể xóa ảnh lúc này." };
                    });
                })
                .then(function (data) {
                    if (data && data.ok) {
                        applyMediaToPage(state.type, "");
                        setBusy(false, "Lưu & tải lên Cloudinary");
                        closeModal();
                        showPageToast(data.message || "Đã khôi phục mặc định.", false);
                    } else {
                        setBusy(false, "Lưu & tải lên Cloudinary");
                        showError((data && data.message) || "Không thể xóa ảnh.");
                    }
                })
                .catch(function () {
                    setBusy(false, "Lưu & tải lên Cloudinary");
                    showError("Lỗi kết nối khi khôi phục ảnh mặc định.");
                });
        });
    }
})();
