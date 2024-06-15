/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, wire, api, track } from "lwc";
import userId from "@salesforce/user/Id";
import searchRecords from "@salesforce/apex/customLookupController.searchRecords";
import sendRecordDetails from "@salesforce/apex/customLookupController.sendRecordDetails";
import getObjLabels from "@salesforce/apex/customLookupController.getObjLabels";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from '@salesforce/apex'

const Delay = 300;

export default class ObjectSearch extends NavigationMixin(LightningElement) {

  objectName;
  searchValue;
  displaySize = "";
  loggedInUser = userId;
  selectedRecord = {
    selectedName: ""
  };

  objectLabelcmpvisible = false;
  //Removing Name field as It is not available in all Objects
  @api defaultLabels = [];
  selectedLabel = [];
  allSelectedLabels = [];
  queryLabels = [];
  options = [];
  allLabel;

  // Data Visualization
  apexReturnedData;
  showDataTable = false;

  // UX related Variables
  delayTimeout;
  resultValue;
  disableButton = true;
  displayOptions = false;
  displayError = false;
  displayWarning = false;
  showHelpMessage = false;

  // Datatable Variables
  // data= [{Id:'003J4000001e6AkIAI',
  //   IsDeleted: 'false'}, {Id:'003J4000001e6AkIAI',
  //   IsDeleted: 'false'}]
  data = []
  @track columns;


  @wire(searchRecords, { searchKey: "$searchValue" }) objectData;

  get isRecordSelected() {
    return this.selectedRecord.selectedName === "" ? false : true;
  }


  changeHandler(event) {
    window.clearTimeout(this.delayTimeout);
    let enteredValue = event.target.value;
    //Debouncing : Delaying the Apex server call so that server calls are less
    this.delayTimeout = setTimeout(() => {
      this.searchValue = enteredValue;
      this.displayOptions = true;
    }, Delay);
  }

  labelChange(event) {
    this.selectedLabel = event.detail.value;
    this.allSelectedLabels = [];
    this.allLabel.forEach((element) => {
      this.selectedLabel.forEach((selectedValue) => {
        if (
          element.value === selectedValue &&
          this.allSelectedLabels.filter(
            (e) => (e.value === selectedValue.length) === 0
          )
        ) {
          this.allSelectedLabels.push(element);
        }
      });
    });
  }

  clickHandler(event) {
    //* Getting Object name selected by User
    let selectedId = event.currentTarget.dataset.item;
    let outputRecord = this.objectData.data.find(
      (currItem) => currItem.DeveloperName === selectedId
    );
    this.selectedRecord = {
      selectedName: outputRecord.DeveloperName
    };
    this.displayOptions = false;

    //* Getting Object Label Details once the user selects the object
    getObjLabels({
      objectName: this.selectedRecord.selectedName,
      user: this.loggedInUser
    })
      .then((result) => {
        console.log("Log Value ~ ObjectSearch ~ .then ~ ApexreturnedLable:", result)

        //* lightning-dual-listbox requires data in value : label format. Converting the Apex labels returned list to js obj
        let convertedData = [];
        // Iterate through the field names array
        for (let i = 0; i < result.length; i++) {
          // Create an object with value and label properties
          const fieldObject = {
            value: (i + 1).toString(), // Index starts from 1
            label: result[i]
          };
          convertedData.push(fieldObject);
        }

        this.options = convertedData;
        this.allLabel = this.options;
        this.objectLabelcmpvisible = true;
      })
      .catch((error) => {
        console.log("Log Value ~ ObjectSearch ~ clickHandler ~ error:", error);
        this.displayError = true;
      });

    if (
      this.selectedRecord.selectedName &&
      this.displaySize &&
      this.objectLabelcmpvisible
    ) {
      this.disableButton = false;
    } else {
      this.disableButton = true;
      this.displayWarning = false;
      this.displayError = false;
    }
  }

  removeSelectedValue() {
    this.selectedRecord = {
      selectedName: ""
    };

    if (
      this.selectedRecord.selectedName &&
      this.displaySize &&
      this.objectLabelcmpvisible
    ) {
      this.disableButton = false;
    } else {
      this.disableButton = true;
      this.displayWarning = false;
      this.displayError = false;
      this.apexReturnedData = ''
    }
  }

  inputChangeHandler(event) {
    this.displaySize = event.target.value;

    if (
      this.selectedRecord.selectedName &&
      this.displaySize &&
      this.objectLabelcmpvisible &&
      this.displaySize <= 199 && this.displaySize >= 1
    ) {
      this.disableButton = false;
    } else {
      this.disableButton = true;
      this.displayWarning = false;
      this.displayError = false;
    }
  }

  fetchRecords() {

    // Preparing the query fields and sending it to Apex method
    //* If no label is selected, Send default labels
    if (this.allSelectedLabels.length === 0) {
      this.queryLabels = this.defaultLabels;
    }
    //* If labels are selected, display selected labels
    else {
      let value = this.allSelectedLabels;
      value.forEach((item) => {
        this.queryLabels.push(item.label);
      });
    }


    //* Converting the Apex returned list to js obj and adding '' for empty fields
    // Iterate through the field names array
    function prepareData(data, queryLabels) {
      const modifiedData = [];
      data.forEach((item) => {
        let obj = { ...item.obj };

        if ("hadEditAccess" in item && "Id" in obj) {
          obj.hadEditAccess = item.hadEditAccess;
          queryLabels.forEach((items) => {
            if (!(items in obj)) {
              obj[items] = ''
            }
          })
          modifiedData.push(convertToValueLabel(obj));
        }
      });

      return modifiedData;
    }


    function convertToValueLabel(jsonData) {
      const valueLabelData = [];
      for (let key in jsonData) {
        if (Object.prototype.hasOwnProperty.call(jsonData, key)) {
          valueLabelData.push({ label: key, value: jsonData[key] });
        }
      }
      return valueLabelData;
    }

    // Creating Data for Column of DataTable
    this.columns = this.queryLabels.map((label, index) => ({
      label: label,
      fieldName: label
    }));


    sendRecordDetails({
      objectName: this.selectedRecord.selectedName,
      size: this.displaySize,
      user: this.loggedInUser,
      queryParameters: this.queryLabels
    })
      .then((result) => {
        this.resultValue = result.length;

        let value = result;
        this.apexReturnedData = prepareData(value, this.queryLabels);

        this.data = fetchData(this.apexReturnedData)
        function fetchData(datas) {
          return datas.map(itemArray => {
            const result = {};
            itemArray.forEach(item => {
              result[item.label] = item.value.toString();
            });
            return result;
          });
        }
  

        this.showDataTable = true;
        this.objectLabelcmpvisible = false;
        this.allSelectedLabels = [];
        this.allLabel = [];
        if (this.resultValue === 0) {
          this.displayWarning = true;
          this.objectLabelcmpvisible = false;
          this.allSelectedLabels = [];
          this.allLabel = [];
        }
      })
      .catch((error) => {
        console.log("Log Value ~ ObjectSearch ~ fetchRecords ~ error:", error);
        this.displayError = true;
        this.objectLabelcmpvisible = false;
      });
  }

  closeDataView() {
    this.showDataTable = false;
    this.objectLabelcmpvisible = false;
    this.allSelectedLabels = [];
    this.allLabel = [];
  }


  getSelectedID(event) {
    
    const selectedRows = event.detail.selectedRows;
    console.log("Log Value ~ ObjectSearch ~ getSelectedID ~ selectedRows:", selectedRows)
    // Display that fieldName of the selected rows
    for (let i = 0; i < selectedRows.length; i++) {
      if (selectedRows[i].hadEditAccess == "true") {
        this[NavigationMixin.Navigate]({
          type: "standard__recordPage",
          attributes: {
            recordId: selectedRows[i].Id,
            objectApiName: this.selectedRecord.selectedName,
            actionName: "edit"
          }
        });
      }
      else{
        alert("You Don't have Edit Access of the Record")
      }
    }
  }
}