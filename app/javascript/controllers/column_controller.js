import ApplicationController from "./application_controller"
import { get } from "@rails/request.js"

export default class extends ApplicationController {

  update (event) {
    event.target.closest("form").requestSubmit()
  }

  edit (event) {
    const { id, editUrl, attribute, attributeType } = event.target.closest("td, th").dataset

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
