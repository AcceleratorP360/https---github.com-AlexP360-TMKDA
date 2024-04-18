import { LightningElement,api,track,wire  } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDDCatRelatedRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDCatRelatedRecord';
import getDdCategoriesLinkage from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDdCategoriesLinkage';
import { getRecord } from 'lightning/uiRecordApi';

const columns = [
        { label: 'Sub Categories', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true },
        { label: 'Category Name', fieldName: 'DDName', type: 'text', sortable: true},
        { label: 'Connected To Primary?', fieldName: 'TMKDA_Connect_To_Primary__c', type: 'text'},
        { label: 'Review Area Completion Status', fieldName: 'Review_Area_Completion_Status_linkage__c', type: 'image'},
        { label: 'Completion Marker', fieldName: 'Completion_Marker_linkage__c', type: 'text', sortable: true },
    ];

export default class P360DA_CustomCategoryLayout extends LightningElement {
    columns = columns;
    section = ['A','B','C','D'];
    @api recordId;
    @api objectApiName;
    @api mainRecordId;
    @api isEditable;
    @track leftRiskyFields;
    @track rightRiskyFields;
    @track isEnableEditRecord = false;
    @track ddRelatedCount;
    @track isCateRelatedSubCat = false;
    @track ddSubRelatedtList;
    @track linkageRecordId;

    @track sortedBy;
    @track sortedDirection = 'asc';

    fields = ['Name'];

    connectedCallback() {
        if(this.isEditable == false){
            getDdCategoriesLinkage({recordId : this.recordId,mainRecordId : this.mainRecordId})
            .then(result => {
                console.log('==result=getDdCategoriesLinkage====',result);
                this.linkageRecordId = result;
            })
            .catch(error => {
                console.log('===error====',error);
                this.error = error;
                this.isLoading = false;
            })
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: ['P360_DD_Category__c.Name'] })
    wiredRecord({ error, data }) {
        if (data) {
            // Access field values from the data object
            console.log('Field 1 Value:',data);
            const field1Value = data.fields.Name.value;

            if(field1Value.includes('Conduct')){
                this.leftRiskyFields = [ {label : 'TMKDA_High_Risk_Customer_Type__c',fieldWritable : true}, {label : 'TMKDA_Number_of_BPAs__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'TMKDA_Highest_PDT_Output__c',fieldWritable : true}, {label : 'TMKDA_Does_attestation_confirm_a_new_TCF__c',fieldWritable : true}];
            }else if(field1Value.includes('Claims')){
                this.leftRiskyFields = [ {label : 'P360_Loss_Fund__c',fieldWritable : true}, {label : 'TMKDA_Has_a_new_Claims_Procedure__c',fieldWritable : true}, {label : 'TMKDA_Coverholder_have_claims_authority__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'P360_CT_Date_of_claims_sign_off_review__c',fieldWritable : true}, {label : 'TMKDA_Claims_authority_limit__c',fieldWritable : true}, {label : 'TMKDA_Are_Claims_delegated_to_a_DCA__c',fieldWritable : true}];
            }else if(field1Value.includes('Data Quality')){
                this.leftRiskyFields = [];
                this.rightRiskyFields = [ {label : 'TMKDA_High_Monitored_List__c',fieldWritable : true}];
            }else if(field1Value.includes('Data & Information Security')){
                this.leftRiskyFields = [ {label : 'TMKDA_Has_a_new_Info_Security_policy__c',fieldWritable : true}, {label : 'P360_Highest_data_type_held__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'TMKDA_Has_a_new_Data_Protection_policy__c',fieldWritable : true}, {label : 'TMKDA_Is_GDPR_in_scope__c',fieldWritable : true}];
            }else if(field1Value.includes('Controls & Risk Framework')){
                this.leftRiskyFields = [ {label : 'TMKDA_Is_Operational_Resilience_in_scope__c',fieldWritable : true}, {label : 'TMKDA_Does_attestation_confirm_a_new_DRP__c',fieldWritable : true}, {label : 'TMKDA_Has_a_new_whistleblowing_policy__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'P360_In_Scope_for_Whistleblowing__c',fieldWritable : true}, {label : 'TMKDA_Does_attestation_confirm_a_new_BCP__c',fieldWritable : true}, {label : 'TMKDA_attestationconfirmnew_Outsourci__c',fieldWritable : true}];
            }else if(field1Value.includes('Financial & Credit')){
                this.leftRiskyFields = [{label : 'TMKDA_Has_a_new_Accounting_Procedure__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'P360_JMD_rating_at_latest_review__c',fieldWritable : true}];
            }else if(field1Value.includes('Complaints')){
                this.leftRiskyFields = [{label : 'TMKDA_Level_of_Authority__c',fieldWritable : true},{label : 'TMKDA_Has_a_new_Complaints_policy__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'TMKDA_attestationconfirm_a_new_Complaint__c',fieldWritable : true}];
            }else if(field1Value.includes('Company')){
                this.leftRiskyFields = [ {label : 'TMKDA_Distribution_channel__c',fieldWritable : true}, {label : 'TMKDA_Attestation_new_Succession_plan__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'TMKDA_Highest_underwriting_authority__c',fieldWritable : true}, {label : 'TMKDA_Attestation_has_new_system__c',fieldWritable : true}];
            }else if(field1Value.includes('Insurance Distribution Directive')){
                this.leftRiskyFields = [ ];
                this.rightRiskyFields = [ ];
            }else if(field1Value.includes('Financial Crime')){
                this.leftRiskyFields = [ {label : 'TMKDA_Inherent_AB_C__c',fieldWritable : true}, {label : 'TMKDA_Inherent_Sactions__c',fieldWritable : true}, {label : 'TMKDA_Hasnew_Conflictsof_Interest_policy__c',fieldWritable : true}];
                this.rightRiskyFields = [ {label : 'TMKDA_Inherent_AML__c',fieldWritable : true}, {label : 'TMKDA_Attestation_Fin_Crime_policy__c',fieldWritable : true}];
            }
            

            // Use the field values as needed
            console.log('Field 1 Value:', field1Value);
        } else if (error) {
            console.error('Error loading record', error);
        }
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        // Perform sorting based on the column clicked
        this.ddSubRelatedtList = [...this.ddSubRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }

    @wire(getDDCatRelatedRecord, { ddRecordId:'$mainRecordId',recordId : '$recordId'})
    wiredData({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:', data);
            console.log('===result=Contact===',data.length);
            this.ddRelatedCount = data.length;
            if(data != null && data.length > 0){
                //this.ddSubRelatedtList = data;
                this.ddSubRelatedtList = data.map(ele => {
                    return {...ele, 'DDName' : ele.P360_DA_Sub_Category_Name__r.P360_Category_Name__r.Name}
                });  

                var tempOppList = [];  
                for (var i = 0; i < this.ddSubRelatedtList.length; i++) {  
                    let tempRecord = Object.assign({}, this.ddSubRelatedtList[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.P360_DA_Sub_Category_Name__c;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddSubRelatedtList = tempOppList; 

                this.isCateRelatedSubCat = true;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    enableEditMode(){
        console.log('========');
        this.isEnableEditRecord = true;
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
		console.log('===fields=====',fields);
		this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(){
		console.log('====handleSuccess====');
		const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Record updated successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
        this.isEnableEditRecord = false;
	}

    handleError(event){
        console.log('======handleError called=======');
         console.log('Error updating record', event.detail);
    }

    handleCancel(){
		this.isEnableEditRecord = false;
	}

    handleOpenRecords(){
		const currentDomain = window.location.hostname;
        console.log('Current Domain:', currentDomain);

		const recordPageUrl = 'https://' + currentDomain + '/lightning/r/' + this.objectApiName + '/' + this.recordId + '/view';
		window.open(recordPageUrl, '_blank');
	}

    renderedCallback(){
        const style = document.createElement('style');
        style.innerText = `.slds-accordion__summary-action  {
                background: var(--slds-g-color-neutral-base-95, var(--lwc-colorBackground,rgb(243, 243, 243)));
                border: none;
            }
            .slds-accordion__list-item{
                border: none;
            }
        `;  

        this.template.querySelector('.main_container').appendChild(style);
      
    }

}