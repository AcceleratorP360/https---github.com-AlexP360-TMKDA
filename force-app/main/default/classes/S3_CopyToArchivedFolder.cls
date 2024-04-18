public class S3_CopyToArchivedFolder implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    public Set<Id> setOf_ConVerIds;
    
    public S3_CopyToArchivedFolder(Set<Id> setOf_ConVerIds) {
        this.setOf_ConVerIds = setOf_ConVerIds;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Description, VersionData, Title FROM ContentVersion WHERE Id IN :setOf_ConVerIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<ContentVersion> scope) {
     
        for(ContentVersion cv : scope){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('PUT');
            request.setBodyAsBlob(cv.VersionData);
            request.setHeader('Content-Encoding', 'UTF-8');
            request.setHeader('Connection', 'keep-alive');
            request.setHeader('ACL', 'public-read-write');
            request.setHeader('Content-Type', 'application/octet-stream');
            request.setEndpoint('callout:'+ Label.S3_Bucket +'/'+ cv.Description +'/Archived/' + cv.Title.replaceAll(' ','%20'));
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200){
                Http http_Del = new Http();
                HttpRequest request_Del = new HttpRequest();
                request_Del.setEndpoint('callout:' + Label.S3_Bucket + '/' + cv.Description + '/' + cv.Title.replaceAll(' ','%20'));
                request_Del.setMethod('DELETE');
                HttpResponse response_Del = http_Del.send(request_Del);
            }   
        }
    }
    
    public void finish(Database.BatchableContext BC) {}
    
   /* public Static void copyToArchivedFolder(Set<Id> setOf_ConVerIds){
        
        List<ContentVersion> docList = [ SELECT Id, VersionData, Title, Description FROM ContentVersion WHERE Id IN : setOf_ConVerIds ];
        
        for(ContentVersion cv : docList){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('PUT');
            request.setBodyAsBlob(cv.VersionData);
            request.setHeader('Content-Encoding', 'UTF-8');
            request.setHeader('Connection', 'keep-alive');
            request.setHeader('ACL', 'public-read-write');
            request.setHeader('Content-Type', 'application/octet-stream');
            request.setEndpoint('callout:'+ Label.S3_Bucket +'/'+ cv.Description +'/Archived/' + cv.Title.replaceAll(' ','%20'));
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200){
                Http http_Del = new Http();
                HttpRequest request_Del = new HttpRequest();
                request_Del.setEndpoint('callout:' + Label.S3_Bucket + '/' + cv.Description + '/' + cv.Title.replaceAll(' ','%20'));
                request_Del.setMethod('DELETE');
                HttpResponse response_Del = http_Del.send(request);
            }   
        }
    }*/ 
}