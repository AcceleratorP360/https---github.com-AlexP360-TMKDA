/**
 * @author [Srikanth Cheera]
 * @create date 2024-04-03 09:38:45
 * @modify date 2024-04-03 09:38:45
 * @desc [description]
 */
public with sharing class DD_FileListCtrl {

    public DD_FileListCtrl() {

    }

    @AuraEnabled(cacheable = true)
    public Static List < FileListCtrl.fileWrapper > getfiles(String recordId) {
        try {
            Set < Id > setOfCat = new Set < Id > ();
            Set < Id > setOfSubCat = new Set < Id > ();
            Set < Id > setOfrArea = new Set < Id > ();
            Set < Id > setOfBPA = new Set < Id > ();
            Set < Id > setOfPUGC = new Set < Id > ();
            Set < Id > setOfPRA = new Set < Id > ();
            Set < Id > setOfBinder = new Set < Id > ();
            Set < Id > setOfAttId = new Set< Id >();
            Set< Id > setOfAttScopIds  = new Set< Id >();
            
            Set < String > setOfParentIds = new Set < String > ();

            List < FileListCtrl.fileWrapper > fWrapList = new List < FileListCtrl.fileWrapper > ();

            List < P360_DD_Category__c > categoryList = [SELECT Id FROM P360_DD_Category__c WHERE P360_Due_Diligence_Name__c =: recordId ];

            if (!categoryList.isEmpty()) {
                for (P360_DD_Category__c cat: categoryList) {
                    setOfCat.add(cat.Id);
                }
            }

            List < P360_DD_Sub_Category__c > subCatgoryList = [SELECT Id FROM P360_DD_Sub_Category__c WHERE P360_Due_Diligence_Name__c =: recordId ];

            if (!categoryList.isEmpty()) {
                for (P360_DD_Sub_Category__c subCat: subCatgoryList) {
                    setOfSubCat.add(subCat.Id);
                }
            }

            List < P360_Review_Area__c > reviewAreaList = [SELECT Id FROM P360_Review_Area__c WHERE Due_Diligence__c =: recordId ];

            if (!reviewAreaList.isEmpty()) {
                for (P360_Review_Area__c rArea: reviewAreaList) {
                    setOfrArea.add(rArea.Id);
                }
            }

            List<TMKDA_BPA_Summary_Header__c> bpaList = [ SELECT Id FROM TMKDA_BPA_Summary_Header__c WHERE TMKDA_Due_Diligence_Id__c =: recordId ];

            if(!bpaList.isEmpty()){
                for(TMKDA_BPA_Summary_Header__c bpa : bpaList){
                    setOfBPA.add(bpa.Id);
                }
            }

            List<TMKDA_DAMO_PUGC__c> pugcList = [ SELECT Id FROM TMKDA_DAMO_PUGC__c WHERE TMKDA_Due_Diligence__c =: recordId ];
            if(!pugcList.isEmpty()){
                for(TMKDA_DAMO_PUGC__c pugc : pugcList){
                    setOfPUGC.add(pugc.Id);
                }
            }

            List<P360_Actions__c> praList = [ SELECT Id FROM P360_Actions__c WHERE Due_Diligence__c =: recordId ];

            if(!praList.isEmpty()){
                for(P360_Actions__c pra : praList){
                    setOfPRA.add(pra.Id);
                }
            }
 
            List<P360_Binder__c> binderList = [ SELECT Id FROM P360_Binder__c WHERE Due_Diligence__c =: recordId ];

            if(!binderList.isEmpty()){
                for(P360_Binder__c binder : binderList){
                    setOfBinder.add(binder.Id);
                }
            }
            
            List<TMKDA_Attestation__c> attList = [ SELECT Id FROM TMKDA_Attestation__c WHERE Due_Diligence__c =: recordId ];
            
            if(!attList.isEmpty()){
                for(TMKDA_Attestation__c att : attList){
                    setOfAttId.add(att.Id);
                }
            }
            
            List<TMKDA_DD_Attestation_Scoping__c> attScoptingList = [ SELECT Id FROM TMKDA_DD_Attestation_Scoping__c WHERE TMKDA_Due_Diligence__c =: recordId ];
            
            if(!attScoptingList.isEmpty()){
                for(TMKDA_DD_Attestation_Scoping__c attScope : attScoptingList){
                    setOfAttScopIds.add(attScope.Id);
                }
            }
            
            List < ContentDocumentLink > cDocLinkList = [SELECT Id, LinkedEntity.Name, LinkedEntityId, ContentDocument.Description,
                                                         ContentDocument.CreatedBy.Name, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentModifiedDate,
                                                         ContentDocument.LastModifiedBy.Name FROM ContentDocumentLink
                                                         WHERE LinkedEntityId =: recordId OR LinkedEntityId =: setOfCat OR LinkedEntityId =: setOfSubCat OR LinkedEntityId =: setOfrArea 
                                                         OR LinkedEntityId =: setOfBPA OR LinkedEntityId =: setOfPUGC  OR LinkedEntityId =: setOfPRA OR LinkedEntityId =: setOfBinder
                                                         OR LinkedEntityId =:setOfAttId OR LinkedEntityId =:setOfAttScopIds
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
                FileListCtrl.fileWrapper fileWap = new FileListCtrl.fileWrapper();
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
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}