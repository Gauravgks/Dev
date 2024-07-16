// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Account> acc = new List<Account>();

for(Integer i =0; i<=5000; i++){
    Account a = new Account();
    a.Name = 'Created for Recursion Testing' + i;
    a.Type = 'Prospect';
    acc.add(a);
}

insert acc;