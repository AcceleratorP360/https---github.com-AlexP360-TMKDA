({
 handleRecordUpdated: function(component, event, helper) {
  var changedFields = event.getParams().changedFields;
  if (changedFields && 'TMKDA_BPA_UW_Review_Approval__c' in changedFields) {
   var reviewStatus = component.get("v.simpleRecord").TMKDA_BPA_UW_Review_Approval__c;
   if (reviewStatus == 'Reviewed') {
    
    var navEvent = $A.get("e.force:navigateToURL");
    navEvent.setParams({
     "url": "{!$CurrentPage.homeUrl}"
    });
    navEvent.fire();
   }
  }
 }
})