import { LightningElement, wire } from 'lwc';
import { IsConsoleNavigation, openTab } from 'lightning/platformWorkspaceApi';

export default class WorkspaceAPIDemo extends LightningElement {
    @wire(IsConsoleNavigation) isConsoleNavigation;

     openTab() {
        // Ensure that we're in a console app
        if (!this.isConsoleNavigation) {
            return;
        }

        // Open contact list a new tab
         openTab({
            pageReference: {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Contact',
                    actionName: 'list'
                }
            },
            focus: true,
            label: 'Contacts List'
        });
    }
}