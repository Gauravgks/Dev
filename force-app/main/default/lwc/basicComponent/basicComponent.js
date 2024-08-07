import { LightningElement } from 'lwc';

export default class BasicComponent extends LightningElement {

    buttonLabel = 'Change ParaTag';
    changeParaTag() {
        this.template.querySelector('.ptag').innerText = 'Value changes';
        this.template.querySelector('.ptag').classList.add('ptagchanged');

        this.buttonLabel = 'Clicked'
    }

}

