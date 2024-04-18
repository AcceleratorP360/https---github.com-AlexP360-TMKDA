public class S3_Insert_BDX_Batch implements Database.Batchable<String>, Database.Stateful{
    
    public List<String> lines;
    public String docName;
    public Set<Id> setOf_Ids;
    public Map<String, List<String>> resultMap;
    public List < S3_ErrorWrapper > errorWrapList;
    public Set<Id> setOf_ConVerIds;
    
    public S3_Insert_BDX_Batch(List<String> lines, String docName, Set<Id> setOf_ConVerIds) {
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
        
        List<P360_STG_BDX__c> stg_BDX_List = new List<P360_STG_BDX__c>();
        
        List<List<String>> cvList = new List<List<String>>(); 
        
      //  AsyncApexJob job = [SELECT Id, JobItemsProcessed FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        
       // Integer numCount = [SELECT Count() FROM P360_STG_BDX__c WHERE Id =: setOf_Ids];
        
        for(String line : scope) {
            //  String lineStr = line.replaceAll(', ', '; ');
            cvList.add(line.split(','));
        }
        
        for (Integer i = 0; i < cvList.size(); i++) {
            
            P360_STG_BDX__c bdx = new P360_STG_BDX__c();
            list < String > csvRowData = cvList[i];
            
           /* if (numCount > 0) {
                resultMap.put(String.valueOf(i + numCount + job.JobItemsProcessed + 2), csvRowData);
            } else {
                resultMap.put(String.valueOf(i + 1), csvRowData);
            }*/
            
            resultMap.put(String.valueOf(i), csvRowData);
            
            if(String.isNotEmpty(csvRowData[0].remove('\r').remove('"'))){
                bdx.P360_UMR__c =  csvRowData[0].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[1].remove('\r').remove('"'))){
                bdx.P360_Coverholder_TPA__c =  csvRowData[1].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[2].remove('\r').remove('"'))){
                bdx.P360_Finding_Status__c =  csvRowData[2].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[3].remove('\r').remove('"'))){
                bdx.P360_Finding_Category__c =  csvRowData[3].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[4].remove('\r').remove('"'))){
                bdx.P360_Due_Date__c =  csvRowData[4].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))){
                bdx.P360_Date_Completed__c =  csvRowData[5].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[6].remove('\r').remove('"'))){
                bdx.P360_YOA__c =  csvRowData[6].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[7].remove('\r').remove('"'))){
                bdx.P360_Audit_End_Date__c =  csvRowData[7].remove('\r').remove('"').replace('comma', ',');
            }
            
            if(String.isNotEmpty(csvRowData[8].remove('\r').remove('"'))){
                bdx.P360_Audit_Reference__c =  csvRowData[8].remove('\r').remove('"').replace('comma', ',');
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
              ){
                  bdx.Name = docName;
                  bdx.P360_Serial_No__c = String.valueOf(i);
                 /* if (numCount > 0) {
                      bdx.P360_Serial_No__c = String.valueOf(i + numCount + job.JobItemsProcessed + 2);
                  } else {
                      bdx.P360_Serial_No__c = String.valueOf(i + 1);
                  }*/
              }
            
            stg_BDX_List.add(bdx);
        }
        
        if(!stg_BDX_List.isEmpty()){
            Database.SaveResult[] srList = Database.insert(stg_BDX_List, false);
            
            List<P360_STG_BDX__c> del_PDT = [ SELECT Id FROM P360_STG_BDX__c WHERE Id =:stg_BDX_List AND  P360_UMR__c LIKE '%UMR%' ];
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
        List < P360_STG_BDX__c > successList = [SELECT Id, P360_Serial_No__c FROM P360_STG_BDX__c WHERE Id =: setOf_Ids];
        if (!successList.isEmpty()) {
            
            for (P360_STG_BDX__c dcom: successList) {
                if (resultMap.containsKey(dcom.P360_Serial_No__c)) {
                    // successResult.put(dcom.P360_Serial_No__c, resultMap.get(dcom.P360_Serial_No__c));
                    resultMap.remove(dcom.P360_Serial_No__c);
                }
            }
            
            
            if (!errorWrapList.isEmpty()) {
                S3_ErrorFile error_Batch = new S3_ErrorFile(resultMap, 'BDX', docName.replace(' ', '%20'), job.Id, setOf_ConVerIds);
                Database.executeBatch(error_Batch);
            }
        }
        
        if (!errorWrapList.isEmpty()) {
           // S3_ErrorLog.errorLog(errorWrapList, docName, job.CompletedDate, job.Id, 'BDX', successList.size());
            resultMap.remove('0');
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            for (String key: resultMap.keySet()) {
                String csvRowVal = /*'Error:' + '\n' + 'Record Number: ' + key +*/ '\n' + 'Error Record: ' + resultMap.get(key) + '\n';
                csvLines.add(csvRowVal);
            }
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() + '\n' +
                         'Records in error: ' + errorWrapList.size() + '\n' + 'Errored records are moved to: ' + 'BDX' + '/Archived/Log files/' + docName.replace('.csv', '.err'));
            String csvBody = String.join(csvLines, '\n');
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'BDX', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
            
        } else {
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() +
                         '\n' + 'Records in error: ' + errorWrapList.size());
            
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'BDX', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
        }
    }
}