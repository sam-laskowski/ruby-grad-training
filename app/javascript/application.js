// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import { createConsumer } from "@rails/actioncable";

import "trix";
import "@rails/actiontext";

import * as bootstrap from "bootstrap";

const consumer = createConsumer();
let notificationsSubscription = null;

const initPopovers = () => {
  document.querySelectorAll('[data-bs-toggle="popover"]').forEach((popoverTriggerEl) => {
    bootstrap.Popover.getOrCreateInstance(popoverTriggerEl);
  });
};

const initToasts = () => {
  document.querySelectorAll(".toast").forEach((toastEl) => {
    const toast = bootstrap.Toast.getOrCreateInstance(toastEl, {
      delay: 3000,
      autohide: true,
    });

    if (toastEl.id === "liveToast") return;
    toast.show();
  });

  const toastTrigger = document.getElementById("liveToastBtn");
  const toastLiveExample = document.getElementById("liveToast");

  if (toastTrigger && toastLiveExample) {
    toastTrigger.onclick = () => {
      const toast = bootstrap.Toast.getOrCreateInstance(toastLiveExample, {
        delay: 3000,
        autohide: true,
      });
      toast.show();
    };
  }
};

const ensureToastContainer = () => {
  let container = document.getElementById("global-toast-container");
  if (container) return container;

  container = document.createElement("div");
  container.id = "global-toast-container";
  container.className = "toast-container position-fixed top-0 start-50 translate-middle-x p-3";
  container.style.zIndex = "9999";
  document.body.appendChild(container);

  return container;
};

const showLiveNotificationToast = (notification) => {
  if (!notification?.message) return;

  const container = ensureToastContainer();
  const toastEl = document.createElement("div");
  toastEl.className = "toast align-items-center text-bg-primary border-0";
  toastEl.role = "alert";
  toastEl.ariaLive = "assertive";
  toastEl.ariaAtomic = "true";

  const messageHtml = notification.link
    ? `<a href="${notification.link}" class="text-white text-decoration-underline">${notification.message}</a>`
    : notification.message;

  toastEl.innerHTML = `
    <div class="d-flex">
      <div class="toast-body">
        <i class="bi bi-bell-fill me-2"></i>${messageHtml}
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  `;

  container.appendChild(toastEl);

  const toast = bootstrap.Toast.getOrCreateInstance(toastEl, {
    delay: 4000,
    autohide: true,
  });

  toastEl.addEventListener("hidden.bs.toast", () => {
    toastEl.remove();
  });

  toast.show();
};

const updateNavbarRequestBadge = (pendingCount) => {
  const badge = document.getElementById("navbar-post-request-badge");
  if (!badge) return;

  const count = Number(pendingCount);
  if (!Number.isFinite(count) || count <= 0) {
    badge.classList.add("d-none");
    badge.textContent = "0";
    badge.dataset.count = "0";
    return;
  }

  badge.classList.remove("d-none");
  badge.textContent = String(count);
  badge.dataset.count = String(count);
};

const initNotificationsSubscription = () => {
  const body = document.body;
  const userId = body?.dataset?.currentUserId;

  if (!userId) {
    if (notificationsSubscription) {
      consumer.subscriptions.remove(notificationsSubscription);
      notificationsSubscription = null;
    }
    return;
  }

  if (notificationsSubscription) return;

  notificationsSubscription = consumer.subscriptions.create(
    { channel: "NotificationsChannel" },
    {
      received(data) {
        if (data?.notification_type === "request_received") {
          updateNavbarRequestBadge(data.pending_requests_count);
        }
        showLiveNotificationToast(data);
      },
    }
  );
};

document.addEventListener("DOMContentLoaded", initToasts);
document.addEventListener("turbo:load", initToasts);
document.addEventListener("DOMContentLoaded", initPopovers);
document.addEventListener("turbo:load", initPopovers);
document.addEventListener("DOMContentLoaded", initNotificationsSubscription);
document.addEventListener("turbo:load", initNotificationsSubscription);