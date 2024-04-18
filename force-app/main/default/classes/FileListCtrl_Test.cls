@isTest
public class FileListCtrl_Test {
    
    @isTest
    public Static void getFiles_Test(){
        
        Account acc = new Account();
        acc.Name = 'Test';
        acc.TMKDA_Lloyd_s_Syndicate_510__c  = true;
        insert acc;
        
        P360_Due_Diligence__c dd = new P360_Due_Diligence__c();
        dd.Name = 'Test';
        dd.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert dd;
        
        P360_DD_Category__c ddCat = new P360_DD_Category__c();
        ddCat.Name = 'Test';
        ddCat.P360_Due_Diligence_Name__c = dd.Id;
        insert ddCat;
        
        P360_DD_Sub_Category__c ddSub = new P360_DD_Sub_Category__c();
        ddSub.Name = 'Test';
        ddSub.P360_Category_Name__c = ddCat.Id;
        ddSub.P360_Due_Diligence_Name__c = dd.Id;
        insert ddSub;
        
        P360_Review_Area__c ddRew = new P360_Review_Area__c();
        ddRew.Name = 'Test';
        ddRew.P360_DD_Sub_Category__c = ddSub.Id;
        ddRew.P360_Review_Point__c = 'test'; 
        ddRew.Due_Diligence__c = dd.Id;
        insert ddRew;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=acc.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;

        ContentVersion content_DD=new ContentVersion(); 
        content_DD.Title='Header_Picture1'; 
        content_DD.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob1 = Blob.valueOf('Unit Test ContentVersion Body'); 
        content_DD.VersionData = bodyBlob1; 
        //content.LinkedEntityId=sub.id;
        content_DD.origin = 'H';
        insert content_DD;
        
        ContentDocumentLink contentlink_DD = new ContentDocumentLink();
        contentlink_DD.LinkedEntityId = dd.id;
        contentlink_DD.contentdocumentid=[select contentdocumentid from contentversion where id =: content_DD.id].contentdocumentid;
        contentlink_DD.ShareType = 'I';
        contentlink_DD.Visibility = 'AllUsers'; 
        insert contentlink_DD;
        
        FileListCtrl.getFiles(acc.Id);
        DD_FileListCtrl.getFiles(dd.Id);
    }
}