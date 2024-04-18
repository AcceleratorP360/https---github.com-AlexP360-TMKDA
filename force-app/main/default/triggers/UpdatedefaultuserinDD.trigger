/*trigger to Update the OOS reviewer default to Current User
trigger will work for after Insert and After Update of record*/

trigger UpdatedefaultuserinDD on P360_Due_Diligence__c (before insert) {

//  user defaultuser = [select id from user where name = 'default user'];

  for (P360_Due_Diligence__c record:trigger.new) {

    if(record.TMKDA_OOS_reviewer__c ==null) {

      record.TMKDA_OOS_reviewer__c = userinfo.getUserId();

    }

  }

}