import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = []

  connect() {
    const recordsTotalElement = this.element.querySelector('.pagy-info b:nth-child(2)')
    if (recordsTotalElement) {
      const recordsTotal = Number(recordsTotalElement.innerText)
      recordsTotalElement.innerText = recordsTotal.toLocaleString()
    }
  }
}