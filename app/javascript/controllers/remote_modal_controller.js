import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remote-modal"
export default class extends Controller {
  static targets = ["frame"]

  connect() {
    this.element.showModal();
  }

  close() {
    this.element.close();
    this.element.remove();
  }
}
