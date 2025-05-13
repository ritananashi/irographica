import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product"
export default class extends Controller {
  static targets = ["name"]
  connect() {
  }

  select(e) {
    const button = e.currentTarget
    this.nameTarget.value = button.dataset.name;

    const event = new Event("change");
    this.nameTarget.dispatchEvent(event);
  }
}
