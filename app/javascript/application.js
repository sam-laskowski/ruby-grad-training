// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import "trix";
import "@rails/actiontext";

import * as bootstrap from "bootstrap";

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

document.addEventListener("DOMContentLoaded", initToasts);
document.addEventListener("turbo:load", initToasts);