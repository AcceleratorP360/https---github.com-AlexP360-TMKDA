import { LightningElement, track, wire, api } from 'lwc';
import getBPADetails from "@salesforce/apex/BPADataTable.getBPADetails";
import updateBPADetails from "@salesforce/apex/BPADataTable.updateBPADetails";
import deleteBPARecord from "@salesforce/apex/BPADataTable.deleteBPARecord";
import { getRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import userId from "@salesforce/user/Id";
import getUserDetails from "@salesforce/apex/BPADataTable.getUserDetails";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";

const COLS = [
    
    { label: '', type: 'button-icon',width:"width:3.5rem;min-width:3.5rem",showCoulmn:true },
    { label: "Section", editable: false,width:"width:10rem;min-width:4rem" , wrapText: true,showCoulmn:true },
    { label: "Question", type: 'text', editable:false, width:"width:12rem;min-width:4rem",  wrapText: true,showCoulmn:true },
    { label: "Information", editable:false, width:"width:16rem;min-width:4rem" ,wrapText: true,showCoulmn:true},
    { label: "CO Comment", editable: true,width:"width:16rem;min-width:4rem" ,wrapText: true,showCoulmn:true},
    { label: "Confirmation Statement Accurate", type: 'boolean', editable: false ,width:"width:140px;min-width:2rem",wrapText: true,showCoulmn:true},    
    { label: "Coverholder Comment", editable: true,width:"width:16rem;min-width:4rem",wrapText: true,showCoulmn:true},
    { label: '', type: 'button-icon',width:"width:3.5rem;min-width:3.5rem",showCoulmn:true },
    
    ];

const FIELDS = ['TMKDA_BPA_Summary_Header__c.TMKDA_BPA_Stage__c'];


export default class P360BPADataTable extends NavigationMixin(LightningElement) {
   // @wire(deleteBPARecord) getBpadetail;86.5rem
    @api recordId;
    columns = COLS;
    draftValues = [];
    @track editedRow = {};
    @track BPADetail = [];
    fixedWidth = "width:15rem;";
    checkBoxWidth="width:5rem;";
    sectionWidth ="width:10rem;";
    questionWidth="width:12rem;";
    informationWidth="width:16rem;";
    coCommentWidth="width:16rem;";
    coverholderWidth="width:16rem;";
    tableWidth = "width:86.5rem;";
    isLoading = false;
    _initWidths=['3.5rem','16rem','16rem','16rem','16rem','16rem','16rem','3.5rem'];
    recordCount =0;
    bpaTitle=`BPA Details (${this.recordCount})`;
    deleteBPAList=['BP-071','BP-075','BP-079'];
    isLoaded=false;
    showNew=true;
    showCoComment=true;
   
   // @track isEditModeOn = true;


//FOR HANDLING THE VISIBILITY OF CO COMMENT FIELD CONDITIONALLY ACCORDING TO TMKDA_BPA_Stage__c VALUE

   @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  bpaSummaryHeader({ error, data }) {
    if (data) {
      console.log("Stage Value:",data.fields.TMKDA_BPA_Stage__c.value);
      if(data.fields.TMKDA_BPA_Stage__c.value=='BPA Initiated'||data.fields.TMKDA_BPA_Stage__c.value=='UW Review'||data.fields.TMKDA_BPA_Stage__c.value=='Review BPA'){
          this.showCoComment=false;
          this.columns[4].showCoulmn=false;
          this._initWidths=['3.5rem','16rem','16rem','16rem','16rem','16rem','3.5rem'];
      }else{
          this.showCoComment=true;
          this.columns[4].showCoulmn=true;
          this._initWidths=['3.5rem','16rem','16rem','16rem','16rem','16rem','16rem','3.5rem'];
      }
    }else if (error) {
      
    }
  }

//FOR HANDLING THE COMPONENET LOADING
   connectedCallback() {
    this.handleApexCall();
    this.handleUserInfo();   
     //this.removeTooltips();
  }


//FOR HANDLING THE DA ADVISORY ANALYST VISIBILITY OF ADD BUTTON

    handleUserInfo(){
        getUserDetails({ userId: userId })
            .then((result) => {
                if(result=='DA Advisory Analyst'){
                    this.showNew=false;
                }
            })
            .catch((error) => {
            });
    }
 


//FOR HANDLING THE COMPONENET REFRESH

handleRefresh() {
        this.handleCancel(); 
   
}  



//FOR HANDLING CREATION OF RECORD PAGE

  navigateToRecord(event) {
    const recordId = event.currentTarget.dataset.id;
    console.log('Navigating to record:', this.recordId);
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            //recordId: this.data.Id,
            recordId: recordId,            
          //  objectApiName: 'TMKDA_BPA_Summary_Detail__c',         
            actionName: 'view'
        }
    });
}



//FOR HANDLING APEX CLASS AND DATA RETRIVING
    handleApexCall() {
        getBPADetails({ name: this.recordId })
            .then((result) => {
                var i = 1;
                console.log(JSON.stringify(result));
                result.forEach((ele) => {
                    let bpaObj = {};
                    bpaObj.rowNumb = i;
                    bpaObj.Id = ele.Id
                    bpaObj.TMKDA_Section__c = ele.TMKDA_Section__c;
                    bpaObj.Name = ele.Name;
                    bpaObj.TMKDA_Information__c = ele.TMKDA_Information__c;                   
                    bpaObj.TMKDA_Confirmation_Statement_Accurate__c = ele.TMKDA_Confirmation_Statement_Accurate__c;                   
                    bpaObj.TMKDA_Coverholder_Comment__c = ele.TMKDA_Coverholder_Comment__c;
                    bpaObj.TMKDA_CO_Comments__c = ele.TMKDA_CO_Comments__c;
                    bpaObj.rowEdit = false;
                    bpaObj.rowDelete = this.deleteBPAList.includes(ele.TMKDA_BPA_Question__r.Name);
                    this.BPADetail.push(bpaObj);
                    i++;
                });
                this.recordCount=this.BPADetail.length;
                this.bpaTitle = `BPA Details (${this.recordCount})`;
                this.isLoaded=false;
            })
            .catch((error) => {
            });
    }



//FOR HANDLING ADD BUTTON

    handleAdd() {
        const defaultValues = encodeDefaultFieldValues({
            TMKDA_BPA_Summary_Name__c: this.recordId,
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'TMKDA_BPA_Summary_Detail__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
            },
        });
    }
      
 
    //FOR HANDLING THE HORIZONTAL SCROLL OF TABLE MANUALLY

    tableOuterDivScrolled(event) {
        this._tableViewInnerDiv = this.template.querySelector(".tableViewInnerDiv");
        if (this._tableViewInnerDiv) {
            if (!this._tableViewInnerDivOffsetWidth || this._tableViewInnerDivOffsetWidth === 0) {
                this._tableViewInnerDivOffsetWidth = this._tableViewInnerDiv.offsetWidth;
            }
            this._tableViewInnerDiv.style = 'width:' + (event.currentTarget.scrollLeft + this._tableViewInnerDivOffsetWidth) + "px;" + this.tableBodyStyle;
        }
        this.tableScrolled(event);
    }
 
    tableScrolled(event) {
        if (this.enableInfiniteScrolling) {
            if ((event.target.scrollTop + event.target.offsetHeight) >= event.target.scrollHeight) {
                this.dispatchEvent(new CustomEvent('showmorerecords', {
                    bubbles: true
                }));
            }
        }
        if (this.enableBatchLoading) {
            if ((event.target.scrollTop + event.target.offsetHeight) >= event.target.scrollHeight) {
                this.dispatchEvent(new CustomEvent('shownextbatch', {
                    bubbles: true
                }));
            }
        }
    }
 
    //#region ***************** RESIZABLE COLUMNS *************************************/
    handlemouseup(e) {
        this._tableThColumn = undefined;
        this._tableThInnerDiv = undefined;
        this._pageX = undefined;
        this._tableThWidth = undefined;
    }
 
    handlemousedown(e) {
        if (!this._initWidths) {
            this._initWidths = [];
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            tableThs.forEach(th => {
                this._initWidths.push(th.style.width);
            });
        }
 
        this._tableThColumn = e.target.parentElement;
        this._tableThInnerDiv = e.target.parentElement;
        while (this._tableThColumn.tagName !== "TH") {
            this._tableThColumn = this._tableThColumn.parentNode;
        }
        while (!this._tableThInnerDiv.className.includes("slds-cell-fixed")) {
            this._tableThInnerDiv = this._tableThInnerDiv.parentNode;
        }
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
        this._pageX = e.pageX;
 
        this._padding = this.paddingDiff(this._tableThColumn);
 
        this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
    }
 /*
    handlemousemove(e) {
        console.log("mousemove this._tableThColumn => ", this._tableThColumn);
        if (this._tableThColumn && this._tableThColumn.tagName === "TH" && (this._tableThWidth+(e.pageX - this._pageX) >60)) {
            this._diffX = e.pageX - this._pageX;
            this.template.querySelector("table").style.width = (this.template.querySelector("table") - (this._diffX)) + 'px';
            this._tableThColumn.style.width = (this._tableThWidth + this._diffX) + 'px';     
            this._tableThInnerDiv.style.width = this._tableThColumn.style.width;
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = this.template.querySelectorAll("table tbody tr");
            let tableBodyTds = this.template.querySelectorAll("table tbody .dv-dynamic-width");
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
    }
    */
    handlemousemove(e) {
    console.log("mousemove this._tableThColumn => ", this._tableThColumn);
    
    if (this._tableThColumn && this._tableThColumn.tagName === "TH") {
        // Calculate the difference in movement
        this._diffX = e.pageX - this._pageX;
        
        // Calculate new width for the column
        let newWidth = this._tableThWidth + this._diffX;
        
        // Check minimum width
        if (newWidth >= 90) {
            // Update the column width
            this._tableThColumn.style.width = newWidth + 'px';
            this._tableThInnerDiv.style.width = newWidth + 'px';
            
            // Update corresponding table cells
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = this.template.querySelectorAll("table tbody tr");
            
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
    }
}
 
    handledblclickresizable() {
        let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
        let tableBodyRows = this.template.querySelectorAll("table tbody tr");
       
        tableThs.forEach((th, ind) => {
            th.style.width = this._initWidths[ind];
            th.querySelector(".slds-cell-fixed").style.width = this._initWidths[ind];
        });
        tableBodyRows.forEach(row => {
        let rowTds = row.querySelectorAll(".dv-dynamic-width");
            
            rowTds.forEach((td, ind) => {
                rowTds[ind].style.width = this._initWidths[ind];
            });
        });
    }



 
 
    paddingDiff(col) {
 
        if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
            return 0;
        }
 
        this._padLeft = this.getStyleVal(col, 'padding-left');
        this._padRight = this.getStyleVal(col, 'padding-right');
        return (parseInt(this._padLeft,10) + parseInt(this._padRight,10));
 
    }
 
    getStyleVal(elm, css) {
        return (window.getComputedStyle(elm, null).getPropertyValue(css))
    }
    
  //FOR HANDLING ROW EDIT BUTTON

    handleRowEdit(event) {
        this.handledblclickresizable(); 
        const rowIndex = event.target.name - 1;
        this.BPADetail[rowIndex].rowEdit = true;      
        this.showSaveCancelButtons = true; // Show the Save and Cancel buttons when a row is being edited
         
    
        }

 //FOR HANDLING THE EDIT ALL BUTTON
    
    handleEditAll() {       
        this.handledblclickresizable();     
        this.BPADetail.forEach(detail => {
            detail.rowEdit = true;
        });
        this.showSaveCancelButtons = true; // Show the Save and Cancel buttons when all rows are being edited
              
    }
   
  //FOR HANDLING THE DELETE BUTTON
    handleCancel() {
       this.handledblclickresizable(); 
      this.BPADetail=[];
      this.showSaveCancelButtons = false;
        // Reset any changes made to the data
        /*this.BPADetail.forEach(detail => {
            detail.rowEdit=false;
            i++;
        });
        this.showSaveCancelButtons = false; // Hide the Save and Cancel buttons after canceling
        getBPADetails({ name: this.recordId });*/
       this.handleApexCall();
        
    }

  //FOR HANDLING THE SAVE BUTTON
    handleSave() {
        let bpaSummaryList=[];
        this.BPADetail.forEach(detail => {
            if (detail.rowEdit == true) {
                let bpaSummaryDetails = { 'sobjectType': 'TMKDA_BPA_Summary_Detail__c' };
                bpaSummaryDetails.Id = detail.Id;
                bpaSummaryDetails.Name = detail.Name;
                bpaSummaryDetails.TMKDA_Information__c = detail.TMKDA_Information__c;
                bpaSummaryDetails.TMKDA_Confirmation_Statement_Accurate__c = detail.TMKDA_Confirmation_Statement_Accurate__c;
                bpaSummaryDetails.TMKDA_CO_Comments__c = detail.TMKDA_CO_Comments__c;
                bpaSummaryDetails.TMKDA_Coverholder_Comment__c = detail.TMKDA_Coverholder_Comment__c;
                bpaSummaryList.push(bpaSummaryDetails);
            }
        });
        // Perform the save operation
        if(bpaSummaryList.length>0){
            updateBPADetails({ recordToUpdate: bpaSummaryList })
            .then(result => {                
               this.handleCancel()               
                // Display a success message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: result,
                        variant: 'success'
                    })                    
                );               
                // If the save is successful, refresh the component
                return refreshApex(this.BPADetail);          
                
            })
            .catch(error => {
                // Display an error message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        }
    }
/*
    handleName(eve){        

        let rowNumb= eve.target.name-1;
        this.BPADetail[rowNumb].Name = eve.target.value;
    }
    */
    
    handleInformation(eve){
        let rowNumb= eve.target.name-1;
        this.BPADetail[rowNumb].TMKDA_Information__c = eve.target.value;
    }
    handleConfirmation(eve){
        let rowNumb= eve.target.name-1;
        this.BPADetail[rowNumb].TMKDA_Confirmation_Statement_Accurate__c = eve.target.checked;
    }
    handleCoComments(eve){
        let rowNumb= eve.target.name-1;
        this.BPADetail[rowNumb].TMKDA_CO_Comments__c = eve.target.value;
    }
    handleCoverholder(eve){
        let rowNumb= eve.target.name-1;
        this.BPADetail[rowNumb].TMKDA_Coverholder_Comment__c = eve.target.value;
    }


  //FOR HANDLING THE DELETE BUTTON CONDITIONALLY 
    handleRowDelete(event){
        this.isLoaded=true;
        const rowIndex = event.target.name - 1;
        let deleteRecordId = this.BPADetail[rowIndex].Id;
        deleteBPARecord({ delRecordId: deleteRecordId })
            .then((result) => {
                this.handleCancel();
            })
            .catch((error) => {
            });
    }

}





/*

removeTooltips() {
        const cells = this.template.querySelectorAll('table tr td, table tr th');
        cells.forEach(cell => {
            cell.removeAttribute('title');
        });
    }
*/
    /*@wire(getBPADetails, { name: "$recordId" })
    wiredBPADetails({ error, data }) {
        if (data) {
            var i = 1;
            data.forEach((ele) => {
                let bpaObj = {};
                bpaObj.rowNumb = i;
                bpaObj.Id = ele.Id
                bpaObj.Name = ele.Name;
                bpaObj.TMKDA_Information__c = ele.TMKDA_Information__c;
                bpaObj.TMKDA_Section__c = ele.TMKDA_Section__c;
                bpaObj.TMKDA_Confirmation_Statement_Accurate__c = ele.TMKDA_Confirmation_Statement_Accurate__c;
                bpaObj.TMKDA_CO_Comments__c = ele.TMKDA_CO_Comments__c;
                bpaObj.TMKDA_Coverholder_Comment__c = ele.TMKDA_Coverholder_Comment__c;
                bpaObj.rowEdit=false;
                this.BPADetail.push(bpaObj);
                i++;
            });
        } else if (error) {
        }
    }
    /*
    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
    
        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = updatedFields.map(row => {
          return { recordId: row.Id };
        });
        console.log("###RecordIds : " + JSON.stringify(notifyChangeIds));
        try {
          // Pass edited fields to the  updateBPADetails Apex controller
          const result = await updateBPADetails({ data: updatedFields });
          console.log(JSON.stringify("Apex update result: " + result));
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: " updateBPADetails updated",
              variant: "success"
            })
          );
    
          // Refresh LDS cache and wires
          getRecordNotifyChange(notifyChangeIds);
    
          // Display fresh data in the datatable
          refreshApex(this.BPADetail).then(() => {
            // Clear all draft values in the datatable
            this.draftValues = [];
          });
        } catch (error) {
          console.log("###Error : " + JSON.stringify(error));
        }
      }
    
*/

/* 
    handleSave() {

       /* const recordInputs = event.detail.draftValues.map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
       // const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        const promises = this.BPADetail.map(detail => {
            
            if (detail.rowEdit) {
                // Implement logic to save individual row changes
              
                return updateRecord({ fields: { Id: detail.Id,
                                                               Name:detail.Name,
                                                               TMKDA_Information__c: detail.TMKDA_Information__c, 
                                                               TMKDA_Section__c:detail.TMKDA_Section__c,
                                                               TMKDA_Confirmation_Statement_Accurate__c:detail.TMKDA_Confirmation_Statement_Accurate__c,
                                                               TMKDA_CO_Comments__c:detail.TMKDA_CO_Comments__c,
                                                               TMKDA_Coverholder_Comment__c:detail.TMKDA_Coverholder_Comment__c,} });
                    
            }
            return Promise.resolve();
            
        });
       
        Promise.all(promises)
            .then(() => {
                // Optionally, show success message or refresh data
                this.showSaveCancelButtons = false; // Hide the Save and Cancel buttons after saving
            })
            .catch(error => {
                console.error('Error updating records', error);
                // Optionally, show error message
            });
    }
/*
    handleRowEdit(eve){
        console.log('row :',eve.target.name);
        let rowIndex=eve.target.name-1;
        this.BPADetail[rowIndex].rowEdit=true;
         this.showSaveCancelButtons = true;

    }
    handleEditAll(){
        let editBBPADetail=[];
        this.BPADetail.forEach((ele) => {
            ele.rowEdit=true;
            editBBPADetail.push(ele);
        });
        this.BPADetail= editBBPADetail;
         this.showSaveCancelButtons = true;
    }


    /*import BPA_DETAIL_NAME_FIELD  from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.Name";
import INFORMATION_FIELD  from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.TMKDA_Information__c";
import CONFIRMATION_STATEMENT_ACCURATE_FIELD from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.TMKDA_Confirmation_Statement_Accurate__c";
import COVERHOLDER_COMMENT_FIELD from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.TMKDA_Coverholder_Comment__c";
import SECTION_FIELD from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.TMKDA_Section__c";
import CO_COMMENT_FIELD from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.TMKDA_CO_Comments__c";
//import BPA_SUMMARY_NAME_FIELD from "@salesforce/schema/TMKDA_BPA_Summary_Detail__c.TMKDA_BPA_Summary_Name__c";

*/