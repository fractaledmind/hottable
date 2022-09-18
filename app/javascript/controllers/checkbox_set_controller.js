import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ['parent', 'child', 'count']
  static values = {
    total: Number
  }

  connect() {
    if (!this.hasParentTarget) return
    if (!this.hasCountTarget) return

    const parentTarget = this.parentTarget
    const setSelectedCount = this.setSelectedCount.bind(this)
    this.childTargets.forEach(checkbox => {
      checkbox.addEventListener("change", event => {
        if (checkbox.checked) {
          setSelectedCount()
        } else {
          parentTarget.checked = false
          setSelectedCount()
        }
      })
    })
  }

  matchAll(e) {
    e.preventDefault()

    this.childTargets.forEach(checkbox => {
      checkbox.checked = e.currentTarget.checked
    })

    if (e.currentTarget.checked) {
      this.setSelectedCount(true)
    } else {
      this.setSelectedCount(false)
    }
  }

  deselectAll(e) {
    e.preventDefault()

    this.childTargets.forEach(checkbox => {
      checkbox.checked = false
    })

    this.setSelectedCount()
  }

  selectAll(e) {
    e.preventDefault()

    this.childTargets.forEach(checkbox => {
      checkbox.checked = true
    })

    this.setSelectedCount()
  }
  
  setSelectedCount(full = false) {
    const selectedCount = Array.from(this.childTargets).filter(checkbox => checkbox.checked).length
    const fullCount = this.totalValue
    this.countTarget.innerHTML = (full ? fullCount : selectedCount).toLocaleString()
  }
}
