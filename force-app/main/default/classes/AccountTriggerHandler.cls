public class AccountTriggerHandler {
    private IDataLayer dataLayer;
    private IFieldReader fieldReader;

    // If the mock data is not being used
    // creates new instances of the real deal
    public AccountTriggerHandler() {
        this(new DataLayer(), new FieldReader());
    }

    // If the mock data is being passed as parameters
    // then use the mock data instead
    public AccountTriggerHandler(
        IDataLayer iDataLayer,
        IFieldReader iFieldReader
    ) {
        this.dataLayer = iDataLayer;
        this.fieldReader = iFieldReader;
    }

    public void beforeUpdate(
        List<Account> oldRecords,
        Map<ID, Account> oldRecordsMap,
        List<Account> newRecords,
        Map<ID, Account> newRecordsMap
    ) {
        
        // Retrieves the map of parent and child records from the data layer
        Map<ID, Account> parentAndChildMap = 
            dataLayer.getParentAndChildAccountsMap(newRecordsMap.keySet());
        
            System.debug('parentAndChildMap: ' + parentAndChildMap);

        for (Account newRecord : newRecords) {
            Account oldRecord = oldRecordsMap.get(newRecord.Id);
            
            // If the website is being changed
            if (newRecord.Website != oldRecord.Website){
                Account parentAndChildAccount = parentAndChildMap.get(newRecord.Id);

                // Child_Accounts__r is a nonwritable child relationship
                // Uses the field reader to retrieve the list of child records:
                List<Account> childRecords =
                    fieldReader.getFieldRecords(parentAndChildAccount, 'Child_Accounts__r');

                System.debug('childRecords: ' + childRecords);

                if (childRecords != null && !childRecords.isEmpty()) {    
                    Account latestChild = childRecords[0];
                    
                    // Updates the field Latest Child URL with the value from External_URL__c
                    // External_URL__c is a formula field (nonwritable string)
                    newRecord.Latest_Child_URL__c = 
                        (String)fieldReader.getFieldValue(latestChild, 'External_URL__c');
                    
                        System.debug('newRecord.Latest_Child_URL__c: ' + newRecord.Latest_Child_URL__c);
                } 
            }
        }
    }

    public class DataLayer implements IDataLayer {
        public Map<ID, Account> getParentAndChildAccountsMap(Set<ID> parentIds) {
            return new Map<ID, Account>(
                [ SELECT Id, Name, Latest_Child_URL__c, Website,
                    // Retrives fields from the child records
                    (   SELECT Id, Name, External_URL__c
                        FROM Child_Accounts__r 
                        ORDER BY LastModifiedDate DESC
                    )
                    FROM Account
                    WHERE Id IN :parentIds
                ]
            );
        }
    }

    public interface IDataLayer {
        Map<ID, Account> getParentAndChildAccountsMap(Set<ID> parentIds);
    }

}
