import NestedForm from "@stimulus-components/rails-nested-form"

export default class extends NestedForm {
  static targets = ["target", "template", "recipe", "name"]
  connect() {
    super.connect()
  }

  openRecipe() {
    if (this.nameTarget.value.startsWith("オリジナル")) {
      this.recipeTarget.classList.remove("hidden");
    } else {
      if (!this.recipeTarget.classList.contains("hidden")) {
        this.recipeTarget.classList.add("hidden");
      }
    };
  }
}