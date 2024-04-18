import { LightningElement } from 'lwc';
import getReviewLinkageRecords from '@salesforce/apex/Linked_Review_Area_List.getReviewLinkageRecords';

export default class Catagorybuttonupdated extends LightningElement {

   // clickedButtonLabel;
   reviewAreaRecords ;
   columns = [
    { label: 'Review Area', fieldName: 'Name', type: 'text' },
    { label: 'Category Name', fieldName: '	P360_DA_Category_linkage__c', type: 'text' },
    { label: 'Connected To Primary?', fieldName: '	TMKDA_Connect_To_Primary__c', type: 'Picklist' },
    { label: 'Review Point', fieldName: 'Review_Point_linkage__c', type: 'text' },
    { label: 'Completion Marker', fieldName: 'Completion_Marker_linkage__c', type: 'text' },
    { label: 'Severity', fieldName: 'Severity_linkage__c', type: 'text' },
    { label: 'Answer', fieldName: '	Answer__c', type: 'text' },
    { label: 'Assessment', fieldName: '	Pass_Fail_linkage__c', type: 'text' },
    { label: 'Source', fieldName: '	P360_DA_Source__c', type: 'text' },
    { label: 'Comment', fieldName: 'Comment__c', type: 'Long Text Area(' } 
];
    

    handleClick(event) {
        const categoryId = event.target.key;
        //const category = event.target.label;
       // this.clickedButtonLabel = event.target.label;
        getReviewLinkageRecords({ categoryId })
            .then(result => {
                this.reviewAreaRecords  = result;
            })
            .catch(error => {
                console.error('Error retrieving related records', error);
            })
}

}