public class P360DA_CustomActivityChatterTabCtrl {

    /**
    * Retrieves the Chatter feed for a given record.
    * @param recordId The ID of the record for which to retrieve the Chatter feed.
    * @return List of FeedItem objects representing Chatter feed records.
    */
    @AuraEnabled
    public static List<FeedWithContentVersion> getChatterFeed(String recordId){

        List<FeedItem> feedRecordList = new List<FeedItem>();

        Map<Id, FeedWithContentVersion> feedWithContentMap = new Map<Id, FeedWithContentVersion>();

        try{

            Map<Id, FeedItem> feedRecordMap = new Map<Id, FeedItem>([
                    SELECT Id, Title, Type, Visibility, LikeCount, LinkUrl, IsRichText, CommentCount, Body, CreatedBy.Name, CreatedDate,
                    (SELECT Id, Status, CommentBody, ParentId, RelatedRecordId, CreatedBy.Name, CreatedDate FROM FeedComments ORDER By CreatedDate ASC)
                    FROM FeedItem WHERE ParentId = :recordId 
                    ORDER By CreatedDate DESC
                    LIMIT 1000
                ]);

            for (Id id : feedRecordMap.keySet()) {
                FeedWithContentVersion data = new FeedWithContentVersion();
                data.feed = feedRecordMap.get(id);
                data.attachList = new List<ContentVersion>();
                feedWithContentMap.put(id, data);
            }

            Set<Id> feedIds = feedRecordMap.keySet();
            Map<Id, Id> contVsFeed = new Map<Id, Id>();

            List<FeedAttachment> feedAttachList = [SELECT Id, Title, FeedEntityId, RecordId FROM FeedAttachment WHERE FeedEntityId IN :feedIds];
            for (FeedAttachment attach : feedAttachList) {
                contVsFeed.put(attach.RecordId, attach.FeedEntityId);
            }
            
            List<ContentVersion> conVerList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id IN :contVsFeed.keySet()];
            
            for (ContentVersion content : conVerList){
                String feedId = contVsFeed.get(content.Id);
                feedWithContentMap.get(feedId).attachList.add(content);
            }

        }catch(Exception e){
            System.debug('ChatterController getChatterFeed : Error : '+e.getMessage());
        }        
        return feedWithContentMap.values();
    }

    @AuraEnabled(cacheable=true)
    public static ContentVersion getContentVersion(String conVersionId){

        ContentVersion conDoc = new ContentVersion();

        try{
            conDoc = [SELECT Id, Title, ContentDocumentId, ContentSize FROM ContentVersion WHERE Id = :conVersionId ];

        }catch(Exception e){
            System.debug('ChatterController getContentVersion : Error : '+e.getMessage());
        }

        return conDoc;
    }

    /**
    * Creates a Chatter feed post with optional attached files.
    * @param feed A JSON string containing the feed data, including body text and attached files.
    * @return JSON string representation of the response (success or error).
    */
    @AuraEnabled
    public static String createChatterFeed(String feed){

        Response res = new Response();
        try{

            FeedWrapper feedData = (FeedWrapper) JSON.deserializeStrict(feed, FeedWrapper.class);
			system.debug('===feedData===='+feedData);
            FeedItem post = new FeedItem();
            post.ParentId = feedData.recordId;
            post.Body = feedData.body;
            insert post;

            Response result = (Response) JSON.deserializeStrict( uploadFiles(feedData.attach,post.Id), Response.class);

            if(result.status == 'success'){

                res.status = 'success';
                res.message = 'Feed created successfully !';

                return JSON.serialize(res);

            }

            return JSON.serialize(result);

        }catch(Exception e){
            System.debug('ChatterController createChatterFeed : Error : '+e.getMessage());
            res.status = 'error';
            res.message = e.getMessage();
            
        }

        return JSON.serialize(res);

    }

    /**
    * Adds a comment to an existing Chatter feed post.
    * @param feed A JSON string containing the comment data, including the feed item ID and body text.
    * @return JSON string representation of the response (success or error).
    */
    @AuraEnabled
    public static String createFeedComment(String feed){

        Response res = new Response();
        try{

            FeedWrapper feedData = (FeedWrapper) JSON.deserializeStrict(feed, FeedWrapper.class);

            FeedComment comment = new FeedComment();
            comment.FeedItemId = feedData.recordId;
            comment.CommentBody = feedData.body;
            insert comment;

            res.status = 'success';
            res.message = 'Feed created successfully !';

        }catch(Exception e){
            System.debug('ChatterController createChatterFeed : Error : '+e.getMessage());
            res.status = 'error';
            res.message = e.getMessage();
            
        }

        return JSON.serialize(res);
    }

    /**
    * Uploads files as ContentVersion and associates them with a Chatter feed post.
    * @param filesList List of FilesWrapper objects containing filename and base64-encoded file data.
    * @param recordId The ID of the Chatter feed item to associate the files with.
    * @return JSON string representation of the response (success or error).
    */
    @AuraEnabled
    public static String uploadFiles(List<FilesWrapper> filesList, String recordId){

        try{

            System.debug('uploadFiles '+JSON.serialize(filesList));

            List<ContentVersion> conVersionList = new List<ContentVersion>();
            List<FeedAttachment> feedAttachList = new List<FeedAttachment>();
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
                        System.debug('uploadFiles conVersionList saveResult '+saveResult);
                        conVersionIdsSet.add(saveResult.getId());
                    }
                }
            }

            if(!conVersionIdsSet.isEmpty()){

                List<ContentVersion> conVerList =  [SELECT Id, Title, ContentDocumentId  FROM ContentVersion  WHERE Id IN :conVersionIdsSet];

                System.debug('uploadFiles conVersionIdsSet '+conVersionIdsSet);
                System.debug('uploadFiles conVerList '+conVerList);

                for (ContentVersion conVersion : conVerList) {
                    FeedAttachment attach = new FeedAttachment();
                    attach.FeedEntityId = recordId;
                    attach.RecordId = conVersion.Id;
                    attach.Title = conVersion.Title;
                    attach.Type = 'Content';
                    feedAttachList.add(attach);
                }

                if(!feedAttachList.isEmpty()){
                    System.debug('uploadFiles feedAttachList '+feedAttachList);
                    list<Database.saveResult>  feedAttachResult = Database.insert(feedAttachList);
                }
            }

            return JSON.serialize(new Response('success','Files uploaded successfully !'));
        }catch(Exception e){
            System.debug('uploadFiles error '+e.getMessage());
            return JSON.serialize(new Response('error',e.getMessage()));
        }
    }

    /**
    * Deletes a Chatter feed record (either main post or comment) based on the provided ID and type.
    * @param id The ID of the Chatter feed record to be deleted.
    * @param feedType The type of Chatter feed record ('MAIN' for main post, 'COMMENT' for comment).
    * @return JSON string representation of the response (success or error).
    */
    @AuraEnabled
    public static String deleteFeedRecord(String id, String feedType){

        try{
            if(feedType == 'MAIN'){
                FeedItem feed = [SELECT Id FROM FeedItem WHERE Id = :id];
                delete feed;
                
            }
            else if(feedType == 'COMMENT'){
                FeedComment comment = [SELECT Id FROM FeedComment WHERE Id = :id];
                delete comment;
            }

            return JSON.serialize(new Response('success','Feed record removed successfully !'));

        }catch(Exception e){
            System.debug('deleteFeedRecord error '+e.getMessage());
            return JSON.serialize(new Response('error',e.getMessage()));
        }

    }

    /**
    * Updates the content of a Chatter feed record (either main post or comment) based on the provided ID and type.
    * @param id The ID of the Chatter feed record to be updated.
    * @param feedType The type of Chatter feed record ('MAIN' for main post, 'COMMENT' for comment).
    * @param body The new content to update for the Chatter feed record.
    * @return JSON string representation of the response (success or error).
    */
    @AuraEnabled
    public static String updateFeedRecord(String id, String feedType, String body){
        try{
            if(feedType == 'MAIN'){
                FeedItem feed = new FeedItem();
                feed.Id = id;
                feed.Body = body;
                update feed;
            }
            else if(feedType == 'COMMENT'){
                FeedComment comment = new FeedComment();
                comment.Id = id;
                comment.CommentBody = body;
                update comment;
            }

            return JSON.serialize(new Response('success','Feed record updated successfully !'));

        }catch(Exception e){
            System.debug('deleteFeedRecord error '+e.getMessage());
            return JSON.serialize(new Response('error',e.getMessage()));
        }
    }

    public class FeedWrapper{
        @AuraEnabled public String recordId {get; set;}
        @AuraEnabled public String body {get; set;}
        @AuraEnabled public List<FilesWrapper> attach {get; set;}
    }

    public class FilesWrapper {

        @AuraEnabled public String filename {get; set;}
        @AuraEnabled public String base64 {get; set;}
    }

    public class FeedWithContentVersion{
        @AuraEnabled public FeedItem feed {get; set;}
        @AuraEnabled public List<ContentVersion> attachList {get; set;}
    }

    public class Response{
        public String status;
        public String message;

        public Response(String status, String message){
            this.status = status;
            this.message = message;
        }

        public Response(){}
    }
}