public class P360DA_CustomActivityTabCtrl {

    public class mainDetail {
        @AuraEnabled public Integer year { get; set; }
        @AuraEnabled public String summary {get;set;}
        @AuraEnabled public String info { get; set; }
        @AuraEnabled public String error { get; set; }
        @AuraEnabled public Boolean hideSection { get; set; }
        @AuraEnabled public List<TaskEventWrapper> Tast_evet_data { get; set; }
    }

    public class TaskEventWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String subject { get; set; }
        @AuraEnabled public DateTime createdDate { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String priority { get; set; }
        @AuraEnabled public Boolean display { get; set; }
        @AuraEnabled public String titleName { get; set; }
        @AuraEnabled public String dateTimeData { get; set; }
        @AuraEnabled public String subtype { get; set; }

        // icone 
        @AuraEnabled public String icone {get;set;}
        @AuraEnabled public String iconeClass {get;set;}
        @AuraEnabled public String className {get;set;}
        @AuraEnabled public String classline {get;set;}

        // event
        @AuraEnabled public String startDate { get; set; }
        @AuraEnabled public String endDate { get; set; }

        // task
        @AuraEnabled public String whatName { get; set; }
        @AuraEnabled public String whoName { get; set; }
        @AuraEnabled public String description { get; set; }

       // email
         //@AuraEnabled public String FromAddress { get; set; }
         //@AuraEnabled public String ToAddress { get; set; }
         //@AuraEnabled public String RelatedToName { get; set; }
         //@AuraEnabled public String TextBody { get; set; }
        

        public TaskEventWrapper(String id, String subject, DateTime createdDate, String status, String priority, String icone) {
            this.id = id;
            this.subject = subject;
            this.createdDate = createdDate;
            this.status = status;
            this.priority = priority;
            this.classline = 'slds-timeline__item_expandable slds-timeline__item_'+icone;
            this.iconeClass = '/_slds/icons/standard-sprite/svg/symbols.svg#'+icone;
            this.icone = icone;
            this.display = false;
            if(icone == 'task')
            {
                this.className = 'slds-icon_container slds-icon-standard-task slds-timeline__icon';
            }
            else if(icone == 'log_a_call')
            {
                this.className = 'slds-icon_container slds-icon-standard-log-a-call slds-timeline__icon';
            }
            else if(icone == 'email')
            {
                this.className = 'slds-icon_container slds-icon-standard-email slds-timeline__icon';
            }
            else if(icone == 'event')
            {
                this.className = 'slds-icon_container slds-icon-standard-event slds-timeline__icon';
            }
        }
    }

    @TestVisible
   private class CreatedDateComparator implements Comparator<TaskEventWrapper> 
    {
        public Integer compare(TaskEventWrapper a, TaskEventWrapper b) {
            // Compare Long values directly in descending order
            return b.createdDate.getTime() > a.createdDate.getTime() ? 1 : 
                b.createdDate.getTime() < a.createdDate.getTime() ? -1 : 0;
        }
    }

    @AuraEnabled
    public static String deleteRec(String recId,String recName) {
        try {
            if(recName == 'Task'){
                Task existingTask = [SELECT Id FROM Task WHERE Id = :recId LIMIT 1];

                if (existingTask != null) {
                    delete existingTask;
                    return 'isDeleted';
                } else {
                    return 'Note not found';
                }
            }else{
                Event existingEvent = [SELECT Id FROM Event WHERE Id = :recId LIMIT 1];

                if (existingEvent != null) {
                    delete existingEvent;
                    return 'isDeleted';
                } else {
                    return 'Note not found';
                }
            }
            
        } catch (Exception e) {
            System.debug('Line Number : ' + e.getLineNumber() + 'Message : ' + e.getMessage());
            return null;
        }
    }


    @AuraEnabled(cacheable=false)
    public static list<mainDetail> getTasksAndEvents(String accountId) {
        Map<String, List<TaskEventWrapper>> monthTaskEventMap = new Map<String, List<TaskEventWrapper>>();
        list<mainDetail> md = new list<mainDetail>();

        // Query for tasks
        List<Task> tasks = [SELECT Id,AccountId,Subject,WhoId,Who.Name,what.Name,CreatedDate,Description,TaskSubtype, Status,ActivityDate, Priority FROM task WHERE whatId = :accountId  AND TaskSubtype !='Email'];
        System.debug('===tasks====='+tasks);
        // Query for events
        List<Event> events = [SELECT Id,AccountId,Subject,WhoId, CreatedDate,StartDateTime,EndDateTime,Description,EventSubtype,Location FROM event WHERE  whatId = :accountId];
        System.debug('===events====='+events);


        /*list<Account> ls = [select Id,Name,(select Id,Name from opportunities) from account where id = :accountId];
        set<Id> opId = new set<Id>();

        for(Opportunity p : ls[0].Opportunities)
        {
            opId.add(p.Id);
        }

        List<EmailMessage> emails = new List<EmailMessage>();
        List<EmailMessage> emailsAcc = [SELECT Id, Subject,FromAddress,ToAddress,RelatedTo.Name,TextBody,HtmlBody, MessageDate FROM EmailMessage WHERE RelatedToId =: accountId];
        List<EmailMessage> emailsOpp = [SELECT Id, Subject,FromAddress,ToAddress,RelatedTo.Name,TextBody,HtmlBody, MessageDate FROM EmailMessage WHERE RelatedToId IN : opId];
        emails.addAll(emailsAcc);
        emails.addAll(emailsOpp);*/

     
        // Iterate through tasks and add to the map based on the month
        for (Task taskRecord : tasks) {
            addTaskEventToMap(monthTaskEventMap, taskRecord.CreatedDate, taskRecord);
        }

        // Iterate through events and add to the map based on the month
        for (Event eventRecord : events) {
            addTaskEventToMap(monthTaskEventMap, eventRecord.StartDateTime , eventRecord);
        }

        // Iterate through emails and add to the map based on the month
        /*for (EmailMessage emailRecord : emails) {
            addTaskEventToMap(monthTaskEventMap, emailRecord.MessageDate,emailRecord);
        }*/

       // system.debug('first =='+JSON.serialize(monthTaskEventMap));
        // Sort the lists in each month based on createdDate
        for (String month : monthTaskEventMap.keySet()) {
            monthTaskEventMap.get(month).sort(new CreatedDateComparator());
        }
        system.debug('last =='+JSON.serialize(monthTaskEventMap));
       
        for(String key : monthTaskEventMap.keyset())
        {
            system.debug('=====key======'+key);
             mainDetail objMD = new mainDetail();
             list<TaskEventWrapper> tedls = new list<TaskEventWrapper>();
             if(key == 'Upcoming & Overdue')
             {
                objMD.summary = key;
                for(TaskEventWrapper tsd :  monthTaskEventMap.get(key))
                {
                    if(tsd.icone == 'log_a_call')
                    {
                         tsd.titleName = 'You have an upcoming call';
                    }
                    else{
                          tsd.titleName = 'You have an upcoming '+tsd.icone;
                    }
                  
                    tedls.add(tsd);
                }
                
             }
             else{
                objMD.summary = key;
                objMD.year = Integer.valueOf(monthTaskEventMap.get(key)[0].createdDate.year());
                objMD.info = calculateInfo(monthTaskEventMap.get(key)[0].createdDate);
                for(TaskEventWrapper tsd :  monthTaskEventMap.get(key))
                {
                     if(tsd.icone == 'log_a_call')
                    {
                         tsd.titleName = 'You logged a call';
                    }
                    else{
                        tsd.titleName = 'You have an '+tsd.icone;
                    }
                  
                    tedls.add(tsd);
                }
             }
            objMD.Tast_evet_data = tedls;
            objMD.hideSection = true;

    
             md.add(objMD);

        }

        // sort list 

        List<mainDetail> upcomingAndOverdue = new List<mainDetail>();
        List<mainDetail> otherSummaries = new List<mainDetail>();

        // Separate upcoming & overdue summaries from others
        for (mainDetail m : md) {
            if (m.summary == 'Upcoming & Overdue') {
                upcomingAndOverdue.add(m);
            } else {
                otherSummaries.add(m);
            }
        }
		
       
        system.debug('md=wwww= otherSummaries=='+JSON.serialize(otherSummaries));    

        for(Integer i=0;i<otherSummaries.size();i++)
        {
            for(Integer j=i+1;j<otherSummaries.size();j++)
            {
                if(otherSummaries[i].year < otherSummaries[j].year)
                {
                    mainDetail temp = new mainDetail();
                    temp = otherSummaries[i];
                    otherSummaries[i] = otherSummaries[j];
                    otherSummaries[j] = temp; 
                }
            }
        }
        system.debug('=================sort======= otherSummaries=='+JSON.serialize(otherSummaries));
        
         // add upcomming 
        if(upcomingAndOverdue.isEmpty())
        {
             mainDetail objMD = new mainDetail();
             objMD.summary = 'Upcoming & Overdue';
             objMd.error = 'No activities to show. Get started by sending an email, scheduling a task, and more.';
              objMD.hideSection = true;
             upcomingAndOverdue.add(objMd);
        }
        if(otherSummaries.isEmpty())
        {
             mainDetail objMD = new mainDetail();
             objMd.error = 'No past activity. Past meetings and tasks marked as done show up here.';
              objMD.hideSection = false;
             otherSummaries.add(objMd);
		}
        
        if(!upcomingAndOverdue.isEmpty())
        {
              otherSummaries.add(0,upcomingAndOverdue[0]);
        }
		
      
       system.debug('md== otherSummaries=='+JSON.serialize(otherSummaries));
       return otherSummaries;
    }

    @TestVisible
    private static String calculateInfo(DateTime createdDate) {
        DateTime currentDate = Datetime.now();
        Integer yearsDifference = currentDate.year() - createdDate.year();
        Integer monthsDifference = 12 * yearsDifference + currentDate.month() - createdDate.month();

        if (yearsDifference == 0 && monthsDifference == 0) {
            return 'This Month';
        } else if (yearsDifference == 0 && monthsDifference == 1) {
            return 'Last Month';
        } else if (yearsDifference == 0 && monthsDifference > 1 && monthsDifference <= 12) {
             if(yearsDifference == 1)
            {
                return 'Last Month';
            }
            else
            {
                 return monthsDifference + ' Months Ago';
            }
           
        } else if (yearsDifference == 1 && currentDate.month() == createdDate.month()) {
            return 'Last Year';
        } else {
            if(yearsDifference == 1)
            {
                 return 'Last Year';
            }
            else
            {
                 return yearsDifference + ' Years Ago';
            }
           
        }
    }


    @TestVisible
    private static String getDatetime(Datetime d)
    {
          if (d == null) {
            return '';  // or any other default value
        }

       
         String inputDateTimeString = String.valueOf(d);
                
        // Parse the date and time parts
        List<String> dateTimeParts = inputDateTimeString.split(' ');
        String dateString = (dateTimeParts.size() > 0) ? dateTimeParts[0] : '';
        String timeString = (dateTimeParts.size() > 1) ? dateTimeParts[1] : '00:00:00';

        // Create a Datetime instance
        Datetime inputDateTime = Datetime.newInstanceGmt(
            (dateString.split('-').size() > 0) ? Integer.valueOf(dateString.split('-')[0]) : 0,
            (dateString.split('-').size() > 1) ? Integer.valueOf(dateString.split('-')[1]) : 0,
            (dateString.split('-').size() > 2) ? Integer.valueOf(dateString.split('-')[2]) : 0,
            (timeString.split(':').size() > 0) ? Integer.valueOf(timeString.split(':')[0]) : 0,
            (timeString.split(':').size() > 1) ? Integer.valueOf(timeString.split(':')[1]) : 0,
            (timeString.split(':').size() > 2) ? Integer.valueOf(timeString.split(':')[2]) : 0
        );

        String formattedDateTime = inputDateTime.format('h:mm a | MMM d, yyyy', 'GMT');
        System.debug('Formatted DateTime: ' + formattedDateTime);

        return formattedDateTime;
    }

    @TestVisible
    private static void addTaskEventToMap(Map<String, List<TaskEventWrapper>> monthTaskEventMap, Datetime DateEvent_Tast , SObject record) 
    {
		
        String year = DateEvent_Tast.format('YYYY');
        String monthKey = DateEvent_Tast.format('MMMM');
        DateTime currentDate = Datetime.now();
        system.debug('======currentDate===='+currentDate);
        system.debug('======DateEvent_Tast===='+DateEvent_Tast);
        Integer yearc = currentDate.year();
        Integer monthc = currentDate.month();
        String key = '';
        Boolean f = false;
        
       
       // Populate other properties based on the record type
       TaskEventWrapper e;
        if (record instanceof Task) {
            System.debug('task-------------');
            Task taskRecord = (Task) record;
            String icone;
            if(taskRecord.Status != 'Completed')
            {
                f = true;
            }

            if(taskRecord.TaskSubtype == 'call')
            {
                icone = 'log_a_call';
            }
            if(taskRecord.TaskSubtype == 'Task')
            {
                icone = 'task';
            }

            e = new TaskEventWrapper( taskRecord.Id,taskRecord.Subject,taskRecord.CreatedDate,taskRecord.Status,taskRecord.Priority,icone);
            e.description = String.valueOf(taskRecord.Description);
            e.whatName = taskRecord.what.Name;
            e.whoName = taskRecord.who.Name;
            System.debug('Activity date==='+taskRecord.ActivityDate);
            System.debug('created date==='+taskRecord.CreatedDate);
            if(taskRecord.ActivityDate != null)
            {
               
                DateTime activityDateTime = DateTime.newInstance(taskRecord.ActivityDate, Time.newInstance(0, 0, 0, 0));
                System.debug('ActivityDate date time date==='+activityDateTime);
                e.dateTimeData = getDatetime(Datetime.valueOf(activityDateTime));
            }
           
            e.titleName = 'You had a task';
            e.subtype = taskRecord.TaskSubtype;
            // if(icone == 'log_a_call')
            // {
            //     e.titleName = 'You logged a call with <a href="#">'+taskRecord.who.Name+'</a>';
            // }
            // else if(icone == 'task')
            // {
            //     e.titleName = 'You had a task about <a href="#">'+taskRecord.what.Name+'</a>';
            // }
        } else if (record instanceof Event) {
                System.debug('Event-------------');
                Event eventRecord = (Event) record;
                e = new TaskEventWrapper( eventRecord.Id,eventRecord.Subject,eventRecord.StartDateTime,null,null,'event');
                e.startDate = eventRecord.StartDateTime.format('dd/MM/yyyy, hh:mm a');
                e.endDate = eventRecord.EndDateTime.format('dd/MM/yyyy, hh:mm a');
                e.description = eventRecord.Description;
                e.titleName = 'You had a event';
                if(eventRecord.StartDateTime != null)
                {
                 e.dateTimeData = getDatetime(eventRecord.StartDateTime);
                }
                e.subtype = eventRecord.EventSubtype;
        }/* else if (record instanceof EmailMessage) {
            EmailMessage emailRecord = (EmailMessage) record;
            e = new TaskEventWrapper(emailRecord.Id, emailRecord.Subject,emailRecord.MessageDate,null,null,'email');
            e.FromAddress = emailRecord.FromAddress;
            e.ToAddress = emailRecord.ToAddress;
            e.RelatedToName = emailRecord.RelatedTo.Name;
            e.TextBody = emailRecord.TextBody;
            e.titleName = 'You had a email';
            e.dateTimeData = getDatetime(emailRecord.MessageDate);
        }*/

        if(!f)
        {
            if(currentDate >= DateEvent_Tast)
            {
               key = monthkey+'.'+year;
            }
            else
             {
                key = 'Upcoming & Overdue';
            }
        }
        else 
        {
            key = 'Upcoming & Overdue';
        }

       
       
        if (!monthTaskEventMap.containsKey(key)) {
             monthTaskEventMap.put(key, new List<TaskEventWrapper>());
        }
        monthTaskEventMap.get(key).add(e);

    }


    @AuraEnabled(cacheable=false)
    public static list<Map<String,String>> fetchvalue(String objectName,String fieldName)
    {
        
        list<Map<String,String>> picklistvalues = new list<Map<String,String>>();
        // String objectName = 'Task';
        // String fieldName ='Subject';
            
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe() ;
        Map<String,Schema.SObjectField> fields = objDescribeSobject.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            Map<String,String> m = new  Map<String,String>();

            m.put('label',String.valueOf(pickListVal.getLabel()));
            m.put('value',String.valueOf(pickListVal.getValue()));

            picklistvalues.add(m);
        }
            
        system.debug('value---'+picklistvalues);
     
        return picklistvalues;
    }


    @AuraEnabled
    public static String createCall(Task obj)
    {
        try
        {
             insert obj;
             return String.valueOf(obj.Id);
        }
        catch(Exception e){
           return e.getMessage();
        }
        
    }

    @AuraEnabled
    public static String createEventData(Event objc)
    {
        try{
            insert objc;
            return String.valueOf(objc.Id);
        }
        catch(Exception e){
           return e.getMessage();
        }
    }


    @AuraEnabled(cacheable=true)
    public static userWapper userinfo()
    {
        String userId = UserInfo.getUserId();
        String username = UserInfo.getName();
        userWapper u = new userWapper();
        u.userId = userId;
        u.username = username;
        return u;
    }

    public class userWapper
    {
       @AuraEnabled public String userId{get;set;}
       @AuraEnabled public String username{get;set;}
    }
    
}