@isTest
public class InboundEmailService_Test {
    
    @isTest
    public static void handleInboundEmail_Test(){
        
        EmailMessage msg = new EmailMessage();
        msg.Subject = 'Test';
        msg.Status = '0';
       // msg.RelatedToId = accRecrd.Id;
        msg.FromAddress = 'test@gmail.com';
        msg.ToAddress = 'test@gmail.com';
        msg.P360_Email_Tags__c = 'Approval Email;Relates To Claims';
        msg.MessageDate = system.today();
        msg.MessageIdentifier = 'Test';
        insert msg;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        // intialize the list string to store emails.
        List<string> emails = new List<string>{'testbandi@gmail.com','testbandi123@gmail.com'};
            List<String> reference = new List<String>();
        reference.add('Test');
            email.subject = 'Create case';
        email.fromAddress = 'someaddress@email.com';
        //assigning the emails to toAddresses 
        email.toAddresses = emails;
        email.plainTextBody = 'email body';
        email.references = reference;
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            InboundEmailService  testInbound=new InboundEmailService ();
        testInbound.handleInboundEmail(email, env);
    }
}