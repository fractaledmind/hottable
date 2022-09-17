import ApplicationController from "./application_controller"

export default class extends ApplicationController {
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
