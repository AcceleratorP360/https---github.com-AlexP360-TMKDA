import { LightningElement, api, wire } from 'lwc';
import getSurveysForDueDiligence from '@salesforce/apex/SIController.getSurveysForDueDiligence';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'CH Name', fieldName: 'P360_DD_Coverholder_Name__c' },
    { label: 'Invitation Link', fieldName: 'InvitationLink' },
    //{ label: 'Due Diligence', fieldName: 'Due_Diligence__c' },
   // { label: 'Participant Name', fieldName: 'Contact.Name' },
    { label: 'DD Record Id', fieldName: 'P360_DD_record_Id__c' }	
];

export default class SurveyInvitationComponent extends LightningElement {
    @api recordId;
    surveys;
    columns = columns;

    @wire(getSurveysForDueDiligence, { dueDiligenceId: '$recordId' })
    wiredSurveys({ error, data }) {
        if (data) {
            this.surveys = data;
        } else if (error) {
            console.error('Error retrieving surveys:', error);
        }
    }
}