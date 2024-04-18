({
    handleCreate: function(component, event, helper) {
        var createEvent = $A.get("e.c:flowCreateEvent"); // Corrected event reference
        createEvent.fire();
        if (component.get("v.onCreate")) {
            component.get("v.onCreate").call(component); // Call the flow callback if provided
        }
    },
    handleCancel: function(component, event, helper) {
        var cancelEvent = $A.get("e.c:flowCancelEvent"); // Corrected event reference
        cancelEvent.fire();
        if (component.get("v.onCancel")) {
            component.get("v.onCancel").call(component); // Call the flow callback if provided
        }
    }
})