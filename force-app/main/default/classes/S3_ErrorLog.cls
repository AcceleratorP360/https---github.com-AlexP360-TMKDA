public class S3_ErrorLog {

    public Static void errorLog(List<S3_ErrorWrapper> errWrapList, String docName,
        DateTime CompletedDate, String jobId, String folderName, Integer successRecords) {
            
            List < P360_Error_Log__c > errorList = new List < P360_Error_Log__c > ();
            for(S3_ErrorWrapper err : errWrapList){
                P360_Error_Log__c error = new P360_Error_Log__c();
                error.P360_Error_Message__c = err.errorMessage; //er.getMessage();
                error.P360_File_Name__c = docName;
                error.P360_Error_Field__c = err.errorFields; //String.valueOf(er.getFields());
                error.P360_Error_Time__c = CompletedDate;
                error.P360_Status_Code__c = err.statusCode;
               /* error.P360_Total_Job_Items__c = TotalJobItems;
                error.P360_Job_Items_Processed__c = JobItemsProcessed;
                error.P360_Number_Of_Errors__c = NumberOfErrors;*/
                error.P360_Batch_Id__c = jobId;
                errorList.add(error);   
            }

        if (!errorList.isEmpty()) {
            insert errorList;
            
            Set<Id> set_ErrId = new Set<Id>();
            for(P360_Error_Log__c err : errorList){
                set_ErrId.add(err.Id);
            }
            S3_LogFile logBatch = new S3_LogFile(set_ErrId, folderName, docName, jobId, String.valueOf(CompletedDate), successRecords, errWrapList.size());
            Database.executeBatch(logBatch);
        }
    }

    public Static void send_EmailMessage(String subject, String plainTextBody) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
            'srikanth.cheera@processthreesixty.com'
        };
        // String[] toAddresses = new String[] {'processthreesixty360@outlook.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        });
    }
}