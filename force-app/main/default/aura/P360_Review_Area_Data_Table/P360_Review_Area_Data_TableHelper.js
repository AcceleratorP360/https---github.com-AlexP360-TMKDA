({
    setupTable : function(component, data){
        var cols = component.get("v.columns"),
            data = component.get("v.data");
        this.setupColumns(component, cols);
        this.setupData(component, data, false);
        component.set("v.isLoading", false);
    },

    setupColumns : function(component, cols){
        var tempCols = [];
        if(cols){
            /*COLUMNS SHOULD BE IN BELOW FORMAT
            [{label: "Oppotunity Name", fieldName: "oppLink", type:"link", sortable: true, resizable: true, 
              attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
             {label: "Type", fieldName: "Type", editable: true, type:"picklist", selectOptions:types},            
             {label: "Stage", fieldName: "StageName", sortable: true},                                
             {label: "Close Date", fieldName: "CloseDate", type:"date", editable: true, resizable: true}, 
             {label: "Amount", fieldName: "Amount", type:"number", editable: true, attributes:{formatter:"currency"}},
             {label: "Owner", fieldName: "ownerLink", type:"link", sortable: true, resizable: true, 
              attributes:{label:{fieldName:"ownerName"}, title:"Click to View(New Window)", target:"_blank"}}],
            */
            cols.forEach(function(col) {
                //set col values
                col.thClassName = "";
                col.thClassName += col.sortable === true ? " slds-is-sortable" : "";
                col.thClassName += col.resizable === true ? " slds-is-resizable" : "";
                col.style = col.width ? "width:"+col.width+"%;" : "";
                col.style += col.minWidth ? "min-width:"+col.minWidth+"px;" : "";
                //col.style += col.maxWidth ? "max-width:"+col.maxWidth+"px;" : "";
                col.style += col.maxWidth ? "max-width:1000px;" : "";
                if(col.sortable === true){
                    col.sortBy = col.fieldName;
                    if(col.type === "link" && col.attributes && typeof col.attributes.label === "object")
                        col.sortBy = col.attributes.label.fieldName;
                }
                //if(!tableData) col.thClassName = "";
                tempCols.push(col);
            });
            component.set("v.columns", JSON.parse(JSON.stringify(tempCols)));
        }
    },
    
    setupData : function(component, data, editAll){        
        var tableData = [], cols = component.get("v.columns");
        component.set("v.dataCache", JSON.parse(JSON.stringify(data)));

        if(data){
            data.forEach(function(value, index) {
                var row = {}, fields = [];
                cols.forEach(function(col) {
                    //set data values
                    var field = {};
                    field.name = col.fieldName;
                    field.value = value[col.fieldName];
                    field.type = col.type ? col.type : "text";
                    if(field.type === "date"){
                        field.isViewSpecialType = true;
                    }
                    if(field.type === "number"){
                        field.isViewSpecialType = true;
                        if(col.attributes){
                            field.formatter = col.attributes.formatter;
                            field.style = col.attributes.formatter;
                            field.minimumFractionDigits = col.attributes.minimumFractionDigits ? col.attributes.minimumFractionDigits : 0;
                            field.maximumFractionDigits = col.attributes.maximumFractionDigits ? col.attributes.maximumFractionDigits : 2;
                            field.currencyCode = col.attributes.currencyCode ? col.attributes.currencyCode : "USD";
                        }
                    }
                    if(field.type === "picklist"){
                        field.isEditSpecialType = true;
                        field.selectOptions = col.selectOptions;
                    }                        
                    if(field.type === "link"){
                        field.isViewSpecialType = true;
                        if(col.attributes){
                            if(typeof col.attributes.label === "object")
                                field.label = value[col.attributes.label.fieldName];
                            else field.label = col.attributes.label;

                            var getGuidanceValue = value['P360_Master_Guidance__c']
                            if(typeof col.attributes.title === "object")
                                field.title = value[col.attributes.title.fieldName];
                            else field.title = col.fieldName == 'accountLink' ? 'Master Guidance: ' + getGuidanceValue : col.attributes.title;
                            
                            if(col.attributes.actionName){
                                field.type = "link-action";
                                field.actionName = col.attributes.actionName;
                            }                                
                            field.target = col.attributes.target;
                        }
                    }
                   field.editable = col.editable && value['P360_IS_Primary_Connect_On_Linked_Area__c'] != 'Yes' ? col.editable : false;
                    
                   
                        field.tdClassName = field.editable === true ? 'slds-cell-edit' : '';
                        field.mode = "view";
                    console.log('View');
                    fields.push(field);
                });
                row.id = value.Id;
                row.fields = fields;
                tableData.push(row);
            });
            component.set("v.tableData", tableData);
            component.set("v.tableDataOriginal", JSON.parse(JSON.stringify(tableData)));
            component.set("v.updatedTableData", JSON.parse(JSON.stringify(tableData)));
        }
    },

    updateTable : function(component, rowIndex, colIndex, value){
        //Update Displayed Data
        var data = component.get("v.tableData");
        data[rowIndex].fields[colIndex].value = value;
        component.set("v.tableData", data);
        
        //Update Displayed Data Cache
        var updatedData = component.get("v.updatedTableData");
        updatedData[rowIndex].fields[colIndex].value = value;
        updatedData[rowIndex].fields[colIndex].mode = "view";
        component.set("v.updatedTableData", updatedData);
       // $A.get('e.force:refreshView').fire();  // added by VA not working
        
        //Update modified records which will be used to update corresponding salesforce records
        var records = component.get("v.modifiedRecords");
        var recIndex = records.findIndex(rec => rec.id === data[rowIndex].id);
        if(recIndex !== -1){
            records[recIndex][""+data[rowIndex].fields[colIndex].name] = value;
        }else{
            var obj = {};
            obj["id"] = data[rowIndex].id;
            obj[""+data[rowIndex].fields[colIndex].name] = value;
            records.push(obj);
        }
        component.set("v.modifiedRecords", records);
        
        //$A.get('e.force:refreshView').fire(); // added by VA

        //Update Data Cache
        var dataCache = component.get("v.dataCache");
        var recIndex = dataCache.findIndex(rec => rec.Id === data[rowIndex].id);
        var fieldName = data[rowIndex].fields[colIndex].name;
        dataCache[recIndex][fieldName] = value;
        component.set("v.dataCache", dataCache);
        //$A.get('e.force:refreshView').fire(); // added by VA
    },
    
    sortData : function(component, sortBy, sortDirection){
        var reverse = sortDirection !== "asc",
            data = component.get("v.dataCache");
        if(!data) return;
        
        var data = Object.assign([], data.sort(this.sortDataBy(sortBy, reverse ? -1 : 1)));
        this.setupData(component, data, false);
    },
    
    sortDataBy : function (field, reverse, primer) {
        var key = primer
        ? function(x) { return primer(x[field]) }
        : function(x) { return x[field] };
        
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
    
})