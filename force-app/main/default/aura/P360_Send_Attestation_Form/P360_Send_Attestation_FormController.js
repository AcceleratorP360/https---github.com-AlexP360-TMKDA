({
    doInit: function (cmp, event, helper) {
        helper.fetchAttestationScoping(cmp, event, helper);
    },
    
    handleEmailSendingAndUpdating : function (cmp, event, helper) {
        var selectedContact = cmp.get("v.selectedContact");
        console.log('----selectedContact ',selectedContact)
        var action = cmp.get("c.sendEmailAndUpdate");
        action.setParams({
            "selecedConId" : selectedContact,
            "attRecId" : cmp.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                 helper.showToast(cmp, event, helper, 'success', 'Mail has been sent Succesfully', 'Success')
                 var dismissActionPanel = $A.get("e.force:closeQuickAction");
                //$A.get('e.force:refreshView').fire();
                dismissActionPanel.fire();
                setTimeout(function(){													//Added by DY - 11/02/24
                     window.location.reload();
                 }, 5000);
            }else if(state === "ERROR"){
                console.log('---State', error)
            }
        });
        $A.enqueueAction(action);
    }
    
})