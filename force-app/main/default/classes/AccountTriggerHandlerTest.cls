public class AccountTriggerHandlerTest {
    private static MockDataLayer mockDataLayer;
    private static AccountTriggerHandler testedClass;
    private static MockFieldReader mockFieldReader;

    private class MockDataLayer implements AccountTriggerHandler.IDataLayer {
        public Map<ID, Account> getParentAndChildAccountsMap(Set<ID> parentIds){
            return null;
        }
    }

}
