import { LightningElement,api,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getReviewLinkage from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getReviewLinkage';
import { getRecord, getFieldValue  } from "lightning/uiRecordApi";
import REVIEW_AREA_NASTER_FIELD from "@salesforce/schema/P360_Review_Area__c.P360_DA_Review_Area_ID__c";

const FIELDS = [REVIEW_AREA_NASTER_FIELD];

export default class P360DA_CustomReviewAreaLayout extends LightningElement {
    section = ['A','B','C','D'];
    @api recordId;
    @api objectApiName;
    @api isEditable;
    @api mainRecordId;
    @track isEnableEditRecord =false;
    @track linkageRecordId;


    @track listleftSideFieldWrapperReview = [{label : 'P360_DA_Review_Area_Name__c',fieldWritable : false},{label : 'P360_DA_Review_Area_ID__c',fieldWritable : true},{label : 'P360_Review_Point__c',fieldWritable : true},{label : 'TMKDA_Answer__c',fieldWritable : true},{label : 'P360_Pass_Fail__c',fieldWritable : true}];

    @track listrightSideFieldWrapperReview = [{label : 'TMKDA_Severity__c',fieldWritable : true},{label : 'P360_Completion_Marker__c',fieldWritable : true},{label : 'TMKDA_Source__c',fieldWritable : true},{label : 'P360_Comment__c',fieldWritable : true}]; //,{label : 'P360_Guidance__c',fieldWritable : true}

    enableEditMode(){
        console.log('========');
        this.isEnableEditRecord = true;
    }

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    reviewArea;

    get masterReviewArea() {
        //return this.reviewArea.data.fields.P360_DA_Review_Area_ID__c.value;
        return getFieldValue(this.reviewArea.data, REVIEW_AREA_NASTER_FIELD);
    }

    connectedCallback() {
        if(this.isEditable == false){
            getReviewLinkage({recordId : this.recordId,mainRecordId : this.mainRecordId})
            .then(result => {
                console.log('==result=getReviewLinkage====',result);
                this.linkageRecordId = result;
            })
            .catch(error => {
                console.log('===error====',error);
                this.error = error;
                this.isLoading = false;
            })
        }
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
		console.log('===fields=====',fields);
		this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(){
		console.log('====handleSuccess====');
		const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Record updated successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
        this.isEnableEditRecord = false;
	}

    handleError(event){
        console.log('======handleError called=======');
         console.log('Error updating record', event.detail);
    }

    handleCancel(){
		this.isEnableEditRecord = false;
	}

    handleOpenRecords(){
		const currentDomain = window.location.hostname;
        console.log('Current Domain:', currentDomain);

		const recordPageUrl = 'https://' + currentDomain + '/lightning/r/' + this.objectApiName + '/' + this.recordId + '/view';
		window.open(recordPageUrl, '_blank');
	}
    
    renderedCallback(){
        const style = document.createElement('style');
        style.innerText = `.slds-accordion__summary-action  {
                background: var(--slds-g-color-neutral-base-95, var(--lwc-colorBackground,rgb(243, 243, 243)));
                border: none;
            }
            .slds-accordion__list-item{
                border: none;
            }
        `;  

        this.template.querySelector('.main_container').appendChild(style);
      
    }
}