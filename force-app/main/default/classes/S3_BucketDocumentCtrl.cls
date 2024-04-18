public class S3_BucketDocumentCtrl {


    @AuraEnabled(cacheable = true)
    public Static void getDocumentFile() {

        // sending request to s3
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:'+ Label.S3_Bucket);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        String xml = res.getBody();
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        S3BucketResult bucketResult = new S3BucketResult();
        Dom.XmlNode rootElement = doc.getRootElement();
        bucketResult.Name = rootElement.getChildElement('Name', rootElement.getNamespace()).getText();

        List < String > listOfDocs = new List < String > ();
        for (Dom.XmlNode contentsNode: rootElement.getChildElements()) {
            if (contentsNode.getChildElement('Key', contentsNode.getNamespace()) <> NULL) {
                listOfDocs.add(contentsNode.getChildElement('Key', contentsNode.getNamespace()).getText());
            }
        }

        // creating libraies
        ContentWorkspace workspace = new ContentWorkspace();
        workspace.Name = bucketResult.Name;
        upsert workspace Name;
        ContentFolder cFolderRecrd = [SELECT Id FROM ContentFolder WHERE Name =: workspace.Id];

        S3_BucketBatchCtrl s3_Batch = new S3_BucketBatchCtrl(cFolderRecrd.Id, listOfDocs, workspace.Name);
        Database.executeBatch(s3_Batch);
    }

    public class S3BucketResult {

        public String Name;
        public List < S3Object > Contents {
            get;
            set;
        }

    }

    public class S3Object {

        public String Key {
            get;
            set;
        }
        public DateTime LastModified {
            get;
            set;
        }
        public String ETag {
            get;
            set;
        }
        public Integer Size {
            get;
            set;
        }
        public String StorageClass {
            get;
            set;
        }

    }
}