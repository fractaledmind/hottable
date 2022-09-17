import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['child']

  initialize () {
  }

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

