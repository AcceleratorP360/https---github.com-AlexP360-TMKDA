({
    getPrimaryDueDeligenceRecords : function(cmp, event, helper) {
        var action = cmp.get("c.getPrimaryDueDeligence");
        action.setParams({
            "accId" : cmp.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var getReturnValue = response.getReturnValue();
                console.log('----getReturnValue ', getReturnValue);
                if(getReturnValue != null){
                    var options = getReturnValue.map(opt => ({ value: opt.Id, label: opt.Name }));
                    cmp.set("v.primaryDeligenceOptions", options);
                cmp.set("v.selectedPrimaryDueDeligence", getReturnValue[0].Id);
                 cmp.set("v.primarySelectedId", getReturnValue[0].Id);
                
                this.getAllRelatedRecords(cmp, event, helper, cmp.get("v.selectedPrimaryDueDeligence"));
                }else{
                    cmp.set("v.noRecordsFound", true);
                }
                
                
            }else if(state === "ERROR"){
                console.log('---State', error)
            }
        });
        $A.enqueueAction(action);
    },
    
    getAllRelatedRecords : function(cmp, event, helper, selPrimaryDueDeligence) {
        cmp.set("v.showSpinner", true); 
        var action = cmp.get("c.getRelatedRecords");
        action.setParams({
            "primaryDueDeligenceRec" : selPrimaryDueDeligence
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.showSpinner", false); 
                var getReturnValue = response.getReturnValue();
                cmp.set("v.wrapperObject", getReturnValue);
                console.log('--->>>>>getReturnValue ', getReturnValue)
            }else if(state === "ERROR"){
                cmp.set("v.showSpinner", false);
                this.showToast(cmp, event, helper, 'error', 'Something Error has Occurred..!!!', 'Error')
            }
        });
        $A.enqueueAction(action);
    },
    
    createRecords :  function(cmp, event, helper, getWrapperObject) {
        var action = cmp.get("c.updateParentRecords");
        action.setParams({
            "wrapObject" : getWrapperObject,
            "currentRecId" : cmp.get("v.recordId"),
            "selectedRcId" : cmp.get("v.selectedPrimaryDueDeligence")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.showSpinner", false); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                this.showToast(cmp, event, helper, 'success', 'Records has been created Succesfully', 'Success')
            }else if(state === "ERROR"){
                cmp.set("v.showSpinner", false);
                this.showToast(cmp, event, helper, 'error', 'Something Error has Occurred..!!!', 'Error')
            }
        });
        
        $A.enqueueAction(action);
    },
    
    showToast : function(cmp, event, helper, type, message, title) {
        var toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({
            title : title,
            message: message,
            duration:' 2000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    }
    
})