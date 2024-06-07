import { LightningElement, api } from 'lwc';

export default class LifeCycleHookChild extends LightningElement {

    valueFromJSChild = 'Child Data'
    constructor() {
        super();
        console.log('Child Constructor');
    }
    connectedCallback() {
        console.log('Inside Child Connected Callback')
    }

    renderedCallback() {

        console.log('Inside Child Rendered Callback')
    }
    handleInputFocus1(event) {
        //this.valueFromJSChild = event.target.value;

        this.dispatchEvent(
            new CustomEvent("senddatatoparent", {
                detail: event.target.value
            })
        );
    }
}