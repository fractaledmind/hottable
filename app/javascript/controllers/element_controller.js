import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = [ "click" ]

  click() {
    this.clickTargets.forEach(target => target.click())
  }
}