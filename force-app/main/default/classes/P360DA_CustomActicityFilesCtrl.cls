public class P360DA_CustomActicityFilesCtrl {

    @AuraEnabled(cacheable=false)
    public static List<ContentDocument> getRelatedFilesRecord(String recordId){

        Set<Id> contentDocIds = new Set<Id>();
        List<ContentDocumentLink> docLinkList = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ORDER BY SystemModstamp DESC LIMIT 5];
        for (ContentDocumentLink docLink : docLinkList) {
            contentDocIds.add(docLink.ContentDocumentId);
        }
        List<ContentDocument> contentDocList = [SELECT Id, Title, ContentSize, FileExtension, SystemModstamp FROM ContentDocument WHERE Id IN :contentDocIds ORDER BY SystemModstamp DESC];

        List<ContentDocument> newListFile = new List<ContentDocument>();
        for(ContentDocument cd : contentDocList){
            Decimal fileSizeKB = cd.ContentSize / 1024.0;
            System.debug('File Size in KB: ' + fileSizeKB);
            Integer intValue = fileSizeKB.intValue();
            if(intValue > 0){
                newListFile.add(cd);
            }
        }
        System.debug('==newListFile==='+newListFile);
        System.debug('RelatedFilesController : getRelatedFilesRecord : contentDocList :'+contentDocList);

        return newListFile;
    }

    @AuraEnabled
    public static String uploadFiles(List<FilesWrapper> filesList, String recordId){

        try{

            System.debug('uploadFiles '+JSON.serialize(filesList));

            List<ContentVersion> conVersionList = new List<ContentVersion>();
            List<ContentDocumentLink> conDocLinkList = new List<ContentDocumentLink>();
            Set<String> conVersionIdsSet = new Set<String>();

            for (FilesWrapper file : filesList) {
                ContentVersion cv = new ContentVersion();
                cv.VersionData = EncodingUtil.base64Decode(file.base64);
                cv.Title = file.filename;
                cv.PathOnClient = file.filename;
                conVersionList.add(cv);
            }
            
            if(!conVersionList.isEmpty()){

                System.debug('uploadFiles conVersionList '+conVersionList);

                list<Database.saveResult> conVerResult = Database.insert(conVersionList);
                for (Database.SaveResult saveResult : conVerResult) {
                    if(saveResult.isSuccess()) {
                        conVersionIdsSet.add(saveResult.getId());
                    }
                }
            }

            if(!conVersionIdsSet.isEmpty()){
                System.debug('uploadFiles conVersionIdsSet '+conVersionIdsSet);
                System.debug('uploadFiles conVersionIdsSet '+conVersionIdsSet);

                List<ContentVersion> conVerList =  [SELECT ContentDocumentId  FROM ContentVersion  WHERE Id IN :conVersionIdsSet];

                for (ContentVersion con : conVerList) {
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = con.ContentDocumentId;
                    cdl.LinkedEntityId = recordId;
                    cdl.ShareType = 'V';
                    conDocLinkList.add(cdl);
                }

                if(!conDocLinkList.isEmpty()){
                    System.debug('uploadFiles conDocLinkList '+conDocLinkList);
                    list<Database.saveResult>  docLinkResult = Database.insert(conDocLinkList);
                }
            }

            return JSON.serialize(new Response('success','Files uploaded successfully !'));
        }catch(Exception e){
            System.debug('uploadFiles error '+e.getMessage());
            return JSON.serialize(new Response('error',e.getMessage()));
        }
    }

    public class FilesWrapper{
        @AuraEnabled
        public String filename{get; set;}
        @AuraEnabled
        public String base64{get; set;}
    }

    public class Response{
        public String status;
        public String message;
        public Response(String status, String message){
            this.status = status;
            this.message = message;
        }
    }
}