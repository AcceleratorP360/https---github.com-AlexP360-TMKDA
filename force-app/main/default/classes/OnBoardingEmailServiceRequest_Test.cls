@isTest
public class OnBoardingEmailServiceRequest_Test {
    
    @isTest
    public static void OnBoarding_Test(){
        
        Contact con = new Contact();
        con.LastName = 'Test';
        con.Email = 'Test@gmail.com';
        insert con;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        // intialize the list string to store emails.
        List<string> emails = new List<string>{'testbandi@gmail.com','testbandi123@gmail.com'};
            List<String> reference = new List<String>();
        reference.add('Test');
        email.subject = 'Create case';
        email.fromAddress = 'Test@gmail.com';
        //assigning the emails to toAddresses 
        email.toAddresses = emails;
        email.plainTextBody = 'email body';
        email.references = reference;
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            OnBoardingEmailServiceRequest  testInbound = new OnBoardingEmailServiceRequest ();
        testInbound.handleInboundEmail(email, env);
    }
    
    @isTest
    public static void OnBoarding_Test_Else(){
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        // intialize the list string to store emails.
        List<string> emails = new List<string>{'testbandi@gmail.com','testbandi123@gmail.com'};
            List<String> reference = new List<String>();
        reference.add('Test');
        email.subject = 'Create case';
        email.fromAddress = 'Test@gmail.com';
        //assigning the emails to toAddresses 
        email.toAddresses = emails;
        email.plainTextBody = 'email body';
        email.references = reference;
        email.fromName = 'Test';
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            OnBoardingEmailServiceRequest  testInbound = new OnBoardingEmailServiceRequest ();
        testInbound.handleInboundEmail(email, env);
    }
}