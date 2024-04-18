public class S3_LogFilesCtrl {
    
    public Static void pushSuccessRecords(String csvBody, String folderName, String fileName){
        Blob pdfBlob = Blob.valueOf(csvBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setBodyAsBlob(pdfBlob);
        request.setHeader('Content-Encoding', 'UTF-8');
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('ACL', 'public-read-write');
        request.setHeader('Content-Type', 'application/octet-stream');
        request.setEndpoint('callout:'+ Label.S3_Bucket +'/'+ folderName +'/Archived/Log%20files/' + fileName.replace(':','%20')+'.log');
        HttpResponse response = http.send(request);
    }
    
    public Static void pushErrorRecords(String csvBody, String folderName, String fileName){
        Blob pdfBlob = Blob.valueOf(csvBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setBodyAsBlob(pdfBlob);
        request.setHeader('Content-Encoding', 'UTF-8');
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('ACL', 'public-read-write');
        request.setHeader('Content-Type', 'application/octet-stream');
        request.setEndpoint('callout:'+ Label.S3_Bucket +'/'+ folderName +'/Archived/Error%20files/' + fileName.replace(':','%20')+'.err');
        HttpResponse response = http.send(request);
    }
    
    public Static void pushArchivedRecords(String csvBody, String folderName, String fileName){
        Blob pdfBlob = Blob.valueOf(csvBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setBodyAsBlob(pdfBlob);
        request.setHeader('Content-Encoding', 'UTF-8');
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('ACL', 'public-read-write');
        request.setHeader('Content-Type', 'application/octet-stream');
        request.setEndpoint('callout:'+ Label.S3_Bucket +'/'+ folderName +'/Archived/' + fileName);
        HttpResponse response = http.send(request);
    }
}