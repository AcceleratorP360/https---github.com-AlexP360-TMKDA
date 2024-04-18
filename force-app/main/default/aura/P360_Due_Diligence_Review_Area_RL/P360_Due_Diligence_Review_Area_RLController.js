({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Review Area', fieldName: 'P360_DA_Review_Area_Name__c', type: 'text' , editable: true},
            {label: 'Review Point	', fieldName: 'P360_Review_Point__c', type: 'text' ,editable: true},
            {label: 'Category Name', fieldName: 'P360_RA_Category__c' ,editable: true},
            {label: 'Primary Linked?', fieldName: 'TMKDA_Primary_Linked__c' ,editable: true},
            {label: 'Severity', fieldName: 'TMKDA_Severity__c' ,editable: true},
            {label: 'Answer', fieldName: 'TMKDA_Answer__c',editable: true},
            {label: 'Assessment', fieldName: 'P360_Pass_Fail__c' ,editable: true},
            {label: 'Source', fieldName: 'TMKDA_Source__c',editable: true } ,
            {label: 'Comment', fieldName: 'P360_Comment__c',editable: true },
            {label: 'Completion Marker', fieldName: 'P360_Completion_Marker__c',editable: true } 
        ]);
        helper.fetchData(cmp,event, helper);
    },
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = cmp.get("c.updateAccount");
        action.setParams({"acc" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
        
    },
})