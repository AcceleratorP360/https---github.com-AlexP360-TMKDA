({
    invoke: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Record created successfully.",
            "type": "success",
            "duration": 3 // Set duration to 3 seconds
        });
        toastEvent.fire();
        var redirectToRecord = function() {
            var redirect = $A.get("e.force:navigateToSObject");
         // Pass the record ID to the event
            redirect.setParams({
                "recordId": recordId
            });
            redirect.fire();
        };

        setTimeout(redirectToRecord, 3); 
    },

    handleRecordCreatedEvent: function(component, event, helper) {
        // Get the record Id from the event
        var recordId = event.getParam("recordId");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Record created successfully.",
            "type": "success",
            "duration": 3 
        });
        toastEvent.fire();
    }
})