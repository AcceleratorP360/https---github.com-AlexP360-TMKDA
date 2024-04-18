@isTest
public class P360_ReviewAreaTableController_Test {

    @testSetup
    public Static void setupMethod(){
        
        Account acc = new Account();
        acc.Name = 'Testacc';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;
        
         P360_Due_Diligence__c dueDili = new P360_Due_Diligence__c();
        dueDili.P360_Approval_Status__c = 'In Progress';
        dueDili.P360_Due_Diligence_Type__c = 'Annual';
        dueDili.P360_CoverHolder_TPA_Name__c = acc.Id;
        //dueDili.p360_Planned_Assessment_Start_Date__c =  System.today() + 1;
        //dueDili.P360_DD_Actual_Assessment_End_Date__c =  System.today() + 5;  
        insert dueDili;
        
        
        P360_DD_Category__c cat = new P360_DD_Category__c();
        cat.P360_Due_Diligence_Name__c = dueDili.Id;
        cat.P360_Company_Type__c = 'Coverholder';
        cat.Connect_Copy_Options__c = 'Link';
        cat.P360_Summary_Final_Assessment__c ='Test Summary';
        cat.P360_Completion_Marker__c = 'Completed';
        insert cat;
        
        P360_DD_Sub_Category__c scat = new P360_DD_Sub_Category__c();
        scat.P360_Category_Name__c = cat.Id;
        scat.P360_Completion_Marker__c = 'Completed';
        scat.P360_Due_Diligence_Name__c = dueDili.Id;
        scat.P360_Is_Connection_Enable__c = True;
        scat.P360_Connect_Copy_Options__c = 'Link';
        insert scat;
        
        P360_Review_Area__c rarea = new P360_Review_Area__c();
        rarea.P360_DD_Sub_Category__c = scat.Id;
        rarea.P360_RA_Category__c = cat.Id;
        rarea.Due_Diligence__c = dueDili.Id;
        rarea.Connect_Copy_Options__c = 'Link';
        rarea.TMKDA_Severity__c = 'High';
        rarea.P360_DD_Scope_of_DD_review__c = 'text area';
        rarea.P360_Pass_Fail__c = 'Pass';
        rarea.P360_Comment__c = 'sample comment';
        rarea.TMKDA_Answer__c = 'Yes';
        rarea.P360_Contained_in_Policy__c = 'Yes';
        rarea.P360_Is_Connection_Enable__c = True;
        rarea.P360_Review_Point__c = 'sample review point';
        rarea.P360_Pass_Fail__c = 'Pass';
        rarea.P360_Completion_Marker__c = 'Completed';
        rarea.TMKDA_Primary_Linked__c = 'Yes';
        rarea.TMKDA_Source__c = 'Source';
        insert rarea;
        
    }
    
    @isTest   
    public static void getReviewAreaTest(){
        P360_Due_Diligence__c ddPrimary = [SELECT Id FROM P360_Due_Diligence__c WHERE Id != Null LIMIT 1];
    P360_Review_Area_Table_Controller.getReviewAreas(ddPrimary.id, 1);
        P360_Review_Area_Table_Controller.getPicklistValues('P360_Review_Area__c');
    }
}