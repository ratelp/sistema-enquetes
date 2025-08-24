import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="poll-form"
export default class extends Controller {
  static targets = ["pollTypeSelect", "maxChoicesField", "optionsWrapper", "optionTemplate"]

  connect() {
    this.toggleMaxChoices()
  }

  toggleMaxChoices() {
    if (this.hasPollTypeSelectTarget && this.pollTypeSelectTarget.value === "multipla_escolha") {
      this.maxChoicesFieldTarget.hidden = false
    } else {
      this.maxChoicesFieldTarget.hidden = true
    }
  }

  addOption(event) {
    event.preventDefault()
    const content = this.optionTemplateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.optionsWrapperTarget.insertAdjacentHTML("beforeend", content)
  }

  removeOption(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")

    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = "1"
      wrapper.style.display = "none"
    }
  }
}
