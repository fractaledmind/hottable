import ApplicationController from "./application_controller"
import { get } from "@rails/request.js"
import { createPopper } from '@popperjs/core'

export default class extends ApplicationController {
  static targets = ["tooltip", "tooltipTemplate"]

  update (event) {
    const form = (event.target instanceof HTMLFormElement) ? event.target : event.target.closest("form")

    if (!this.updatable) return

    form.requestSubmit()

    this.updatable = false
  }

  abort (event) {
    event.preventDefault()

    const { editUrl, attribute } = event.target.closest("td, th").dataset

    get(editUrl, {
      query: {
        'book_edit': "false",
        'book_attribute': attribute,
      },
      responseKind: "turbo-stream"
    })

    this.updatable = false
  }

  async edit (event) {
    this.clearSelection()

    const { editUrl, attribute } = event.target.closest("td, th").dataset

    await get(editUrl, {
      query: {
        'book_edit': "true",
        'book_attribute': attribute,
      },
      responseKind: "turbo-stream"
    })

    this.updatable = true
  }

  clearSelection() {
    if (window.getSelection) {
      window.getSelection().removeAllRanges()
    } else if (document.selection) {
      document.selection.empty()
    }
  }

  tooltipTargetConnected(target) {
    this.popper = createPopper(target, this.tooltipTemplateTarget, {
      placement: 'top'
    })
  }

  tooltipTargetDisconnected(target) {
    this.popper.destroy()
  }
}
