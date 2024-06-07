import { LightningElement, api } from 'lwc';

export default class NestedRecord extends LightningElement {
    @api recordId;
    @api objectApiName;

    items = []
} 