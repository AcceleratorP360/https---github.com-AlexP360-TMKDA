({
    doInit: function (cmp, event, helper) {
        helper.getPrimaryDueDeligenceRecords(cmp, event, helper);
    },
    
    handleDueDeligenceSelection: function (cmp, event, helper) {
        var getSelectedValue = event.getParam("value");
        var selPrimaryDueDeligence = cmp.get("v.selectedPrimaryDueDeligence");
        var getPrimaryDueId = cmp.get("v.primarySelectedId");
        cmp.set("v.expandAll", false);
        if(getPrimaryDueId === selPrimaryDueDeligence){
            cmp.set("v.showHelperText", true);
        }else{
            cmp.set("v.showHelperText", false);
        }
        helper.getAllRelatedRecords(cmp, event, helper, selPrimaryDueDeligence);
    },
    
    handleCategoryChange: function (cmp, event, helper) {  
        console.log('---->>>>>> CATEGORY');
        cmp.set("v.isSelectionSelected", false);
        var getSelectedId = event.getSource().get("v.name");
        cmp.set("v.selectedCatId", getSelectedId)
        var selectedValue = event.getSource().get("v.value");
        if(getSelectedId && selectedValue){
            cmp.set("v.isSelectionSelected", true);
        }
        var getWrapper = cmp.get("v.wrapperObject");
        for(let i = 0; i < getWrapper.length; i++){
            if(getWrapper[i].cat.Id === getSelectedId){
                for(let subCat =0; subCat < getWrapper[i].subCatList.length; subCat++){
                    if((selectedValue === 'NA' || selectedValue === 'Link') && getWrapper[i].subCatList[subCat].P360_Category_Name__c === getSelectedId){
                        getWrapper[i].subCatList[subCat].P360_Is_Connection_Enable__c = true;  
                    }else{
                        getWrapper[i].subCatList[subCat].P360_Is_Connection_Enable__c = false;
                    }
                    getWrapper[i].subCatList[subCat].P360_Connect_Copy_Options__c = selectedValue;
                    for(let rArea =0; rArea < getWrapper[i].reviewAreaList.length; rArea++){
                        if((selectedValue === 'NA'  || selectedValue === 'Link') &&
                           getWrapper[i].reviewAreaList[rArea].P360_RA_Category__c === getSelectedId){
                            getWrapper[i].reviewAreaList[rArea].P360_Is_Connection_Enable__c = true; 
                        }else{
                            getWrapper[i].reviewAreaList[rArea].P360_Is_Connection_Enable__c = false;
                        }
                        getWrapper[i].reviewAreaList[rArea].Connect_Copy_Options__c = selectedValue;
                    }
                }
                
            }
            
        }
        cmp.set("v.wrapperObject", getWrapper);
        
    },
    
    handlesubCategoryChange: function (cmp, event, helper) {  
        var getSelectedSubCatId = event.getSource().get("v.name");
        cmp.set("v.selectedSubCatId", getSelectedSubCatId)
        var selectedValue = event.getSource().get("v.value");
        var getWrapper = cmp.get("v.wrapperObject");
        for(let i = 0; i < getWrapper.length; i++){
            for(let subCat =0; subCat < getWrapper[i].subCatList.length; subCat++){
                if(getWrapper[i].subCatList[subCat].Id === getSelectedSubCatId){
                    getWrapper[i].subCatList[subCat].P360_Connect_Copy_Options__c === selectedValue;
                    for(let rArea =0; rArea < getWrapper[i].reviewAreaList.length; rArea++){
                        if(getWrapper[i].reviewAreaList[rArea].P360_DD_Sub_Category__c === getSelectedSubCatId){
                            if((selectedValue === 'NA' || selectedValue === 'Link')){
                                getWrapper[i].reviewAreaList[rArea].P360_Is_Connection_Enable__c = true; 
                            }else{
                                getWrapper[i].reviewAreaList[rArea].P360_Is_Connection_Enable__c = false; 
                            }
                            
                            getWrapper[i].reviewAreaList[rArea].Connect_Copy_Options__c = selectedValue;
                        }
                    }
                }
            }
            
        }
        cmp.set("v.wrapperObject", getWrapper);
        
    },
    
    catShowToolTip : function (cmp, event, helper) {
        var id1=event.currentTarget.getAttribute("data-recId");
        cmp.set("v.selectedCatId", id1);
        cmp.set("v.isCatModalOpen" , true);
        
    },
    catHideToolTip : function (cmp, event, helper) {
        cmp.set("v.isCatModalOpen" , false);
    },
    
    summaryShowToolTip : function (cmp, event, helper) {
        var id1=event.currentTarget.getAttribute("data-recId");
        cmp.set("v.selectedCatId", id1);
        var getSummaryModalOpen = cmp.get("v.isSummaryModalOpen");
        if(getSummaryModalOpen){
            cmp.set("v.isSummaryModalOpen" , false);
        }else{
            cmp.set("v.isSummaryModalOpen" , true);
        }         
    },
    
    commentShowToolTip : function (cmp, event, helper) {
        var id1=event.currentTarget.getAttribute("data-recId");
        cmp.set("v.selectedReviewAreaId", id1);
        var getShowModalOpen = cmp.get("v.isCommentModalOpen");
        if(getShowModalOpen){
            cmp.set("v.isCommentModalOpen" , false);
        }else{
            cmp.set("v.isCommentModalOpen" , true);
        }  
    },
    
    
    subCatShowToolTip : function (cmp, event, helper) {
        var id1=event.currentTarget.getAttribute("data-recId");
        cmp.set("v.selectedSubCatId", id1);
        cmp.set("v.issubCatModalOpen" , true);
        
    },
    subCatHideToolTip : function (cmp, event, helper) {
        cmp.set("v.issubCatModalOpen" , false);
    },
    
    reviewAreaShowToolTip : function (cmp, event, helper) {
        var id1=event.currentTarget.getAttribute("data-recId");
        cmp.set("v.selectedReviewAreaId", id1);
        cmp.set("v.isreviewAreaModalOpen" , true);
        
    },
    reviewAreaHideToolTip : function (cmp, event, helper) {
        cmp.set("v.isreviewAreaModalOpen" , false);
    },
    
    handleOpenDetailPage : function (cmp, event, helper) {
        var navService = cmp.find("navService");
        var getRecordId =event.currentTarget.getAttribute("data-recId");         
        var pageReference = {    
            "type": "standard__recordPage", 
            "attributes": {
                "recordId": getRecordId,
                "actionName": "view"
            }
        }
        console.log('----pageReference ',pageReference);
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            console.log('success: ' + url); 
            window.open(url,'_blank');
        }), 
              $A.getCallback(function(error) {
                  console.log('error: ' + error);
              }));
    },
    
    handleCreationOfRecords : function (cmp, event, helper) {
        var isSelectionSelected =  cmp.get("v.isSelectionSelected");
        if(isSelectionSelected){
            cmp.set("v.showSpinner", true);
            helper.createRecords(cmp, event, helper, cmp.get("v.wrapperObject"));
        }else{
            helper.showToast(cmp, event, helper, 'error', 'Please Select Category records to Inherit from Primary Connections', 'Error')
        }
    },
    
    
    handleShowDetails : function (cmp, event, helper) {
        var getCatId = event.getSource().get("v.name");
        cmp.set("v.showBoxCatId", getCatId)
        
    },
    sectionOne : function(cmp, event, helper) {
        var getRecordId =event.currentTarget.getAttribute("data-recId");
        var getClickedCatId =  cmp.get("v.expand_CollapseCatId");
        
        var getWrapper = cmp.get("v.wrapperObject");
        for(let i = 0; i < getWrapper.length; i++){
            if(getWrapper[i].cat.Id === getRecordId){
                if(getWrapper[i].cat.Expand_Category__c){
                    getWrapper[i].cat.Expand_Category__c = false;
                    for(let subCat =0; subCat < getWrapper[i].subCatList.length; subCat++){
                        if(getRecordId === getWrapper[i].subCatList[subCat].P360_Category_Name__c){
                            if(getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c){
                                getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c = false;
                            }else{
                                getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c = true;
                            }  
                        }  
                    }
                }else{
                    getWrapper[i].cat.Expand_Category__c = true;
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
    expandAllCollapseAll :  function(cmp, event, helper) {
        var getWrapper = cmp.get("v.wrapperObject");
        var isExpCollapse = cmp.get("v.expandAll");
        if(isExpCollapse){
            cmp.set("v.expandAll" , false);
            for(let i = 0; i < getWrapper.length; i++){
                getWrapper[i].cat.Expand_Category__c = false;
                for(let subCat =0; subCat < getWrapper[i].subCatList.length; subCat++){
                    getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c = false;                    
                }            
                cmp.set("v.wrapperObject", getWrapper);  
            }
        }else{
            cmp.set("v.expandAll" , true);
            for(let i = 0; i < getWrapper.length; i++){
                getWrapper[i].cat.Expand_Category__c = true;
                for(let subCat =0; subCat < getWrapper[i].subCatList.length; subCat++){
                    getWrapper[i].subCatList[subCat].Expand_Sub_Catgeory__c = true;                    
                }            
                cmp.set("v.wrapperObject", getWrapper);  
            }
        }
        
    }
    
})