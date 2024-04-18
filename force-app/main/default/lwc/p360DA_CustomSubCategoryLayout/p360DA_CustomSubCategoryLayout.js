import { LightningElement,api,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDDCatRelatedRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDdSubCatRelatedRecord';
import getDdSubCategoriesLinkage from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDdSubCategoriesLinkage';

const columns = [
        { label: 'Review Area',fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true },
        { label: 'Sub-Category', fieldName: 'P360_DA_Sub_Category_linkage__c', type: 'text', sortable: true},
        { label: 'Severity', fieldName: 'Severity_linkage__c', type: 'text', sortable: true},
        { label: 'Connect To Primary?', fieldName: 'TMKDA_Connect_To_Primary__c', type: 'text'},
        { label: 'Review Point', fieldName: 'P360_Review_Point__c', type: 'text', sortable: true },
        { label: 'Source', fieldName: 'TMKDA_Source__c', type: 'text', sortable: true },
        { label: 'Answer', fieldName: 'TMKDA_Answer__c', type: 'text', sortable: true },
        { label: 'Comment', fieldName: 'P360_Comment__c', type: 'text', sortable: true },
        { label: 'Assessment', fieldName: 'P360_Assessment__c', type: 'text', sortable: true },
    ];

export default class P360DA_CustomSubCategoryLayout extends LightningElement {

    columns = columns;
    section = ['A','B','C','D'];
    @api recordId;
    @api isEditable;
    @api objectApiName;
    @api mainRecordId;
    @track isEnableEditRecord = false;
    @track issSubRelatedReview = false;
    @track ddSubRelatedtReviewList;
    @track ddRelatedCount;
    @track linkageRecordId;

    @track sortedBy;
    @track sortedDirection = 'asc';

    connectedCallback() {
        if(this.isEditable == false){
            getDdSubCategoriesLinkage({recordId : this.recordId,mainRecordId : this.mainRecordId})
            .then(result => {
                console.log('==result=getDdSubCategoriesLinkage====',result);
                this.linkageRecordId = result;
            })
            .catch(error => {
                console.log('===error====',error);
                this.error = error;
                this.isLoading = false;
            })
        }
    }


    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        // Perform sorting based on the column clicked
        this.ddSubRelatedtReviewList = [...this.ddSubRelatedtReviewList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }


    @wire(getDDCatRelatedRecord, { ddRecordId:'$mainRecordId',recordId : '$recordId'})
    wiredData({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:', data);
            console.log('===result=Contact===',data.length);
            this.ddRelatedCount = data.length;
            if(data != null && data.length > 0){
                //this.ddSubRelatedtList = data;
                //this.ddSubRelatedtReviewList = data;
                var tempOppList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.P360_DA_Review_Area_Name__c;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddSubRelatedtReviewList = tempOppList; 

                this.issSubRelatedReview = true;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    enableEditMode(){
        console.log('========');
        this.isEnableEditRecord = true;
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