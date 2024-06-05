public class AccountHandler {
    
    public static void insertAccount(Integer newAccounts){
       
       //Creates list to store accounts
       List < Account > addAccounts = new List < Account >();
       
       Integer counter = 1;
       
       while(counter <= newAccounts){
           
           //create new account
           Account a = new Account();
           a.Name = 'Acme Inc ' + counter;
           a.AccountNumber = 'A000' + counter;
           addAccounts.add(a);
           
           //increment counter
           counter++;

       }
       //inserts all items in list
       insert addAccounts;
   }

}