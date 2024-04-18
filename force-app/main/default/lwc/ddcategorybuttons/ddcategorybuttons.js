import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCategoryDetails from '@salesforce/apex/CategoryController.getCategoryDetails';
//import ParentId from '@salesforce/schema/Account.ParentId';
export default class Ddcategorybuttons extends NavigationMixin(LightningElement) {

    @api recordId;
    categoryId;
    categoryName;
    duediligenceName;
   

    connectedCallback() {
        // Call an Apex method to get category details when component is connected to DOM
        getCategoryDetails({ recordId: this.recordId })
            .then(result => {
                this.categoryId = result.Id;
                this.categoryName = result.Name;
                this.duediligenceName = result.P360_Due_Diligence_Name__c;
            })
            .catch(error => {
                console.error('Error retrieving category details: ', error);
            });
        }

        handleClick() {
           //recordId = event.target.label;
            // Navigate to the detail page of the category record
           this[NavigationMixin.Navigate]({
             //const pageReference = {
                type: 'standard__recordPage',
                attributes: {
            //recordId: "a063L000006a7j6QAA",
              recordId: this.categoryId,  
               objectApiName: 'P360_DD_Category__c',
                                                   
                    actionName: 'view'
                }
         //  };
            });

           // this[NavigationMixin.Navigate](pageReference);
        }
    }