public class wrapperCustomObjCtrCmp {    
   
    public class wrapperCustomClass{
        @AuraEnabled
        public string studentName;
        @AuraEnabled
        public string studentEmail;
        @AuraEnabled
        public string studentAddress;
        @AuraEnabled
        public Id recStudentId;
        @AuraEnabled
        public boolean checkAttachFile= false;
        
        public wrapperCustomClass(string studentName, string studentEmail, string studentAddress, Id recStudentId,boolean checkAttachFile){
         this.studentName = studentName;
         this.studentEmail = studentEmail;
         this.studentAddress = studentAddress;  
         this.recStudentId = recStudentId;  
         this.checkAttachFile=checkAttachFile;
        }
    }
    
    
    @AuraEnabled
    public static List<wrapperCustomClass> appCustomWrapListMthd(){
       List<P360_Review_Area__c> newStudent = new List<P360_Review_Area__c>();       
       List<wrapperCustomClass> custWrapObj = new  List<wrapperCustomClass>();
       List<P360_Review_Area__c> newStudentView =[SELECT Id,P360_Scope_of_DD_Review__c,P360_Assessment__c,P360_DD_Sub_Category__c,P360_Evidence_file_path__c,P360_Completion_Marker__c,P360_Summary__c,Name FROM P360_Review_Area__c];
        
        Map<Id,contentdocumentlink> projCheckIdDocMap = new Map<Id,contentdocumentlink> ();
        Set<Id> projChecklistIdSet= new Set<Id> ();
        for(P360_Review_Area__c de: newStudentView) {
            projChecklistIdSet.add(de.Id);
        }
        List<Contentdocumentlink> listDocs = [select Id,LinkedEntityId from contentdocumentlink where LinkedEntityId IN :projChecklistIdSet
                                              ];
        for(Contentdocumentlink doc: listDocs) {
          projCheckIdDocMap.put(doc.LinkedEntityId, doc); 
        }     
        
        boolean hasAttch= false;
        for(P360_Review_Area__c studentObj:newStudentView){
        
            if(projCheckIdDocMap.get(studentObj.Id)!=null){
                hasAttch=true;
                system.debug('hasAttch###' + hasAttch);
                
            }else{
                 hasAttch=false;
            }            
         custWrapObj.add(new wrapperCustomClass(studentObj.Name,studentObj.P360_Assessment__c, studentObj.P360_Completion_Marker__c,studentObj.Id, hasAttch));                       
        }
        return custWrapObj;     
    }
 }