({
    fetchAttestationScoping : function(cmp, event, helper) {
        var action = cmp.get("c.fetchAttestaionScoping");
        action.setParams({
            "attRecId" : cmp.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var getReturnValue = response.getReturnValue();
                console.log('----getReturnValue ', getReturnValue);
                if(getReturnValue != null){
                    var options = getReturnValue.map(opt => ({ value: opt.Send_Attestation_Form_Contact__c, label: opt.Send_Attestation_Form_Contact__c.Name }));
                cmp.set("v.selectedContact", getReturnValue[0].Send_Attestation_Form_Contact__c);
                }else{
                    cmp.set("v.noRecordsFound", true);
                }
                
                
            }else if(state === "ERROR"){
                console.log('---State', error)
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