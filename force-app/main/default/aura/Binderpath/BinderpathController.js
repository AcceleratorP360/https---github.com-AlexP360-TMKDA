({
    handleSelect : function (component, event, helper) {
        var stepName = event.getParam("detail").value;
        console.log(stepName);
        console.log(component.get("v.recordId"));
        var action = component.get("c.oppyStageUpdate");
        action.setParams({stageName:stepName , recordId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                if (state === 'SUCCESS'){
                    toastEvent.setParams({
                      //  "title": "Success!",
                       // "message": "Stage changed successfully."
                    });
                }
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})

//HELPER//
({
	helperMethod : function() {
		
	}
})