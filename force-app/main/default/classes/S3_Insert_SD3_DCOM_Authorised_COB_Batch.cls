public class S3_Insert_SD3_DCOM_Authorised_COB_Batch  implements Database.Batchable<String>, Database.Stateful{
    
    public List<String> lines;
    public String docName;
    public Set<Id> setOf_Ids;
    public Map<String, List<String>> resultMap;
    public List < S3_ErrorWrapper > errorWrapList;
    public Set<Id> setOf_ConVerIds;
    
    public S3_Insert_SD3_DCOM_Authorised_COB_Batch(List<String> lines, String docName, Set<Id> setOf_ConVerIds) {
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
        
        List<P360_DCOM_Authorized_COB__c> stg_DCOM_List = new List<P360_DCOM_Authorized_COB__c>();
        
        List<List<String>> cvList = new List<List<String>>(); 
        
      //  AsyncApexJob job = [SELECT Id, JobItemsProcessed FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        
      //  Integer numCount = [SELECT Count() FROM P360_DCOM_Authorized_COB__c WHERE Name =: docName];
        
        for(String line : scope) {
            //  String lineStr = line.replaceAll(', ', '; ');
            cvList.add(line.split(','));
        }
        
        for (Integer i = 0; i < cvList.size(); i++) {
            
            P360_DCOM_Authorized_COB__c dcom = new P360_DCOM_Authorized_COB__c();
            
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
                dcom.P360_Distribution_Method__c =  csvRowData[4].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))){
                dcom.P360_Premium_level_of_authority__c =  csvRowData[5].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[6].remove('\r').remove('"'))){
                dcom.P360_Deductibles_andor_excesses__c =  csvRowData[6].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[7].remove('\r').remove('"'))){
                dcom.P360_Items_insured_Group_Insured_Item__c =  csvRowData[7].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[8].remove('\r').remove('"'))){
                dcom.P360_High_Level_Class_of_Business__c =  csvRowData[8].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[9].remove('\r').remove('"'))){
                dcom.P360_Generic_Class_of_Business__c =  csvRowData[9].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[10].remove('\r').remove('"'))){
                dcom.P360_Risk_codes_and_description__c =  csvRowData[10].remove('\r').remove('"').replace('comma', ',');
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
            // S3_ErrorLog.errorLog(srList, 'SD3_DCOM'+String.valueOf(System.now()));
            
            List<P360_DCOM_Authorized_COB__c> del_SD3 = [ SELECT Id FROM P360_DCOM_Authorized_COB__c WHERE Id =:stg_DCOM_List AND  P360_Unique_Market_Reference_Number__c LIKE '%Unique%' ];
            delete del_SD3;
            
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
List<P360_DCOM_Authorized_COB__c> successList = [ SELECT Id, P360_Serial_No__c FROM P360_DCOM_Authorized_COB__c WHERE Id =: setOf_Ids];

Map<String, List<String>> successResult = new Map<String, List<String>>();

for(P360_DCOM_Authorized_COB__c dcom : successList){
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
        List < P360_DCOM_Authorized_COB__c > successList = [SELECT Id, P360_Serial_No__c FROM P360_DCOM_Authorized_COB__c WHERE Id =: setOf_Ids];
        if (!successList.isEmpty()) {
            
            for (P360_DCOM_Authorized_COB__c dcom: successList) {
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
                String csvRowVal = /*'Error:' + '\n' + 'Record Number: ' + key +*/ '\n' + 'Error Record: ' + resultMap.get(key) + '\n';
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