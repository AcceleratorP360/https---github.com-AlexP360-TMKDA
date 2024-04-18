({
    doInit : function(component, event, helper) {
        console.log('doINtIt');
        helper.setupTable(component);
    },
    
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
        console.log('mouseStart',mouseStart);
        console.log('event.clientX',event.clientX);
        var oldWidth = component.get("v.oldWidth");
        var newWidth = event.clientX- parseFloat(mouseStart)+parseFloat(oldWidth);
        console.log('oldWidth',oldWidth);
        console.log('newWidth',newWidth);
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
                    if(data[rowIndex].fields[7].name === 'P360_IS_Primary_Connect_On_Linked_Area__c' && 
                       data[rowIndex].fields[7].value == 'Yes'){
                        isRowEdit = false;
                    }  
                    if(isRowEdit){
                        if((col.fieldName === 'P360_Completion_Marker__c' ||
                            col.fieldName === 'TMKDA_Severity__c' ||
                            col.fieldName === 'TMKDA_Answer__c' ||
                            col.fieldName === 'P360_Pass_Fail__c' ||
                            col.fieldName === 'TMKDA_Source__c' )){
                            data[rowIndex].fields[colIndex].mode = 'edit';
                            data[rowIndex].fields[colIndex].tdClassName = '';
                        }
                        component.set("v.isEditModeOn", true);
                    }
                }
            });
        });
        component.set("v.tableData", data); 
        
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
                        if(data[index].fields[7].name === 'P360_IS_Primary_Connect_On_Linked_Area__c' && 
                           data[index].fields[7].value == 'Yes'){
                            isRowEdit = false;
                        }  
                        if(isRowEdit){
                            if((col.fieldName === 'P360_Completion_Marker__c' ||
                                col.fieldName === 'TMKDA_Severity__c' ||
                                col.fieldName === 'TMKDA_Answer__c' ||
                                col.fieldName === 'P360_Pass_Fail__c' ||
                                col.fieldName === 'TMKDA_Source__c' ) ){
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
        
    },
    
    onInputChange : function(component, event, helper){
         var field = event.getSource(),         
             value = field.get("v.value"),         
             indexes = field.get("v.name"),
             rowIndex = indexes.split('-')[0],
             colIndex = indexes.split('-')[1];
         var data = component.get("v.tableData");  
   /*    
                                                          // add  by vardhani ---22/02
        
              // Check if the input value is blank
           if (!$A.util.isEmpty(value) && value.trim().length === 0) {
              // Set a custom error message
               var errorMessage;
           if (field.isInstanceOf("lightning:select")) {
              // For lightning:select component
            errorMessage = "Please select an option";
        } else if (field.isInstanceOf("lightning:textarea")) {
              // For lightning:textarea component
            errorMessage = "This field must not be empty";
        } else {
             // For other types of fields, if any
            errorMessage = "This field must not be empty";
        }
         field.setCustomValidity(errorMessage);
        } else {
            // Clear the custom error message
        field.setCustomValidity(""); 
    }
    
           // Report the validity of the input field
        field.reportValidity();

          // Update the table data if the input is valid
        if (field.checkValidity()) {
            data[rowIndex].fields[colIndex].tdClassName = 'valueChange';      
            helper.updateTable(component, rowIndex, colIndex, value);
    }
   
        
    var field = component.find("Completion Marker"); 

    // Clear any custom error message set for the field
    field.setCustomValidity("");

    // Remove the "required" attribute to make the field not required
    field.set("v.required", false);
    */    
    
    //---------end by vardhani 22/02 
   
   
    
        data[rowIndex].fields[colIndex].tdClassName = 'valueChange';      
        
        helper.updateTable(component, rowIndex, colIndex, value);
      
     
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
        component.set("v.buttonClicked", "Cancel");
        component.set("v.isLoading", true);
        setTimeout(function(){
            var dataCache = component.get("v.dataCache");
            var originalData = component.get("v.tableDataOriginal");
            component.set("v.data", JSON.parse(JSON.stringify(dataCache)));
            component.set("v.tableData", JSON.parse(JSON.stringify(originalData)));
            component.set("v.isEditModeOn", false);
            component.set("v.isLoading", false);
            component.set("v.error", "");
            component.set("v.buttonsDisabled", false);
            component.set("v.buttonClicked", "");
        }, 0);
    },
    
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
        }, 0);
    },
    
    finishSaving : function(component, event, helper){
        var params = event.getParam('arguments');
         // added by vardhani 27/02/2024 to have refresh data
         $A.get('e.force:refreshView').fire(); 
        // end here
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
    }    
})