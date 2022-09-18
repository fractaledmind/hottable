import ApplicationController from "./application_controller"
import { get } from "@rails/request.js"

export default class extends ApplicationController {

  update (event) {
    const form = (event.target instanceof HTMLFormElement) ? event.target : event.target.closest("form")

    form.requestSubmit()
  }

  edit (event) {
    const { id, editUrl, attribute, attributeType } = event.target.closest("td, th").dataset

    if (window.getSelection) {
      window.getSelection().removeAllRanges()
    } else if (document.selection) {
      document.selection.empty()
    }

    get(editUrl, {
      query: {
        'book[id]': id,
        'book[attribute]': attribute,
        'book[attribute_type]': attributeType
      },
      responseKind: "turbo-stream"
    })
  }
}
