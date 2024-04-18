import { LightningElement, wire, api, track } from 'lwc';
import getbpaAttestation from '@salesforce/apex/P360_BPA_viewAttestationform.getbpaAttestation';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import TMK_Logo from '@salesforce/resourceUrl/TMK_Logo';

export default class BPAAttestation extends LightningElement {
    @api recordId;
    summaryId;
    TMK_Logo_URL = TMK_Logo;
    @track data;
    saveDraftValues = [];
    error;
    @track columns = [
        { label: "Question Description", fieldName: "Name", type: "text", wrapText: true },
        { label: "Coverholder Comment", fieldName: "TMKDA_Coverholder_Comment__c", type: "text" ,editable : true},
        { label: "Information", fieldName: "TMKDA_Information__c", type: "text",editable : true },
        { label: "Confirmation Statement Accurate", fieldName: "TMKDA_Confirmation_Statement_Accurate__c", type: "boolean",editable : true }
    ];
    

    @wire(getbpaAttestation, {summaryId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.data = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
 
        // Updating the records using the UiRecordAPI
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.showToast('Error', 'An Error Occurred!', 'error', 'dismissable');
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }
 
    showToast(title, message, variant, mode){
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
        await refreshApex(this.data);
    }
}