@RestResource(urlMapping = '/partyEntityId/*')
global class GetParty_RestResource {
    
    @HttpPost
    global Static List<PartyWrapper> getParty(List < String > entityId) {
        
        List < P360_Due_Diligence__c > accList = [
            SELECT
            P360_CoverHolder_TPA_Name__r.Coverholder_Id__c,
            P360_CoverHolder_TPA_Name__r.Name,
            P360_CoverHolder_TPA_Name__r.RecordType.Name,
            
            P360_Date_of_Lloyd_s_Approval__c,
            P360_Cyber_Security_Contact_Name__c,
            P360_Cyber_Security_Contact_Email_Add__c,
            P360_Doe_your_org_have_an_InfoSec_policy__c,
            P360_InfoSec_Policy_Comments__c,
            P360_Is_there_a_security_lead__c,
            P360_Security_Lead_Comments__c,
            P360_Vulnerability_management__c,
            P360_Vulnerability_management_Comments__c,
            P360_Third_party_security_standards__c,
            P360_Third_Party_Sec_Standards_Comments__c,
            P360_Internet_MFA_enforced__c,
            P360_Internet_MFA_enforced_Comments__c,
            P360_Anti_malware_protection__c,
            P360_Anti_Malware_Protection_Comments__c,
            P360_Mobile_data_control__c,
            P360_Mobile_Data_Control_Comments__c,
            P360_Restricted_admin_privileges__c,
            P360_Restricted_Admin_Privilege_Comments__c,
            P360_Data_encryption_practices__c,
            P360_Data_Encryption_Practices_Comments__c,
            P360_Ongoing_security_training__c,
            P360_Ongoing_Security_Training_Comments__c,
            P360_Systems_monitoring__c,
            P360_Systems_Monitoring_Comments__c,
            P360_Incident_management_process__c,
            P360_Incident_Management_Pro_Comments__c,
            P360_Cybersecurity_insurance__c,
            P360_Cybersecurity_Insurance_Comments__c,
            P360_No_data_breaches_in_3_years__c,
            P360_No_Data_Breache_in_3_Years_Comments__c,
            P360_Business_continuity_plan__c,
            P360_Business_Continuity_Plan_Comments__c,
            P360_Disaster_recovery_plan__c,
            P360_Disaster_Recovery_Plan_Comments__c,
            P360_Security_certifications__c,
            P360_Security_Certifications_Comments__c
            FROM P360_Due_Diligence__c WHERE P360_CoverHolder_TPA_Name__r.Coverholder_Id__c =: entityId
        ];
        
        List<PartyWrapper> pWrapList = new List<PartyWrapper>();
        for(P360_Due_Diligence__c ddRecrd : accList){
            List<Map<String, String>> questionsList = new List<Map<String, String>>();
            PartyWrapper pwrap = new PartyWrapper();
            pWrap.EntityUniqueId = ddRecrd.P360_CoverHolder_TPA_Name__r.Coverholder_Id__c;
            pWrap.EntityName = ddRecrd.P360_CoverHolder_TPA_Name__r.Name;
            pWrap.EntityType = ddRecrd.P360_CoverHolder_TPA_Name__r.RecordType.Name;
            if(ddRecrd.P360_Date_of_Lloyd_s_Approval__c <> NULL){
                pWrap.CompletionTimeStamp = ddRecrd.P360_Date_of_Lloyd_s_Approval__c;
            }
            
            if(ddRecrd.P360_Cyber_Security_Contact_Name__c <> NULL){
                pWrap.CyberSecurityContactName = ddRecrd.P360_Cyber_Security_Contact_Name__c;
            }
            
            if(ddRecrd.P360_Cyber_Security_Contact_Email_Add__c <> NULL){
                pWrap.CyberSecurityContactEmail = ddRecrd.P360_Cyber_Security_Contact_Email_Add__c;
            }
            
            if(ddRecrd.P360_Doe_your_org_have_an_InfoSec_policy__c <> NULL){
                Map < String, String > question1 = new Map < String, String > {
                    'Does your organisation have a formal Information Security policy?' => ddRecrd.P360_Doe_your_org_have_an_InfoSec_policy__c,
                        'Comments' => ddRecrd.P360_InfoSec_Policy_Comments__c
                        };
                            questionsList.add(question1);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Is_there_a_security_lead__c)){
                Map < String, String > question2 = new Map < String, String > {
                    'Is there someone responsible for Security in your organisation?' => ddRecrd.P360_Is_there_a_security_lead__c,
                        'Comments' => ddRecrd.P360_Security_Lead_Comments__c
                        };
                            questionsList.add(question2);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Vulnerability_management__c)){
                Map < String, String > question3 = new Map < String, String > {
                    'Do you have a vulnerability management programme in place that identifies and remediates vulnerabilities in a timely manner?' => ddRecrd.P360_Vulnerability_management__c,
                        'Comments' => ddRecrd.P360_Vulnerability_management_Comments__c
                        };
                            questionsList.add(question3);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Third_party_security_standards__c)){
                Map < String, String > question4 = new Map < String, String > {
                    'Have you defined a set of standards against which to assess the security posture of your third-party business partners, and  do you assess third parties prior to doing business with them and thereafter on a frequency commensurate with the risk?' => ddRecrd.P360_Third_party_security_standards__c,
                        'Comments' => ddRecrd.P360_Third_Party_Sec_Standards_Comments__c
                        };
                            questionsList.add(question4);
            }
            
            
            if(String.isNotEmpty(ddRecrd.P360_Internet_MFA_enforced__c)){
                Map < String, String > question5 = new Map < String, String > {
                    'Is multi-factor authentication enforced for all connections to company resources over the internet?' => ddRecrd.P360_Internet_MFA_enforced__c,
                        'Comments' => ddRecrd.P360_Internet_MFA_enforced_Comments__c
                        };
                            questionsList.add(question5);
                // pWrap.question5 = question5;  
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Anti_malware_protection__c)){
                Map < String, String > question6 = new Map < String, String > {
                    'Are your systems covered by an up-to-date anti-malware solution?' => ddRecrd.P360_Anti_malware_protection__c,
                        'Comments' => ddRecrd.P360_Anti_Malware_Protection_Comments__c
                        };
                            questionsList.add(question6);
            }
            
            
            if(String.isNotEmpty(ddRecrd.P360_Mobile_data_control__c)){
                Map < String, String > question7 = new Map < String, String > {
                    'If you are handling company data on mobile devices, do you have technical measures to control it?' => ddRecrd.P360_Mobile_data_control__c,
                        'Comments' => ddRecrd.P360_Mobile_Data_Control_Comments__c
                        };
                            questionsList.add(question7);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Restricted_admin_privileges__c)){
                Map < String, String > question8 = new Map < String, String > {
                    'Do you restrict the use of administrator privileges to IT specialists?' => ddRecrd.P360_Restricted_admin_privileges__c,
                        'Comments' => ddRecrd.P360_Restricted_Admin_Privilege_Comments__c
                        };
                            questionsList.add(question8);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Data_encryption_practices__c)){
                Map < String, String > question9 = new Map < String, String > {
                    'Is all Sensitive and Confidential information in scope encrypted at rest and in transit  usine best practice methodologies?' => ddRecrd.P360_Data_encryption_practices__c,
                        'Comments' => ddRecrd.P360_Data_Encryption_Practices_Comments__c
                        };
                            questionsList.add(question9);      
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Ongoing_security_training__c)){
                Map < String, String > question10 = new Map < String, String > {
                    'Does the organisation provide staff with on-going training and awareness on information and information security, including how to prevent social engineerine ohishine and ransomware?' => ddRecrd.P360_Ongoing_security_training__c,
                        'Comments' => ddRecrd.P360_Ongoing_Security_Training_Comments__c
                        };
                            questionsList.add(question10);
                // pWrap.question10 = question10;
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Systems_monitoring__c)){
                Map < String, String > question11 = new Map < String, String > {
                    'Does your organisation implement monitoring of all your systems in scope for the purpose of detection and prevention?' => ddRecrd.P360_Systems_monitoring__c,
                        'Comments' => ddRecrd.P360_Systems_Monitoring_Comments__c
                        };
                            questionsList.add(question11);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Incident_management_process__c)){
                Map < String, String > question12 = new Map < String, String > {
                    'Does your organisation have a documented incident management process, which is practiced or reviewed at least annually?' => ddRecrd.P360_Incident_management_process__c,
                        'Comments' => ddRecrd.P360_Incident_Management_Pro_Comments__c
                        };
                            questionsList.add(question12);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Cybersecurity_insurance__c)){
                Map < String, String > question13 = new Map < String, String > {
                    'Does the organisation have cybersecurity insurance or cyber liability insurance?' => ddRecrd.P360_Cybersecurity_insurance__c,
                        'Comments' => ddRecrd.P360_Cybersecurity_Insurance_Comments__c
                        };
                            questionsList.add(question13);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_No_data_breaches_in_3_years__c)){
                Map < String, String > question14 = new Map < String, String > {
                    'Can you confirm your organisation has not had a data breach in the past 3 years?' => ddRecrd.P360_No_data_breaches_in_3_years__c,
                        'Comments' => ddRecrd.P360_No_Data_Breache_in_3_Years_Comments__c
                        };
                            questionsList.add(question14);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Business_continuity_plan__c)){
                Map < String, String > question15 = new Map < String, String > {
                    'Do you have a business continuity plan in place that is reviewed and tested at least annually?' => ddRecrd.P360_Business_continuity_plan__c,
                        'Comments' => ddRecrd.P360_Business_Continuity_Plan_Comments__c
                        };
                            questionsList.add(question15);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Disaster_recovery_plan__c)){
                Map < String, String > question16 = new Map < String, String > {
                    'Do you have a disaster recovery plan, including backups, that allow you to recover in line with your business continuity plans that is reviewed and tested at least annually?' => ddRecrd.P360_Disaster_recovery_plan__c,
                        'Comments' => ddRecrd.P360_Disaster_Recovery_Plan_Comments__c
                        };
                            questionsList.add(question16);
            }
            
            if(String.isNotEmpty(ddRecrd.P360_Security_certifications__c)){
                Map < String, String > question17 = new Map < String, String > {
                    'Do you have any recognised information security certifications or audit reports?' => ddRecrd.P360_Security_certifications__c,
                        'Comments' => ddRecrd.P360_Security_Certifications_Comments__c
                        };
                            questionsList.add(question17);
            }
            pWrap.Questions = questionsList;
            pWrapList.add(pWrap);
        }        
        return pWrapList;
    }
    
    global class PartyWrapper {
        
        public String EntityUniqueId;
        public String EntityName;
        public String EntityType;
        public Date CompletionTimeStamp;
        public String CyberSecurityContactName;
        public String CyberSecurityContactEmail;
        public List<Map<String, String>> Questions;
        
    }   
}