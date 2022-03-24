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