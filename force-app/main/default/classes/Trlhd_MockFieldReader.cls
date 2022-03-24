public class Trlhd_MockFieldReader implements IFieldReader {
    // Map of value stored in a field by Id
    private Map<Id, Map<String, Object>> fieldValuesByIdMap = new Map<Id, Map<String, Object>>();

    // ======================================================================
    // GETTER
    //    The following method will try to find the field name and value
    //    in the map above, and return the correct value accordingly
    // ======================================================================
    public Object getFieldValue(SObject record, String fieldName) {

        Map<String, Object> fieldToValueMap = new Map<String, Object>();
        if (record != null)
            fieldToValueMap = fieldValuesByIdMap.get(record.Id);

        Object result = (fieldToValueMap == null)
            ? null
            : fieldToValueMap.get(fieldName);

        return result;
    }
    
    // ======================================================================
    // SETTER
    //    The following method is used to add values and fields in the map
    //    above
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