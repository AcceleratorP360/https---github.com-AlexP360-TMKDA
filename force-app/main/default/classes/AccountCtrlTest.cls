@isTest
public class AccountCtrlTest {
    
     @isTest
    public static void FetchAccounts() {
        Account acc = new account();
            acc.Name = 'Test Party';
        Database.insert(acc);
        
         Test.startTest();
        List<Account> result = AccountCtrl.fetchAccounts();
        Test.stopTest();
        
    }

}