public class MockFieldReader implements IFieldReader {
    // Map of value stored in a field by Id
    private Map<Id, Map<String, Object>> fieldValuesByIdMap = new Map<Id, Map<String, Object>>();
    
    // ======================================================================
    // GETTERS
    //    The following method will try to find the field name and value
    //    in the map above, and return the correct value accordingly
    // ======================================================================
    public Object getFieldValue(SObject record, String fieldName) {

        Map<String, Object> fieldToValueMap = new Map<String, Object>();
        
        // If a record Id was provided, 
        // attempts to retrive the field/value pair from the map
        if (record?.Id != null)
            fieldToValueMap = fieldValuesByIdMap.get(record.Id);

        // If the field/value pair was retrieved
        // returns the value based on the field
        Object result = (fieldToValueMap == null)
            ? null
            : fieldToValueMap.get(fieldName);

        return result;
    }

     // Get a value of a field as an SObject
     public SObject getFieldRecord(SObject record, String fieldName) {
        return (SObject)getFieldValue(record, fieldName);
    }

    // Get a value of a field as a List of SObjects
    public List<SObject> getFieldRecords(SObject record, String fieldName) {
        return (List<SObject>)getFieldValue(record, fieldName);
    }
    
    // ======================================================================
    // SETTER
    //    The following method is used to add values and fields in the map
    // ======================================================================

    // Adds a value to a field by Id
    public void addValueToField(SObject record, String field, Object value) {
        Map<String, Object> fieldToValueMap = new Map<String, Object>();
        if (record != null) {
            if (fieldValuesByIdMap.containsKey(record.Id)) {
                fieldToValueMap = fieldValuesByIdMap.get(record.Id);
            }
            fieldToValueMap.put(field, value);
            fieldValuesByIdMap.put(record.Id, fieldToValueMap);
        }
    }
}