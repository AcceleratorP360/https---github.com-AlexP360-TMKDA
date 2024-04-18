public class P360DA_CustomDueDiligenceCtrl {

    /*@AuraEnabled
    public static String updateObject(Id recordId, Map<String, Object> updatedObject) {
        System.debug('===updatedObject===' + updatedObject);
        try {

            Map<String, String> fieldInfoMap = new Map<String, String>();

            // Get the SObjectType for the object API name
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get('P360_Due_Diligence__c');

            if (objectType != null) {
                // Get the fields for the object
                Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

                // Iterate through the fields and store the API name and data type
                for (String fieldName : fieldMap.keySet()) {
                    Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                    String fieldType = fieldDescribe.getType().name();
                    System.debug('=====fieldName======='+fieldName);
                    fieldInfoMap.put(fieldName.toLowerCase(), fieldType);
                }
            }

            System.debug('=====fieldInfoMap======='+fieldInfoMap);

            // Update the fields
            P360_Due_Diligence__c dd = new P360_Due_Diligence__c();

            for (String field : updatedObject.keySet()) {
                System.debug('====field====='+field);
                System.debug('====fieldInfoMap====='+fieldInfoMap);
                System.debug('====fieldInfoMap==22==='+fieldInfoMap.containsKey(field));
                if(fieldInfoMap.containsKey(field.toLowerCase())){
                    System.debug('====fieldsType====='+fieldInfoMap.get(field.toLowerCase()));
                    dd.put('Id',recordId);
                    if(fieldInfoMap.get(field.toLowerCase()) == 'DATE'){
                        Date dt = Date.valueof(updatedObject.get(field));
                        dd.put(field,dt);
                    }else if(fieldInfoMap.get(field.toLowerCase()) == 'DATETIME'){
                        DateTime dateTimeValue = DateTime.valueOf(updatedObject.get(field));
                        dd.put(field,dateTimeValue);
                    }else{
                        dd.put(field,updatedObject.get(field));
                    }
                }
            }

            System.debug('===dd===' + dd);

            // Perform the update
            Database.SaveResult saveResult = Database.update(dd, false);

            // Check the result
            if (saveResult.isSuccess()) {
                return 'success';
            } else {
                String errorMessage = 'Failed to update record';
                if (!saveResult.getErrors().isEmpty()) {
                    errorMessage += ': ' + saveResult.getErrors()[0].getMessage();
                }
                return errorMessage;
            }
        } catch (Exception e) {
            // Handle exceptions
            return 'Error updating record: ' + e.getMessage();
        }
    }*/


    @AuraEnabled
    public static List<P360_Due_Diligence__c> getDDRecords(String accountId){
        List<P360_Due_Diligence__c> dDList = new List<P360_Due_Diligence__c>();
        system.debug('accountId : '+accountId);
        try {

            if(accountId!=null){
                dDList = [SELECT Id,P360_CoverHolder_TPA_Name__c,Name,P360_Approval_Status__c,P360_Due_Diligence_Type__c FROM P360_Due_Diligence__c WHERE P360_CoverHolder_TPA_Name__c =: accountId ORDER BY CreatedDate DESC];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<P360_DA_DD_Categories_Linkage__c> getDDRelatedRecord(Id recordId){
        List<P360_DA_DD_Categories_Linkage__c> dDList = new List<P360_DA_DD_Categories_Linkage__c>();
        system.debug('recordId==== : '+recordId);
        try {

            if(recordId!=null){
                dDList = [SELECT Id,Name, P360_DA_Linked_Due_Diligence_Name__c,P360_DA_Category_Name__c,P360_DA_Category_Name__r.name,Sub_Category_Completion_Status_Linkage__c,Completion_Marker_linkage__c,P360_DA_Summary_linkage__c     FROM P360_DA_DD_Categories_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<P360_DA_DD_Sub_Category_Linkage__c> getDDCatRelatedRecord(Id ddRecordId,Id recordId){
        List<P360_DA_DD_Sub_Category_Linkage__c> dDList = new List<P360_DA_DD_Sub_Category_Linkage__c>();
        system.debug('recordId==== : '+ddRecordId);
        try {

            if(ddRecordId!=null && recordId != null){
                dDList = [SELECT Id,P360_DA_Linked_Due_Diligence_Name__c,P360_DA_Sub_Category_Name__r.P360_Category_Name__r.Name,P360_DA_Sub_Category_Name__c,P360_DA_Sub_Category_Name__r.name,Name,P360_DA_DD_Category_Linkage__c,TMKDA_Connect_To_Primary__c,Completion_Marker_linkage__c,Review_Area_Completion_Status_linkage__c,P360_DA_DD_Category_Linkage__r.P360_DA_Category_Name__c  FROM P360_DA_DD_Sub_Category_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c =: ddRecordId AND P360_DA_DD_Category_Linkage__r.P360_DA_Category_Name__c  =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<P360_DA_DD_Review_Area_Linkage__c> getDdSubCatRelatedRecord(Id ddRecordId,Id recordId){
        List<P360_DA_DD_Review_Area_Linkage__c> dDList = new List<P360_DA_DD_Review_Area_Linkage__c>();
        system.debug('recordId==== : '+ddRecordId);
        try {

            if(ddRecordId!=null && recordId != null){
                dDList = [SELECT Id,P360_DA_Linked_Due_Diligence_Name__c,P360_DA_DD_Sub_Category_Linkage__c,Name,P360_DA_Review_Area_Name__c,P360_DA_Review_Area_Name__r.P360_Review_Point__c,P360_DA_DD_Sub_Category_Linkage__r.P360_DA_Sub_Category_Name__c,TMKDA_Connect_To_Primary__c,Review_Point_linkage__c,P360_DA_Source__c,Answer__c, Comment__c, Assessment_linkage__c,Severity_linkage__c,P360_DA_Sub_Category_linkage__c   FROM P360_DA_DD_Review_Area_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c  =: ddRecordId AND P360_DA_DD_Sub_Category_Linkage__r.P360_DA_Sub_Category_Name__c =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<P360_Actions__c> getDDRelatedActionRecord(Id recordId){
        List<P360_Actions__c> dDList = new List<P360_Actions__c>();
        system.debug('recordId==== : '+recordId);
        try {

            if(recordId != null){
                dDList = [SELECT Id,Due_Diligence__c,Name,P360_Action__c,P360_Description__c,User__c FROM P360_Actions__c WHERE Due_Diligence__c  =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<P360_Binder__c> getDDRelatedBindersRecord(Id recordId){
        List<P360_Binder__c> dDList = new List<P360_Binder__c>();
        system.debug('recordId==== : '+recordId);
        try {

            if(recordId != null){
                dDList = [SELECT Id,Due_Diligence__c,Name,P360_Expiry_Date__c,P360_Inception_date__c FROM P360_Binder__c WHERE Due_Diligence__c  =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<TMKDA_DAMO_PUGC__c> getDDRelatedDamoRecord(Id recordId){
        List<TMKDA_DAMO_PUGC__c> dDList = new List<TMKDA_DAMO_PUGC__c>();
        system.debug('recordId==== : '+recordId);
        try {

            if(recordId != null){
                dDList = [SELECT Id,TMKDA_Due_Diligence__c,Name,TMKDA_Start_Date__c,TMKADA_Outcome_status__c,TMKDA_Outcome_reason__c FROM TMKDA_DAMO_PUGC__c WHERE TMKDA_Due_Diligence__c  =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<TMKDA_BPA_Summary_Header__c> getDDRelatedSummaryRecord(Id recordId){
        List<TMKDA_BPA_Summary_Header__c> dDList = new List<TMKDA_BPA_Summary_Header__c>();
        system.debug('recordId==== : '+recordId);
        try {

            if(recordId != null){
                dDList = [SELECT Id,TMKDA_Due_Diligence_Id__c,Name,TMKDA_BPA_Stage__c,TMKDA_BPA_Start_Date__c,TMKDA_BPA_End_Date__c FROM TMKDA_BPA_Summary_Header__c WHERE TMKDA_Due_Diligence_Id__c  =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<TMKDA_Attestation__c> getDDRelatedAttestationsRecord(Id recordId){
        List<TMKDA_Attestation__c> dDList = new List<TMKDA_Attestation__c>();
        system.debug('recordId==== : '+recordId);
        try {

            if(recordId != null){
                dDList = [SELECT Id,Due_Diligence__c,Name,TMKDA_Attestation_Stages__c FROM TMKDA_Attestation__c WHERE Due_Diligence__c  =: recordId];
            }
            system.debug('dDList :'+dDList);
            return dDList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getDdCategoriesLinkage(Id recordId,Id mainRecordId){
        P360_DA_DD_Categories_Linkage__c ddLinkage = new P360_DA_DD_Categories_Linkage__c();
        try {
            if (recordId != null && mainRecordId != null) {
                List<P360_DA_DD_Categories_Linkage__c> linkageList = [
                    SELECT Id
                    FROM P360_DA_DD_Categories_Linkage__c
                    WHERE P360_DA_Linked_Due_Diligence_Name__c = :mainRecordId
                    AND P360_DA_Category_Name__c = :recordId
                    LIMIT 1
                ];
    
                if (!linkageList.isEmpty()) {
                    ddLinkage = linkageList[0];
                    return String.valueOf(ddLinkage.Id);
                } else {
                    // Handle case where no records are found
                    system.debug('No DD Categories Linkage found for the given criteria.');
                    return null;
                }
            }
    
            return null; // Handle case where either recordId or mainRecordId is null
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getDdSubCategoriesLinkage(Id recordId,Id mainRecordId){
        P360_DA_DD_Sub_Category_Linkage__c ddLinkage = new P360_DA_DD_Sub_Category_Linkage__c();
        try {
            if (recordId != null && mainRecordId != null) {
                List<P360_DA_DD_Sub_Category_Linkage__c> linkageList = [
                    SELECT Id
                    FROM P360_DA_DD_Sub_Category_Linkage__c
                    WHERE P360_DA_Linked_Due_Diligence_Name__c = :mainRecordId
                    AND P360_DA_Sub_Category_Name__c = :recordId
                    LIMIT 1
                ];
    
                if (!linkageList.isEmpty()) {
                    ddLinkage = linkageList[0];
                }
            }
    
            system.debug('ddLinkage: ' + ddLinkage);
            return String.valueOf(ddLinkage.Id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getReviewLinkage(Id recordId,Id mainRecordId){
        P360_DA_DD_Review_Area_Linkage__c ddLinkage = new P360_DA_DD_Review_Area_Linkage__c();
        try {
            if(recordId != null && mainRecordId != null){
                List<P360_DA_DD_Review_Area_Linkage__c> listOfReviewAreaLink = [SELECT Id,P360_DA_Linked_Due_Diligence_Name__c,P360_DA_Review_Area_Name__c FROM P360_DA_DD_Review_Area_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c  =: mainRecordId AND P360_DA_Review_Area_Name__c =: recordId LIMIT 1];
            
            	system.debug('listOfReviewAreaLink :'+listOfReviewAreaLink);
            
                if(!listOfReviewAreaLink.isEmpty()){
                    ddLinkage = listOfReviewAreaLink[0];
                }
            }
            
            system.debug('ddLinkage :'+ddLinkage);
            return string.valueof(ddLinkage.Id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getRecordsName(Id recordId){
        try {
            System.debug('=====recordId======='+recordId);
            if(recordId != null){
                SObjectType objType = recordId.getSObjectType();
                String objName = objType.getDescribe().getName();
                System.debug('=====objName======='+objName);
                String queryString = 'SELECT Id, Name FROM ' + objName + ' WHERE Id = :recordId';
                sObject record = Database.query(queryString);
                System.debug('=====record======='+record);
                System.debug('=====record.get()======='+record.get('Name'));
                return String.valueOf(record.get('Name'));
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ddWrapper> getDueDiligenceRecord(Id recordId){
        List<ddWrapper> listddWrap =  new List<ddWrapper>();
        List<P360_Due_Diligence__c> listDD = [SELECT Id,P360_CoverHolder_TPA_Name__c,Name,CreatedDate FROM P360_Due_Diligence__c WHERE P360_CoverHolder_TPA_Name__c =: recordId ORDER BY CreatedDate DESC];

        Map<Id,P360_Due_Diligence__c> mapIdVsDD = new Map<Id,P360_Due_Diligence__c>();

        for(P360_Due_Diligence__c dd : listDD){
            mapIdVsDD.put(dd.Id,dd);
        }
        System.debug('====mapIdVsDD====='+mapIdVsDD);

        //Set<Id> setDDIds = new Set<Id>();
        Map<Id, List<P360_DA_DD_Categories_Linkage__c>> mapIdVsDDCLinkage = new Map<Id, List<P360_DA_DD_Categories_Linkage__c>>();
        List<P360_DA_DD_Categories_Linkage__c> listDDLinkage = [SELECT Id,Name, P360_DA_Linked_Due_Diligence_Name__c,P360_DA_Category_Name__c,P360_DA_Category_Name__r.name,TMKDA_Connect_To_Primary__c FROM P360_DA_DD_Categories_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c IN :mapIdVsDD.keySet()];
        System.debug('===listDDLinkage==='+listDDLinkage);
        System.debug('===listDDLinkage==='+listDDLinkage.size());
        for(P360_DA_DD_Categories_Linkage__c ddLink: listDDLinkage){
            //setDDIds.add(ddLink.P360_DA_Linked_Due_Diligence_Name__c);
            if (!mapIdVsDDCLinkage.containsKey(ddLink.P360_DA_Linked_Due_Diligence_Name__c)) {
                mapIdVsDDCLinkage.put(ddLink.P360_DA_Linked_Due_Diligence_Name__c, new List<P360_DA_DD_Categories_Linkage__c>());
            }
            mapIdVsDDCLinkage.get(ddLink.P360_DA_Linked_Due_Diligence_Name__c).add(ddLink);
        }   
        System.debug('===mapIdVsDDCLinkage==='+mapIdVsDDCLinkage);

        Map<Id, List<P360_DA_DD_Sub_Category_Linkage__c>> mapIdVsddSubLinkage = new Map<Id, List<P360_DA_DD_Sub_Category_Linkage__c>>();
        List<P360_DA_DD_Sub_Category_Linkage__c> listDdSubLinkage = [SELECT Id,P360_DA_Linked_Due_Diligence_Name__c,P360_DA_Sub_Category_Name__c,P360_DA_Sub_Category_Name__r.name,Name,P360_DA_DD_Category_Linkage__c,TMKDA_Connect_To_Primary__c  FROM P360_DA_DD_Sub_Category_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c IN :mapIdVsDD.keySet()];
        for(P360_DA_DD_Sub_Category_Linkage__c ddSubLink : listDdSubLinkage){
            if (!mapIdVsddSubLinkage.containsKey(ddSubLink.P360_DA_DD_Category_Linkage__c)) {
                mapIdVsddSubLinkage.put(ddSubLink.P360_DA_DD_Category_Linkage__c, new List<P360_DA_DD_Sub_Category_Linkage__c>());
            }
            mapIdVsddSubLinkage.get(ddSubLink.P360_DA_DD_Category_Linkage__c).add(ddSubLink);
        }

        System.debug('===mapIdVsddSubLinkage==='+mapIdVsddSubLinkage);

        List<P360_DA_DD_Review_Area_Linkage__c> listDdReviewLinkaed = [SELECT Id,P360_DA_Linked_Due_Diligence_Name__c,P360_DA_DD_Sub_Category_Linkage__c,Name,P360_DA_Review_Area_Name__c,P360_DA_Review_Area_Name__r.P360_Review_Point__c,TMKDA_Connect_To_Primary__c  FROM P360_DA_DD_Review_Area_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c IN :mapIdVsDD.keySet()]; 
        Map<Id, List<P360_DA_DD_Review_Area_Linkage__c>> mapIdVsReviewLinkage = new Map<Id, List<P360_DA_DD_Review_Area_Linkage__c>>();
        for(P360_DA_DD_Review_Area_Linkage__c ddReview : listDdReviewLinkaed){
            if (!mapIdVsReviewLinkage.containsKey(ddReview.P360_DA_DD_Sub_Category_Linkage__c)) {
                mapIdVsReviewLinkage.put(ddReview.P360_DA_DD_Sub_Category_Linkage__c, new List<P360_DA_DD_Review_Area_Linkage__c>());
            }
            mapIdVsReviewLinkage.get(ddReview.P360_DA_DD_Sub_Category_Linkage__c).add(ddReview);
        }

        System.debug('===mapIdVsReviewLinkage==='+mapIdVsReviewLinkage);

        for(Id ddId : mapIdVsDD.keySet()){
            P360_Due_Diligence__c dd =  mapIdVsDD.get(ddId);
            ddWrapper ddWrap = new ddWrapper();
            ddWrap.label = dd.Name;
            ddWrap.name = dd.Id+ ',P360_Due_Diligence__c,'+ dd.Id;
            ddWrap.ids = dd.Id;
            ddWrap.expanded= false;
            if (mapIdVsDDCLinkage.containsKey(ddId)) {
                List<P360_DA_DD_Categories_Linkage__c > listDdCat = mapIdVsDDCLinkage.get(ddId);
                List<ddCategoryWrapper> listddCatWrap = new List<ddCategoryWrapper>();
                for(P360_DA_DD_Categories_Linkage__c  ddcat : listDdCat){
                    System.debug('ddcat Id: ' + ddcat.Id);
                    ddCategoryWrapper ddCatWrap = new ddCategoryWrapper();
                    ddCatWrap.ids = ddcat.P360_DA_Category_Name__c;
                    if(ddcat.TMKDA_Connect_To_Primary__c == 'Yes'){
                        ddCatWrap.label = ddcat.P360_DA_Category_Name__r.name + ' (Linked)';
                        ddCatWrap.name = ddcat.P360_DA_Category_Name__c+ ',P360_DD_Category__c,' + dd.Id +',' + false;
                    }else{
                        ddCatWrap.label = ddcat.P360_DA_Category_Name__r.name;
                        ddCatWrap.name = ddcat.P360_DA_Category_Name__c+ ',P360_DD_Category__c,' + dd.Id +',' + true;
                    }
                    
                    ddCatWrap.expanded= false;
                    listddCatWrap.add(ddCatWrap);

                    if(mapIdVsddSubLinkage.containsKey(ddcat.Id)){
                        List<P360_DA_DD_Sub_Category_Linkage__c> listddSub = mapIdVsddSubLinkage.get(ddcat.Id);
                        List<ddSubCategoryWrapper> listddSubWrap = new List<ddSubCategoryWrapper>();
                        for(P360_DA_DD_Sub_Category_Linkage__c ddSub : listddSub){
                            ddSubCategoryWrapper ddSubWrap = new ddSubCategoryWrapper();
                            ddSubWrap.ids = ddSub.P360_DA_Sub_Category_Name__c;
                            if(ddSub.TMKDA_Connect_To_Primary__c == 'Yes'){
                                ddSubWrap.label = ddSub.Name + ' (Linked)';
                                ddSubWrap.name = ddSub.P360_DA_Sub_Category_Name__c+ ',P360_DD_Sub_Category__c,' +dd.Id+',' + false;
                            }else{
                                ddSubWrap.label = ddSub.Name;
                                ddSubWrap.name = ddSub.P360_DA_Sub_Category_Name__c+ ',P360_DD_Sub_Category__c,' +dd.Id +',' + true;
                            }
                            
                            ddSubWrap.expanded= false;
                            listddSubWrap.add(ddSubWrap);
                            if(mapIdVsReviewLinkage.containsKey(ddSub.Id)){
                                List<P360_DA_DD_Review_Area_Linkage__c> listReview = mapIdVsReviewLinkage.get(ddSub.Id);
                                List<ddReviewWrapper> listReviewWrap = new List<ddReviewWrapper>();
                                for(P360_DA_DD_Review_Area_Linkage__c review : listReview){
                                    ddReviewWrapper reviewWrap = new ddReviewWrapper();
                                    if(review.TMKDA_Connect_To_Primary__c == 'Yes'){
                                        reviewWrap.label = review.P360_DA_Review_Area_Name__r.P360_Review_Point__c + ' (Linked)';
                                        reviewWrap.name = review.P360_DA_Review_Area_Name__c+ ',P360_Review_Area__c,'+dd.Id +',' + false;
                                    }else{
                                        reviewWrap.label = review.P360_DA_Review_Area_Name__r.P360_Review_Point__c;
                                        reviewWrap.name = review.P360_DA_Review_Area_Name__c+ ',P360_Review_Area__c,'+dd.Id +',' + true;
                                    }
                                    
                                    reviewWrap.ids = review.P360_DA_Review_Area_Name__c;
                                    reviewWrap.expanded= false;
                                    listReviewWrap.add(reviewWrap);
                                }
                                ddSubWrap.items =listReviewWrap;
                            }
                        }
                        ddCatWrap.items = listddSubWrap;
                    }
                }
                ddWrap.items = listddCatWrap;
            }
            listddWrap.add(ddWrap);  
        }
        System.debug('====listddWrap====='+listddWrap);

        return listddWrap;
    }

    public class ddWrapper{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String ids{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
        @AuraEnabled
        public List<ddCategoryWrapper> items{get;set;}
    }

    public class ddCategoryWrapper{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String Ids{get;set;}
        @AuraEnabled
        public List<ddSubCategoryWrapper> items{get;set;}
    }

    public class ddSubCategoryWrapper{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String Ids{get;set;}
        @AuraEnabled
        public List<ddReviewWrapper> items{get;set;}
    }

    public class ddReviewWrapper{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
        @AuraEnabled
        public String Ids{get;set;}
    }

    @AuraEnabled
	public static List<sectionWithFieldsWrapper> getLayoutMetadata(String objName) {
        System.debug('==objName===='+objName);
        String objNames = '';
        if(objName == 'P360_Due_Diligence__c'){
            objNames = objName +'-Due Diligence Layout';
        }else if (objName == 'P360_DD_Category__c'){
            System.debug('==objName======'+objName);
            objNames = objName +'-DD-Category Layout';
        }else if (objName == 'P360_DD_Sub_Category__c'){
            objNames = objName +'-DD-Sub Category Layout';
        }else if (objName == 'P360_Review_Area__c'){
            objNames = objName +'-TMKDA_Review Area Layout';
        }
        
        System.debug('==objNames===='+objNames);
		Map<String, List<String>> sectionVsFieldsList = new Map<String, List<String>>();
		List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {objNames});
	
        List<sectionWithFieldsWrapper> listSectionWithFieldsWrapper = new List<sectionWithFieldsWrapper>();

        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objName).getDescribe();
        System.debug('==objectDescribe===='+objectDescribe);
		Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
		for (Metadata.LayoutSection section : layoutMd.layoutSections) {
			System.debug('=section='+section.label);
			List<String> fieldList = new List<String>();
            
            System.debug('==section.layoutColumns==='+section.layoutColumns);
            System.debug('==section.layoutColumns==='+section.layoutColumns.size());
            Metadata.LayoutColumn leftColumn;
            Metadata.LayoutColumn rightColumn;
            if(section.layoutColumns.size() > 1){
                leftColumn = section.layoutColumns[0];
                System.debug('=leftColumn=if===='+leftColumn);
                rightColumn = section.layoutColumns[1];
                System.debug('=rightColumn=if===='+rightColumn);
            }else{
                leftColumn = section.layoutColumns[0];
                System.debug('=leftColumn=else==='+leftColumn);
            }

            List<String> leftFields = new List<String>();
            List<leftSideFieldWrapper> leftSideFieldWrappers = new List<leftSideFieldWrapper>();
            if(leftColumn != null && leftColumn.layoutItems != null){
                for(Metadata.LayoutItem left : leftColumn.layoutItems){
                    System.debug('=leftFields='+left.field);
                    //leftFields.add(left.field);
                    if(left.field != null){
                        Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(left.field).getDescribe();
                        leftSideFieldWrapper leftWrap = new leftSideFieldWrapper();
                        leftWrap.fieldName = left.field;
                        if(fieldDescribe.isUpdateable()){
                            leftWrap.fieldWritable = true;
                        }else{
                            leftWrap.fieldWritable = false;
                        }
                        leftSideFieldWrappers.add(leftWrap);
                    }
                }
            }

            List<String> rightFields = new List<String>();
            List<rightSideFieldWrapper> rightSideFieldWrappers = new List<rightSideFieldWrapper>();
            if(rightColumn != null && rightColumn.layoutItems != null){
                for(Metadata.LayoutItem right : rightColumn.layoutItems){
                    System.debug('=rightFields='+right.field);
                    //rightFields.add(right.field);
                    if(right.field != null){
                        Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(right.field).getDescribe();
                        rightSideFieldWrapper rightWrap = new rightSideFieldWrapper();
                        rightWrap.fieldName = right.field;
                        if(fieldDescribe.isUpdateable()){
                            rightWrap.fieldWritable = true;
                        }else{
                            rightWrap.fieldWritable = false;
                        }
                        rightSideFieldWrappers.add(rightWrap);
                    }
                }
            }
            System.debug('=leftSideFieldWrappers======'+leftSideFieldWrappers);
            System.debug('=rightSideFieldWrappers====='+rightSideFieldWrappers);
            System.debug('=leftFields='+leftFields);
            System.debug('=rightFields='+rightFields);
            System.debug('=leftFields.size()='+leftFields.size());
            System.debug('=rightFields.size()='+rightFields.size());

            if(rightSideFieldWrappers.size() >  0 || leftSideFieldWrappers.size() > 0){
                sectionWithFieldsWrapper wrap = new sectionWithFieldsWrapper();
                wrap.sectionName = section.label;
                wrap.leftSideFields = leftFields;
                wrap.rightSideFields = rightFields;
                wrap.listleftSideFieldWrapper = leftSideFieldWrappers;
                wrap.listrightSideFieldWrapper = rightSideFieldWrappers;
                listSectionWithFieldsWrapper.add(wrap);
            }
		}
		System.debug('listSectionWithFieldsWrapper=='+listSectionWithFieldsWrapper);
        return listSectionWithFieldsWrapper;
	}

    public class sectionWithFieldsWrapper{
        @AuraEnabled
        public String sectionName{get;set;}
        @AuraEnabled
        public List<String> leftSideFields{get;set;}
        @AuraEnabled
        public List<String> rightSideFields{get;set;}
        @AuraEnabled
        public List<leftSideFieldWrapper> listleftSideFieldWrapper{get;set;}
        @AuraEnabled
        public List<rightSideFieldWrapper> listrightSideFieldWrapper{get;set;}
    }

    public class leftSideFieldWrapper{
        @AuraEnabled
        public String fieldName{get;set;}
        @AuraEnabled
        public Boolean fieldWritable{get;set;}
    }

    public class rightSideFieldWrapper{
        @AuraEnabled
        public String fieldName{get;set;}
        @AuraEnabled
        public Boolean fieldWritable{get;set;}
    }
}