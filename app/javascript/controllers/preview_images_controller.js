import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview-images"
export default class extends Controller {
  static targets = ["input", "previewContainer"]
  connect() {
    this.accumulatedFiles = []
  }

  preview(event) {
    const input = this.inputTarget
    const newFiles = Array.from(input.files)

    newFiles.forEach((file) => {
      this.accumulatedFiles.push(file)
      this.appendPreview(file)
    })
    this.updateInputFiles()
  }

  appendPreview(file) {
    const container = this.previewContainerTarget
    const wrapper = document.createElement("div")
    wrapper.classList.add("new-image-wrapper")

    const img = document.createElement("img")
    img.src = URL.createObjectURL(file)
    img.classList.add("w-[60px]", "sm:w-[80px]", "h-[60px]", "sm:h-[80px]", "object-fill", "object-center")

    const button = document.createElement("button")
    button.type = "button"
    button.classList.add("fa-regular", "fa-circle-xmark", "my-1")
    button.dataset.action = "click->preview-images#remove"

    wrapper.appendChild(img)
    wrapper.appendChild(button)
    container.appendChild(wrapper)
  }

  remove(event) {
    const button = event.currentTarget
    const wrapper = button.closest(".new-image-wrapper")
    const container = this.previewContainerTarget
    
    const allWrappers = Array.from(container.querySelectorAll(".new-image-wrapper"))
    const index = allWrappers.indexOf(wrapper)

    if (index === -1) return

    const img = wrapper.querySelector("img")
    if (img && img.src) {
      URL.revokeObjectURL(img.src)
    }

    this.accumulatedFiles.splice(index, 1)
    this.updateInputFiles()

    wrapper.remove()
  }

  updateInputFiles() {
    const dt = new DataTransfer()
    this.accumulatedFiles.forEach(file => dt.items.add(file))
    this.inputTarget.files = dt.files
  }
}
