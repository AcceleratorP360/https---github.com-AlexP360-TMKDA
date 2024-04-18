({
    doInit : function(component, event, helper) {
        var getObj = component.get("v.sObjectName");
        if(getObj){
            localStorage.setItem( 'storeObjName', component.get("v.sObjectName"));
        }
        component.set("v.storeObjectName", localStorage.getItem( 'storeObjName'));
        
        component.set("v.isLoading", true);
        helper.setupTable(component);
        
    },
    
    handleCatChange : function(component, event, helper) {
        var getSelCat = event.getSource().get("v.value");
        helper.loadRecords(component, event, helper, getSelCat);
    },
    
    saveTableRecords : function(component, event, helper) {
        var recordsData = event.getParam("recordsString");
        var tableAuraId = event.getParam("tableAuraId");
        var action = component.get("c.updateRecords");
        action.setParams({
            jsonString: recordsData
        });
        action.setCallback(this,function(response){
            var datatable = component.find(tableAuraId);
            datatable.finishSaving("SUCCESS");
        });
        $A.enqueueAction(action);        
    },
    
    loadMoreRecords  : function(component, event, helper) {
        component.set("v.recordCount", 1000);
        helper.loadRecords(component, event, helper, '');
    },
    
    handleRefresh : function(component, event, helper) {
        helper.loadRecords(component, event, helper, '');
    },
    
    handleEditAll : function(component, event, helper) {
        component.set("v.editAll", true);                   
          
        var appEvent = $A.get("e.c:P360_EditAll_ButtonClicked"); 
        //Set event attribute value
         appEvent.setParams({"isEditALL" : "true"});        
        appEvent.fire();
    },
    
   
    
    handleFilter: function(component, event, helper) {
        var getShowFilter = component.get("v.showFilter");
        if(getShowFilter){
            component.set("v.showFilter", false);
        }else {
            component.set("v.showFilter", true);
        }
    }
})