public  class BPADataTable {
   
    @AuraEnabled

    public static List<TMKDA_BPA_Summary_Detail__c> getBPADetails(String name) {

        return [
            SELECT Id,  Name, TMKDA_BPA_Summary_Name__c, TMKDA_Information__c, TMKDA_Confirmation_Statement_Accurate__c,TMKDA_Section__c,TMKDA_Coverholder_Comment__c,TMKDA_CO_Comments__c,TMKDA_Sequence__c,TMKDA_BPA_Question__r.Name
            FROM TMKDA_BPA_Summary_Detail__c
            WHERE TMKDA_BPA_Summary_Name__c = :name ORDER BY TMKDA_Sequence__c ASC
            
        ];
    

       

    }
    
    @AuraEnabled
public static String updateBPADetails(List<TMKDA_BPA_Summary_Detail__c> recordToUpdate) {
    try {
        update recordToUpdate;
        return 'Success: record updated successfully';
    } catch (Exception e) {
        return 'Error: ' + e.getMessage();
    }
}

   
      @AuraEnabled
public static void deleteBPARecord (Id delRecordId) {
        try {
            // Perform record deletion using the delete DML operation
            //TMKDA_BPA_Summary_Detail__c delRecord=[SELECT Id,TMKDA_BPA_Summary_Name__c,Name FROM TMKDA_BPA_Summary_Detail__c WHERE Id IN : delRecordId];
            Database.delete(delRecordId, false);
        } catch(Exception e) {
            // Handle any exceptions
            System.debug('Error deleting records: ' + e.getMessage());
            throw e;
        }
    }



@AuraEnabled
public static String getUserDetails(Id userId) {
    try {
        return [SELECT id,Profile.Name FROM User WHERE Id=:userId].Profile.Name;
    } catch (Exception e) {
        return 'Error: ' + e.getMessage();
    }
}

}
/*
    @AuraEnabled
    public static String updateBPADetails(List<TMKDA_BPA_Summary_Detail__c> data) {
        try {
            update data;
            return 'Success: records updated successfully';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
*/