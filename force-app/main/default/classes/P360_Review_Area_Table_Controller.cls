public class P360_Review_Area_Table_Controller {
    @AuraEnabled
    public static List < getAllRecordsWrapper > getReviewAreas(String parentId, integer recCount, Boolean isFromCategory, string selectedCat) {
        Set < Id > reviewAreaIdSet = new Set < Id > ();
        List < P360_Review_Area__c > rAreaList = new List < P360_Review_Area__c > ();
        List < getAllRecordsWrapper > wrapperList = new List < getAllRecordsWrapper > ();
        String parentRecName = '';
        String parentDDId = '';  //Added by Amitabh 27/02 to get in CMP
        String parentCatName = ''; //Added by Amitabh 27/02 to get in CMP
        String parentCatId = '';  //Added by Amitabh 27/02 to get in CMP
        Set<String> rAreaCatNames = new Set<string>();
        List<String> sortCat = new List<String>();
        List < P360_Review_Area__c > reviewAreaList = new List< P360_Review_Area__c >();
        String query = 'SELECT Id, P360_DA_Review_Area_Name__c, Name, P360_IS_Primary_Connect_On_Linked_Area__c, P360_Review_Point__c';
        query += ', P360_DA_Review_Area_ID__c, P360_DA_Review_Area_ID__r.P360_DA_RA_Guidance__c, P360_Guidance__c, P360_RA_Category__c';
        query += ', P360_Master_Guidance__c, P360_RA_Category__r.Name, P360_DD_Sub_Category__r.Name, Parent_Sub_Category__c, TMKDA_Primary_Linked__c,TMKDA_Severity__c';
        query += ', Due_Diligence__c, Due_Diligence__r.Name';
        /* commented by vardhani 1/03/2024 */
      /*  query += ', TMKDA_Answer__c, P360_Pass_Fail__c, TMKDA_Source__c, P360_Parent_Category_Name__c,P360_Completion_Marker__c  FROM P360_Review_Area__c';*/
         query += ', TMKDA_Answer__c, P360_Pass_Fail__c, TMKDA_Source__c, P360_Parent_Category_Name__c, P360_Comment__c,P360_Completion_Marker__c  FROM P360_Review_Area__c';
        if(!isFromCategory){
        /* added Comment_c field in query */
            for (P360_DA_DD_Review_Area_Linkage__c reviewAreaLink: [SELECT Id, P360_DA_Review_Area_Name__c,P360_DA_RA_Linked_Status__c,
                                                                    P360_DA_Review_Area_Name__r.P360_IS_Primary_Connect_On_Linked_Area__c, TMKDA_Connect_To_Primary__c,
                                                                    P360_DA_Linked_Due_Diligence_Name__c, P360_DA_Linked_Due_Diligence_Name__r.Name, 
                                                                    P360_DA_Review_Area_Name__r.P360_DD_Sub_Category__r.Name,P360_DA_DD_Sub_Category_Linkage__c,Comment__c
                                                                   
                                                                    FROM P360_DA_DD_Review_Area_Linkage__c WHERE
                                                                    P360_DA_Linked_Due_Diligence_Name__c =: parentId
                                                                   ]) {
                                                                       parentRecName = reviewAreaLink.P360_DA_Linked_Due_Diligence_Name__r.Name;
                                                                       parentDDId = '/lightning/r/P360_Due_Diligence__c/' + reviewAreaLink.P360_DA_Linked_Due_Diligence_Name__c + '/view';
                                                                       if (String.isNotBlank(reviewAreaLink.P360_DA_Review_Area_Name__c)) {
                                                                           if (reviewAreaLink.P360_DA_Review_Area_Name__r.P360_IS_Primary_Connect_On_Linked_Area__c != reviewAreaLink.TMKDA_Connect_To_Primary__c) {
                                                                               P360_Review_Area__c rArea = new P360_Review_Area__c(Id = reviewAreaLink.P360_DA_Review_Area_Name__c,
                                                                                                                                   P360_IS_Primary_Connect_On_Linked_Area__c = reviewAreaLink.TMKDA_Connect_To_Primary__c);
                                                                               rAreaList.add(rArea);
                                                                           }
                                                                           reviewAreaIdSet.add(reviewAreaLink.P360_DA_Review_Area_Name__c);
                                                                       }
                                                                   }
            if (!rAreaList.isEmpty()) {
                update rAreaList;
            }
            
            if (recCount != null) {
                query += ' where Id IN : reviewAreaIdSet AND TMKDA_Show_ReviewA_Record__c = true  ORDER BY TMK_DD_Review_area_sort_order__c';
                query += ' LIMIT ' + recCount;
            }else{
                
                query += ' where Id IN : reviewAreaIdSet AND TMKDA_Show_ReviewA_Record__c = true';
                query += String.isNotBlank(selectedCat) ? ' AND P360_RA_Category__r.Name =: selectedCat' : '';
                query += ' ORDER BY TMK_DD_Review_area_sort_order__c';
            }
            system.debug('---query '+query);
            reviewAreaList = Database.query(query);
            if(rAreaCatNames.isEmpty()){
                for(P360_Review_Area__c rArea : reviewAreaList){
                    rAreaCatNames.add(rArea.P360_RA_Category__r.Name);
                }
                sortCat.addAll(rAreaCatNames);
                    sortCat.sort();
            }
        }else{
            query += ' where P360_RA_Category__c = : parentId AND TMKDA_Show_ReviewA_Record__c = true  ORDER BY TMK_DD_Review_area_sort_order__c';
            if (recCount != null) {
                query += ' LIMIT ' + recCount;
            }
            reviewAreaList = Database.query(query);
            for(P360_Review_Area__c rArea : reviewAreaList){
                // Updated by Amitabh -27/02 -- to get Categoty and Due Dilgence details
                parentRecName = rArea.Due_Diligence__r.Name;
                parentDDId = '/lightning/r/P360_Due_Diligence__c/' + rArea.Due_Diligence__c + '/view';
                parentCatName = rArea.P360_RA_Category__r.Name;
                parentCatId = '/lightning/r/P360_DD_Category__c/' + rArea.P360_RA_Category__c + '/view';
                // ends here
                
                break;
            }
        }
        
        getAllRecordsWrapper wrp = new getAllRecordsWrapper();
        wrp.reviewAreaList = reviewAreaList;
        /* commented by VA to have total count of records 10/04/2024*/
        //String reviewAreaCount = reviewAreaList.size() > 10 ? 'Review Areas' + ' (10+)' : 'Review Areas' + '(' + reviewAreaList.size() + ')';
        //String rCount = reviewAreaList.size() > 10 ? '10+ items' : reviewAreaList.size() + ' items';
        //Added by VA to have total count of records
            String reviewAreaCount = 'Review Areas' + '(' + reviewAreaList.size() + ')';
            String rCount =  reviewAreaList.size() + ' items';
        wrp.reviewAreaCount = reviewAreaCount;
        wrp.count = rCount;
        wrp.catNames = sortCat;
        wrp.parentRecName = parentRecName;
        wrp.parentDDId = parentDDId;
        wrp.parentCatName = parentCatName;
        wrp.parentCatId = parentCatId;
        
        wrapperList.add(wrp);
        return wrapperList;
    }
    public class getAllRecordsWrapper {
        @AuraEnabled public List < P360_Review_Area__c > reviewAreaList { get; set; }
        @AuraEnabled public String reviewAreaCount { get; set; }
        @AuraEnabled public String count { get; set; }
        @AuraEnabled public String parentRecName { get; set; }
        @AuraEnabled public String parentDDId { get; set; }
        @AuraEnabled public String parentCatName { get; set; }
        @AuraEnabled public String parentCatId { get; set; }
        @AuraEnabled public List<String> catNames { get; set; }
    }
    
    @AuraEnabled
    public static void updateRecords(String jsonString) {
        try {
            List < P360_Review_Area__c > records = (List < P360_Review_Area__c > ) JSON.deserialize(jsonString, List < P360_Review_Area__c > .class);
            update records;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map < string, Map < string, String >> getPicklistValues(String objectAPIName) {
        
        
            
        Map < String, String > pickListValuesMapAns = new Map < String, String > ();
        Map < String, String > pickListValuesMapSev = new Map < String, String > ();
        Map < String, String > pickListValuesMapAss = new Map < String, String > ();
        Map < String, String > pickListValuesMapCom = new Map < String, String > ();
        Map < String, String > pickListValuesMapPri = new Map < String, String > ();
        Map < string, Map < string, String >> fieldNamePickListValueMap = new Map < string, Map < string, String >> ();
            
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult descResult = convertToObj.getDescribe();
         
        //TMKDA_Answer__c
        Schema.DescribeFieldResult fieldResult = descResult.fields.getMap().get('TMKDA_Answer__c').getDescribe();
        Boolean isFieldNotRequired = fieldResult.isNillable();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
             
        for (Schema.PicklistEntry pickListVal: ple) {
            if (isFieldNotRequired)
                pickListValuesMapAns.put('--None--', '');
            if (pickListVal.isActive())
                pickListValuesMapAns.put(pickListVal.getLabel(), pickListVal.getValue()); 
            
            /* ---addedby vardhani -- 22/02
              if (pickListVal == null || pickListVal.getValue() == ''||pickListVal.getValue() == 'None')
                pickListValuesMapAns.TMKDA_Answer__c.addError('TMKDA_Answer__c field must not be empty.');
           */
    }          
        fieldNamePickListValueMap.put('TMKDA_Answer__c', pickListValuesMapAns);
        
        
        //TMKDA_Severity__c
        Schema.DescribeFieldResult fieldResultSev = descResult.fields.getMap().get('TMKDA_Severity__c').getDescribe();
        Boolean isFieldNotRequiredSev = fieldResultSev.isNillable();
        List < Schema.PicklistEntry > pleSev = fieldResultSev.getPicklistValues();
        for (Schema.PicklistEntry pickListVal: pleSev) {
            if (isFieldNotRequiredSev)
                pickListValuesMapSev.put('--None--', '');
            if (pickListVal.isActive())
                pickListValuesMapSev.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        fieldNamePickListValueMap.put('TMKDA_Severity__c', pickListValuesMapSev);
        //P360_Assessment__c
        Schema.DescribeFieldResult fieldResultAss = descResult.fields.getMap().get('P360_Pass_Fail__c').getDescribe();
        Boolean isFieldNotRequiredAss = fieldResultAss.isNillable();
        List < Schema.PicklistEntry > pleAss = fieldResultAss.getPicklistValues();
        for (Schema.PicklistEntry pickListVal: pleAss) {
            if (isFieldNotRequiredAss)
                pickListValuesMapAss.put('--None--', '');
            if (pickListVal.isActive())
                pickListValuesMapAss.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        fieldNamePickListValueMap.put('P360_Pass_Fail__c', pickListValuesMapAss);
        //P360_Completion_Marker__c
        Schema.DescribeFieldResult fieldResultCm = descResult.fields.getMap().get('P360_Completion_Marker__c').getDescribe();
        Boolean isFieldNotRequiredCom = fieldResultCm.isNillable();
        List < Schema.PicklistEntry > pleCom = fieldResultCm.getPicklistValues();
        for (Schema.PicklistEntry pickListVal: pleCom) {
            if (isFieldNotRequiredCom)
                pickListValuesMapCom.put('--None--', '');
            if (pickListVal.isActive())
                pickListValuesMapCom.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        fieldNamePickListValueMap.put('P360_Completion_Marker__c', pickListValuesMapCom);
        
        //TMKDA_Primary_Linked__c
        Schema.DescribeFieldResult fieldResultPri = descResult.fields.getMap().get('TMKDA_Primary_Linked__c').getDescribe();
        Boolean isFieldNotRequiredPri = fieldResultPri.isNillable();
        List < Schema.PicklistEntry > plePri = fieldResultPri.getPicklistValues();
        for (Schema.PicklistEntry pickListVal: plePri) {
            if (isFieldNotRequiredPri)
                pickListValuesMapPri.put('--None--', '');
            if (pickListVal.isActive())
                pickListValuesMapPri.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        fieldNamePickListValueMap.put('TMKDA_Primary_Linked__c', pickListValuesMapPri);
        
        return fieldNamePickListValueMap;     
        
            
    }
    
    
   /* 
     @AuraEnabled
    
     public static void updateReviewAreaRecords(List<P360_Review_Area__c> reviewAreas) {
        Set<Id> parentIds = new Set<Id>();
        
        // Collect all Category, Due Diligence, and Account Ids
        for (P360_Review_Area__c reviewArea : reviewAreas) {
            if (reviewArea.P360_DD_Sub_Category__c != null) {
                parentIds.add(reviewArea.P360_DD_Sub_Category__c);
            }
        }
        
        // Query Sub-category, Category, Due Diligence, and Account records to get their field values
        Map<Id, P360_DD_Sub_Category__c> subcategoryMap = new Map<Id, P360_DD_Sub_Category__c>([
            SELECT Id, P360_Category_Name__c, P360_Due_Diligence_Name__c, P360_Coverholder_TPA_Name__c
            FROM P360_DD_Sub_Category__c
            WHERE Id IN :parentIds
        ]);
        
        // Update Review Area records with Sub Category, Category, Due Diligence, and Account information
        for (P360_Review_Area__c reviewArea : reviewAreas) {
            if (reviewArea.P360_DD_Sub_Category__c != null) {
                P360_DD_Sub_Category__c subcategory = subcategoryMap.get(reviewArea.P360_DD_Sub_Category__c);
                if (subcategory != null) {
                    reviewArea.P360_DD_Sub_Category__c = subcategory.Id;
                    reviewArea.P360_RA_Category__c = subcategory.P360_Category_Name__c;
                    reviewArea.Due_Diligence__c = subcategory.P360_Due_Diligence_Name__c;
                    reviewArea.P360_CoverHolder_Name__c = subcategory.P360_Coverholder_TPA_Name__c;
                }
            }
        }
    }
*/
    
    
}