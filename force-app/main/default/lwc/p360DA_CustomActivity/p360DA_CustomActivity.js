import { LightningElement, wire, api, track } from 'lwc';
import { registerListener, unregisterAllListeners } from 'c/pubsub'; 
import getRecordsName from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getRecordsName';

export default class P360DA_CustomActivity extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track selectedRecord;

    connectedCallback() {
        registerListener('eventdetails', this.sutUpDetails, this); 
        console.log('connectedCallback : recordId :======== ',this.recordId);
    }

    sutUpDetails(recordIds){ 
        console.log('====recordIds===',recordIds);
        this.recordId = recordIds; 
        this.connectedCallback();

    } 

    @wire(getRecordsName, { recordId : '$recordId'})
    wiredData({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from ApexgetRecordsName===:', data);
            if(data != null ){
                this.selectedRecord = data;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

}