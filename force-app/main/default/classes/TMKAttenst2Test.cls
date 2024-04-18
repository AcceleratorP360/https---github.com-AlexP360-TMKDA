@isTest
private class TMKAttenst2Test {

    // Testing the insertCustomer method
    @isTest
    static void testInsertCustomer() {
      
    TMKDA_DD_Attestation_Scoping__c testCustomer = new TMKDA_DD_Attestation_Scoping__c();
   
      testCustomer.TMKDA_Review_Scope__c = 'Live';
      testCustomer.TMKDA_PDT_Outcome__c = 'BPA required. 1 year audit cycle';
       testCustomer.Name ='abc';  
      testCustomer.TMKDA_Is_Whistleblowing_in_Scope__c = 'Yes';
      testCustomer.TMKDA_Is_IDD_in_scope__c = 'Yes';
  
          
insert testCustomer;

TMKAttenst2 controller = new TMKAttenst2();

controller.att = 'yes'; 
controller.att2 = 'yes'; 
controller.att3 = 'yes';
controller.att4 = 'yes'; 
controller.att5 = 'yes'; 
controller.att6 = 'yes'; 
controller.att7 = 'yes'; 
controller.att8 = 'yes'; 
controller.att9 = 'yes'; 
controller.att10 = 'yes'; 
controller.att11 = 'yes'; 
controller.att12 = 'yes'; 
controller.att13 = 'yes'; 
controller.att14 = 'yes'; 
controller.att15 = 'yes'; 
controller.att16 = 'yes'; 
controller.att17 = 'yes'; 
controller.att18 = 'yes'; 
controller.att19 = 'yes'; 
controller.att20 = 'yes'; 
controller.att21 = 'yes'; 
controller.att22 = 'yes'; 
controller.att23 = 'yes'; 
controller.att24 = 'yes'; 
controller.att25 = 'yes'; 
controller.att26 = 'yes'; 
controller.att27 = 'yes'; 
controller.att28 = 'yes'; 
controller.att29 = 'yes'; 
controller.att30 = 'yes'; 
controller.att31 = 'yes'; 
controller.att32 = 'yes'; 
controller.att33 = 'yes'; 
controller.att34 = 'yes'; 
controller.att35 = 'yes'; 
controller.att36 = 'yes'; 
controller.att37 = 'yes'; 
controller.att38 = 'yes'; 
controller.att39 = 'yes'; 
        
  TMKDA_DD_Attestation_Form__c testme = new TMKDA_DD_Attestation_Form__c();
        
 
        

        PageReference pageRef = Page.AttestationScoping; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testCustomer.Id);

        Test.startTest();
        PageReference result = controller.insertCustomer();
        Test.stopTest();
  
     }
    
  

    
}