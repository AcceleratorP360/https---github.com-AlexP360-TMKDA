@RestResource(urlMapping = '/getParties/*')
global class Party_RestResource {
    
    @HttpGet
    global static List<PartyWrapper> getParties(){
        List<Account> accList = [ SELECT Coverholder_Id__c, Name, RecordType.Name FROM Account ];
        List<PartyWrapper> wrapList = new List<PartyWrapper>();
        for(Account accRecrd : accList){
            PartyWrapper pWrap = new PartyWrapper();
            pWrap.EntityUniqueId = accRecrd.Coverholder_Id__c;
            pWrap.EntityName = accRecrd.Name;
            pWrap.EntityType = accRecrd.RecordType.Name;
            wrapList.add(pWrap);
        }
        
        if(!wrapList.isEmpty()){
            return wrapList;
        }else{
            return null;
        }
    }
    
    global class PartyWrapper{
        
        public String EntityUniqueId;
        public String EntityName;
        public String EntityType;
        
    }
}