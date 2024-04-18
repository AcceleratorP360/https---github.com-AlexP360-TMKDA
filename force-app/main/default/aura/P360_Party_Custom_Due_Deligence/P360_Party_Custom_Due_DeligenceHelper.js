({
    getDueDeligenceRecords : function(cmp, event, helper, partyId) {
        cmp.set("v.showSpinner", true); 
        var action = cmp.get("c.getAllPartyRecords");
        action.setParams({
            "partyId" : partyId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.wrapperObject", response.getReturnValue());
                cmp.set("v.showSpinner", false); 
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