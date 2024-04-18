public class GenerateAttestation {

    public Account account {set;get;}
  //  public string totalAmount {set;get;}   
    public string generateddate {get;set;}
    
    public GenerateAttestation(ApexPages.StandardController standardPageController){
        DateTime d = Date.Today() ;
        String dateStr =  d.format('dd/MM/yyyy') ;

        this.generatedDate = dateStr; 
        
        account = [SELECT id, Name,P360_Lloyd_PIN__c,P360_Sponsoring_Service_Provider_MGA__r.Name,RecordTypeId,	RecordTypeName__c,
                          P360_Sponsoring_Broker__r.Name,P360_Europe_Syndicate_Number__c,P360_Attestation_Type__c,
                          TMKDA_Syndicate_Number__c,P360_Syndicate_Number__c,TMKDA_Type_of_change_to_Permission__c,
                   		  TMKDA_Key_Broker_Contact__c,TMKDA_Key_Broker_Contact__r.Name,P360_DA_UnderWriter_Name__c, P360_DA_UnderWriter_Name__r.Name
                   FROM Account
                   WHERE Id =: standardPageController.getRecord().Id];
    }
    
}