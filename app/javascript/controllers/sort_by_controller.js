import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ["items", "field"]

  connect() {
    if (this.fieldTargets.length === 0) {
      this.appendChild()
    }
  }

  add(event) {
    event.preventDefault()

    this.appendChild()
  }

  remove(event) {
    event.preventDefault()
    event.stopPropagation()

    event.target.closest(".fields").remove()
    this.updateIndexes()
  }

  appendChild() {
    const fields = this.fieldTarget.cloneNode(true)
    fields.querySelectorAll("select").forEach(field => field.value = null)

    this.itemsTarget.appendChild(fields)
    this.updateIndexes()
  }

  updateIndexes() {
    this.fieldTargets.forEach(field => {
      const [column, direction] = field.querySelectorAll("select")

      column.name = `q[s][${this.fieldTargets.indexOf(field)}][name]`
      column.id = `q_s_[${this.fieldTargets.indexOf(field)}]_name`

      direction.name = `q[s][${this.fieldTargets.indexOf(field)}][dir]`
      direction.id = `q_s_[${this.fieldTargets.indexOf(field)}]_dir`
    })
  }

  clear(event) {
    event.preventDefault()

    this.element.querySelectorAll("select").forEach(select => select.value = null)
    this.element.closest("form").requestSubmit()
  }
}
