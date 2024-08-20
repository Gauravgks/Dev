import { api, LightningElement } from "lwc";

export default class FetchRecordId extends LightningElement {
  @api recordId;

  get acceptedFormats() {
    return [".pdf", ".png"];
  }

  handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    alert("No. of files uploaded : " + uploadedFiles.length);
  }
}
