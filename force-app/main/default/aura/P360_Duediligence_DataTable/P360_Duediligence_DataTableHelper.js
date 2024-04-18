({
    setupTable : function(component) {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectAPIName: "P360_Review_Area__c"
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var answers = [];
                var severity = [];
                var assesment = [];
                var completionMarker = [];
                var primaryLinked = [];
                var result = response.getReturnValue();
                for(var key in result){
                    if(key === 'TMKDA_Answer__c'){
                        Object.entries(result['TMKDA_Answer__c']).forEach(([key, value]) => answers.push({label:key,value:value}));
                    }
                    if(key === 'TMKDA_Severity__c'){
                        Object.entries(result['TMKDA_Severity__c']).forEach(([key, value]) => severity.push({label:key,value:value}));
                    }
                    if(key === 'P360_Pass_Fail__c'){
                        Object.entries(result['P360_Pass_Fail__c']).forEach(([key, value]) => assesment.push({label:key,value:value}));
                    }
                    if(key === 'P360_Completion_Marker__c'){
                        Object.entries(result['P360_Completion_Marker__c']).forEach(([key, value]) => completionMarker.push({label:key,value:value}));
                    } 
                    if(key === 'P360_IS_Primary_Connect_On_Linked_Area__c'){
                        Object.entries(result['P360_IS_Primary_Connect_On_Linked_Area__c']).forEach(([key, value]) => primaryLinked.push({label:key,value:value}));
                    } 
                }
                var getSObjectName = component.get("v.sObjectName");
                var storedSobjName = getSObjectName != undefined ? getSObjectName : component.get("v.storeObjectName");
                var cols = [];
                if(storedSobjName !== 'P360_Due_Diligence__c'){
                     cols = [
                    {label: "Review Area", fieldName: "accountLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
                    {label: "Severity", fieldName: "TMKDA_Severity__c", editable: true, type:"picklist", selectOptions:severity, resizable:true},
                    {label: "Review Point", fieldName: "P360_Review_Point__c", type:"text", sortable: true, resizable:true},
                    {label: "Sub-Category Name", fieldName: "Parent_Sub_Category__c", type:"text", sortable: true, resizable:true},       /* added by vardhani 20/02*/  
                    {label: "Answer", fieldName: "TMKDA_Answer__c", editable: true, type:"picklist", selectOptions:answers, resizable:true},
                   /* {label: "Assesment", fieldName: "P360_Pass_Fail__c", editable: true, type:"picklist", selectOptions:assesment, resizable:true},*/ /* changes made by vardhani*/
                    {label: "Source", fieldName: "TMKDA_Source__c", type:"text", editable: true, sortable: true, resizable:true},
                         /* Commented changes made label : Connected To Primary to  linked by vardhani 26/02/2024     
                    {label: "Connect To Primary", fieldName: "P360_IS_Primary_Connect_On_Linked_Area__c", type:"text", resizable:true},*/
                         /* added label : Linked  by vardhani 26/02/2024*/
                          {label: "Linked", fieldName: "P360_IS_Primary_Connect_On_Linked_Area__c", type:"text", resizable:true},  
                         {label: "Completion marker", fieldName: "P360_Completion_Marker__c", editable: true, type:"picklist", selectOptions:completionMarker, resizable:true, required :false},  /* to exist line of code required : false added by vardhani 23/02  */    
                    {label: "Guidance", fieldName: "P360_Master_Guidance__c", type:"text", sortable: true, resizable:true},
                         ];
                }else{
                         /*field editable : true changes to false at duediligence level review area by vardhani :21/02/2024/*/
                cols = [
                    {label: "Review Area", fieldName: "accountLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
                    {label: "Severity", fieldName: "TMKDA_Severity__c", editable: false, type:"picklist", selectOptions:severity, resizable:true},
                    {label: "Review Point", fieldName: "P360_Review_Point__c", type:"text", sortable: true, resizable:true},
                    {label: "Category Name", fieldName: "P360_Parent_Category_Name__c", type:"text", sortable: true, resizable:true},
                    
                    {label: "Answer", fieldName: "TMKDA_Answer__c", editable: false, type:"picklist", selectOptions:answers, resizable:true},
                   /* {label: "Assesment", fieldName: "P360_Pass_Fail__c", editable: false, type:"picklist", selectOptions:assesment, resizable:true},*/ /* changes made by vardhani*/
                    {label: "Source", fieldName: "TMKDA_Source__c", type:"text", editable: false, sortable: true, resizable:true},
                          /* Commented changes made label : Connected To Primary to  linked by vardhani 26/02/2024 
                    {label: "Connect To Primary", fieldName: "P360_IS_Primary_Connect_On_Linked_Area__c", type:"text", resizable:true},*/
                         /* added label : Linked  by vardhani 26/02/2024*/
                         {label: "Linked", fieldName: "P360_IS_Primary_Connect_On_Linked_Area__c", type:"text", resizable:true},
                         {label: "Completion marker", fieldName: "P360_Completion_Marker__c", editable: false, type:"picklist", selectOptions:completionMarker, resizable:true},        //added required : true by vardhani 23/02
                    {label: "Guidance", fieldName: "P360_Master_Guidance__c", type:"text", sortable: true, resizable:true},
                ];
                    }
                    component.set("v.columns", cols);
                    this.loadRecords(component);
                    }else{
                    var errors = response.getError();
                    var message = "Error: Unknown error";
                    if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error: "+message);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadRecords : function(component, event, helper, selectedCat) {
        console.log('--->>> selectedCat ',selectedCat)
        component.set("v.isLoading", true);
        component.set("v.data", '');
        var action = component.get("c.getReviewAreas");
        var getRecordId = component.get("v.recordId");
        if(getRecordId){
            localStorage.setItem( 'storeRecId', component.get("v.recordId"));
            localStorage.setItem( 'isFromCategory', component.get("v.isFromCategory"));
            component.set("v.showViewAll", true);
            action.setParams({
                "parentId" : component.get("v.recordId"),
                "recCount" : component.get("v.recordCount"),
                "isFromCategory" : component.get("v.isFromCategory"),
                "selectedCat" : selectedCat
            }); 
        }else{
            component.set("v.showViewAll", false);
            action.setParams({
                "parentId" : localStorage.getItem('storeRecId'),
                "recCount" : null,
                "isFromCategory" : localStorage.getItem('isFromCategory'),
                "selectedCat" : selectedCat
            });  
            component.set("v.isViewAll", true);
            //localStorage.removeItem("storeRecId");
        }
        
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                //var allRecords = response.getReturnValue();
                var wrapperObject = response.getReturnValue();
                var allRecords = wrapperObject[0].reviewAreaList;
                component.set("v.reviewAreaCount", wrapperObject[0].reviewAreaCount);
                component.set("v.rCount", wrapperObject[0].count);
                component.set("v.parentRecName", wrapperObject[0].parentRecName);
                component.set("v.parentDDId", wrapperObject[0].parentDDId);
                component.set("v.parentCatName", wrapperObject[0].parentCatName);
                component.set("v.parentCatId", wrapperObject[0].parentCatId);
                var getCatnames = wrapperObject[0].catNames;
                var catValue = [];
                for(var key in getCatnames){
                    catValue.push({key: key, value: getCatnames[key]});
                }
                if(selectedCat === undefined){
                component.set("v.rAreaCatNames", catValue);
                }
                allRecords.forEach(rec => {
                    rec.accountLink = '/'+rec.Id;
                });
                    component.set("v.data", allRecords);
                    component.set("v.isLoading", false);
                }else{
                    var errors = response.getError();
                    var message = "Error: Unknown error";
                    if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                    component.set("v.error", message);
                    console.log("Error: "+message);
                }
                });
                    $A.enqueueAction(action);
                },
                })