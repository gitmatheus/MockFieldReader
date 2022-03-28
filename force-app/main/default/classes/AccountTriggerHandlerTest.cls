@IsTest(isParallel=true)
private class AccountTriggerHandlerTest {
    private static MockDataLayer mockDataLayer;
    private static AccountTriggerHandler testedClass;
    private static MockFieldReader mockFieldReader;

    static {
        mockDataLayer = new MockDataLayer();
        mockFieldReader = new MockFieldReader();

        // Passes the mock data layer and the mock field reader to the constructor
        testedClass = new AccountTriggerHandler(
            mockDataLayer,
            mockFieldReader
        );
    }

    @IsTest
    static void testBeforeUpdate() {
        String parentWebsite     = 'https://matheus.dev';
        String childAccountExtId = 'child_account_01';
        String expectedURL = parentWebsite + '/' + childAccountExtId;

        Account oldRecord = new Account(
            Name = 'Parent Account',
            Id = TestUtils.getMockId(Schema.Account.SObjectType),
            Website = null,
            Latest_Child_URL__c = null
        );

        // Clones it preserving the ID
        mockDataLayer.parentAccount = oldRecord.clone(true);
        // Updates the Website to trigger the change
        mockDataLayer.parentAccount.Website = parentWebsite;


        mockDataLayer.childAccount = new Account(
            Name = 'Child Account',
            Id = TestUtils.getMockId(Schema.Account.SObjectType),
            Parent_Account__c = mockDataLayer.parentAccount.Id,
            External_ID__c = childAccountExtId
        );

        // ====================================================================
        // Time to mock the nonwritable fields:
        // ====================================================================

        // First, the formula field on the child object:
        mockFieldReader.addValueToField(
            mockDataLayer.childAccount,
            'External_URL__c',
            expectedURL
        );

        // Then, the nonwritable child relationship
        mockFieldReader.addValueToField(
            mockDataLayer.parentAccount, 
            'Child_Accounts__r', 
            new List<Account>{mockDataLayer.childAccount}
        );

        // ====================================================================

        // Now we run the tests with the mock data:
        Test.startTest();

            testedClass.beforeUpdate(
                new List<Account>{ oldRecord },
                new Map<ID, Account>( new List<Account>{oldRecord} ),
                new List<Account>{ mockDataLayer.parentAccount},
                new Map<ID, Account>( new List<Account>{ mockDataLayer.parentAccount })
            );

        Test.stopTest();

        // Run the assertions: 
        System.assertEquals(
            expectedURL, 
            mockDataLayer.parentAccount.Latest_Child_URL__c,
            'The parent account was not updated correctly with the URL from the child record'
        );
        
    }

    private class MockDataLayer implements AccountTriggerHandler.IDataLayer {
        Account parentAccount = new Account();
        Account childAccount = new Account();

        public Map<ID, Account> getParentAndChildAccountsMap(Set<ID> parentIds){
            return new Map<ID, Account>(
                new List<Account>{parentAccount}
            );
        }
    }
}
