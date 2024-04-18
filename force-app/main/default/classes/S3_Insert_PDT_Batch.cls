public class S3_Insert_PDT_Batch implements Database.Batchable<String>, Database.Stateful {
    
    public List<String> lines;
    public String docName;
    public Set<Id> setOf_Ids;
    public Map<String, List<String>> resultMap;
    public List < S3_ErrorWrapper > errorWrapList;
    public Set<Id> setOf_ConVerIds;
    
    public S3_Insert_PDT_Batch(List<String> lines, String docName, Set<Id> setOf_ConVerIds) {
        this.lines = lines;
        this.docName = docName;
        this.setOf_Ids = new Set<Id>();
        this.resultMap = new Map<String, List<String>>();
        this.errorWrapList = new List < S3_ErrorWrapper > ();
        this.setOf_ConVerIds = setOf_ConVerIds;
    }
    
    public Iterable<String> start(Database.BatchableContext context) {
        return lines;
    }
    
    public void execute(Database.BatchableContext bc, List<String> scope) {
        
       // AsyncApexJob job = [SELECT Id, JobItemsProcessed FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        
       // Integer numCount = [SELECT Count() FROM P360_STG_PDT__c WHERE Id =: setOf_Ids];
        
        List<P360_STG_PDT__c> stg_PDT_List = new List<P360_STG_PDT__c>();
        
        List<List<String>> cvList = new List<List<String>>(); 
        
        
        for(String line : scope) {
            //  String lineStr = line.replaceAll(', ', '; ');
            cvList.add(line.split(','));
        }
        
        for (Integer i = 0; i < cvList.size(); i++) {
            
            P360_STG_PDT__c pdt = new P360_STG_PDT__c();
            list < String > csvRowData = cvList[i];
            
            /* if (numCount > 0) {
                resultMap.put(String.valueOf(i + numCount + job.JobItemsProcessed + 2), csvRowData);
            } else {
                resultMap.put(String.valueOf(i + 1), csvRowData);
            }*/
            
            resultMap.put(String.valueOf(i), csvRowData);
            
            if(String.isNotEmpty(csvRowData[0].remove('\r').remove('"'))){
                pdt.P360_PDT_Number__c =  csvRowData[0].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[1].remove('\r').remove('"'))){
                pdt.P360_PDT_Status__c =  csvRowData[1].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[2].remove('\r').remove('"'))){
                pdt.P360_DA_Criteria__c =  csvRowData[2].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[3].remove('\r').remove('"'))){
                pdt.P360_Q6_New_Or_Renewal__c =  csvRowData[3].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[4].remove('\r').remove('"'))){
                pdt.P360_Q7_Eclipse_Ref__c =  csvRowData[4].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))){
                pdt.P360_Q8_Contract_Type__c =  csvRowData[5].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[0].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[1].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[2].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[3].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[4].remove('\r').remove('"'))
               || String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))
              ){
                  pdt.Name = docName;
                  pdt.P360_Serial_No__c = String.valueOf(i);
                 /* if (numCount > 0) {
                      pdt.P360_Serial_No__c = String.valueOf(i + numCount + job.JobItemsProcessed + 2);
                  } else {
                      pdt.P360_Serial_No__c = String.valueOf(i + 1);
                  }*/
              }
            
            stg_PDT_List.add(pdt);
        }
        
        if(!stg_PDT_List.isEmpty()){
            Database.SaveResult[] srList = Database.insert(stg_PDT_List, false);
            // S3_ErrorLog.errorLog(srList, 'PDT'+String.valueOf(System.now()));
            
            List<P360_STG_PDT__c> del_PDT = [ SELECT Id FROM P360_STG_PDT__c WHERE Id =:stg_PDT_List AND  P360_PDT_Number__c LIKE '%Number%' ];
            delete del_PDT;
            
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
        
        AsyncApexJob job = [SELECT Id, CompletedDate, TotalJobItems, JobItemsProcessed, NumberOfErrors FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        List < P360_STG_PDT__c > successList = [SELECT Id, P360_Serial_No__c FROM P360_STG_PDT__c WHERE Id =: setOf_Ids];
        if (!successList.isEmpty()) {
            
            for (P360_STG_PDT__c dcom: successList) {
                if (resultMap.containsKey(dcom.P360_Serial_No__c)) {
                    // successResult.put(dcom.P360_Serial_No__c, resultMap.get(dcom.P360_Serial_No__c));
                    resultMap.remove(dcom.P360_Serial_No__c);
                }
            }
            
            
            if (!errorWrapList.isEmpty()) {
                S3_ErrorFile error_Batch = new S3_ErrorFile(resultMap, 'PDT', docName.replace(' ', '%20'), job.Id, setOf_ConVerIds);
                Database.executeBatch(error_Batch);
            }
        }
        
        if (!errorWrapList.isEmpty()) {
           // S3_ErrorLog.errorLog(errorWrapList, docName, job.CompletedDate, job.Id, 'PDT', successList.size());
            resultMap.remove('0');
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            for (String key: resultMap.keySet()) {
                String csvRowVal = /*'Error:' + '\n' + 'Record Number: ' + key +*/ '\n' + 'Error Record: ' + resultMap.get(key) + '\n';
                csvLines.add(csvRowVal);
            }
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() + '\n' +
                         'Records in error: ' + errorWrapList.size() + '\n' + 'Errored records are moved to: ' + 'PDT' + '/Archived/Log files/' + docName.replace('.csv', '.err'));
            String csvBody = String.join(csvLines, '\n');
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'PDT', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
            
        } else {
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() +
                         '\n' + 'Records in error: ' + errorWrapList.size());
            
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'PDT', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
        }
    }
}