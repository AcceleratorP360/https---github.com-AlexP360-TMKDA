import { LightningElement, track, wire, api } from 'lwc';
import fetchAccounts from '@salesforce/apex/SubcategoryController.fetchAccounts';
import ACCOUNT_OBJECT from '@salesforce/schema/P360_DD_Sub_Category__c';
import TYPE_FIELD from '@salesforce/schema/P360_DD_Sub_Category__c.P360_Assessment__c';
import COMPLETION_FIELD from '@salesforce/schema/P360_DD_Sub_Category__c.P360_Completion_Marker__c';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation'; 


 
const columns = [
  
    { label: 'Name', fieldName: 'Name', editable: true },
    { label: 'Inherent Risk',class: "slds-align_absolute-center", fieldName: 'P360_SC_Inherent_risk__c', type: 'image', 
    cellAttributes: {
      
      class: "slds-align_absolute-center"
    }
  },

     
    {
    label: 'Summary', class: "slds-align_absolute-center", wrapText:true,fieldName: 'P360_Summary_Final_Assessment__c',initialWidth: 300, type: 'text',editable: true
    },
    { label: 'Assessment Status',initialWidth: 160 , class: "slds-align_absolute-center",fieldName: 'P360_SC_Assessment_status__c', type: 'image'   ,  cellAttributes: {
      
        class: "slds-align_absolute-center"
      }},
{ label: 'Review Area Completion status',initialWidth: 240 , fieldName: 'P360_DD_Child_COmpletion_Status__c', type:'image'},
    {
        label: 'Completion Marker', initialWidth: 160 ,fieldName: 'P360_Completion_Marker__c', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: 'Choose Completion', options: { fieldName: 'pickListCompletionOptions' }, 
            value: { fieldName: 'P360_Completion_Marker__c' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    },
    { label: 'View Record' ,initialWidth: 100,type: "button", typeAttributes: {  
        label: 'View ',  
        name: 'View',  
        variant: 'Brand',
        title: 'View',  
        disabled: false,  
        value: 'view',  
        initialWidth: 5,
        iconPosition: 'left'  
    } } ,
    { label: 'Edit Reocrd' ,initialWidth: 100,type: "button", typeAttributes: {  
        label: 'Edit',  
        name: 'Edit',  
        variant: 'Brand',
        title: 'Edit',  
        disabled: false,  
        value: 'edit',  
        iconPosition: 'left'  
    } }  
    
]
 
export default class CustomDatatableDemo extends NavigationMixin(LightningElement) {
    columns = columns;
    showSpinner = false;
    @track data = [];
    @track accountData;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;
    @track pickListCompletionOptions;
    @api recordId;
 
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;
 
    //fetch picklist options
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: TYPE_FIELD
    })
 
    wirePickList({ error, data }) {
        if (data) {
            console.log(data.values);
            this.pickListOptions = data.values;
        } else if (error) {
            console.log(error);
        }
    }


     //fetch picklist options
     @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: COMPLETION_FIELD
    })
 
    wirePickList1({ error, data }) {
        if (data) {
            this.pickListCompletionOptions= data.values;
        } else if (error) {
            console.log(error);
        }
    }
    
 
    //here I pass picklist option so that this wire method call after above method
    @wire(fetchAccounts, { recordId: '$recordId', pickListone: '$pickListCompletionOptions' })
    accountData(result) {
        this.accountData = result;
        if (result.data) {
            console.log(result.data);
            this.data = JSON.parse(JSON.stringify(result.data));
 
            this.data.forEach(ele => {
                ele.pickListOptions = this.pickListOptions;
                ele.pickListCompletionOptions = this.pickListCompletionOptions;
            })
 
            this.lastSavedData = JSON.parse(JSON.stringify(this.data));
 
        } else if (result.error) {
            this.data = undefined;
        }
    };
 
    
    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));
 
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
 
        //write changes back to original data
        this.data = [...copyData];
    }
 
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        //store changed value to do operations
        //on save. This will enable inline editing &
        //show standard cancel & save button
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }
 
    //handler to handle cell changes & update values in draft values
    handleCellChange(event) {
        //this.updateDraftValues(event.detail.draftValues[0]);
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValues(ele);
        })
    }
    actionToCreateAccountNav() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'P360_DD_Sub_Category__c',
                actionName: 'new'
            },
        });
    }
   
  
    handleSave(event) {
        this.showSpinner = true;
        this.saveDraftValues = this.draftValues;
 
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
 
        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.draftValues = [];
            return this.refresh();
        }).catch(error => {
            console.log(error);
            this.showToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.draftValues = [];
            this.showSpinner = false;
        });
    }
 
    handleCancel(event) {
        //remove draftValues & revert data changes
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }
 
    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
    


    
    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.accountData);
    }
    @track contactRow={};
  @track rowOffset = 0;  
  @track modalContainer = false;
   @wire(fetchAccounts) wireContact;
    handleRowAction(event){
    
        const dataRow = event.detail.row;
        window.console.log('dataRow@@ ' + dataRow);
        this.contactRow=dataRow;
        window.console.log('contactRow## ' + dataRow);
        this.modalContainer=true;
  
  
        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  
        if ( actionName === 'Edit' ) {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: '	P360_DD_Sub_Category__c',  
                    actionName: 'edit'  
                }  
            })  
  
        } else if ( actionName === 'View') {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: '	P360_DD_Sub_Category__c',  
                    actionName: 'view'  
                }  
            });
  
         
  
        }
        
     }
    
     
  
     closeModalAction(){
      this.modalContainer=false;
     }
}