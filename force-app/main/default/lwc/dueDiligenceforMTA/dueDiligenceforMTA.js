import {
    api,
    LightningElement,
    wire,
    track
} from 'lwc';
import getDueDiligenceRecrd from '@salesforce/apex/DueDiligenceMTACtrl.getDueDiligenceRecrd';
import cloneRecords from '@salesforce/apex/DueDiligenceMTACtrl.cloneRecords';



import { 
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
    encodeDefaultFieldValues
} from 'lightning/pageReferenceUtils';
import {
    NavigationMixin
} from 'lightning/navigation';
import {
    CloseActionScreenEvent
} from 'lightning/actions';
export default class CloneDueDiligenceLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @track data;
    @track name;
    @track actualStartDate;
    @track actualEndDate;
    @track expectedStartDate;
    @track expectedEndDate;
    @track isConfirm = false;
    @track coverHolder;
    @track isShowTable = false;
    @track isSpinner= false;
    @track isDisabled = true;
    /*@track textValue = '';
    @track isError = false;
    errorMessage = 'Maximum character limit has exceeded (80 characters)';*/
    //@track existingduediligence;
    // @wire(cloneRecords, { recordId: '$recordId'}) record;


    connectedCallback() {
        //var today = new Date();
        //this.expectedStartDate = today.toISOString();
        this.expectedStartDate = null;
        //var last=new Date(new Date().getFullYear(), 11, 32);
        //this.date1=last.toISOString();
    }


    handleNo() {
        this.isConfirm = false;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleYes() {
        this.isConfirm = true;
    }
    @wire(getDueDiligenceRecrd, {
        recordId: '$recordId'
    })
    records({
        error,
        data
    }) {
        if (data) {
            this.data = data;
            let currentDate = new Date();

            let formatter = new Intl.DateTimeFormat('en', {
                year: "numeric",
                month: "numeric",
                day: "numeric",
                hour: "2-digit",
                minute: "2-digit",
                hour12: "true"
            })

            //let formattedDate = formatter.format(currentDate);
            this.name = 'MTA for'+' '+ data.Name ;
            this.coverHolder = data.P360_CoverHolder_TPA_Name__r.Name;
            this.parentAccountSelectedRecord = data.P360_CoverHolder_TPA_Name__c;
            //this.existingduediligence = data.Name;
        }
    };

    handleNameChange(event) {
        this.name = event.target.value;
        /*if (this.name.length > 80) {
            this.isError = true;
        } else {
            this.isError = false;
        }*/
    }

    handleCoverHolderChange(event){
        this.parentAccountSelectedRecord = event.detail.id;
    }

    handleActualStartDate(event) {
        this.actualStartDate = event.target.value;
    }

    handleActualEndDate(event) {
        this.actualEndDate = event.target.value;
    }

    handleExpectedStartDate(event) {
        this.expectedStartDate = event.target.value;
    }

    handleExpectedEndDate(event) {
        this.expectedEndDate = event.target.value;
    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleSubmit() {
        this.isSpinner = true;
        cloneRecords({
                recordId: this.recordId,
                name: this.name,
                //   actualAssessmentStartDate: this.actualStartDate,
                //   actualAssessmentEndDate: this.actualEndDate,
                plannedAssessmentStartDate: this.expectedStartDate,
                plannedAssessmentEndDate: this.expectedEndDate,
                coverHolderTPAName: this.parentAccountSelectedRecord
            })
            .then(result => {
                this.dispatchEvent(new CloseActionScreenEvent());
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result,
                        actionName: 'view',
                        objectApiName: 'P360_Due_Diligence__c'
                    }
                })
                /*.then(url => {
                    window.open(url);
                });*/
                this.isSpinner = false;
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'MTA for Due Diligence has been done successfully!',
                    variant: 'Success',
                });
                this.dispatchEvent(evt);
            })
            .catch(error => {
                this.isSpinner = false;
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: JSON.stringify(error.body.message),
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            })
    }

    @track accoutData;
    handleAccountRecrds(event){
       this.coverHolder =  event.target.value;
       getTPArecords({searchName:this.coverHolder})
       .then(result =>{
        if(result){
            this.isShowTable = true;
            this.accoutData = result;
        }
    })
    }

    parentAccountSelectedRecord;
    handleValueSelectedOnAccount(event) {
        this.parentAccountSelectedRecord = event.detail.id;
    }
    /*@api invoke() {
        //urlencode the field values for protection
        const defaultValues = encodeDefaultFieldValues({
            recordId : this.recordId
        });
        cloneRecords({recordId:this.recordId})
        .then(result =>{
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result,
                    actionName: 'view',
                    objectApiName: 'P360_Due_Diligence__c'
                }
            }).then(url => {
                window.open(url);
            });
        })
        .catch(error =>{
            this.errorMsg = error;
        })
    }*/
}