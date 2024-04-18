({
	createRecord: function(component, event, helper) {
        var action = component.get("c.createDDCategoryRecord");

        // Set parameters for the Apex controller method
        action.setParams({
            parentId: component.get("v.recordId"),
            categoryName: component.get("v.categoryName"),
            categoryID: component.get("v.categoryID"),
            completionMarker: component.get("v.completionMarker")
        });

        // Define the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Success message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: "Record created successfully",
                    type: "success"
                });
                toastEvent.fire();

                // Close the quick action
                $A.get("e.force:closeQuickAction").fire();
                
                // Optionally, navigate to the newly created record
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response.getReturnValue(),
                    "slideDevName": "related"
                });
                navEvt.fire();
            } else {
                // Error message
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.error("Error message: " + errors[0].message);
                }
            }
        });

        // Enqueue the action
        $A.enqueueAction(action);
		
	}
})