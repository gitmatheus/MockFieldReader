public class TestUtils {
    private static Integer fakeMockCounter = 1;

    public static String getMockId(Schema.SObjectType type) {
        String result = String.valueOf(fakeMockCounter++);
        return type.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }
}
