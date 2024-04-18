({
    doInit: function (cmp, event, helper) {
        var partyId = '';
        helper.getDueDeligenceRecords(cmp, event, helper, partyId);
    },
    
    sectionOne : function(cmp, event, helper) {
        var getRecordId =event.currentTarget.getAttribute("data-recId");
        var getWrapper = cmp.get("v.wrapperObject");
        
        for(let i = 0; i < getWrapper.length; i++){
            for(let cat =0; cat < getWrapper[i].catList.length; cat++){
                if(getWrapper[i].catList[cat].Id === getRecordId){
                    if(getWrapper[i].catList[cat].Expand_Category__c){
                        getWrapper[i].catList[cat].Expand_Category__c = false;
                    }else{
                        getWrapper[i].catList[cat].Expand_Category__c = true;
                    }
                }
            }    
        }
        
        cmp.set("v.wrapperObject", getWrapper);  
    },
    sectionTwo : function(cmp, event, helper) {
        var getRecordId =event.currentTarget.getAttribute("data-recId"); 
        var getWrapper = cmp.get("v.wrapperObject");
        for(let i = 0; i < getWrapper.length; i++){
            for(let subCat =0; subCat < getWrapper[i].subCatList.length; subCat++){
                if(getWrapper[i].subCatList[subCat].Id === getRecordId){
                    if(getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c){
                        getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c = false;
                    }else{
                        getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c = true;
                    } 
                }
            }
            
        }
        cmp.set("v.wrapperObject", getWrapper);
    },
    
    handleDueDeligence :  function (cmp, event, helper) {  
        var getRecordId =event.currentTarget.getAttribute("data-recId");        
        var getWrapper = cmp.get("v.wrapperObject");
        for(let i = 0; i < getWrapper.length; i++){
            if(getWrapper[i].dueDeligence.Id === getRecordId){
                if(getWrapper[i].dueDeligence.Expand_Due_Deligence__c){
                    getWrapper[i].dueDeligence.Expand_Due_Deligence__c = false;
                }else{
                    getWrapper[i].dueDeligence.Expand_Due_Deligence__c = true;
                }
            }
        }
        
        cmp.set("v.wrapperObject", getWrapper);
    },
    
    handleNavigateRecordPage :   function (cmp, event, helper) { 
        var getRecordId =event.currentTarget.getAttribute("data-recId");
        var getObject =event.target.id;
        var ExAppEvent = $A.get("e.c:P360_Custom_Record_Edit_Page_App");
        ExAppEvent.setParams({"selectedRecordId" : getRecordId});
        ExAppEvent.setParams({"selectedSobject" : getObject});
        ExAppEvent.fire();
    },
    
    handleAccountChange :    function (cmp, event, helper) { 
        console.log('--  event.getParam("value")[0] ', event.getParam("value")[0])
        helper.getDueDeligenceRecords(cmp, event, helper, event.getParam("value")[0]);
        
        var ExAppEvent = $A.get("e.c:P360_Custom_Record_Edit_Page_App");
        ExAppEvent.setParams({"selectedRecordId" : event.getParam("value")[0]});
        ExAppEvent.setParams({"selectedSobject" : ''});
        ExAppEvent.fire();
    }
})