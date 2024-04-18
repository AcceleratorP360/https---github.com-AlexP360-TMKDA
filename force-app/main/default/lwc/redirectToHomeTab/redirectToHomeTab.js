import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

export default class RedirectHome extends NavigationMixin(LightningElement) {
    @api recordId; // Required to get the recordId from the context

    @wire(getRecord, { recordId: '$recordId', fields: ['TMKDA_BPA_Summary_Header__c.TMKDA_BPA_UW_Review_Approval__c'] })
    bpa;

    connectedCallback() {
        if(this.bpa.data && this.bpa.data.fields.TMKDA_BPA_UW_Review_Approval__c.value === 'Reviewed') {
            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'home'
                }
            });
        }
    }
}