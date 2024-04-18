global with sharing class InboundEmailService implements Messaging.InboundEmailHandler {
    public InboundEmailService() {}

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
        Messaging.InboundEmailResult emailResult = new Messaging.InboundEmailResult();
System.debug('email==>>>'+email.plainTextBody);
        try {
            EmailMessage eMsgIndentifier = [SELECT Id,
                RelatedToId FROM EmailMessage WHERE MessageIdentifier =: email.references LIMIT 1
            ];

            Group queue = [Select Id from Group where Type = 'Queue'
                AND DeveloperNAME = 'P360_DA_Advisory_Queue'
            ];

            List < EmailMessage > emailList = new List < EmailMessage > ();
            List < Task > taskList = new List < Task > ();
            EmailMessage emailMessage = new EmailMessage();
            emailMessage.Status = '2';
            emailMessage.FromAddress = email.FromAddress;
            emailMessage.Incoming = true;
            emailMessage.MessageIdentifier = email.inReplyTo;
            if (email.toAddresses.size() > 0) {
                emailMessage.ToAddress = String.join(email.toAddresses, ';');
            }

            if (email.ccAddresses != null && email.ccAddresses.size() > 0) {
                emailMessage.CcAddress = String.join(email.ccAddresses, ';');
            }
            emailMessage.FromName = email.FromName;
            emailMessage.Subject = email.Subject;
            emailMessage.TextBody = email.plainTextBody;
            emailMessage.RelatedToId = eMsgIndentifier.RelatedToId;
            emailList.add(emailMessage);

            Task task = new Task();
            task.Subject = email.subject;
            task.WhatId = eMsgIndentifier.RelatedToId;
            //  task.WhoId = diligence.P360_CoverHolder_TPA_Name__r.Id;
            task.OwnerId = queue.Id;
            task.ActivityDate = System.today() + 1;
            task.Description = 'Email received from ' + email.FromName + ' On ' + String.valueOf(System.today()) + ' please review and action on the email';
            taskList.add(task);

            if (!emailList.isEmpty()) {
                insert emailList;
            }

            if (!taskList.isEmpty()) {
                insert taskList;
            }

            List < Attachment > attachmentList = new List < Attachment > ();
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                for (EmailMessage emg : emailList) {
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
        } catch (Exception e) {}

        return emailResult;
    }
}