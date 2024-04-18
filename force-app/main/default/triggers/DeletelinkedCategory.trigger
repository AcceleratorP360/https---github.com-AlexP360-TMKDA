trigger DeletelinkedCategory on P360_DA_DD_Categories_Linkage__c (after delete) {
    set<id> linkedDueDeliganceIds= new set<id>();
    for(P360_DA_DD_Categories_Linkage__c catLink: trigger.old){
        linkedDueDeliganceIds.add(catLink.P360_DA_Linked_Due_Diligence_Name__c);
    }
    Map<id,List<P360_DA_DD_Categories_Linkage__c>> dueDeleDDCatLinkedMap = new Map<id,List<P360_DA_DD_Categories_Linkage__c>>();
    if(linkedDueDeliganceIds.size()>0){
        List<P360_DA_DD_Categories_Linkage__c> ddCatLinkageRecords=[Select id,P360_DA_Linked_Due_Diligence_Name__c,LinkedCompletionMarker__c From P360_DA_DD_Categories_Linkage__c where P360_DA_Linked_Due_Diligence_Name__c IN :linkedDueDeliganceIds];
        if(ddCatLinkageRecords.size()>0){
            for(P360_DA_DD_Categories_Linkage__c ddCatLinkage:ddCatLinkageRecords){
                if(dueDeleDDCatLinkedMap.containsKey(ddCatLinkage.P360_DA_Linked_Due_Diligence_Name__c)){
                    List<P360_DA_DD_Categories_Linkage__c> addDDCatLink = dueDeleDDCatLinkedMap.get(ddCatLinkage.P360_DA_Linked_Due_Diligence_Name__c);
                    addDDCatLink.add(ddCatLinkage);
                    dueDeleDDCatLinkedMap.put(ddCatLinkage.P360_DA_Linked_Due_Diligence_Name__c,addDDCatLink);
                }else{
                    dueDeleDDCatLinkedMap.put(ddCatLinkage.P360_DA_Linked_Due_Diligence_Name__c,new List<P360_DA_DD_Categories_Linkage__c>{ddCatLinkage});
                }
            }
        }
        
        List<P360_Due_Diligence__c> dueDiliganceRecords = [Select Id,LinkRecordCount__c,LinkCompletionCount__c From P360_Due_Diligence__c Where Id IN:linkedDueDeliganceIds];
        List<P360_Due_Diligence__c> updateDueDiligance = new List<P360_Due_Diligence__c>();
        if(dueDiliganceRecords.size()>0){
            for(P360_Due_Diligence__c dueDiligance:dueDiliganceRecords){
                if(dueDeleDDCatLinkedMap.containsKey(dueDiligance.Id)){
                    integer recordCount = 0;
                    integer recordCompletionCount = 0;
                    for(P360_DA_DD_Categories_Linkage__c ddcatLink: dueDeleDDCatLinkedMap.get(dueDiligance.Id)){
                        recordCount++;
                        if(ddcatLink.LinkedCompletionMarker__c=='Completed'||ddcatLink.LinkedCompletionMarker__c=='Completed with missing information'){
                            recordCompletionCount++;
                        }
                    }
                    dueDiligance.LinkRecordCount__c=recordCount;
                    dueDiligance.LinkCompletionCount__c=recordCompletionCount;
                    updateDueDiligance.add(dueDiligance);
                }
            }
            if(updateDueDiligance.size()>0){
                update updateDueDiligance;
            }
            
        }
    }
    
    
}