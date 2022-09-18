import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ['input']

  clear(event) {
    event.preventDefault()

    this.inputTargets.forEach(input => {
      console.log "beautiful!"
    })
  }
}
