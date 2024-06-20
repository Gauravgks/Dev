public class BatchPractiseStatefullAndCallOut implements Database.Batchable<sobject>,Database.AllowsCallouts, Database.Stateful{

    // Instance variable to retain the State across execute method: Learning Statefull 
    public List<Id> recordsProcessed = new List<Id>();

    public Database.QueryLocator start(Database.BatchableContext BC){//NOPMD
        return Database.getQueryLocator('SELECT Id FROM Account');
    }

    public void Execute(Database.BatchableContext BC,List<Account> accList){//NOPMD
        
        // call to ApexResource class defined in the same Org
        for(Account acc: accList){
            Http h = new Http();

            // Instantiate a new HTTP request
            // Specify request properties such as the endpoint, the POST method, etc. 
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://gksdevorg-dev-ed.develop.my.salesforce.com/services/apexrest/batch/'+ acc.Id);
            req.setMethod('GET');
            // Named Credentials are not req for same org (sessionId will work)
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());//NOPMD
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            recordsProcessed.add(acc.Id);    
        }
    }

    public void finish(Database.BatchableContext BC){//NOPMD

        // ? Pass the value to a flow to send the email to the user
        AsyncApexJob job = [Select Id, Status, CreatedBy.Email FROM AsyncApexJob WHERE ID =: BC.getJobId()];
        System.debug('Record Processed' + recordsProcessed);
        System.debug('Job Details' + job);

        if(job.Status == 'Completed'){
            // Call the flow to send the email
            system.debug('Call the Flow');
            FlowCall.Flow();
            }

    }
}