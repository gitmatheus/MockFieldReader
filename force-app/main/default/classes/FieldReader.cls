public class FieldReader implements IFieldReader {
    
    // Retrieves a value from a field, as an object
    public Object getFieldValue(SObject record, String fieldName) {
        return record.get(fieldName);
    }
}