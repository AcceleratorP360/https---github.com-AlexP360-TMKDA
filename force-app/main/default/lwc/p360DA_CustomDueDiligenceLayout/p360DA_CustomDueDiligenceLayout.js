import { LightningElement,api,track,wire } from 'lwc';
import getDDRelatedRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRelatedRecord';
import getDDRelatedActionRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRelatedActionRecord';
import getDDRelatedBindersRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRelatedBindersRecord';
import getDDRelatedDamoRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRelatedDamoRecord';
import getDDRelatedSummaryRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRelatedSummaryRecord';
import getDDRelatedAttestationsRecord from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getDDRelatedAttestationsRecord';
//import updateObject from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.updateObject';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

    const columns = [
        { label: 'Category', fieldName: 'DDName', type: 'text', sortable: true },
        { label: 'Category Name', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true},
        { label: 'Connected To Primary?', fieldName: 'TMKDA_Connect_To_Primary__c', type: 'text'},
        { label: 'Category Name', fieldName: 'DDName', type: 'text', sortable: true },
        { label: 'Sub-Category Completation Status', fieldName: 'Sub_Category_Completion_Status_Linkage__c', type: 'image' },
        { label: 'Completion Marker', fieldName: 'Completion_Marker_linkage__c   ', type: 'text' , sortable: true},
        { label: 'Summary', fieldName: 'P360_DA_Summary_linkage__c', type: 'text' , sortable: true},
    ];

    const columns1 = [
        { label: 'Action Id', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true },
        { label: 'Action', fieldName: 'P360_Action__c', type: 'text', sortable: true},
        { label: 'Action Description ', fieldName: 'P360_Description__c', type: 'text', sortable: true },
        { label: 'Assigned To', fieldName: 'User__c   ', type: 'text', sortable: true }
    ];

    const columns2 = [
        { label: 'Binder Name', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true },
        { label: '	Expiry Date', fieldName: 'P360_Expiry_Date__c', type: 'text', sortable: true},
        { label: 'Inception Date ', fieldName: 'P360_Inception_date__c', type: 'text', sortable: true },
    ];

    const columns3 = [
        { label: 'DAMO / PUGC Approval Request', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true },
        { label: 'Start Date', fieldName: 'TMKDA_Start_Date__c', type: 'text', sortable: true},
        { label: 'Outcome Status', fieldName: 'TMKADA_Outcome_status__c', type: 'text', sortable: true },
        { label: 'Outcome Reason', fieldName: 'TMKDA_Outcome_reason__c', type: 'text', sortable: true }
    ];

    const columns4 = [
        { label: 'Name', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } , sortable: true},
        { label: 'Stages', fieldName: 'TMKDA_BPA_Stage__c', type: 'text', sortable: true},
        { label: 'Start Date', fieldName: 'TMKDA_BPA_Start_Date__c', type: 'text' , sortable: true},
        { label: 'End Date', fieldName: 'TMKDA_BPA_End_Date__c', type: 'text', sortable: true }
    ];

    const columns5 = [
        { label: 'Name', fieldName: 'recordLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, sortable: true },
        { label: 'Stages', fieldName: 'TMKDA_Attestation_Stages__c', type: 'text', sortable: true},
    ];

export default class P360DA_CustomDueDiligenceLayout extends LightningElement {
    columns = columns;
    columnsAction = columns1;
    columnsBinder = columns2; 
    columnsDamo = columns3; 
    columnsSummary =  columns4; 
    columnsAttestations = columns5;
    section = ['A','B','C','D','E'];
    @api recordId;
    @api objectApiName;
    @track listleftSideFieldWrapperCoverHolder = [ {label : 'P360_Due_Diligence_Record_Id__c',fieldWritable : false},{label : 'P360_CoverHolder_TPA_Name__c',fieldWritable : true},{label : 'P360_Due_Diligence_Type__c',fieldWritable : true},{label : 'TMKDA_Domicile__c',fieldWritable : true},{label : 'P360_DD_Total_EPI__c',fieldWritable : true},{label : 'TMKDA_Previous_Committee_Date__c',fieldWritable : true},{label : 'TMKDA_DD_Connection_Status__c',fieldWritable : true},{label : 'P360_DD_Number_of_Run_Off_Binders__c',fieldWritable : true},{label : 'P360_DD_Risk_Location__c',fieldWritable : true},{label : 'TMKDA_Overview__c',fieldWritable : true}];

    @track listrightSideFieldWrapperCoverHolder = [ {label : 'Name',fieldWritable : true},{label : 'TMKDA_Primary_Due_Diligence_record__c',fieldWritable : true},{label : 'P360_DD_Coverholder_or_DCA__c',fieldWritable : true},{label : 'TMKDA_Binder_Renewal_Date__c',fieldWritable : true},{label : 'P360_DD_Coverholder_Live_Date__c',fieldWritable : true},{label : 'P360_DD_Line_of_Business__c',fieldWritable : true},{label : 'P360_DD_Number_of_Live_Binders__c',fieldWritable : true},{label : 'P360_Due_Diligence_Connection__c',fieldWritable : true},{label : 'P360_DD_Customer_Domicile__c',fieldWritable : true}];

    @track listleftSideFieldWrapperReview = [{label : 'P360_Attestation_Signed_By__c',fieldWritable : true},{label : 'P360_Completed_By__c',fieldWritable : true},{label : 'P360_DA_Peer_Reviewer__c',fieldWritable : true},{label : 'TMKDA_Committee__c',fieldWritable : true}];

    @track listrightSideFieldWrapperReview = [{label : 'P360_Date_Attestation_Received__c',fieldWritable : true},{label : 'TMKDA_Committee_Date_Completed__c',fieldWritable : true},{label : 'P360_Date_Signed_Off__c',fieldWritable : true},{label : 'TMKDA_Committee_Date_Completed__c',fieldWritable : true}];

    @track isEnableEditRecord = false;
    @track isAccRelatedCon = false;
    @track isAccRelatedAction = false;
    @track isAccRelatedBinders = false;
    @track isAccRelatedDamo = false;
    @track isAccRelatedSummary = false;
    @track isAccRelatedAttestations = false;
    @track ddRelatedtList;
    @track ddRelatedCount;
    @track ddActionRelatedtList;
    @track ddActionRelatedCount;
    @track ddBinderRelatedCount;
    @track ddBinderRelatedtList;
    @track ddDamoRelatedCount;
    @track ddDamoRelatedtList;
    @track ddSummaryRelatedCount;
    @track ddSummaryRelatedtList;
    @track ddAttestationsRelatedCount;

    @track sortedBy;
    @track sortedDirection = 'asc';

    @track sortedByPRAs;
    @track sortedDirectionPRAs = 'asc';

    @track sortedByBinders;
    @track sortedDirectionBinders = 'asc';

    @track sortedByAtt;
    @track sortedDirectionAtt = 'asc';

    @track sortedByDAMO;
    @track sortedDirectionDAMO = 'asc';

    @track sortedByBPAs;
    @track sortedDirectionBPAs = 'asc';
    

    @wire(getDDRelatedRecord, { recordId: '$recordId'})
    wiredData({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:', data);
            console.log('===result=Contact===',data.length);
            this.ddRelatedCount = data.length;
            if(data != null && data.length > 0){
                this.ddRelatedtList = data.map(ele => {
                    console.log('===ele.P360_DA_Category_Name__r.Name====',ele.P360_DA_Category_Name__r.Name);
                    return {...ele, 'DDName' : ele.P360_DA_Category_Name__r.Name}
                }); 
                console.log('===ddRelatedtList=======',JSON.stringify(this.ddRelatedtList));

                var tempOppList = [];  
                for (var i = 0; i < this.ddRelatedtList.length; i++) {  
                    let tempRecord = Object.assign({}, this.ddRelatedtList[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddRelatedtList = tempOppList; 

                //this.ddRelatedtList = data;
                this.isAccRelatedCon = true;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    @wire(getDDRelatedActionRecord, { recordId: '$recordId'})
    wiredData1({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:getDDRelatedActionRecord===', data);
            console.log('===result=Contact===',data.length);
            this.ddActionRelatedCount = data.length;
            if(data != null && data.length > 0){
                var tempOppList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddActionRelatedtList = tempOppList;
                //this.ddRelatedtList = data;
                this.isAccRelatedAction = true;
            }else{
                this.isAccRelatedAction = false;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    @wire(getDDRelatedBindersRecord, { recordId: '$recordId'})
    wiredData2({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:getDDRelatedBindersRecord===', data);
            console.log('===result=Contact===',data.length);
            this.ddBinderRelatedCount = data.length;
            if(data != null && data.length > 0){
                var tempOppList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddBinderRelatedtList = tempOppList;
                //this.ddRelatedtList = data;
                this.isAccRelatedBinders = true;
            }else{
                this.isAccRelatedBinders = false;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    @wire(getDDRelatedDamoRecord, { recordId: '$recordId'})
    wiredData3({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:getDDRelatedDamoRecord===', data);
            console.log('===result=Contact===',data.length);
            this.ddDamoRelatedCount = data.length;
            if(data != null && data.length > 0){
                var tempOppList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddDamoRelatedtList = tempOppList;
                //this.ddRelatedtList = data;
                this.isAccRelatedDamo = true;
            }else{
                this.isAccRelatedDamo = false;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    @wire(getDDRelatedSummaryRecord, { recordId: '$recordId'})
    wiredData4({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:getDDRelatedDamoRecord===', data);
            console.log('===result=Contact===',data.length);
            this.ddSummaryRelatedCount = data.length;
            if(data != null && data.length > 0){
                var tempOppList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddSummaryRelatedtList = tempOppList;
                //this.ddRelatedtList = data;
                this.isAccRelatedSummary = true;
            }else{
                this.isAccRelatedSummary = false;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    @wire(getDDRelatedAttestationsRecord, { recordId: '$recordId'})
    wiredData5({ error, data }) {
        if (data) {
            // Handle the data
            console.log('data from Apex:getDDRelatedAttestationsRecord===', data);
            console.log('===result=Contact===',data.length);
            this.ddAttestationsRelatedCount = data.length;
            if(data != null && data.length > 0){
                var tempOppList = [];  
                for (var i = 0; i < data.length; i++) {  
                    let tempRecord = Object.assign({}, data[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.Id;  
                    tempOppList.push(tempRecord);  
                }  
                this.ddAttestationsRelatedtList = tempOppList;
                //this.ddRelatedtList = data;
                this.isAccRelatedAttestations = true;
            }else{
                this.isAccRelatedAttestations = false;
            }
        } else if (error) {
            // Handle the error
            console.error('Error calling Apex:', error);
        }
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        // Perform sorting based on the column clicked
        this.ddRelatedtList = [...this.ddRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }

    handleSortPRAs(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedByPRAs = fieldName;
        this.sortedDirectionPRAs = sortDirection;

        // Perform sorting based on the column clicked
        this.ddActionRelatedtList = [...this.ddActionRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }

    handleSortBinders(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedByBinders = fieldName;
        this.sortedDirectionBinders = sortDirection;

        // Perform sorting based on the column clicked
        this.ddBinderRelatedtList = [...this.ddBinderRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }

    handleSortAtt(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedByAtt = fieldName;
        this.sortedDirectionAtt = sortDirection;

        // Perform sorting based on the column clicked
        this.ddAttestationsRelatedtList = [...this.ddAttestationsRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }

    handleSortDAMO(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedByDAMO = fieldName;
        this.sortedDirectionDAMO = sortDirection;

        // Perform sorting based on the column clicked
        this.ddDamoRelatedtList = [...this.ddDamoRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }

    handleSortBPAs(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedByBPAs = fieldName;
        this.sortedDirectionBPAs = sortDirection;

        // Perform sorting based on the column clicked
        this.ddSummaryRelatedtList = [...this.ddSummaryRelatedtList].sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];

            if (typeof valueA === 'string' || valueA instanceof Date) {
                valueA = valueA.toString().toLowerCase();
                valueB = valueB.toString().toLowerCase();
            }

            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
    }


    enableEditMode(){
        console.log('========');
        this.isEnableEditRecord = true;
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        console.log('===fields=====',fields);
        const rec =this.recordId;
        console.log('===event.detail=====',event.detail);
        console.log('===rec====',rec);
		//this.template.querySelector('lightning-record-edit-form').submit(fields);
        /*updateObject({recordId: rec, updatedObject: fields })
        .then((result) => {
            console.log('result result : ',result);
            if(result == 'success'){
                this.handleSuccess();
            }else{

            }
        })
        .catch((error) => {
            console.log('getLookupObjectList error : ',error);
        });*/
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