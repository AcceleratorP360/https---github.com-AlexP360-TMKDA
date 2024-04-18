import { LightningElement,api, wire,track } from 'lwc';
import fetchAccounts from '@salesforce/apex/ReviewAreaController.fetchAccounts';
import ACCOUNT_OBJECT from '@salesforce/schema/P360_Review_Area__c';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import uploadFiles from '@salesforce/apex/Screen3Controller.uploadFiles'
import INDUSTRY_FIELD from '@salesforce/schema/P360_Review_Area__c.P360_Scope_of_DD_Review__c';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'; 
import TYPE_FIELD from '@salesforce/schema/P360_Review_Area__c.P360_Assessment__c';
import COMPLETION_FIELD from '@salesforce/schema/P360_Review_Area__c.P360_Completion_Marker__c';
import updateAccounts from '@salesforce/apex/ReviewAreaController.updateAccounts';





const columns = [

    { label: 'Name',initialWidth: 170, fieldName: 'Name', editable: true },
   
        { label: 'Inherent Risk ',initialWidth: 150,class: "slds-align_absolute-center", fieldName: 'Inherent_Risk__c', type: 'image', 
        cellAttributes: {
          
          class: "slds-align_absolute-center"
        }
      },
    {
    label: 'Summary', fieldName: 'P360_Summary__c',type: 'text',wrapText:true,editable: true
    },
    {
        label: 'Completion Marker ',initialWidth: 160 , fieldName: 'P360_Completion_Marker__c', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: 'Choose Completion', options: { fieldName: 'pickListCompletionOptions' }, 
            value: { fieldName: 'P360_Completion_Marker__c' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    },
    
        { label: 'Assessment Status',initialWidth: 160 , class: "slds-align_absolute-center",fieldName: 'Assessment_Status__c', type: 'image'   ,  cellAttributes: {
      
            class: "slds-align_absolute-center"
          }},
    { label: 'Documents Upload', type: 'fileUpload', fieldName: 'Id', typeAttributes: { acceptedFileFormats: '.xls,.Doc,.jpg,.jpeg,.pdf,.png',fileUploaded:{fieldName: 'documentUploaded__c'} } },

    { label: 'View Record',initialWidth: 100,type: "button", typeAttributes: {  
        label: 'View ',  
        name: 'View',  
        variant: 'Brand',
        title: 'View',  
        disabled: false,  
        value: 'view',  
        initialWidth: 5,
        iconPosition: 'left'  
    } } ,
    { label: 'Edit Record',initialWidth: 100,type: "button", typeAttributes: {  
        label: 'Edit',  
        name: 'Edit',  
        title: 'Edit',  
        variant: 'Brand',
        disabled: false,  
        value: 'edit',  
        iconPosition: 'left'  
    } }  

];

export default class Sample extends NavigationMixin(LightningElement) {

    @api recordId;
    records;
    data;
    wiredRecords;
    error;
    columns = columns;
    draftValues = [];
    columns = columns;
    showSpinner = false;
    @track data = [];
    @track accountData;
    @track draftValues = [];
 
    wiredRecords;
    lastSavedData = [];
    @track pickListOptions;
    @track pickListCompletionOptions;

 
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
    handleIsLoading(isLoading) {
        this.isLoading = isLoading;
    }
   
   
    @wire(fetchAccounts, {recordId : '$recordId'})  
    wiredContact(result) {
        this.wiredRecords = result; // track the provisioned value
        const { data, error } = result;
 
        if(data) {
            this.data = JSON.parse(JSON.stringify(data));
            this.error = undefined;
            this.handleIsLoading(false);
        } else if(error) {
            this.error = error;
            this.data = undefined;
            this.handleIsLoading(false);
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
    @wire( fetchAccounts )  
    wiredAccount( value ) {

        this.wiredRecords = value; // track the provisioned value
        const { data, error } = value;


        if ( data ) {
                            
            this.data = data;
            this.error = undefined;

        } else if ( error ) {

            this.error = error;
            this.data = undefined;

        }

    }  
    handleCellChange(event) {
        //this.updateDraftValues(event.detail.draftValues[0]);
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValues(ele);
        })
    }
    //handler to handle cell changes & update values in draft values
    actionToCreateAccountNav() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'P360_Review_Area__c',
                actionName: 'new'
            },
        });
    }


    
 
    handleCancel(event) {
        //remove draftValues & revert data changes
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }
 
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                variant: variant,
                message: message,
            })
        );
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
                    objectApiName: '	P360_Review_Area__c',  
                    actionName: 'edit'  
                }  
            })  
  
        } else if ( actionName === 'View') {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {     
                    recordId: recId,  
                    objectApiName: '	P360_Review_Area__c',  
                    actionName: 'view'  
                }  
            });
  
         
  
        }
        
     }
    
     
  
     closeModalAction(){
      this.modalContainer=false;
     }

     connectedCallback() {
        fetchAccounts().then(res => { 
            console.log('res:'+res);
            this.data = res; 
        }
        ).catch(err => console.error('err:'+err));
        console.log('columns => ', columns);
        
        console.log(this.data);
    }
    handleUploadFinished(event) {
        event.stopPropagation();
        console.log('data => ', JSON.stringify(event.detail.data));
    }



  
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        let uploadedFileNames = '';
        for(let i = 0; i < uploadedFiles.length; i++) {
            uploadedFileNames += uploadedFiles[i].name + ', ';
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' Files uploaded Successfully: ' + uploadedFileNames,
                variant: 'success',
            }),
        );
    }
    callRowAction( event ) {  
          
        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  
        if ( actionName === 'Edit' ) {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: 'P360_Review_Area__c',  
                    actionName: 'edit'  
                }  
            })  
  
        } else if ( actionName === 'View') {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: 'P360_Review_Area__c',  
                    actionName: 'view'  
                }  
            });
  
         

        }


    }  
    addRow() {
        let randomId = Math.random() * 16;
        let myNewElement = {Name: "", P360_Scope_of_DD_Review__c: "", Id: "", P360_Assessment__c: "",P360_Summary__c:"",P360_Evidence_file_path__c:"", P360_DD_Sub_Category__c: this.recordId};
        this.data = [...this.data, myNewElement];
    }

    

    // to get the default record type id, if you dont' have any recordtypes then it will get master

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })

    accountMetadata;
   
    @track filesData = [];
    showSpinner = false;

   
  
  

    uploadFiles() {
        if(this.filesData == [] || this.filesData.length == 0) {
            this.showToast('Error', 'error', 'Please select files first'); return;
        }
        this.showSpinner = true;
        uploadFiles({
            recordId : this.recordId,
            filedata : JSON.stringify(this.filesData)
        })
        .then(result => {
            console.log(result);
            if(result && result == 'success') {
                this.filesData = [];
                this.showToast('Success', 'success', 'Files Uploaded successfully.');
            } else {
                this.showToast('Error', 'error', result);
            }
        }).catch(error => {
            if(error && error.body && error.body.message) {
                this.showToast('Error', 'error', error.body.message);
            }
        }).finally(() => this.showSpinner = false );
    }

    removeReceiptImage(event) {
        var index = event.currentTarget.dataset.id;
        this.filesData.splice(index, 1);
    }

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                variant: variant,
                message: message,
            })
        );
    }

    async handleSave( event ) {

        const updatedFields = event.detail.draftValues;

        await updateAccounts( { data: updatedFields } )
        .then( result => {

            console.log( JSON.stringify( 'Apex update result: '+ result ) );
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Review Area Updated',
                    variant: 'success'
                })
            );
            
            refreshApex( this.wiredRecords ).then( () => {
                this.draftValues = [];
            });        


        }).catch( error => {

            console.log( 'Error is ' + JSON.stringify( error ) );
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or refreshing records',
                    message: error.body.message,
                    variant: 'error'
                })
            );

        });

    }

}