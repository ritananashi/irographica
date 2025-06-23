import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab-states"
export default class extends Controller {
  static targets = ["collection", "bookmark"]
  connect() {
    const path = location.pathname;
    if (path.includes("bookmarks")) {
      this.bookmarkTarget.classList.add("active_tabs");
      this.collectionTarget.classList.add("not_active_tabs");
    } else {
      this.collectionTarget.classList.add("active_tabs");
      this.bookmarkTarget.classList.add("not_active_tabs");
    };
  }

  select(e) {
    const button = e.currentTarget
    if (button.id === "collection") {
      this.collectionTarget.classList.remove("not_active_tabs");
      this.collectionTarget.classList.add("active_tabs");
      this.bookmarkTarget.classList.remove("active_tabs");
      this.bookmarkTarget.classList.add("not_active_tabs");
    } else {
      this.collectionTarget.classList.add("not_active_tabs");
      this.collectionTarget.classList.remove("active_tabs");
      this.bookmarkTarget.classList.add("active_tabs");
      this.bookmarkTarget.classList.remove("not_active_tabs");
    };
  }
}
