import { LightningElement, wire, api } from 'lwc';
import getAccountContacts from '@salesforce/apex/P360_BPA_viewAttestationform.getAccountContacts';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' }
    
];

export default class MyComponent extends LightningElement {
    @api recordId;
    contacts;
    error;

    @wire(getAccountContacts, { accountId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    get columns() {
        return columns;
    }
}