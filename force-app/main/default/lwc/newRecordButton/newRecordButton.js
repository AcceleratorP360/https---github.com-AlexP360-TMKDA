import { LightningElement,api  } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NewRecordButton extends NavigationMixin(LightningElement) {
    @api navigateToNewCategory() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'P360_DD_Category__c',
                actionName: 'new'
            }
        });
    }
}