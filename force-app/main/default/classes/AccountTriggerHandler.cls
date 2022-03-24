public with sharing class AccountTriggerHandler {
    public void beforeInsert(List<Account> newRecords) {
        for (Account newRecord : newRecords) {
            // TBD
        }
    }

    public void beforeUpdate(
        List<Account> oldRecords,
        Map<ID, Account> oldRecordsMap,
        List<Account> newRecords,
        Map<ID, Account> newRecordsMap
    ) {
        for (Account newRecord : newRecords) {
            // TBD
        }
    }

    public class DataLayer implements IDataLayer {
        public Map<ID, Account> getParentAndChildAccountsMap(Set<ID> parentIds) {
            return new Map<ID, Account>(
                [ SELECT Id, Name, External_URL__c, Website, External_ID__c,
                    // Retrives the same fields from the child records
                    (   SELECT Id, Name, External_URL__c, Website, External_ID__c 
                        FROM Child_Accounts__r 
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
