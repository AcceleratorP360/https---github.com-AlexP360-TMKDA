import { LightningElement,api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getSurveyResponses from '@salesforce/apex/AttestationResponse.getSurveyResponses';
import { getRecord } from 'lightning/uiRecordApi';
import fetchAccounts from '@salesforce/apex/AccountDataController.fetchAccounts';
import ACCOUNT_OBJECT from '@salesforce/schema/P360_DD_Category__c';
import TYPE_FIELD from '@salesforce/schema/P360_DD_Category__c.P360_Assessment__c';
//import CATEGORY_ID_FIELD from '@salesforce/schema/P360_DD_Category__c.TMKDA_Does_attestation_confirm_a_new_TCF__c';
import COMPLETION_FIELD from '@salesforce/schema/P360_DD_Category__c.TMKDA_Does_attestation_confirm_a_new_TCF__c';
import PROGRESS from '@salesforce/schema/P360_DD_Category__c.Progress__c';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { refreshApex } from '@salesforce/apex';
import Red from '@salesforce/resourceUrl/Red';
import LWCCustomDatatableType from 'c/lWCCustomDatatableType';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation'; 
import CATEGORY_ID_URL_FIELD from '@salesforce/schema/P360_DD_Category__c.P360_DA_Category_ID_URL__c';
import PREPOPULATE_DUE_DILIGENCE_LOOKUP from '@salesforce/apex/PrepopulateDueDiligenceLookupClass.prepopulateDueDiligenceLookup';
import COVERHOLDERNAME from '@salesforce/apex/AttestationResponse.getSurveyInvitations';
const columns = [
    { label: 'Question', fieldName: 'QuestionName', type: 'text' },
    { label: 'Response', fieldName: 'ResponseValue', type: 'text'},
  /*  { label: 'Name', fieldName: 'name', type: 'text' },
    { label: 'Coverholder Name', fieldName: 'P360_DD_Coverholder_Name__c', type: 'text' },
    {
        label: 'Category Name',
        fieldName: CATEGORY_ID_URL_FIELD.fieldApiName,
        type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, 
        target: '_blank'},
        initialWidth: 170,
        editable: false
    }
    ,  
    {   label: 'View Response',initialWidth: 100, type: "button", typeAttributes: {  
        label: 'View ',  
        name: 'View',  
        title: 'View',  
        variant: 'Brand',
        disabled: false,  
        value: 'view',  
        initialWidth: 5,
        iconPosition: 'left'  
    } } ,
    {   label: 'Accept' ,initialWidth: 100,type: "button", typeAttributes: {  
        label: 'Accept',  
        variant: 'Brand',
        name: 'Edit',  
        title: 'Edit',  
        disabled: false,  
        value: 'edit',  
        iconPosition: 'left'  
    } }  */
];

export default class AttestationRepsonse extends LightningElement {
    surveyResponses = [];
    columns = columns;
    @api recordId;

    columns = columns;
    showSpinner = false;
    @track data = [];
    @track records = [];
    @track accountData;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;
    @track pickListCompletionOptions;
    @track richText;
    //@api recordId;
    @track result = [];
    sfimage = Red;
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

    fetchData(data) {
        // Map data to array of objects with image formula field
        this.records = data.map(item => ({
            Id: item.Id,
            Name: item.Name,
            P360_DA_Category_ID__c : item.name
            //Sub_category_Completion_status__c: item.Sub_category_Completion_status__c,
           // Progress__c: item.Progress__c
        }));
    };
    
    //here I pass picklist option so that this wire method call after above method
    @wire(fetchAccounts, { recordId: '$recordId', pickListone: '$pickListCompletionOptions'  })
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
    @wire(fetchAccounts)
wiredCaseList({ error, data }) {
    if(data) {
        let resultList = [];
        let objectTemp;
        data.forEach(ele => {
            objectTemp = Object.assign({}, ele);
            if (/<img\s+[^>]*src="([^"]*)"[^>]*>/i.test(ele.Progress__c)) {
                // extract the URL from the src attribute of the img tag
                const imgTag = ele.Progress__c.match(/<img\s+[^>]*src="([^"]*)"[^>]*>/i)[0];
                const srcIndex = imgTag.indexOf('src="');
                const imgSrcSubstring = imgTag.substring(srcIndex + 5);
                objectTemp.Progress__c = imgSrcSubstring.substring(0, imgSrcSubstring.indexOf('"'));
            } else {
                objectTemp.Progress__c = ele.Progress__c;
            }
            
            console.log(JSON.stringify(objectTemp));
            resultList.push(objectTemp);
        });
        // pass the correct URL value to the template
        this.data = resultList.map(result => ({
            url: result.Progress__c && result.Progress__c.includes('https://delegatedauthority-dev-ed--c.vf.force.com/resource/')
                ? result.Progress__c.replace(/<img[^>]+>/g, '') // remove any <img> tags from the URL
                : 'https://delegatedauthority-dev-ed--c.vf.force.com/resource/1671114286000/Red',
            altText: "Image Not Found"
        }));
    } else if(error) {
        console.log(JSON.stringify(error));
    }
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
        const defaultValues = {
             Name   : 'Test',
            Id: '0015i00000TURBDAA5',
            DD_Categories__r: { Name: 'ParentName' } 
        };
        console.log('defaultValues:', defaultValues);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'P360_DD_Category__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: JSON.stringify(defaultValues)
            }
        }).then((recordId) => {
            console.log('Record created with ID:', recordId);
        }).catch((error) => {
            console.error('Error creating record:', error);
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
    handleImageRender(cell, row) {
        cell.innerHTML = row.Progress__c;
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

   @wire(fetchAccounts) wireContact;
    handleRowAction(event){
    
        const dataRow = event.detail.row;
        window.console.log('dataRow@@ ' + dataRow);
        this.contactRow=dataRow;
        window.console.log('contactRow## ' + dataRow);
        
  
  
        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  
        if ( actionName === 'Edit' ) {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: '	P360_DD_Category__c',  
                    actionName: 'edit'  
                }  
            })  
  
        } else if ( actionName === 'View') {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: '	P360_DD_Category__c',  
                    actionName: 'view'  
                }  
            });
  
         
  
        }
        
     }

    @wire(getSurveyResponses, { responseId: '0My3L00000004iRSAQ' })
    wiredSurveyResponses(result) {
        if (result.data) {
            this.surveyResponses = result.data.map(response => ({
                QuestionName: response.Question.Name,
                ResponseValue: response.ResponseValue
            }));
        }
    }

   /* refreshTable() {
        return refreshApex(this.wiredSurveyResponses);
    }*/
    
}