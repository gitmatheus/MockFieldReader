public interface IFieldReader {
    Object getFieldValue(SObject record, String fieldName);
    SObject getFieldRecord(SObject record, String fieldName);
    List<SObject> getFieldRecords(SObject record, String fieldName);
}