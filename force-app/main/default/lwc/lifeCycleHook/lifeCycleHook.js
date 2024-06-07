import { LightningElement } from 'lwc';

export default class LifeCycleHook extends LightningElement {
    valuefromJS = 'Hello';
    constructor() {
        super();
        console.log('Parent Constructor');
    }
    connectedCallback() {
        console.log('Inside Parent Connected Callback')

    }
    renderedCallback() {

        console.log('Inside Parent Rendered Callback')
        //this.valuefromJS = 'Change done from Parent RenderCallBack'
    }

    disconnectedCallback() {

        console.log('Inside Disconnected Callback')
    }

    handleInputFocus(event) {
        this.valuefromJS = event.detail;
    }
}