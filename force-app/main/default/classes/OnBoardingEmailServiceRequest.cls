global with sharing class OnBoardingEmailServiceRequest implements Messaging.InboundEmailHandler{
    public OnBoardingEmailServiceRequest() {
        
    }
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        List<Contact> conList = [ Select Id, Email FROM Contact WHERE Email =: email.FromAddress Order by createddate DESC LIMIT 1 ];
        
        if(!conList.isEmpty()){
            createEmailMessage(email, conList[0].Id, 'Contact found with same email');
        }else if(conList.isEmpty()){
            Contact conRecrd = new Contact();
            conRecrd.LastName = email.fromName;
            conRecrd.Email = email.fromAddress;
            insert conRecrd;
            createEmailMessage(email, conRecrd.Id, 'New contact record created');
        }
        result.success = true;
        return result;
    }
    
    public Static void createEmailMessage(Messaging.InboundEmail email, String contactId, String contactRecrd){
        Group queue = [ Select Id, Name from Group where Type = 'Queue' AND DeveloperNAME = 'DA_Coordination_Team' ];
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.Status = '0';
        emailMessage.FromAddress = email.FromAddress;
        emailMessage.Incoming = true;
        emailMessage.MessageIdentifier = email.inReplyTo;
        // emailMessage.P360_Assign_To__c = queue.Id;
        if(email.toAddresses.size() > 0){
            emailMessage.ToAddress = String.join( email.toAddresses, ';' );
        }
        
        if(email.ccAddresses != null && email.ccAddresses.size() > 0){
            emailMessage.CcAddress = String.join( email.ccAddresses, ';' );
        }
        emailMessage.FromName = email.FromName; 
        emailMessage.Subject = email.Subject; 
        emailMessage.TextBody = email.plainTextBody; 
        // emailMessage.RelatedToId = conRecrd.Id; 
        String[] toIds = new String[]{contactId}; 
            emailMessage.toIds = toIds;
        emailMessageList.add(emailMessage);
        
        if(!emailMessageList.isEmpty()){
            insert emailMessageList;
        }
        
        List<EmailMessageRelation> emRelationList = new List<EmailMessageRelation>();
        for(EmailMessage em : emailMessageList){
            EmailMessageRelation emr = new EmailMessageRelation();  
            emr.emailMessageId = em.Id;  
            emr.relationId = contactId;  
            emr.relationType = 'FromAddress'; 
            emRelationList.add(emr);
        }
        
        if(!emRelationList.isEmpty()){
            insert emRelationList;
        }
        
        List < Attachment > attachmentList = new List < Attachment > ();
        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
            for (EmailMessage emg : emailMessageList) {
                for (integer i = 0; i < email.binaryAttachments.size(); i++) {
                    Attachment attachment = new Attachment();
                    attachment.ParentId = emg.Id;
                    attachment.Name = email.binaryAttachments[i].filename;
                    attachment.Body = email.binaryAttachments[i].body;
                    attachmentList.add(attachment);
                }
            }
            
            if (!attachmentList.isEmpty()) {
                insert attachmentList;
            }
        }
        
        
        if(String.isNotEmpty(email.Subject)  && String.isNotEmpty(email.plainTextBody) && String.isNotBlank(email.plainTextBody) && String.isNotBlank(email.Subject)){
            List<Task> taskList = new List<Task>();
            Task task = new Task();
            task.Subject = email.subject;
            // task.WhatId = diligence.Id;
            task.WhoId = contactId;
            task.P360_Task_Type__c = 'CH - Initiate onboarding'; //Added by Deepika
            task.OwnerId = UserInfo.getUserId();
            task.ActivityDate = System.today() + 1;
            taskList.add(task);
            task.Description = 'Email received from '+ email.FromName + ' On ' + String.valueOf(System.today()) + '. Please review and action on the email to create the shell record and relate it to the shell record. ' + contactRecrd;
            if(!taskList.isEmpty()){
                insert taskList;   
            }
            
            task.OwnerId = queue.Id;
            update task;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //   String[] toAddresses = new String[] {'srikanth.cheera@processthreesixty.com'};
        String[] toAddresses = new String[] {'processthreesixty360@outlook.com'}; 
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName(queue.Name);
        mail.setSubject(email.subject);
        mail.setPlainTextBody(email.plainTextBody);
        
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        for (Attachment file: attachmentList) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(file.Name);
            efa.setBody(file.Body);
            efa.setContentType(file.ContentType);
            attachments.add(efa);
        }
        mail.setFileAttachments(attachments);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}