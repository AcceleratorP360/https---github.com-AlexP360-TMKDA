public class S3_Insert_KDR_Batch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts {
    
    public List<String> lines;
    public String docName;
    public Set<Id> setOf_Ids;
    public Map<String, List<String>> resultMap;
    public List < S3_ErrorWrapper > errorWrapList;
    public Set<Id> setOf_ConVerIds;
    
    public S3_Insert_KDR_Batch(List<String> lines, String docName, Set<Id> setOf_ConVerIds) {
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
        
       // AsyncApexJob job = [SELECT Id, JobItemsProcessed FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        
       // Integer numCount = [SELECT Count() FROM P360_STG_KDR__c WHERE Id =: setOf_Ids];
        
        List<List<String>> cvList = new List<List<String>>(); 
       /* for(String line : scope) {
            
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"').trim());
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"').trim());
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"').trim());
                }
            }
            
            cvList.add(cleanFields);
        }*/
            
            for(String line : scope) {
                //  String lineStr = line.replaceAll(', ', '; ');
                cvList.add(line.split(','));
            }
        
        List<P360_STG_KDR__c> stg_KDR_List = new List<P360_STG_KDR__c>();
        
        for (Integer i = 0; i < cvList.size(); i++) {
            
            P360_STG_KDR__c kdr = new P360_STG_KDR__c();
            
            list < String > csvRowData = cvList[i];
            
            /*if (numCount > 0) {
                resultMap.put(String.valueOf(i + numCount + job.JobItemsProcessed + 2), csvRowData);
            } else {
                resultMap.put(String.valueOf(i + 1), csvRowData);
            }*/
            
            resultMap.put(String.valueOf(i), csvRowData);
            
            if(String.isNotEmpty(csvRowData[0].remove('\r').remove('"'))){ //if (cvList[0].contains('Unique_Market_Reference')) {
                kdr.P360_Unique_Market_Reference__c = csvRowData[0].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Unique_Market_Reference__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[1].remove('\r').remove('"'))){ //if (cvList[0].contains('Inception_DT')) {
                kdr.P360_Inception_Date__c = csvRowData[1].remove('\r').remove('"').replace('comma', ',');                    
            }else{
                kdr.P360_Inception_Date__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[2].remove('\r').remove('"'))){ //if (cvList[0].contains('Expiry_DT')) {
                kdr.P360_Expiry_Date__c = csvRowData[2].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Expiry_Date__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[3].remove('\r').remove('"'))){ //if (cvList[0].contains('Lead_Syndicate')) {
                kdr.P360_Lead_Syndicate__c = csvRowData[3].remove('\r').remove('"').replace('comma', ',');  
            }else{
                kdr.P360_Lead_Syndicate__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[4].remove('\r').remove('"'))){ //if (cvList[0].contains('Policy_Reference')) {
                kdr.P360_Policy_Reference__c = csvRowData[4].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Policy_Reference__c = '';
            }
            
            /* if(String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))){ //if (cvList[0].contains('policylinereference')) {
kdr.P360_Policy_Line_Reference__c = csvRowData[5].remove('\r').remove('"');
}else{
kdr.P360_Policy_Line_Reference__c = '';
}*/
            
            if(String.isNotEmpty(csvRowData[5].remove('\r').remove('"'))){ //if (cvList[0].contains('Year_of_Account')) {
                kdr.P360_Year_of_Account__c = csvRowData[5].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Year_of_Account__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[6].remove('\r').remove('"'))){ //if (cvList[0].contains('Line_Status')) {
                kdr.P360_Line_Status__c = csvRowData[6].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Line_Status__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[7].remove('\r').remove('"'))){ //if (cvList[0].contains('Placing_Basis')) {
                kdr.P360_Placing_Basis__c = csvRowData[7].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Placing_Basis__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[8].remove('\r').remove('"'))){ //if (cvList[0].contains('Placing_Basis')) {
                kdr.P360_Contract_Record_Type__c = csvRowData[8].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Contract_Record_Type__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[9].remove('\r').remove('"'))){ //if (cvList[0].contains('Lead_Or_Follow')) {
                kdr.P360_Lloyds_Lead_Follow__c = csvRowData[9].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Lloyds_Lead_Follow__c = '';
            }
            
            
            if(String.isNotEmpty(csvRowData[10].remove('\r').remove('"'))){ //if (cvList[0].contains('underwriter')) {
                kdr.P360_Underwriter__c = csvRowData[10].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Underwriter__c = '';
            }
            
            
            if(String.isNotEmpty(csvRowData[11].remove('\r').remove('"'))){ //if (cvList[0].contains('Budget_Epi_Gbp_Amt')) {
                kdr.P360_Budget_Epi_Gbp_Amt__c = csvRowData[11].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Budget_Epi_Gbp_Amt__c = '';
            }
            
            if(String.isNotEmpty(csvRowData[12].remove('\r').remove('"'))){ //if (cvList[0].contains('Budget_Epi_Gbp_Amt')) {
                kdr.P360_Contract_Status__c = csvRowData[12].remove('\r').remove('"').replace('comma', ',');
            }else{
                kdr.P360_Contract_Status__c = '';
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
              ){
                  kdr.Name = docName;  
                  kdr.P360_Serial_No__c = String.valueOf(i);
                  /* if (numCount > 0) {
                      kdr.P360_Serial_No__c = String.valueOf(i + numCount + job.JobItemsProcessed + 2);
                  } else {
                      kdr.P360_Serial_No__c = String.valueOf(i + 1);
                  }*/
              }
            
            stg_KDR_List.add(kdr);
        }
        
        if(!stg_KDR_List.isEmpty()){
            
            Database.SaveResult[] srList = Database.insert(stg_KDR_List, false);
            
            List<P360_STG_KDR__c> del_KDR = [ SELECT Id FROM P360_STG_KDR__c WHERE Id =: stg_KDR_List AND P360_Unique_Market_Reference__c LIKE '%Unique%' ];
            delete del_KDR;
            
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
        List < P360_STG_KDR__c > successList = [SELECT Id, P360_Serial_No__c FROM P360_STG_KDR__c WHERE Id =: setOf_Ids];
        if (!successList.isEmpty()) {
            
            for (P360_STG_KDR__c dcom: successList) {
                if (resultMap.containsKey(dcom.P360_Serial_No__c)) {
                    // successResult.put(dcom.P360_Serial_No__c, resultMap.get(dcom.P360_Serial_No__c));
                    resultMap.remove(dcom.P360_Serial_No__c);
                }
            }
            
            
            if (!errorWrapList.isEmpty()) {
                S3_ErrorFile error_Batch = new S3_ErrorFile(resultMap, 'KDR', docName.replace(' ', '%20'), job.Id, setOf_ConVerIds);
                Database.executeBatch(error_Batch);
            }
        }
        
        if (!errorWrapList.isEmpty()) {
          // S3_ErrorLog.errorLog(errorWrapList, docName, job.CompletedDate, job.Id, 'KDR', successList.size());
            resultMap.remove('1');
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            for (String key: resultMap.keySet()) {
                String csvRowVal = /*'Error:' + '\n' + 'Record Number: ' + key + */'\n' + 'Error Record: ' + resultMap.get(key) + '\n';
                csvLines.add(csvRowVal);
            }
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() + '\n' +
                         'Records in error: ' + errorWrapList.size() + '\n' + 'Errored records are moved to: ' + 'KDR' + '/Archived/Log files/' + docName.replace('.csv', '.err'));
            String csvBody = String.join(csvLines, '\n');
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'KDR', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
            
        } else {
            List < String > csvLines = new List < String > ();
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Processing file: ' + docName + '\n');
            
            csvLines.add('Batch Id ' + job.Id + ' at ' + job.CompletedDate + '\n' + 'Records successfully processed: ' + successList.size() +
                         '\n' + 'Records in error: ' + errorWrapList.size());
            
            S3_SuceessLogFile logFile_Batch = new S3_SuceessLogFile(csvLines, 'KDR', docName, setOf_ConVerIds);
            Database.executebatch(logFile_Batch);
        }
    } 
}