public class FileController {
    @AuraEnabled(cacheable=true)
    public static FilesWrapper[] getFilesList(Id recordId) {
        FilesWrapper[] filesList = new List<FilesWrapper>{};
            for (ContentDocumentLink link : [
                SELECT
                ContentDocumentId,
                ContentDocument.LatestPublishedVersion.FileType,
                ContentDocument.LatestPublishedVersion.Title,
                ContentDocument.LatestPublishedVersion.Description,
                ContentDocument.LatestPublishedVersion.CreatedDate,
                ContentDocument.LatestPublishedVersion.CreatedBy.Name
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :recordId
            ]) {
                filesList.add(
                    new FilesWrapper(
                        link.ContentDocumentId,
                        link.ContentDocument.LatestPublishedVersion.Title,
                        link.ContentDocument.LatestPublishedVersion.Description,
                        link.ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                        Date.valueOf(link.ContentDocument.LatestPublishedVersion.CreatedDate),
                        link.ContentDocument.LatestPublishedVersionId
                    )
                );
            }
        return filesList;
    } 
    
    @AuraEnabled
    public static FileVersionWrapper[] getFileVersionDetails(Id fileId) {
        FileVersionWrapper[] contentversions = new List<FileVersionWrapper>{};
            for (ContentVersion cv : [SELECT id,title,Description,createddate, createdby.name,FileType ,FileExtension,ReasonForChange FROM ContentVersion WHERE ContentDocumentId = :fileId]) {
                contentVersions.add(new FileVersionWrapper(cv.id, cv.title,cv.Description, cv.createdby.name, Date.valueOf(cv.createddate),cv.Description,cv.FileType,cv.ReasonForChange));
            }
        return contentVersions;
    } 
    
     public virtual class File{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String title { get; set; }
              @AuraEnabled
        public String Description { get; set; }
        @AuraEnabled
        public String createdBy { get; set; }
        @AuraEnabled
        public Date createdDate { get; set; }
        public File(String id, String title, String Description, String createdBy, Date createdDate) {
            this.id = id;
            this.title = title;
            this.Description = Description;
            this.createdBy = createdBy;
            this.createdDate = createdDate;
        }
    }
    
    public class FilesWrapper extends File{
        @AuraEnabled
        public String latestVersionId { get; set; }
        
        public FilesWrapper(String id, String title, string Description,String createdBy, Date createdDate, String latestVersionId) {
           	super(id, title, Description, createdBy, createdDate);
            this.latestVersionId = latestVersionId;
        }
    }
    
    public class FileVersionWrapper extends File{
       	@AuraEnabled
        public String reasonForChange { get; set; }
        @AuraEnabled
        public String contentUrl { get; set; }
        public FileVersionWrapper(String id, String title, string Description,String createdBy, Date createdDate, string FileType, String reasonForChange,string contentUrl) {
           	super(id, title, Description, createdBy, createdDate);
            this.reasonForChange = reasonForChange;
            this.contentUrl=contentUrl;
        }
    } 
    
    @AuraEnabled
    public static Id createContentDocLink(Id contentVersionId, Id recordId) {
        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId].ContentDocumentId;
        insert new ContentDocumentLink(ContentDocumentId = docId, LinkedEntityId = recordId);
        return docId;
    }
     @AuraEnabled
       public static boolean updaterecord(List<ContentVersion> acclist){
        try {
            update acclist;
            return true;
        } catch(Exception e) {
            return false;
        }
    }
   
}