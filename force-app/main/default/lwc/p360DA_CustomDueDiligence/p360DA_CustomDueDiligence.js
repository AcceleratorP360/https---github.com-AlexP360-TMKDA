import { LightningElement,api,track,wire } from 'lwc';
import getDueDiligenceRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDueDiligenceRecord';
import getDDRecords from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRecords';
import getLayoutMetadata from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getLayoutMetadata';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation'; 
import { fireEvent } from 'c/pubsub'; 


const columns = [
        { label: 'Due Diligence Name', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } },
        { label: 'Due Diligence Type', fieldName: 'P360_Due_Diligence_Type__c', type: 'text', sortable: false },
        { label: 'Status', fieldName: 'P360_Approval_Status__c', type: 'text', sortable: false }
    ];

export default class P360DA_CustomDueDiligence extends LightningElement {
    @wire(CurrentPageReference) pageRef; 

    @api recordId;
    @track isLoading = false;
    @track items;
    @track objectApiName;
    @track isLoadDataTable = true;
    @track isDueDiligenceFound = false;
    @track isDdCategoryRecordFound = false;
    @track isDdSubCategoryRecordFound = false;
    @track isReviewRecordFound = false;
    @track recordItemsDD;
    @track horizontalTab = false;
    @track isEnableEditRecord = false;
    @track isDdRecordFound = false;
    @track mainRecordId;
    @track isEditable;
    columns = columns;
    ddList;

    connectedCallback() {
        console.log('====recordId======',this.recordId);
        this.isLoading = true;
        getDueDiligenceRecord({recordId : this.recordId })
		.then(result => {
            console.log('==result=====',result);
			this.items = result;
			this.isLoading = false;
		})
		.catch(error => {
			this.error = error;
            console.log('===this.error=====',this.error);
            this.isLoading = false;
		})

        getDDRecords({accountId : this.recordId})
        .then(result => {
            console.log('===result=Contact===',result);
            console.log('===result=Contact===',result.length);
            this.contactCount = result.length;
            if(result != null && result.length > 0){
                //this.ddList = result;
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                    let tempRecord = Object.assign({}, result[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddList = tempOppList; 
                console.log('====this.ddList===',JSON.stringify(this.ddList));
            }
            this.isLoading = false;
        })
        .catch(error => {
            console.log('===error====',error);
            this.error = error;
            this.isLoading = false;
        })
    }

    handleTreeItemSelect(event){
        this.isLoading = true;
        this.isEnableEditRecord = false;
        const selectedItem = event.detail.name;
		console.log('===selectedItem===',selectedItem);
		let numArray = selectedItem.split(",");
		this.recordId = numArray[0];
        console.log('===this.recordId===',this.recordId);
		this.objectApiName = numArray[1];
        console.log('===this.objectApiName===',this.objectApiName);
        this.mainRecordId = numArray[2];
        console.log('===this.mainRecordId===',this.mainRecordId);
        if(numArray[3] == 'true'){
            this.isEditable = true;
        }else{
            this.isEditable = false;
        }
        console.log('===this.isEditable===',this.isEditable);

        fireEvent(this.pageRef, 'eventdetails',this.recordId); 

        if(this.objectApiName == 'P360_Due_Diligence__c'){
            this.isDdRecordFound = true;
            this.isDdCategoryRecordFound = false;
            this.isDdSubCategoryRecordFound = false;
            this.isReviewRecordFound = false;
        }else if (this.objectApiName == 'P360_DD_Category__c'){
            this.isDdCategoryRecordFound = true;
            this.isDdRecordFound = false;
            this.isDdSubCategoryRecordFound = false;
            this.isReviewRecordFound = false;
        }else if (this.objectApiName == 'P360_DD_Sub_Category__c'){
            this.isDdSubCategoryRecordFound = true;
            this.isDdRecordFound = false;
            this.isDdCategoryRecordFound = false;
            this.isReviewRecordFound = false;
        }else if (this.objectApiName == 'P360_Review_Area__c'){
            this.isReviewRecordFound = true;
            this.isDdRecordFound = false;
            this.isDdCategoryRecordFound = false;
            this.isDdSubCategoryRecordFound = false;
        }

        getLayoutMetadata({objName : this.objectApiName})
        .then(result => { 
            console.log('===getLayoutMetadata===result=',result);
            if(this.objectApiName == 'P360_Due_Diligence__c'){
                
            }
            this.recordItemsDD = result;
            this.horizontalTab = true;
            this.isLoadDataTable = false;
        })
        .catch(error => {
			console.log('===error====',error);
			this.error = error;
			this.isLoading = false;
			this.accounts = undefined;
		})
        this.isLoading = false;
    }

    handleRowClick(event) {
        // Extract the record id from the clicked row
        console.log('========',event.detail.selectedRows[0].Id);
        const recordId = event.detail.selectedRows[0].Id;

        // Construct the full record URL
        const recordUrl = window.location.origin + recordId;

        // Open the record URL in a new tab
        window.open(recordUrl, '_blank');
    }

    handleRowAction(event) {
        // Extract the record id from the clicked row
        console.log('========');
    }

    enableEditMode(){
		this.isEnableEditRecord = true;
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
		console.log('===fields=====',fields);
		this.template.querySelector('lightning-record-edit-form').submit(fields);
        //fields.ACCOUNT_ID_FIELD = this.recordId;
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(){
		console.log('====handleSuccess====');
		const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Record updated successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
		
		getLayoutMetadata({objName : this.objectApiName})
		.then(result => {
			console.log('==result=getLayoutMetadata====',result);
			this.recordItemsDD = result;
			this.isEnableEditRecord = false;
			this.isLoading = false;
		})
		.catch(error => {
			console.log('===error====',error);
			this.error = error;
			this.isLoading = false;
		})
	}

    handleCancel(){
		this.isEnableEditRecord = false;
	}


    renderedCallback(){
        const style = document.createElement('style');
        style.innerText = `.slds-tree__item {
                display: flex;
                padding: .24rem 0 .25rem var(--lwc-spacingMedium,1rem);
                border-bottom: 1px solid lightgray;
            }

            .slds-tree__group-header{
                    margin-bottom: 3px;
            }
            .left-pan{
                background: var(--slds-g-color-neutral-base-95, var(--lwc-splitViewColorBackground,rgb(243, 243, 243)))
            }
        `;  

        this.template.querySelector('.slds-wrap').appendChild(style);
      
    }

    togglePanel() {
        let leftPanel = this.template.querySelector("div[data-my-id=leftPanel]");
        let rightPanel = this.template.querySelector("div[data-my-id=rightPanel]");

        if (leftPanel.classList.contains('slds-is-open')) {
            leftPanel.classList.remove("slds-is-open");
            leftPanel.classList.remove("open-panel");
            leftPanel.classList.add("slds-is-closed");
            leftPanel.classList.add("close-panel");
            rightPanel.classList.add("expand-panel");
            rightPanel.classList.remove("collapse-panel");
            const style = document.createElement('style');
            style.innerText = `.slds-split-view__toggle-button{
                    padding-right: 0px;

            }
            `;  

            this.template.querySelector('.slds-wrap').appendChild(style);
        } else {
            leftPanel.classList.add("slds-is-open");
            leftPanel.classList.add("open-panel");
            leftPanel.classList.remove("slds-is-closed");
            leftPanel.classList.remove("close-panel");
            rightPanel.classList.remove("expand-panel");
            rightPanel.classList.add("collapse-panel");
            const style = document.createElement('style');
            style.innerText = `.slds-split-view__toggle-button{
                    padding-right: 10px;

            }
            `;  

            this.template.querySelector('.slds-wrap').appendChild(style);
        }
    }
}