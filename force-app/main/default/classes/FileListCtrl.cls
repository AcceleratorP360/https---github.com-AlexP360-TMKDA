/**
 * @author [ Srikanth Cheera ]
 * @create date 2023-10-10 17:08:49
 * @modify date 2023-10-10 17:08:49
 * @desc [ to display the Content version list based on Parent and child records and grand child records ]
 */
public with sharing class FileListCtrl {
    public FileListCtrl() {

    }

    @AuraEnabled(cacheable = true)
    public static List < fileWrapper > getFiles(String recordId) {
        try {
            Set < Id > setOfDD = new Set < Id > ();
            Set < Id > setOfCat = new Set < Id > ();
            Set < Id > setOfSubCat = new Set < Id > ();
            Set < Id > setOfrArea = new Set < Id > ();
            Set < Id > setOfBPA = new Set < Id > ();
            Set < Id > setOfPUGC = new Set < Id > ();
            Set < Id > setOfPRA = new Set < Id > ();
            Set < Id > setOfBinder = new Set < Id > ();
            Set< Id > setOfAttId = new Set< Id >();
            Set< Id > setOfAttScopIds  = new Set< Id >();
            Set < String > setOfParentIds = new Set < String > ();
            
            List < fileWrapper > fWrapList = new List < fileWrapper > ();
            /* List < ContentDocument > cDocList = [SELECT Id FROM ContentDocument];
             Set < Id > setOfcDocIds = new Set < Id > ();
             for (ContentDocument cDoc: cDocList) {
                 setOfcDocIds.add(cDoc.Id);
             }*/

            // if (!setOfcDocIds.isEmpty()) {
            List < P360_Due_Diligence__c > dueDeligenceList = [SELECT Id FROM P360_Due_Diligence__c
                WHERE P360_CoverHolder_TPA_Name__c =: recordId
            ];
            
            if (!dueDeligenceList.isEmpty()) {
                for (P360_Due_Diligence__c dd: dueDeligenceList) {
                    setOfDD.add(dd.Id);
                }
            }

            List < P360_DD_Category__c > categoryList = [SELECT Id FROM P360_DD_Category__c WHERE P360_Coverholder_TPA_Name__c =: recordId];
            
            if (!categoryList.isEmpty()) {
                for (P360_DD_Category__c cat: categoryList) {
                    setOfCat.add(cat.Id);
                }
            }

            List < P360_DD_Sub_Category__c > subCatgoryList = [SELECT Id FROM P360_DD_Sub_Category__c WHERE P360_Coverholder_TPA_Name__c =: recordId];
            
            if (!categoryList.isEmpty()) {
                for (P360_DD_Sub_Category__c subCat: subCatgoryList) {
                    setOfSubCat.add(subCat.Id);
                }
            }

            List < P360_Review_Area__c > reviewAreaList = [SELECT Id FROM P360_Review_Area__c WHERE P360_CoverHolder_Name__c =: recordId];
            
            
            if (!reviewAreaList.isEmpty()) {
                for (P360_Review_Area__c rArea: reviewAreaList) {
                    setOfrArea.add(rArea.Id);
                }
            }
            
            List<TMKDA_BPA_Summary_Header__c> bpaList = [ SELECT Id FROM TMKDA_BPA_Summary_Header__c WHERE TMKDA_Coverholder_DCA__c =: recordId ];
            
            if(!bpaList.isEmpty()){
                for(TMKDA_BPA_Summary_Header__c bpa : bpaList){
                    setOfBPA.add(bpa.Id);
                }
            }
            
            List<TMKDA_DAMO_PUGC__c> pugcList = [ SELECT Id FROM TMKDA_DAMO_PUGC__c WHERE TMKDA_Party__c =: recordId ];
            if(!pugcList.isEmpty()){
                for(TMKDA_DAMO_PUGC__c pugc : pugcList){
                    setOfPUGC.add(pugc.Id);
                }
            }
            
            List<P360_Actions__c> praList = [ SELECT Id FROM P360_Actions__c WHERE Party__c =: recordId ];
            
            if(!praList.isEmpty()){
                for(P360_Actions__c pra : praList){
                    setOfPRA.add(pra.Id);
                }
            }
            
            List<P360_Binder__c> binderList = [ SELECT Id FROM P360_Binder__c WHERE Party__c =: recordId ];
            
            if(!binderList.isEmpty()){
                for(P360_Binder__c binder : binderList){
                    setOfBinder.add(binder.Id);
                }
            }
            
            List<TMKDA_Attestation__c> attList = [ SELECT Id FROM TMKDA_Attestation__c WHERE Company_Name__c =: recordId ];
            
            if(!attList.isEmpty()){
                for(TMKDA_Attestation__c att : attList){
                    setOfAttId.add(att.Id);
                }
            }
            
            List<TMKDA_DD_Attestation_Scoping__c> attScoptingList = [ SELECT Id FROM TMKDA_DD_Attestation_Scoping__c WHERE TMKDA_Company_Name__c =: recordId ];
            
            if(!attScoptingList.isEmpty()){
                for(TMKDA_DD_Attestation_Scoping__c attScope : attScoptingList){
                    setOfAttScopIds.add(attScope.Id);
                }
            }
            
            List < ContentDocumentLink > cDocLinkList = [SELECT Id, LinkedEntity.Name, LinkedEntityId, ContentDocument.Description,
                                                         ContentDocument.CreatedBy.Name, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentModifiedDate,
                                                         ContentDocument.LastModifiedBy.Name FROM ContentDocumentLink
                                                         WHERE LinkedEntityId =: recordId OR LinkedEntityId =: setOfDD OR LinkedEntityId =: setOfCat
                                                         OR LinkedEntityId =: setOfSubCat OR LinkedEntityId =: setOfrArea 
                                                         OR LinkedEntityId =: setOfBPA OR LinkedEntityId =: setOfPUGC OR LinkedEntityId =: setOfPRA OR LinkedEntityId =: setOfBinder
                                                         OR LinkedEntityId =: setOfAttId OR LinkedEntityId =: setOfAttScopIds
                                                         Order BY ContentDocument.LastModifiedDate DESC
            ];
            
            for (ContentDocumentLink cDocLink: cDocLinkList) {
                setOfParentIds.add(String.valueOf(cDocLink.LinkedEntityId).substring(0, 3));
            }

            Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
            Map < String, String > objMap = new Map < String, String > ();
            for (Schema.SObjectType stype: gd.values()) {

                Schema.DescribeSObjectResult r = stype.getDescribe();
                if (setOfParentIds.contains(r.getKeyPrefix())) {
                    objMap.put(r.getKeyPrefix(), r.getLabel());
                }
            }

            for (ContentDocumentLink cDocLink: cDocLinkList) {
                fileWrapper fileWap = new fileWrapper();
                fileWap.docTitle = cDocLink.ContentDocument.Title;
                fileWap.docId = cDocLink.ContentDocumentId;
                if (String.isNotEmpty(cDocLink.ContentDocument.Description)) {
                    fileWap.docDescription = cDocLink.ContentDocument.Description;
                } else {
                    fileWap.docDescription = '';
                }
              //  fileWap.docCreatedBy = cDocLink.ContentDocument.CreatedBy.Name;
                fileWap.docRelated = cDocLink.LinkedEntity.Name;
                fileWap.DocModifiedBy = cDocLink.ContentDocument.LastModifiedBy.Name;
                fileWap.DocModifiedDate = cDocLink.ContentDocument.ContentModifiedDate;
                if (objMap.containskey(String.valueOf(cDocLink.LinkedEntityId).substring(0, 3))) {
                    fileWap.DocObjLabel = objMap.get(String.valueOf(cDocLink.LinkedEntityId).substring(0, 3));
                    fileWap.DocRelatedId = cDocLink.LinkedEntityId;
                }
                fWrapList.add(fileWap);
            }
            // }
            if (!fWrapList.isEmpty()) {
                return fWrapList;
            } else {
                return null;
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class fileWrapper {

        @AuraEnabled public String docTitle;
        @AuraEnabled public String docId;
        @AuraEnabled public String docDescription;
        @AuraEnabled public String docRelated;
      //  @AuraEnabled public String docCreatedBy;
        @AuraEnabled public String DocModifiedBy;
        @AuraEnabled public String DocObjLabel;
        @AuraEnabled public DateTime DocModifiedDate;
        @AuraEnabled public String DocRelatedId;

    }
}