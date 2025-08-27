import { Controller } from "@hotwired/stimulus"

// Toggles a class on a target element to show/hide a mobile menu.
export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("is-active")
  }
}

