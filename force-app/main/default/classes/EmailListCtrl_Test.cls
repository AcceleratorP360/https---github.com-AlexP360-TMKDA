@isTest
public class EmailListCtrl_Test {
    
    @isTest
    public static void createEmail_Deleted(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '0';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, date.valueOf(msg.MessageDate), date.valueOf(msg.MessageDate), 
                                      false, '001', true, msg.P360_Email_Tags__c, 'Test', false, true);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '0';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.P360_Actioned__c = false;
        msg.Incoming = true;
        msg.MessageDate = system.today() - 2;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Else_1(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '0';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email';
        msg.P360_Actioned__c = false;
        msg.Incoming = true;
        msg.MessageDate = system.today() - 2;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Else_2(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '0';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = '';
        msg.P360_Actioned__c = false;
        msg.Incoming = true;
        msg.MessageDate = system.today() - 2;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Read(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '1';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        msg.Incoming = true;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Read_Else_1(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '1';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email';
        msg.MessageDate = system.today();
        msg.Incoming = true;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Read_Else_2(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '1';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = '';
        msg.MessageDate = system.today();
        msg.Incoming = true;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Replied(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '2';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        msg.Incoming = true;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Replied_Else_1(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '2';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email';
        msg.MessageDate = system.today();
        msg.Incoming = true;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Replied_Else_2(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '2';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = '';
        msg.MessageDate = system.today();
        msg.Incoming = true;
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Sent(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '3';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);       
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Sent_Else_1(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '3';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);       
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Sent_Else_2(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '3';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);       
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Forwarded(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '4';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Forwarded_Else_1(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '4';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    @isTest
    public static void createEmail_Forwarded_Else_2(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '4';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = '';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
        
    }
    
    @isTest
    public static void createEmail_Draft(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '5';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);  
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Draft_Else_1(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '5';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);  
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Draft_Else_2(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '5';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = '';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);  
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Draft_Else(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '5';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), null, '001', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);  
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Draft_Else_Else(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '5';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), null, '', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);  
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
    
    @isTest
    public static void createEmail_Draft_Else_Else_Else(){
        
        Account accRecrd = new Account();
        accRecrd.Name = 'Test';
        insert accRecrd;
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '5';
        msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        insert msg;
        
        EmailListCtrl.incoming_Emails(msg.status, msg.subject, msg.fromAddress, msg.toAddress, System.today() - 1, System.today(), false, '', false, 
                                      msg.P360_Email_Tags__c, 'Test', msg.P360_Actioned__c, msg.Incoming);  
        EmailListCtrl.getObjAPI('001');
        EmailListCtrl.getPicklistValues('EmailMessage', 'P360_Email_Tags__c');
        EmailListCtrl.findObjectNameFromRecordIdPrefix(msg.status, false, msg.P360_Actioned__c);
    }
}