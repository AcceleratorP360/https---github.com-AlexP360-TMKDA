({
    
    doInit: function (cmp, event, helper) {
        cmp.set("v.selectedRecId", '');  
    },
    
    handleDetailPage : function(component, event, helper) {
        var getRecIdAndName = event.getParam("selectedRecordId");
        if(getRecIdAndName && event.getParam("selectedSobject")){
        var getRecId = getRecIdAndName.split('-')[0];
        component.set("v.recordName", getRecIdAndName.split('-')[1]);
        component.set("v.selectedRecId", getRecId);
        }else{
          component.set("v.selectedRecId", '');  
        }
        component.set("v.selectedObject", event.getParam("selectedSobject"));
    },
    
    handleSubmit : function(cmp, event, helper) {
       // event.preventDefault();
      //  const fields = event.getParam('fields');
       // cmp.find('myRecordForm').submit(fields);
    },
    
    handleNavigateToDetailPage : function(cmp, event, helper) {
        var navService = cmp.find("navService");
        var getRecordId = cmp.get("v.selectedRecId");
        var pageReference = {    
            "type": "standard__recordPage", 
            "attributes": {
                "recordId": getRecordId,
                "actionName": "view"
            }
        }
        
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            console.log('success: ' + url); 
            window.open(url,'_blank');
        }), 
              $A.getCallback(function(error) {
                  console.log('error: ' + error);
              }));
    },
})