public class S3_BucketBatchCtrl implements Database.Batchable < sObject > , Database.AllowsCallouts {

    public String folderId;
    public List < String > foldersList;
    public String workSpaceName;
    public S3_BucketBatchCtrl(String folderId, List < String > foldersList, String workSpaceName) {
        this.folderId = folderId;
        this.foldersList = foldersList;
        this.workSpaceName = workSpaceName;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name FROM ContentFolder WHERE Id = \'' + folderId + '\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List < ContentFolder > scope) {

        List < ContentFolder > cfldList = new List < ContentFolder > ();
        Set < String > strNames = new Set < String > ();
        for (String str: foldersList) {
            strNames.add(str.substringBefore('/'));
        }
        
        List < ContentFolder > contFolderList = [SELECT Id, Name FROM ContentFolder WHERE Name =: strNames AND ParentContentFolderId =: folderId];
        Map<String, ContentFolder> cfMap = new Map<String, ContentFolder>();
        
        if(!contFolderList.isEmpty()){
            for(ContentFolder cf : contFolderList){
                cfMap.put(cf.Name, cf);
            }
        }
        
        if (contFolderList.isEmpty()) {
            for (String str: strNames) {
                ContentFolder cFolder = new ContentFolder();
                cFolder.Name = str;
                cFolder.ParentContentFolderId = folderId;
                cfldList.add(cFolder);
            }
            
            if (!cfldList.isEmpty()) {
                insert cfldList;
            }
        }else{
            for (String str: strNames) {
                if(!cfMap.containsKey(str)){
                    ContentFolder cFolder = new ContentFolder();
                    cFolder.Name = str;
                    cFolder.ParentContentFolderId = folderId;
                    cfldList.add(cFolder);
                }
            }
            if (!cfldList.isEmpty()) {
                insert cfldList;
            }
        }
    }

    public void finish(Database.BatchableContext BC) {
        List < ContentFolder > cFOlderList = [SELECT Id, Name, ParentContentFolderId FROM ContentFolder WHERE ParentContentFolderId =: folderId];
        List < ContentVersion > conVerList = new List < ContentVersion > ();
        Map < String, String > mapFolders = new Map < String, String > ();

        for (String str: foldersList) {
            mapFolders.put(str.substringAfter('/'), str.substringBefore('/'));
        }

        P360_S3__c s3 = [SELECT P360_SD1_DCOM_Coverholder__c, P360_SD3a_DCOM_High_COB_Max_limit__c, P360_SD3_DCOM_Authorized_COB__c, P360_SD4_DCOM_Territorial_Limits__c,
            P360_SD8_DCOM_Claims_Complaints__c, P360_SD10a_DCOM_Section_Leads__c, P360_KDR__c, P360_PDT__c, P360_BDX__c FROM P360_S3__c LIMIT 1
        ];

        for (String str: foldersList) {
            if (mapFolders.KeySet() <> NULL && mapFolders.containsKey(str.substringAfter('/')) && !str.contains('Archived')) {

                String url = 'callout:'+ Label.S3_Bucket;
                HttpRequest reqStr = new HttpRequest();
                reqStr.setEndpoint(url + '/' + str.substringBefore('/') + '/' + str.substringAfter('/').replaceAll(' ', '%20'));
                reqStr.setMethod('GET');
                Http http = new Http();
                HttpResponse resStr = http.send(reqStr);
                if (resStr.getStatusCode() == 200) {
                    if (String.isNotBlank(resStr.getBody())) {
                        if ((str.substringAfter('/').contains('_SD1_') && s3.P360_SD1_DCOM_Coverholder__c == true) ||
                            (str.substringAfter('/').contains('_SD3_') && s3.P360_SD3_DCOM_Authorized_COB__c == true) ||
                            (str.substringAfter('/').contains('_SD10a_') && s3.P360_SD10a_DCOM_Section_Leads__c == true) ||
                            (str.substringAfter('/').contains('_SD3a_') && s3.P360_SD3a_DCOM_High_COB_Max_limit__c == true) ||
                            (str.substringAfter('/').contains('_SD4_') && s3.P360_SD4_DCOM_Territorial_Limits__c == true) ||
                            (str.substringAfter('/').contains('_SD8_') && s3.P360_SD8_DCOM_Claims_Complaints__c == true) ||
                            (str.substringAfter('/').contains('KDR') && s3.P360_KDR__c == true) ||
                            (str.substringAfter('/').contains('PDT') && s3.P360_PDT__c == true) ||
                            (str.substringAfter('/').contains('BDX') && s3.P360_BDX__c == true)) {
                            ContentVersion conVer = new ContentVersion();
                            conVer.contentLocation = 'S';
                            conver.PathonClient = str.substringAfter('/');
                            conVer.Title = str.substringAfter('/');
                            conver.VersionData = resStr.getBodyasblob();
                            conver.Description = str.substringBefore('/');
                            conVerList.add(conver);
                        }
                    }
                }
            }
        }

        if (!conVerList.isEmpty()) {
            // Saving documents
            insert conVerList;
            List < ContentVersion > cvList = [SELECT Id, ContentDocumentId, Description FROM ContentVersion WHERE Id =: conVerList];
            ContentWorkspace ws = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name =: workSpaceName];
            Set < Id > setOf_rootFolderIds = new Set < Id > ();
            List < ContentDocumentLink > docList = new List < ContentDocumentLink > ();
            Set < Id > conVerIds = new Set < Id > ();
            for (ContentVersion cv: cvList) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = ws.Id;
                setOf_rootFolderIds.add(ws.RootContentFolderId);
                conVerIds.add(cv.Id);
                docList.add(cdl);
            }

            if (!docList.isEmpty()) {
                insert docList;
            }


            Map < String, String > folderMap = new Map < String, String > ();
            List < ContentFolder > folderList = [SELECT Id, Name FROM ContentFolder WHERE ParentContentFolderId =: folderId];
            for (ContentFolder cFolder: folderList) {
                folderMap.put(cFolder.Name, cFolder.Id);
            }

            List < ContentFolderMember > folderMemList = [SELECT Id, ParentContentFolderId, ChildRecord.Description FROM ContentFolderMember
                WHERE ParentContentFolderId =: setOf_rootFolderIds
                AND ChildRecord.Description =: folderMap.keySet()
            ];

            List < ContentFolderMember > update_fMember = new List < ContentFolderMember > ();
            for (ContentFolderMember fMember: folderMemList) {
                if (folderMap.containsKey(fMember.ChildRecord.Description.substringBefore('/'))) {
                    fMember.ParentContentFolderId = folderMap.get(fMember.ChildRecord.Description.substringBefore('/'));
                    update_fMember.add(fMember);
                }
            }

            if (!update_fMember.isEmpty()) {
                update update_fMember;
                S3_StagingTableBatch stagingBatch = new S3_StagingTableBatch(conVerIds);
                Database.executeBatch(stagingBatch, 1);
            }
        }
    }
}