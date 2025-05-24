import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["load"]

  connect() {
    this.hide()
  }

  show() {
    this.loadTarget.classList.remove("hidden")
  }

  hide() {
    this.loadTarget.classList.add("hidden")
  }
}
