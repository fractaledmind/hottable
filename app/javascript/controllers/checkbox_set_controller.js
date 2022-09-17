import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['child']

  deselectAll(e) {
    e.preventDefault()

    this.childTargets.forEach(checkbox => {
      checkbox.checked = false
    })
  }

  selectAll(e) {
    e.preventDefault()
  
    this.childTargets.forEach(checkbox => {
      checkbox.checked = true
    })
  }
}

