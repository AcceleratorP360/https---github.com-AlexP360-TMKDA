public class S3_SuceessLogFile implements Database.Batchable < String > , Database.Stateful, Database.AllowsCallouts {


    public List < String > csvLines;
    public String folderName;
    public String fileName;
    public Set<Id> setOf_ConVerIds;

    public S3_SuceessLogFile(List < String > csvLines, String folderName, String fileName, Set<Id> setOf_ConVerIds) {
        this.csvLines = csvLines;
        this.folderName = folderName;
        this.fileName = fileName;
        this.setOf_ConVerIds = setOf_ConVerIds; 
    }

    public Iterable < String > start(Database.BatchableContext context) {
        return csvLines;
    }

    public void execute(Database.BatchableContext context, List < String > scope) {
        String fName = fileName;
        String csvBody = String.join(scope, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody.replace('comma', ','), folderName, fName.replace('.csv', String.valueOf(System.now()).replaceAll(' ', '%20')).replace(' ', '%20'));

    }

    public void finish(Database.BatchableContext context) {
        S3_CopyToArchivedFolder copyBatch = new S3_CopyToArchivedFolder(setOf_ConVerIds);
        Database.executeBatch(copyBatch);
        // S3_CopyToArchivedFolder.copyToArchivedFolder(setOf_ConVerIds);
      //  S3_FileMover.moveFile(folderName, fileName.replace(' ', '%20'));
    }
}