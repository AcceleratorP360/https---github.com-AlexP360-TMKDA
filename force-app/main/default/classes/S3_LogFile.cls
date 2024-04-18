/**
* @author [Srikanth Cheera]
* @create date 2024-03-12 10:47:29
* @modify date 2024-03-13 10:47:29
*/


public class S3_LogFile implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    
    public Set<Id> errorIds;
    public String folderName;
    public String docName;
    public String batchId;
    public String batchTime;
    public Integer suceessRecords;
    public Integer errorRecords;
    
    public S3_LogFile(Set<Id> errorIds, String folderName, String docName, String batchId, String batchTime, Integer suceessRecords, Integer errorRecords){
        this.errorIds = errorIds;
        this.folderName = folderName;
        this.docName = docName;   
        this.batchId = batchId;
        this.batchTime = batchTime;
        this.suceessRecords = suceessRecords;
        this.errorRecords = errorRecords;
    }
    
    public Database.querylocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Name, P360_Error_Message__c, P360_File_Name__c, P360_Error_Field__c, P360_Error_Time__c, P360_Status_Code__c, P360_Total_Job_Items__c, P360_Job_Items_Processed__c, P360_Number_Of_Errors__c, P360_Batch_Id__c FROM P360_Error_Log__c  WHERE Id =: errorIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<P360_Error_Log__c> scope) {
        
        List < String > csvLines = new List < String > ();
        csvLines.add('Batch Id ' + batchId + ' at ' + batchTime + '\n' + 'Processing file: ' + docName + '\n');
        
        for (P360_Error_Log__c err: scope) {
            
            String csvRowVal = 'Error:' + '\n' + 'Record number:' + '' + '\n' 
                + /*'Error code: ' + err.P360_Error_Field__c + '\n' +*/ 'Error reason: ' + err.P360_Status_Code__c + '\n';
            
            csvLines.add(csvRowVal);
        }
        
        csvLines.add('Batch Id ' + batchId + ' at ' + batchTime + '\n' + 'Records successfully processed: ' + suceessRecords + '\n' 
                     + 'Records in error: ' + errorRecords + '\n' + 'Errored records are moved to: ' + folderName +'/Archived/Log files/'+docName.replace('.csv', '.err'));
        String csvBody = String.join(csvLines, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody, folderName , docName.replace('.csv', String.valueOf(System.now())).replace(' ', '%20'));        
        
    }
    
    public void finish(Database.BatchableContext context){
       // S3_FileMover.moveFile(folderName, docName.replace(' ', '%20'));
    }
}