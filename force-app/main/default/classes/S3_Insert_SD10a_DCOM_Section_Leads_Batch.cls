public class S3_Insert_SD10a_DCOM_Section_Leads_Batch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
    
    public List<String> lines;
    public String docName;
    public Set<Id> setOf_Ids;
    public Map<String, List<String>> resultMap;
    public List < S3_ErrorWrapper > errorWrapList;
    public Set<Id> setOf_ConVerIds;
    public S3_Insert_SD10a_DCOM_Section_Leads_Batch(List<String> lines, String docName, Set<Id> setOf_ConVerIds) {
        this.lines = lines;
        this.docName = docName;
        this.setOf_Ids = new Set<Id>();
        this.resultMap = new Map<String, List<String>>();
        this.errorWrapList = new List < S3_ErrorWrapper > ();
        this.setOf_ConVerIds = setOf_ConVerIds;
    }
    
    public Iterable<String> start(Database.BatchableContext bc) {
        return lines;
    }
    
    public void execute(Database.BatchableContext bc, List<String> scope) {
        
      //  AsyncApexJob job = [SELECT Id, JobItemsProcessed FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        
      //  Integer numCount = [SELECT Count() FROM P360_DCOM_Section_Leads__c WHERE Id =: setOf_Ids];
        
        List<P360_DCOM_Section_Leads__c> stg_DCOM_List = new List<P360_DCOM_Section_Leads__c>();
        
        List<List<String>> cvList = new List<List<String>>(); 
        
        
        for(String line : scope) {
            //  String lineStr = line.replaceAll(', ', '; ');
            cvList.add(line.split(','));
        }
        
        for (Integer i = 0; i < cvList.size(); i++) {
            
            P360_DCOM_Section_Leads__c dcom = new P360_DCOM_Section_Leads__c();
            
            list < String > csvRowData = cvList[i];
            
           /* if (numCount > 0) {
                resultMap.put(String.valueOf(i + numCount + job.JobItemsProcessed + 2), csvRowData);
            } else {
                resultMap.put(String.valueOf(i + 1), csvRowData);
            }*/
            
            resultMap.put(String.valueOf(i), csvRowData);
            
            if(String.isNotEmpty(csvRowData[0].remove('\r').remove('"'))){
                dcom.P360_Unique_Market_Reference_Number__c =  csvRowData[0].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[1].remove('\r').remove('"'))){
                dcom.P360_Contract_Unique_Identifier__c =  csvRowData[1].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[2].remove('\r').remove('"'))){
                dcom.P360_Section_Name__c =  csvRowData[2].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[3].remove('\r').remove('"'))){
                dcom.P360_Section_Unique_ID__c =  csvRowData[3].remove('\r').remove('"').replace('comma', ',');
            }
            
            
            if(String.isNotEmpty(csvRowData[4].remove('\r').remove('"'))){
                dcom.P360_Is_this_a_Non_Lloyd_s_Insurer_led__c =  csvRowData[4].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))){
                dcom.P360_Lead_Type_Section_Lead_s__c =  csvRowData[5].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[6].remove('\r').remove('"'))){
                dcom.P360_Company_reference__c =  csvRowData[6].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[7].remove('\r').remove('"'))){
                dcom.P360_Written_LineS__c =  csvRowData[7].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[8].remove('\r').remove('"'))){
                dcom.P360_Signed_Line__c =  csvRowData[8].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[9].remove('\r').remove('"'))){
                dcom.P360_Syndicate_Name__c =  csvRowData[9].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[10].remove('\r').remove('"'))){
                dcom.P360_Syndicate_Year_of_Account__c =  csvRowData[10].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[11].remove('\r').remove('"'))){
                dcom.P360_Syndicate_Number__c =  csvRowData[11].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[12].remove('\r').remove('"'))){
                dcom.P360_Managing_Agent__c =  csvRowData[12].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[13].remove('\r').remove('"'))){
                dcom.P360_Service_Company_Name__c =  csvRowData[13].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[14].remove('\r').remove('"'))){
                dcom.P360_Service_Company_PIN__c = csvRowData[14].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[15].remove('\r').remove('"'))){
                dcom.P360_UMR_Number__c =  csvRowData[15].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[16].remove('\r').remove('"'))){
                dcom.P360_Non_Lloyd_s_Insurer_ID__c =  csvRowData[16].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[17].remove('\r').remove('"'))){
                dcom.P360_Non_Lloyd_s_Insurer_Company_Name__c =  csvRowData[17].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[18].remove('\r').remove('"'))){
                dcom.P360_Non_Lloyd_s_Insurer_City__c =  csvRowData[18].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[19].remove('\r').remove('"'))){
                dcom.P360_Non_Lloyd_s_Insurer_Division_ID__c =  csvRowData[19].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[20].remove('\r').remove('"'))){
                dcom.P360_Non_Lloyd_s_Insurer_Division_Name__c =  csvRowData[20].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[21].remove('\r').remove('"'))){
                dcom.P360_Non_Lloyd_s_Insurer_Trading_Name__c =  csvRowData[21].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[22].remove('\r').remove('"'))){
                dcom.P360_Other_Non_Lloyd_s_Insurer__c =  csvRowData[22].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[23].remove('\r').remove('"'))){
                dcom.P360_Year_of_account__c =  csvRowData[23].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[24].remove('\r').remove('"'))){
                dcom.P360_Date_confirmation_was_received__c =  csvRowData[24].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[25].remove('\r').remove('"'))){
                dcom.P360_Total_Capacity__c =  csvRowData[25].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[0].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[1].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[2].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[3].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[4].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[6].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[7].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[8].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[9].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[10].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[11].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[12].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[13].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[14].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[15].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[16].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[17].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[18].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[19].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[20].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[21].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[22].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[23].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[24].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[25].remove('\r').remove('"'))
              ){
                  dcom.Name =  docName;
                  dcom.P360_Serial_No__c = String.valueOf(i);
                 /* if (numCount > 0) {
                      dcom.P360_Serial_No__c = String.valueOf(i + numCount + job.JobItemsProcessed + 2);
                  } else {
                      dcom.P360_Serial_No__c = String.valueOf(i + 1);
                  }*/
              }
            
            
            stg_DCOM_List.add(dcom);
        }
        
        if(!stg_DCOM_List.isEmpty()){
            Database.SaveResult[] srList = Database.insert(stg_DCOM_List, false);
            // S3_ErrorLog.errorLog(srList, 'SD10a_DCOM'+String.valueOf(System.now()));            
            List<P360_DCOM_Section_Leads__c> sd10_DeleteList = [ SELECT Id FROM P360_DCOM_Section_Leads__c WHERE Id =: stg_DCOM_List AND P360_Unique_Market_Reference_Number__c LIKE '%Unique%' ];
            delete sd10_DeleteList;
            
            if(!srList.isEmpty()){
                for (Database.SaveResult sr : srList) {
                    if(sr.isSuccess()){
                        setOf_Ids.add(sr.getId());
                    }
                    for(Database.Error er : sr.getErrors()) {
                        S3_ErrorWrapper wrp = new S3_ErrorWrapper();
                        wrp.errorMessage = er.getMessage();
                        wrp.errorFields = String.valueOf(er.getfields());
                        wrp.statusCode = String.valueOf(er.getStatusCode());
                        errorWrapList.add(wrp);
                    }
                }
            }
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
        
        /* if(!setOf_Ids.isEmpty()){
List<P360_DCOM_Section_Leads__c> successList = [ SELECT Id, P360_Serial_No__c FROM P360_DCOM_Section_Leads__c WHERE Id =: setOf_Ids];

Map<String, List<String>> successResult = new Map<String, List<String>>();

for(P360_DCOM_Section_Leads__c dcom : successList){
if(resultMap.containsKey(dcom.P360_Serial_No__c)){
successResult.put(dcom.P360_Serial_No__c, resultMap.get(dcom.P360_Serial_No__c));
resultMap.remove(dcom.P360_Serial_No__c);
}
}

if(!successResult.isEmpty()){
S3_SuceessFile batchable = new S3_SuceessFile(successResult, 'DCOM', docName);
Database.executeBatch(batchable, 2000);  
}

if(!resultMap.isEmpty()){
AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
S3_ErrorFile error_Batch = new S3_ErrorFile(resultMap, 'DCOM', docName.replace(' ','%20'), job.Id);
Database.executeBatch(error_Batch);
}                           
}*/
        
        AsyncApexJob job = [SELECT Id, CompletedDate, TotalJobItems, JobItemsProcessed, NumberOfErrors FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        List < P360_DCOM_Section_Leads__c > successList = [SELECT Id, P360_Serial_No__c FROM P360_DCOM_Section_Leads__c WHERE Id =: setOf_Ids];
        if (!successList.isEmpty()) {
            
            
            for (P360_DCOM_Section_Leads__c dcom: successList) {
                if (resultMap.containsKey(dcom.P360_Serial_No__c)) {
                    // successResult.put(dcom.P360_Serial_No__c, resultMap.get(dcom.P360_Serial_No__c));
                    resultMap.remove(dcom.P360_Serial_No__c);
                }
            }
            
            
            if (!errorWrapList.isEmpty()) {
                S3_ErrorFile error_Batch = new S3_ErrorFile(resultMap, 'DCOM', docName.replace(' ', '%20'), job.Id, setOf_ConVerIds);
                Database.executeBatch(error_Batch);
            }
        }
        
        if (!errorWrapList.isEmpty()) {
           // S3_ErrorLog.errorLog(errorWrapList, docName, job.CompletedDate, job.Id, 'DCOM', successList.size());
            resultMap.remove('0');
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            for (String key: resultMap.keySet()) {
                String csvRowVal = /*'Error:' + '\n' + 'Record Number: ' + key + */ '\n' + 'Error Record: ' + resultMap.get(key) + '\n';
                csvLines.add(csvRowVal);
            }
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() + '\n' +
                         'Records in error: ' + errorWrapList.size() + '\n' + 'Errored records are moved to: ' + 'DCOM' + '/Archived/Log files/' + docName.replace('.csv', '.err'));
            String csvBody = String.join(csvLines, '\n');
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'DCOM', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
            
        } else {
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() +
                         '\n' + 'Records in error: ' + errorWrapList.size());
            
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'DCOM', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
        }
    }
}