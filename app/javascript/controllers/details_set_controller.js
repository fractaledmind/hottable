import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ['child']

  connect () {
    this.childTargets.forEach(details => details.addEventListener('toggle', (event) => {
      if (!event.currentTarget.open) return

      this.childTargets.forEach((details) => {
        if (details == event.currentTarget) return

        details.removeAttribute('open')
      })
    }))
  }
}
