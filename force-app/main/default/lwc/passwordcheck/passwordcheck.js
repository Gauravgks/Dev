import { LightningElement, track } from "lwc";

export default class Passwordcheck extends LightningElement {
  @track value;
  min = 3;
  max = 10;

  dataCheck(event) {
    // Getting Char length
    this.value = event.target.value;
    // Check for length check for min/max value
    if (this.value.length <= this.min || this.value.length > this.max) {
      //change color to red
      this.template.querySelector(".PasswordField").classList.add("redColor");
      this.template
        .querySelector(".PasswordField")
        .classList.remove("greenBorder");
    } else {
      //change color to green
      this.template
        .querySelector(".PasswordField")
        .classList.remove("redColor");
      this.template
        .querySelector(".PasswordField")
        .classList.add("greenBorder");
    }
  }
}
