# Mock Field Reader

A while ago we explored the [Mock Data Layer Pattern](https://github.com/gitmatheus/Mock-Data-Layer-Pattern), which allows us to mock virtually any relationships between records within your tests. This is especially handy when trying to improve the performance of these tests - more details on [matheus.dev](https://matheus.dev/unit-test-mock-relationships-apex/).

Now, how can we mock formula fields and <strong>non-writable</strong> child relationships if they are, well, non-writable fields? 

## Mocking field values using a Mock Field Reader

For this exploratory project, we will use a *not-so-realistic* scenario with parent and child accounts, but the intent is to create a test for the Account Trigger Handler that will use a <strong>Mock Field Reader</strong> and a <strong>Mock Data Layer</strong>.

The <strong>Mock Field Reader</strong> will be used so we can mock two <strong>non-writable</strong> fields on the Account object.

- `Child_Accounts__r`, a non-writable child relationship on the parent record
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

<h3>Show me the code!</h3>

First, let's create an interface with the required methods for the Field Reader: 

````
public interface IFieldReader {
    Object getFieldValue(SObject record, String fieldName);
    SObject getFieldRecord(SObject record, String fieldName);
    List<SObject> getFieldRecords(SObject record, String fieldName);
}
````


Using this interface, let's create a class that reads values from a <code>SObject</code> record:

````
public class FieldReader implements IFieldReader {
    
    // Retrieves a value from a field, as an object
    public Object getFieldValue(SObject record, String fieldName) {
        return record.get(fieldName);
    }

    // Retrieves a value from a field, as a SObject
    public SObject getFieldRecord(SObject record, String fieldName) {
        return record.getSObject(fieldName);
    }

    // Retrieves a value from a field, as a List of SObject
    public List<SObject> getFieldRecords(SObject record, String fieldName) {
        return record.getSObjects(fieldName);
    }
}
````

Also, using this interface, the class `MockFieldReader` will non-writable fields to be mocked, like a child relationship or formula fields.

````
public class MockFieldReader implements IFieldReader {
    // Map of value stored in a field by Id
    private Map<Id, Map<String, Object>> fieldValuesByIdMap = new Map<Id, Map<String, Object>>();
    
    public Object getFieldValue(SObject record, String fieldName) {
      ... 
    }

     // Get a value of a field as an SObject
     public SObject getFieldRecord(SObject record, String fieldName) {
        return (SObject)getFieldValue(record, fieldName);
    }

    // Get a value of a field as a List of SObjects
    public List<SObject> getFieldRecords(SObject record, String fieldName) {
        return (List<SObject>)getFieldValue(record, fieldName);
    }

    // Adds a value to a field by Id
    public void addValueToField(SObject record, String field, Object value) {
        ...
    }
}
````

<h4>Getters</h4>

Some things to notice here:

<code>public Object getFieldValue(SObject record, String fieldName)</code>

This method is the one used to retrieve the mock values of formula fields. It returns an <code>Object</code> that can later be casted as different types, such as <code>String</code>, <code>Number</code>, <code>Id</code>, etc. 

<code>public SObject getFieldRecord(SObject record, String fieldName)</code>

This method is the one used to retrieve the mock values that represent a single record. It returns an <code>SObject</code>.

<code>public List<SObject> getFieldRecords(SObject record, String fieldName)</code>

This method is the one used to retrieve the mock values that represent a list of records, such as a child relationship. It returns a list of <code>SObjects</code>.

<h4>Setter</h4>

There's only one method used to set the values:

<code>public void addValueToField(SObject record, String field, Object value)</code>

This method adds the field/value pair to a map of mocked values, indexed by the record Id.

<h4>Examples</h4>

In the <a href="https://github.com/gitmatheus/MockFieldReader" target="_blank" rel="noopener">repository on Github</a> you will find a trigger handler class and its respective test class with the usage of this Mock Field Reader. 

<strong>Snippet from the AccountTriggerHandler</strong>: pay attention to how the following methods are being used:

<code>fieldReader.getFieldRecords(parentAndChildAccount, 'Child_Accounts__r');</code>
    
<code>fieldReader.getFieldValue(latestChild, 'External_URL__c');</code>

````
// Snippet from the AccountTriggerHandler

    ...

    // Child_Accounts__r is a nonwritable child relationship
    // Uses the field reader to retrieve the list of child records:
    List<Account> childRecords =
        fieldReader.getFieldRecords(parentAndChildAccount, 'Child_Accounts__r');

    if (childRecords != null && !childRecords.isEmpty()) {    
        Account latestChild = childRecords[0];

        // Updates the field Latest Child URL with the value from External_URL__c
        // External_URL__c is a formula field (nonwritable string)
        newRecord.Latest_Child_URL__c = 
            (String)fieldReader.getFieldValue(latestChild, 'External_URL__c');
    } 


````

And in the <strong>AccountTriggerHandlerTest</strong> you can see how these non-writable fields can be mocked:

````
    // Snippet from AccountTriggerHandlerTest

    ...
    mockDataLayer = new MockDataLayer();
    mockFieldReader = new MockFieldReader();
    ...

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
````

With this code and the Mock Field Reader, it becomes easy to mock non-writable fields used in the tests. 

I hope that helps!
