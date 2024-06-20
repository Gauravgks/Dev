@RestResource(urlMapping='/batch/*')
global with sharing class RestResourceUtilClass {
        
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name FROM Account WHERE Id = :accountId];//NOPMD
        return result;
    }
}