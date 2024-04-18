import { LightningElement , api} from 'lwc';

export default class ReviewArealinkage extends LightningElement {

    @api records;

    get columns() {
        return [
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
    }
}