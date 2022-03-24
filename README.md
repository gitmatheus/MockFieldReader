# Mock Field Reader

A while ago we explored the [Mock Data Layer Pattern](https://github.com/gitmatheus/Mock-Data-Layer-Pattern), that allow us to mock virtually any relationships between records within your tests. This is especially handy when trying to improve the performance of these tests - more details on [matheus.dev](https://matheus.dev/unit-test-mock-relationships-apex/).

Now, how can we mock formula fields and <strong>nonwritable</strong> child relationships if they are, well, nonwritable fields? 

## Mocking field values using a Mock Field Reader

For this exploratory project, we will use a *not-so-realistic* scenario with parent and child accounts, but the intent is to create a test for the Account Trigger Handler that will use a <strong>Mock Field Reader</strong> and a <strong>Mock Data Layer</strong>.

The <strong>Mock Field Reader</strong> will be used so we can mock two <strong>nonwritable</strong> fields on the Account object.

- `Child_Accounts__r`, a nonwritable child relationship on the parent record
- `External_URL__c`, a formula field on the child record

The trigger handler logic will update the following field:
- `Parent.Latest_Child_URL__c`

Based on the following formula field:
- `Child.External_URL__c`

---

## Files used in this project

```
force-app
    main
        default
            classes
                ◦ AccountTriggerHandler.cls
                ◦ AccountTriggerHandlerTest
                ◦ FieldReader
                ◦ IFieldReader
                ◦ MockFieldReader
                ◦ TestUtils.cls
            triggers
                ◦ AccountTrigger.trigger
```

---
