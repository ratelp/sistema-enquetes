import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = [ "content", "button" ]

  toggle() {
    const isHidden = this.contentTarget.classList.toggle("hidden")

    if (this.hasButtonTarget) {
      this.buttonTarget.textContent = isHidden ? "Mostrar resultados" : "Ocultar resultados"
    }
  }
}