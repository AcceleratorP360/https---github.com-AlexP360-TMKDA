public class Screen3Controller {
    @AuraEnabled
    public static String uploadFiles(String recordId, String filedata) {
        try {
            if(String.isNotBlank(FileData)) {
                List<FileDataWP> files = (List<FileDataWP>) JSON.deserialize(filedata, List<FileDataWP>.class);
                System.debug(files);
                
                List<ContentVersion> cvList = new List<ContentVersion>();
                for(FileDataWP file : files) {
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S'; // S = Salesforce, E = External Files
                    conVer.VersionData = EncodingUtil.base64Decode(file.fileContent);
                    conVer.Title = file.fileName;
                    conVer.PathOnClient = file.fileName;
                    cvList.add(conVer);
                }
                Insert cvList;
                
                List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
                for(ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cvList]) {
                    ContentDocumentLink conDocLink = New ContentDocumentLink();
                    conDocLink.LinkedEntityId = recordId;
                    conDocLink.ContentDocumentId = cv.ContentDocumentId;
                    conDocLink.Visibility = 'AllUsers';
                    conDocLink.shareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
                    cdList.add(conDocLink);
                }
                Insert cdList;        
            } else {
                return 'record Id is Blank';
            }
            return 'success';
        } catch (Exception ex) {
            System.debug(ex.getMessage() + ' -> ' + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    public class FileDataWP {
        public String fileName;
        public String fileContent;
    }
    
    @AuraEnabled( cacheable = true )
    public static List< P360_Review_Area__c > fetchAccounts(String recordId) {
        
        return [ SELECT Id,P360_Scope_of_DD_Review__c,P360_Assessment__c,P360_DD_Sub_Category__c,P360_Evidence_file_path__c,P360_Completion_Marker__c,P360_Summary__c,Name FROM P360_Review_Area__c ];
        
    }
    
    @AuraEnabled
    public static string updateAccounts( Object data )
    {
        
        List < P360_Review_Area__c > accsForUpdate = ( List < P360_Review_Area__c > ) JSON.deserialize(
            JSON.serialize( data ),
            List < P360_Review_Area__c >.class
        );
        try {
            update accsForUpdate;
            return 'Success: Due Diligience Review Area updated successfully';
        }
        catch (Exception e) {
            return 'The following exception has occurred: '+ e.getMessage();
        }
        
    }
    
    @AuraEnabled(cacheable = true)
    public static List < pickListWrapper > getPickListValues(sObject customObjInfo, string selectPicklistApi) {
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();
        Map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();
        List < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        List < pickListWrapper > customObjWrapper = new List < pickListWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) {
            pickListWrapper selectOptionValueWrapper = new pickListWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }
        
        return customObjWrapper;
    }
    
    public with sharing class pickListWrapper {
        @auraEnabled public string custFldlabel {
            get;
            set;
        }
        @auraEnabled public string custFldvalue {
            get;
            set;
        }
    }
    
    
    
}