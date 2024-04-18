({
    doInit : function(component, event, helper) {
        var getObj = component.get("v.sObjectName");
        if(getObj){
            localStorage.setItem( 'storeObjName', component.get("v.sObjectName"));
        }
        component.set("v.storeObjectName", localStorage.getItem( 'storeObjName'));
       
        component.set("v.isLoading", true);
        helper.setupTable(component);
        
        
        
     /*   
        window.addEventListener('load', $A.getCallback(function(){
            helper.handlePageLoad(component);
        }));
         
        
         //$A.get('e.force:refreshView').fire(); // added by VA 08/03/2024  not worked not loading************************
       */   
    
    },
    
    
  /* 
    handlePageLoad: function(component, event, helper) {
        var isReturningFromViewAll = sessionStorage.getItem('isReturningFromViewAll');
        if (isReturningFromViewAll) {
            sessionStorage.removeItem('isReturningFromViewAll');
            location.reload();
        }
    },
    */
    
     
    
    
    createReviewArea : function(component, event, helper){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName" : "P360_Review_Area__c"
            
        });
        createRecordEvent.fire();
        
    } ,
    
    
  
    
    handleCatChange : function(component, event, helper) {
        component.set("v.showFilter", false);
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
            
         /*   added by VA for refresh 08/03/2024
            var recId =component.get("v.recordId");
            console.log('recId1',recId);
            if(recId){
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recId
                });
                navEvt.fire();
            }
            end here */
            
        });
        $A.enqueueAction(action);        
    },
    // added by VA 28/03/2024
   loadMoreRecords: function(component, event, helper) {
    // Call a helper method to fetch the total number of records
    helper.getTotalRecordCount(component).then(totalRecordCount => {      
        component.set("v.recordCount", totalRecordCount);        
         helper.loadRecords(component, event, helper, '');
    }).catch(error => {
        // Handle any errors in fetching the total record count
        console.error('Error fetching total record count:', error);
    });
},
/*end by VA*/
   
        //commented not to have specific count by VA 2/03/2024
   /* 
    loadMoreRecords  : function(component, event, helper) {
        component.set("v.recordCount", 1000);
        helper.loadRecords(component, event, helper, '');
       // $A.get('e.force:refreshView').fire();  // added by VA 08/03/2024 not worked
    },
    */
    
    handleRefresh : function(component, event, helper) {
        var selectedCat = component.get("v.selectedCat"); // Assuming selectedCat represents the filter condition
        helper.loadRecords(component, event, helper, selectedCat);
           
        // helper.loadRecords(component, event, helper, '');
        
      
                  //  window.location.reload();
         // $A.get('e.force:refreshView').fire(); by VA not worked 08/03/2024
    },
    
    /* added by VA to refresh view all 07/03/2024 
    handleRefreshView: function(component, event, helper) {
        // Reset fields to non-editable mode
        var data = component.get("v.tableData");
        data.forEach(function(row) {
            row.fields.forEach(function(field) {
                // Set field mode to view
                field.mode = 'view';
            });
        });
        component.set("v.tableData", data);
        component.set("v.isEditModeOn", false);
    },
     end here */
    
    handleEditAll : function(component, event, helper) {
       component.set("v.editAll", true);  
         
          
        var appEvent = $A.get("e.c:P360_EditAll_ButtonClicked"); 
        //Set event attribute value
         appEvent.setParams({"isEditALL" : "true"});        
         appEvent.fire();
        
           
      
         
     
        // $A.get('e.force:refreshView').fire(); // added by VA 08/03/2024 when edit all click getting refresh*******************
    },
    /* added by VA to refresh view all by edit button 07/03/2024
    onInit: function(component, event, helper) {
        // Check if edit mode was initiated
        var editAll = component.get("v.editAll");
        if (editAll) {
            // Reset the flag
            component.set("v.editAll", false);
            
            // Refresh the data in the Lightning Datatable by reloading it from the server
            helper.loadData(component); // You need to implement this method in your helper to reload data
        }
    },
    
    end here */
    
  /* to get edit all false -- not worked
    handleLocationChange : function(component, event, helper) {
        // Reset editAll attribute to false
        component.set("v.editAll", false);
    },

*/
    
    handleFilter: function(component, event, helper) {
        var getShowFilter = component.get("v.showFilter");
        if(getShowFilter){
            component.set("v.showFilter", false);  // changed true to false filter to close after action by VA 07/03/2024
        }else {
            component.set("v.showFilter", true);
        }
    }
})