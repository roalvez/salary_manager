import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "input", "select"]

  connect() {
    console.log("SalaryType controller connected!")
    console.log("Targets found:", this.hasLabelTarget, this.hasInputTarget, this.hasSelectTarget)
    this.updateLabel()
  }

  change() {
    console.log("Change event triggered!")
    this.updateLabel()
  }  updateLabel() {
    console.log("UpdateLabel called")
    const salaryType = this.selectTarget.value
    console.log("Salary type:", salaryType)

    if (!this.hasLabelTarget || !this.hasInputTarget) {
      console.log("Missing targets:", this.hasLabelTarget, this.hasInputTarget)
      return
    }

    const label = this.labelTarget
    const input = this.inputTarget

    switch(salaryType) {
      case 'hourly':
        label.textContent = '💰 Hourly Wage ($)'
        input.placeholder = '25.00'
        break
      case 'monthly':
        label.textContent = '💰 Monthly Salary ($)'
        input.placeholder = '4000.00'
        break
      case 'annual':
        label.textContent = '💰 Annual Salary ($)'
        input.placeholder = '50000.00'
        break
    }
  }
}
