import ApplicationController from "./application_controller"
import { get } from "@rails/request.js"

export default class extends ApplicationController {

  click (event) {
    event.target.closest("form").requestSubmit()
  }

  edit (event) {
    const { id, editUrl, attribute, attributeType } = event.target.dataset

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
