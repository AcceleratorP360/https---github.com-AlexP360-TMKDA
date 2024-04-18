@isTest
public class P360DA_CustomActivityChatterTabCtrlTest {

    @isTest
    public static void getChatterFeed(){
        Account acc = new Account();
        acc.Name = 'Test Acc';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;
        
        FeedItem testFeedItem = new FeedItem();
        testFeedItem.ParentId = acc.Id;
        testFeedItem.Type = 'LinkPost';
        testFeedItem.Body = 'Test Chatter Feed Item';
        //testFeedItem.CreatedBy = UserInfo.getUserId();
        insert testFeedItem;
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            CommunityNickname = 'testuser' + DateTime.now().getTime(), // Ensure a unique CommunityNickname
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Content',
            VersionData = Blob.valueOf('Test Content Data'),
            PathOnClient = 'testContent.txt',
            IsMajorVersion = true
        );
        insert testContentVersion;
        
        String body = 'yourContentBody';
        Map<String,String> attach = new Map<String,String>();
        attach.put('filename','File1');
        attach.put('base64','test');
        
        Map<String, Object> feed = new Map<String, Object>{
            'recordId' => acc.Id,
            'body' => body,
            'attach' => null
        };
        String serializedFeed = JSON.serialize(feed);
        
        FeedItem parentFeedItem = new FeedItem();
        parentFeedItem.Body = 'Parent Feed Item';
        parentFeedItem.ParentId =  acc.Id;
        insert parentFeedItem;
        
        FeedComment testComment = new FeedComment();
        //testComment.ParentId = acc.Id;  
        testComment.CommentBody = 'Test Comment Body'; 
        testComment.FeedItemId = parentFeedItem.Id;
        insert testComment;  
        
        //FeedComment testComment = new FeedComment();
        
        FeedItem feed11 = new FeedItem();
        feed11.ParentId =  acc.Id;
        feed11.Body = 'Main Feed Body';
        insert feed11;
        
        FeedComment comment22 = new FeedComment();
        comment22.FeedItemId = feed11.Id;
        comment22.CommentBody = 'Comment Body';
        insert comment22;
        String invalidId = 'invalidId';
        
         List<P360DA_CustomActivityChatterTabCtrl.FilesWrapper> filesList = new List<P360DA_CustomActivityChatterTabCtrl.FilesWrapper>();
        P360DA_CustomActivityChatterTabCtrl.FilesWrapper files = new P360DA_CustomActivityChatterTabCtrl.FilesWrapper();
        files.base64 = 'Test File Body';
        files.filename = 'Test.Pdf';
        filesList.add(files);
        
        
        Test.startTest();
        List<P360DA_CustomActivityChatterTabCtrl.FeedWithContentVersion> result = P360DA_CustomActivityChatterTabCtrl.getChatterFeed(acc.Id);
        P360DA_CustomActivityChatterTabCtrl.getContentVersion(testContentVersion.Id);
        P360DA_CustomActivityChatterTabCtrl.createChatterFeed(serializedFeed);
        P360DA_CustomActivityChatterTabCtrl.createFeedComment(serializedFeed);
        String response = P360DA_CustomActivityChatterTabCtrl.deleteFeedRecord(testFeedItem.Id, 'MAIN');
        String response1 = P360DA_CustomActivityChatterTabCtrl.deleteFeedRecord(testComment.Id, 'COMMENT');
        String response2 = P360DA_CustomActivityChatterTabCtrl.deleteFeedRecord('invalidId', 'INVALID_TYPE');
        String result11 = P360DA_CustomActivityChatterTabCtrl.updateFeedRecord(feed11.Id, 'MAIN', feed11.Body);
        String result22 = P360DA_CustomActivityChatterTabCtrl.updateFeedRecord(comment22.Id, 'COMMENT', comment22.CommentBody);
        String result33 = P360DA_CustomActivityChatterTabCtrl.updateFeedRecord(invalidId, 'MAIN', 'Invalid Body');
        P360DA_CustomActivityChatterTabCtrl.uploadFiles(filesList,acc.Id);
        Test.stopTest();
    }
    
}