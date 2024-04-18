({
    doInit : function(component, event, helper) {
        console.log('doINtIt');
        helper.setupTable(component);
        /*
        //$A.get('e.force:refreshView').fire(); // added by VA 08/03***************
         window.addEventListener('load', $A.getCallback(function(){
            helper.handlePageLoad(component);
        }));*/
    },
    
    
   
    
  /*  
    handlePageLoad: function(component,event, helper) {
        var isReturningFromViewAll = sessionStorage.getItem('isReturningFromViewAll');
        if (isReturningFromViewAll) {
            sessionStorage.removeItem('isReturningFromViewAll');
            location.reload();
        }
    },*/
    
    sortTable : function(component, event, helper) {
        component.set("v.isLoading", true);
        setTimeout(function(){
            var childObj = event.target;
            var parObj = childObj.parentNode;
            while(parObj.tagName != 'TH') {
                parObj = parObj.parentNode;
            }
            var sortBy = parObj.name, //event.getSource().get("v.name"),
                sortDirection = component.get("v.sortDirection"),
                sortDirection = sortDirection === "asc" ? "desc" : "asc"; //change the direction for next time
            
            component.set("v.sortBy", sortBy);
            component.set("v.sortDirection", sortDirection);
            helper.sortData(component, sortBy, sortDirection);
            component.set("v.isLoading", false);
        }, 0);
    },
    
    calculateWidth : function(component, event, helper) {
        var childObj = event.target
        var parObj = childObj.parentNode;
        
        var count = 1;
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
            count++;
        }
        console.log('final tag Name'+parObj.tagName);
        var mouseStart=event.clientX;
        component.set("v.mouseStart",mouseStart);
        component.set("v.oldWidth",parObj.offsetWidth);
    },
    setNewWidth : function(component, event, helper) {
        var childObj = event.target
        var parObj = childObj.parentNode;
        var count = 1;
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
            count++;
        }
        var mouseStart = component.get("v.mouseStart");
        var oldWidth = component.get("v.oldWidth");
        var newWidth = event.clientX- parseFloat(mouseStart)+parseFloat(oldWidth);
        parObj.style.width = newWidth+'px';
        component.set("v.newWidth","width:"+newWidth+"px;");
    },
    
    editField : function(component, event, helper) {
        var field = event.getSource();
        var indexes = field.get("v.name");
        var rowIndex = indexes.split('-')[0];
        var colIndex = indexes.split('-')[1];
        var data = component.get("v.tableData");
        data[rowIndex].fields[colIndex].mode = 'edit';
        data[rowIndex].fields[colIndex].tdClassName = '';
        component.set("v.tableData", data);        
        component.set("v.isEditModeOn", true);
       // $A.get('e.force:refreshView').fire();// add by VA not working
    },
    
    handleEditRow : function(component, event, helper) {
        var field = event.getSource();
        var indexes = field.get("v.name");
        var data = component.get("v.tableData");
        var cols = component.get("v.columns");
        var rowIndex = indexes.split('-')[0];
        var colIndex = indexes.split('-')[1];
        
        
        data.forEach(function(value, index) {   
            cols.forEach(function(col, colIndex) {
                var isRowEdit = true;
                if(isRowEdit){
                    /*added by VA to check columns and index dynamically 07/03/2024 */
                    data[rowIndex].fields.forEach(function(eachValue, eachIndex){
                     if(data[rowIndex].fields[eachIndex].name === 'P360_IS_Primary_Connect_On_Linked_Area__c' &&  
                        
                       data[rowIndex].fields[eachIndex].value == 'Yes'){                       
                         isRowEdit = false;                        
                    } 
                    });
                   /* commented by VA not to check colums and specific index  07/03/2024
                  if(data[rowIndex].fields[6].name === 'P360_IS_Primary_Connect_On_Linked_Area__c' && 
                       data[rowIndex].fields[6].value == 'Yes'){                       
                         isRowEdit = false;                        
                    } 
                  */
                                      
                    if(isRowEdit){
                        if((col.fieldName === 'P360_Completion_Marker__c' ||
                            //col.fieldName === 'TMKDA_Severity__c' ||     /*commented by VA 01/03/2024 to make read only*/
                            col.fieldName === 'TMKDA_Answer__c' ||
                            col.fieldName === 'P360_Pass_Fail__c' ||
                            col.fieldName === 'TMKDA_Source__c' ||
                            col.fieldName === 'P360_Comment__c')){    /*added by VA 01/03/2024*/
                            data[rowIndex].fields[colIndex].mode = 'edit';
                            data[rowIndex].fields[colIndex].tdClassName = '';
                        }
                        component.set("v.isEditModeOn", true);
                    }
                   //  $A.get('e.force:refreshView').fire(); // added by VA not working
                }
            });
        });
        component.set("v.tableData", data);
       // $A.get('e.force:refreshView').fire(); // added by VA not working
        
    },

    handleEditAll: function(component, event, helper) {
        var message = event.getParam("isEditALL"); 
        if(message === 'true'){
            var data = component.get("v.tableData");
            var cols = component.get("v.columns");
            
            data.forEach(function(value, index) {
                cols.forEach(function(col, colIndex) {
                    var isRowEdit = true;
                    if(isRowEdit){
                        
                        /* added by VA  to check columns and index dynamically06/03/2024*/
                        data[index].fields.forEach(function(eachValue, eachIndex){
                        if(data[index].fields[eachIndex].name === 'P360_IS_Primary_Connect_On_Linked_Area__c' &&                        
                        data[index].fields[eachIndex].value == 'Yes'){                       
                         isRowEdit = false;                        
                    } 
                    });
                        /* commented by VA 06/03/2024
                          if(data[index].fields[6].name === 'P360_IS_Primary_Connect_On_Linked_Area__c' && 
                           data[index].fields[6].value == 'Yes'){
                            isRowEdit = false;
                          data[index].bgColour="background:#edeff2;";   // added by VA to have bgcolour grey
                        }  */
                        
                        if(isRowEdit){
                            if((col.fieldName === 'P360_Completion_Marker__c' ||
                                //col.fieldName === 'TMKDA_Severity__c' ||  /* commented by VA 01/03/2024 to make read only*/
                                col.fieldName === 'TMKDA_Answer__c' ||
                                col.fieldName === 'P360_Pass_Fail__c' ||
                                col.fieldName === 'TMKDA_Source__c' ||
                                col.fieldName === 'P360_Comment__c') ){    /*added by VA 01/03/2024*/
                                data[index].fields[colIndex].mode = 'edit';
                                data[index].fields[colIndex].tdClassName = '';
                            }
                           
                        }
                    }
                     
                });
            });
           component.set("v.tableData", data); 
           component.set("v.isEditModeOn", true);
              
          
        }
       // $A.get('e.force:refreshView').fire();// added by VA when clicking edit all getting refresh not able see edit mode
      
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
    /* end here */
    
    
    onInputChange : function(component, event, helper){
         var field = event.getSource(),         
             value = field.get("v.value"),         
             indexes = field.get("v.name"),
             rowIndex = indexes.split('-')[0],
             colIndex = indexes.split('-')[1];
         var data = component.get("v.tableData");     
    
        data[rowIndex].fields[colIndex].tdClassName = 'valueChange';      
        
        helper.updateTable(component, rowIndex, colIndex, value);
        
        //$A.get('e.force:refreshView').fire(); // added by VA not working
      
     
    },
    
    
 
    
    onRowAction : function(component, event, helper){
        var actionEvent = component.getEvent("P360_dataTableRowActionEvent"),
            indexes = event.target.id, //rowIndex-colIndex-actionName
            params = indexes.split('-'),
            data = component.get("v.dataCache");
        
        actionEvent.setParams({
            actionName: params[2],
            rowData: data[params[0]]
        });
        actionEvent.fire();
    },
  
    closeEditMode : function(component, event, helper){
        component.set("v.buttonsDisabled", true);
        //$A.get('e.force:refreshView').fire(); // added by VA not working
        component.set("v.buttonClicked", "Cancel");
        component.set("v.isLoading", true);
        setTimeout(function(){
            var dataCache = component.get("v.dataCache");
            var originalData = component.get("v.tableDataOriginal");
            component.set("v.data", JSON.parse(JSON.stringify(dataCache)));
            component.set("v.tableData", JSON.parse(JSON.stringify(originalData)));
            component.set("v.isEditModeOn", false);
            //$A.get('e.force:refreshView').fire(); // added by VA  not working 
            component.set("v.isLoading", false);
           //  $A.get('e.force:refreshView').fire(); // added by VA not working
            component.set("v.error", "");
            component.set("v.buttonsDisabled", false);
            component.set("v.buttonClicked", "");
        }, 0);
           //$A.get('e.force:refreshView').fire(); // added by VA not woking
    },
   
  /*  commented by VA 07/03/2024
    saveRecords : function(component, event, helper){
        component.set("v.buttonsDisabled", true);
        component.set("v.buttonClicked", "Save");
        component.set("v.isLoading", true);
        
        setTimeout(function(){
            var saveEvent = component.getEvent("P360_dataTableSaveEvent");
            saveEvent.setParams({
                tableAuraId: component.get("v.auraId"),
                recordsString: JSON.stringify(component.get("v.modifiedRecords"))
            });

            saveEvent.fire();             
            component.set("v.isLoading", false);           
            
        }, 0);
    },*/
    
   /* added by VA to show success message 07/03/2024*/ 
    saveRecords: function(component, event, helper) {
    component.set("v.buttonsDisabled", true);
    component.set("v.buttonClicked", "Save");
    component.set("v.isLoading", true);
        
    setTimeout(function(){    
    var saveEvent = component.getEvent("P360_dataTableSaveEvent");
    saveEvent.setParams({
        tableAuraId: component.get("v.auraId"),
        recordsString: JSON.stringify(component.get("v.modifiedRecords"))
    });

    saveEvent.fire();             
    component.set("v.isLoading", false);
    }, 0);
},
    
/*  commented by VA 07/03/2024
    finishSaving : function(component, event, helper){
        var params = event.getParam('arguments');
      
        if(params){
            var result = params.result, //Valid values are "SUCCESS" or "ERROR"
                data = params.data, //refreshed data from server
                message = params.message;
            
            if(result === "SUCCESS"){//success
                if(data){
                    helper.setupData(component, data, false);
                }else{
                    var dataCache = component.get("v.dataCache"),
                        updatedData = component.get("v.updatedTableData");
                    component.set("v.data", JSON.parse(JSON.stringify(dataCache)));
                    component.set("v.tableDataOriginal", JSON.parse(JSON.stringify(updatedData)));
                    component.set("v.tableData", JSON.parse(JSON.stringify(updatedData)));                    
                }
                component.set("v.isEditModeOn", false);
            }else{
                if(message) component.set("v.error", message);
            }
        }
        component.set("v.isLoading", false);
        component.set("v.buttonsDisabled", false);
        component.set("v.buttonClicked", "");
    }  */ 
    
    
    /* added by VA to show sucess message  07/03/2024*/
    finishSaving: function(component, event, helper) {
    var params = event.getParam('arguments');
  
    if (params) {
        var result = params.result, // Valid values are "SUCCESS" or "ERROR"
            data = params.data, // refreshed data from server
            message = params.message;
        
        if (result === "SUCCESS") { // Success
            if (data) {
                helper.setupData(component, data, false);
            } else {
                var dataCache = component.get("v.dataCache"),
                    updatedData = component.get("v.updatedTableData");
                component.set("v.data", JSON.parse(JSON.stringify(dataCache)));
                component.set("v.tableDataOriginal", JSON.parse(JSON.stringify(updatedData)));
                component.set("v.tableData", JSON.parse(JSON.stringify(updatedData)));                    
            }
            component.set("v.isEditModeOn", false);
            // Display success toast message
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Success!',
                message: 'Records saved successfully.',
                type: 'success'
            });
            toastEvent.fire();
        }  else if (result === "ERROR") { // Error
            if (message) {
                component.set("v.error", message);
                // Display error toast message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Records saved unsuccessfull.',
                    type: 'error'
                });
                toastEvent.fire();
            }
        }
    }
    component.set("v.isLoading", false);
    component.set("v.buttonsDisabled", false);
    component.set("v.buttonClicked", "");
}
    
    
  

})