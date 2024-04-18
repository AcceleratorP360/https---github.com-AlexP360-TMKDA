public class DeleteDuplicateReviewLinkageCtrl {
    
    public static void deleteReviwAreaLinkage(List < P360_Review_Area__c > revieLinkList) {
        
        Set<Id> setOfReviewIds = new Set<Id>();
        for(P360_Review_Area__c reviewRecrd : revieLinkList){
            setOfReviewIds.add(reviewRecrd.Id);
        }
        
        List<P360_DA_DD_Review_Area_Linkage__c> reviewList = [
            SELECT Id FROM P360_DA_DD_Review_Area_Linkage__c WHERE P360_DA_Review_Area_Name__c =: setOfReviewIds
        ];
        
        if(!reviewList.isEmpty()){
            delete reviewList;
        }
    }
}