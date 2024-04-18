import { LightningElement ,api,wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = [
    'P360_DD_Category__c.Id',
    'P360_DD_Category__c.Name',
    'P360_DD_Category__c.P360_Due_Diligence__c'
];

export default class Buttoncategory extends LightningElement {
    @api recordId; 
     // Assuming you are passing the recordId of P360_Due_Diligence__c to this component

    ddCategoryId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.ddCategoryId = data.fields.P360_DD_Category__c.value;
        } else if (error) {
            // Handle error
            console.error('Error retrieving related records', error);
        }
    }

    handleClick() {
        if (this.ddCategoryId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.ddCategoryId,
                    actionName: 'view'
                }
            });
        } else {
            console.error('Error retrieving related records', error);
        }
    }
}