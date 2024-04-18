public class P360DA_CustomLookUpCtrl {

    @AuraEnabled(cacheable=true)
	public static List <sObject> searchLookupData(String searchKey ,String sObjectApiName) {    
		
		List < sObject > returnList = new List < sObject > ();
		String sWildCardText = '%' + searchKey + '%';
		String sQuery = 'SELECT Id,Name FROM ' + sObjectApiName + ' WHERE Name LIKE : sWildCardText ORDER BY createdDate DESC LIMIT 5';
		
		if(!String.isBlank(sQuery))
		{
			for (sObject obj: database.query(sQuery)) {
				returnList.add(obj);
			}
		}

		return returnList;
	}

	@AuraEnabled
	public static sObject searchDefaultRecord(string recordId , string sObjectApiName) {
		string sRecId = recordId;    
		string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
		for (sObject obj: database.query(sQuery)) {
			return obj;
		}
		return null;
	}
	
	@AuraEnabled(cacheable=true)
    public static String getLookupObjectList(String sObjectName, String fieldName){
        List<String> referencedObjects = new List<String>();

        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(sObjectName).getDescribe();

        Schema.DescribeFieldResult fieldDescribe = objDescribe.fields.getMap().get(fieldName).getDescribe();

        for (Schema.SObjectType referencedObjectType : fieldDescribe.getReferenceTo()) {
            String name = referencedObjectType.getDescribe().getName();
            referencedObjects.add(name);
        }
        System.debug(referencedObjects);

        return JSON.serialize(referencedObjects);
    }

}