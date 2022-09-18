import ApplicationController from "./application_controller"
import { get } from "@rails/request.js"
import { createPopper } from '@popperjs/core'

export default class extends ApplicationController {
  static targets = ["tooltip", "tooltipTemplate"]

  async update (event) {
    if (event instanceof KeyboardEvent) {
      if (event.key !== "Enter") return
    }

    const form = (event.target instanceof HTMLFormElement) ? event.target : event.target.closest("form")
    await form.requestSubmit()
  }

  async abort (event) {
    event.preventDefault()

    await this.requestEdit(event.target, { "book_edit": "false" })
  }

  async edit (event) {
    this.clearSelection()

    await this.requestEdit(event.target, { "book_edit": "true" })
  }

  async requestEdit(target, query = {}) {
    const { editUrl, attribute } = target.closest("td, th").dataset

    await get(editUrl, {
      query: {
        ...query,
        'book_attribute': attribute,
      },
      responseKind: "turbo-stream"
    })
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
      placement: "top"
    })
  }

  tooltipTargetDisconnected(target) {
    this.popper.destroy()
  }
}
