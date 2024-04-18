@isTest
public class Screen3Controller_Test {
    
    @isTest
    static void testUploadFiles() {
        
        Account acc = new Account();
        acc.Name = 'Test';
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
        insert ddSub;
        
        List<P360_Review_Area__c> ddRewList = new List<P360_Review_Area__c>();
        P360_Review_Area__c ddRew = new P360_Review_Area__c();
        ddRew.Name = 'Test';
        ddRew.P360_DD_Sub_Category__c = ddSub.Id;
        ddRew.P360_Review_Point__c = 'test'; 
        ddRewList.add(ddRew);
        insert ddRewList;
        
        List<Screen3Controller.FileDataWP> files = new List<Screen3Controller.FileDataWP>();
        Screen3Controller.FileDataWP file = new Screen3Controller.FileDataWP();
        file.fileName = 'TestFile.txt';
        file.fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        files.add(file);
        String filedata = JSON.serialize(files);
        
        Test.startTest();
        Screen3Controller.uploadFiles(acc.Id, filedata);
        Screen3Controller.updateAccounts(ddRewList);
        Test.stopTest();
    }
    
    @isTest
    public static void getPickListValues_Test(){
        Account acc = new Account(Name = 'Test Object');
        insert acc;
        
        Test.startTest();
        Screen3Controller.getPickListValues(acc, 'Rating');
        Test.stopTest();
    }
}