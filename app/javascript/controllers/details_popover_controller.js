import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ['button']

  connect() {
    this.element.addEventListener("toggle", (event) => {
      this.buttonTarget.setAttribute('aria-expanded', event.currentTarget.open)
    });
  }

  hide(event) {
    if (event && (this.element.contains(event.target))) {
      return;
    }

    this.buttonTarget.setAttribute('aria-expanded', 'false');
    this.element.removeAttribute('open')
  }
}
