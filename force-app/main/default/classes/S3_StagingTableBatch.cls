public class S3_StagingTableBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public Set<Id> setOf_ConVerIds;
    public Map<String, List<String>> fileLinesMap;

    public S3_StagingTableBatch(Set<Id> setOf_ConVerIds) {
        this.setOf_ConVerIds = setOf_ConVerIds;
        this.fileLinesMap = new Map<String, List<String>>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Description, VersionData, Title FROM ContentVersion WHERE Id IN :setOf_ConVerIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<ContentVersion> scope) {
        List<P360_Error_Log__c> error_List = new List<P360_Error_Log__c>();
        
        for(ContentVersion cv : scope) {
            if(cv.VersionData != null && (cv.Description == 'KDR' || cv.Description == 'DCOM' || cv.Title.contains('PDT') || cv.Title.contains('BDX'))) {
                try {
                    String contents = '';
                    if(cv.Title.contains('_SD1_') || cv.Title.contains('_SD8_') || cv.Title.contains('_SD3_') || 
                       cv.Title.contains('KDR') || cv.Title.contains('PDT') || cv.Title.contains('BDX')){
                        contents = cv.VersionData.toString();
                    }
                    if(cv.Title.contains('_SD3a_')){
                        contents = cv.VersionData.toString().replace('\nMaximum', ' Maximum');
                    }
                    if(cv.Title.contains('_SD10a_') || cv.Title.contains('_SD4_')){
                        contents = cv.VersionData.toString().replace(' \n[', ' [').replace('\n[', ' [').replace(' \n', ' ');
                    }
                    
                    RowIteratorUtility r = new RowIteratorUtility(contents, '\n');
                    String firstRow;
                    
                    while(r.hasNext()) {
                        firstRow = r.next();
                       // String key = cv.Title + '_' + cv.Description;
                        String key = cv.Title;
                        if (!fileLinesMap.containsKey(key)) {
                            fileLinesMap.put(key, new List<String>());
                        }
                        fileLinesMap.get(key).add(replaceCommasWithinQuotes(firstRow));
                    }
                } catch(Exception e) {
                    P360_Error_Log__c error = new P360_Error_Log__c();
                    error.P360_Error_Message__c = e.getMessage();
                    error.P360_Error_Time__c = System.Now();
                    error.P360_File_Name__c = cv.Title;
                    error_List.add(error);
                    S3_ErrorLog.send_EmailMessage(cv.Title + ' process failed', 'Failed to process ' + cv.Title + ' caused by ' + e.getMessage());
                }
            }
        }
        
        if(!error_List.isEmpty()) {
            insert error_List;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        for(String key : fileLinesMap.keySet()) {
            if (key.contains('_SD1_')) {
                S3_Insert_SD1_DCOM_Coverholder_Batch dcomBatch = new S3_Insert_SD1_DCOM_Coverholder_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(dcomBatch, 2000);   
            } if (key.contains('_SD10a_')) {
                S3_Insert_SD10a_DCOM_Section_Leads_Batch dcomBatch = new S3_Insert_SD10a_DCOM_Section_Leads_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(dcomBatch, 2000);  
            } else if (key.contains('_SD3_')) {
                S3_Insert_SD3_DCOM_Authorised_COB_Batch dcomBatch = new S3_Insert_SD3_DCOM_Authorised_COB_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(dcomBatch, 2000);  
            } else if (key.contains('_SD3a_')) {
                S3_Insert_SD3a_DCOM_COB_Max_limit_Batch dcomBatch = new S3_Insert_SD3a_DCOM_COB_Max_limit_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(dcomBatch, 2000);  
            } else if (key.contains('_SD4_')) {
                S3_Insert_SD4_DCOM_Territorial_Batch dcomBatch = new S3_Insert_SD4_DCOM_Territorial_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(dcomBatch, 2000);  
            } else if (key.contains('_SD8_')) {
                S3_Insert_SD8_DCOM_Claims_Compl_Batch dcomBatch = new S3_Insert_SD8_DCOM_Claims_Compl_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(dcomBatch, 2000);   
            } else if (key.contains('KDR')) {
                S3_Insert_KDR_Batch kdr_Batch = new S3_Insert_KDR_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(kdr_Batch, 2000);
            } else if (key.contains('PDT')) {
                S3_Insert_PDT_Batch pdt_Batch = new S3_Insert_PDT_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(pdt_Batch, 2000);
            } else if (key.contains('BDX')) {
                S3_Insert_BDX_Batch bdx_Batch = new S3_Insert_BDX_Batch(fileLinesMap.get(key), key, setOf_ConVerIds);
                Database.executeBatch(bdx_Batch, 2000);
            }
        }
    }
    
    public static String replaceCommasWithinQuotes(String line) {
        String[] parts = line.split('"');
        Boolean withinQuotes = false;
        
        for(Integer i = 0; i < parts.size(); i++) {
            if (withinQuotes) {
                parts[i] = parts[i].replace(',', 'comma').trim();
            }
            withinQuotes = !withinQuotes;
        }
        
        return String.join(parts, '"');
    }
}