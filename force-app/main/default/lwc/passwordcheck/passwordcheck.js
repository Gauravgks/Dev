import { LightningElement, track } from "lwc";

export default class Passwordcheck extends LightningElement {
  @track value;
  min = 3;
  max = 10;

  changeHandler(event) {
    this.taskname = event.target.value;

    if (this.taskname <= this.min) {
      //change color to red
      this.template.querySelector(".nameinput").classList.add("redColor");
    } else if (this.taskname > this.max) {
      //change color to green
      this.template.querySelector(".nameinput").classList.remove("redColor");
      this.template.querySelector(".nameinput").classList.add("greenBorder");
    }
  }

  dataCheck(event) {
    this.value = event.target.value;

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
