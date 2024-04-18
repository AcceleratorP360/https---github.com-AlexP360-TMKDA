({
  invoke: function (component, event, helper) {
    // Get the record ID attribute
    var record = component.get("v.recordId");
    var navService = component.find("navService");
    var pageReference = {
      type: "standard__recordPage",
      attributes: {
        recordId: record,
        // objectApiName: "Contact",
        actionName: "view"
      }
    };
    navService.navigate(pageReference, true);
  }
});