import { LightningElement, wire, api, track } from "lwc";
import {
  subscribe,
  unsubscribe,
  onError,
  setDebugFlag,
  isEmpEnabled
} from "lightning/empApi";
import { NavigationMixin } from "lightning/navigation";
//import taskId from "@salesforce/apex/taskInvocableClass.sendTaskRecordToLwc";

export default class InvokeTaskRecord extends NavigationMixin(
  LightningElement
) {
  //TODO: Subscribe the event in LWC from the Flow

  channelName = "/event/TaskRecord__e";
  subscription = {};

  onClick(recordId) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: recordId,
        objectApiName: "Account",
        actionName: "view"
      }
    });
  }

  connectedCallback() {
    this.handleSubscribe();
    // Register error listener
    //this.registerErrorListener();
  }

  // Handles subscribe button click
  handleSubscribe() {
    const messageCallback = (response) => {
      this.handleEvent(response);
    };

    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then((response) => {
      // Response contains the subscription information on subscribe call
      console.log(
        "Subscription request sent to: ",
        JSON.stringify(response.channel)
      );
      this.subscription = response;
    });
  }

  handleEvent(response) {
    console.log("Event Fire", response);
    if (Object.prototype.hasOwnProperty.call(response, "data")) {
      let taskId = response.data.payload.taskId__c;
      this.onClick(taskId);
    }
  }
}
