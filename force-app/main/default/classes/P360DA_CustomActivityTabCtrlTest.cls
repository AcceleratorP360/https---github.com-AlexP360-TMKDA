@isTest
public class P360DA_CustomActivityTabCtrlTest {
    
    @isTest
    public static void getTasksAndEvents(){
        Account acc = new Account();
        acc.Name = 'Test for Acc';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;
        
         Event testEvent = new Event(
            Subject = 'Test Event',
            WhatId = acc.Id,
            StartDateTime = Datetime.now(),
            EndDateTime = Datetime.now().addHours(1)
        );
        insert testEvent;
        
        DateTime createdDate = DateTime.now().addDays(-10);
         
        Map<String, List<P360DA_CustomActivityTabCtrl.TaskEventWrapper>> monthTaskEventMap = new Map<String, List<P360DA_CustomActivityTabCtrl.TaskEventWrapper>>();
       
        
        Test.startTest();
        List<P360DA_CustomActivityTabCtrl.mainDetail> result = P360DA_CustomActivityTabCtrl.getTasksAndEvents(acc.Id);
        P360DA_CustomActivityTabCtrl.calculateInfo(createdDate);
        P360DA_CustomActivityTabCtrl.getDatetime(createdDate);
        P360DA_CustomActivityTabCtrl.fetchvalue('Task','Subject');
        //P360DA_CustomActivityTabCtrl.addTaskEventToMap(monthTaskEventMap,task.ActivityDate,task);
        P360DA_CustomActivityTabCtrl.createEventData(testEvent);
        P360DA_CustomActivityTabCtrl.userWapper result1 = P360DA_CustomActivityTabCtrl.userinfo();
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void getTasksAndEvents2(){
        Account acc = new Account();
        acc.Name = 'Test for Acc';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;
        
        Task task = new Task();
        task.Description = 'Test 1';
        task.Status = 'Not Started';
        task.Priority = 'Normal';
        task.TaskSubtype = 'Task';
        task.Status = 'Open';
        task.ActivityDate = Date.today().addDays(30);
        task.WhatId = acc.Id;
        insert task;
        
       
        
        DateTime createdDate = DateTime.now().addDays(-10);
         
        Map<String, List<P360DA_CustomActivityTabCtrl.TaskEventWrapper>> monthTaskEventMap = new Map<String, List<P360DA_CustomActivityTabCtrl.TaskEventWrapper>>();
       
        
        Test.startTest();
        List<P360DA_CustomActivityTabCtrl.mainDetail> result = P360DA_CustomActivityTabCtrl.getTasksAndEvents(acc.Id);
        P360DA_CustomActivityTabCtrl.calculateInfo(createdDate);
        P360DA_CustomActivityTabCtrl.getDatetime(createdDate);
        P360DA_CustomActivityTabCtrl.fetchvalue('Task','Subject');
        //P360DA_CustomActivityTabCtrl.addTaskEventToMap(monthTaskEventMap,task.ActivityDate,task);
        P360DA_CustomActivityTabCtrl.createCall(task);
        P360DA_CustomActivityTabCtrl.userWapper result1 = P360DA_CustomActivityTabCtrl.userinfo();
        Test.stopTest();
        
    }
    
    
   
}