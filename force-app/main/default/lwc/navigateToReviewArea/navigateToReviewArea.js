import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
 
export default class NavigateToReviewArea extends NavigationMixin(LightningElement) {
 
    refUrl;
    navigateToCustomTab() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Review_Area'
            },
        });
    }
   
}