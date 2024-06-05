@isTest
private class customLookupControllerTest {

    @isTest
    static void testSearchRecords() {
        Test.startTest();
        // Test search with a valid search key
        List<SObject> result = customLookupController.searchRecords('Account');
        // Assert that the result is not null
        System.assertNotEquals(null, result);
        Test.stopTest();
    }

    @isTest
    static void testSendRecordDetails() {
        Test.startTest();
        // Test sendRecordDetails with valid parameters
        List<customLookupController.customLookupWrapper> result = customLookupController.sendRecordDetails('Account', '10', UserInfo.getUserId(), new List<String>{'Id', 'Name'});
        // Assert that the result is not null
        System.assertNotEquals(null, result);
        Test.stopTest();
    }

    @isTest
    static void testGetObjLabels() {
        Test.startTest();
        // Test getObjLabels with valid parameters
        List<String> result = customLookupController.getObjLabels('Account', UserInfo.getUserId());
        // Assert that the result is not null
        System.assertNotEquals(null, result);
        Test.stopTest();
    }
}