import { LightningElement ,api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import P360_DA_Category_Name__c from '@salesforce/schema/P360_DA_DD_Categories_Linkage__c.P360_DA_Category_Name__c';
import Name from '@salesforce/schema/P360_DA_DD_Categories_Linkage__c.Name';
import 	P360_DA_Review_Area_Name__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.P360_DA_Review_Area_Name__c';
import 	P360_DA_Category_linkage__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.P360_DA_Category_linkage__c';
import TMKDA_Connect_To_Primary__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.TMKDA_Connect_To_Primary__c';
import 	Review_Point_linkage__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.Review_Point_linkage__c';
import 	Completion_Marker_linkage__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.Completion_Marker_linkage__c';
import 	Severity_linkage__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.Severity_linkage__c';
import 	Answer__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.Answer__c';
import Assessment_linkage__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.Assessment_linkage__c';
import 	P360_DA_Source__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.P360_DA_Source__c';
import 	Comment__c from '@salesforce/schema/P360_DA_DD_Review_Area_Linkage__c.Comment__c';

export default class Categorybutton extends LightningElement {

    @api recordId;

    fields = [P360_DA_Review_Area_Name__c,TMKDA_Connect_To_Primary__c,P360_DA_Category_linkage__c,Review_Point_linkage__c,Completion_Marker_linkage__c,
              Severity_linkage__c,Answer__c,Assessment_linkage__c,P360_DA_Source__c,Comment__c];

    @wire(getRecord, { recordId: '$recordId', fields: [P360_DA_Category_Name__c, Name] })
    parentRecord;

    navigateToChildRecords() {
        if (this.parentRecord.data) {
            const childRecordIds = getFieldValue(this.parentRecord.data, fields);
            if (childRecordIds) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: childRecordIds,
                        actionName: 'view'
                    }
                });
            } else {
                this.showToast('Error', 'No child records found.', 'error');
            }
        }
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

}