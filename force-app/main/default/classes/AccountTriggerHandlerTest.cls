@IsTest(isParallel=true)
public class AccountTriggerHandlerTest {
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
        Account parentAccount = new Account(
            Name = 'Parent Account',
            Id = TestUtils.getMockId(Schema.Account.SObjectType)
        );
    }

    private class MockDataLayer implements AccountTriggerHandler.IDataLayer {
        public Map<ID, Account> getParentAndChildAccountsMap(Set<ID> parentIds){
            return null;
        }
    }
}
