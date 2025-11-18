import java.util.*;

public class JsonUtils {

    /**
     * JSON 문자열에서 "resultList" 배열을 직접 파싱하여
     * List<Map<String, Object>> 형태로 반환.
     */
    public static List<Map<String, Object>> extractResultList(String json) {
        if (json == null || json.isEmpty()) return List.of();

        // resultList 찾기
        int idx = json.indexOf("\"resultList\"");
        if (idx == -1) return List.of();

        // resultList: [ 로 이동
        int start = json.indexOf("[", idx);
        int end = findMatchingBracket(json, start);
        if (start == -1 || end == -1) return List.of();

        String arrayContent = json.substring(start + 1, end).trim();
        if (arrayContent.isEmpty()) return List.of();

        return parseArrayOfObjects(arrayContent);
    }


    /** resultList 내부의 { ... } 오브젝트 배열 파싱 */
    private static List<Map<String, Object>> parseArrayOfObjects(String content) {
        List<Map<String, Object>> list = new ArrayList<>();

        int i = 0;
        while (i < content.length()) {
            // find '{'
            int objStart = content.indexOf("{", i);
            if (objStart == -1) break;

            int objEnd = findMatchingBracket(content, objStart);
            if (objEnd == -1) break;

            String objText = content.substring(objStart + 1, objEnd).trim();
            Map<String, Object> parsed = parseObject(objText);

            list.add(parsed);
            i = objEnd + 1;
        }
        return list;
    }


    /** { key: value } 구조 파싱 */
    private static Map<String, Object> parseObject(String objText) {
        Map<String, Object> map = new HashMap<>();

        String[] entries = objText.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");

        for (String entry : entries) {
            String[] kv = entry.split(":", 2);
            if (kv.length != 2) continue;

            String key = unquote(kv[0].trim());
            String rawValue = kv[1].trim();
            Object value = parseValue(rawValue);

            map.put(key, value);
        }

        return map;
    }


    /** JSON Value 파싱 */
    private static Object parseValue(String raw) {
        if (raw.startsWith("\"")) return unquote(raw);

        if (raw.equals("null")) return null;

        if (raw.matches("-?\\d+")) return Integer.parseInt(raw);

        if (raw.matches("-?\\d+\\.\\d+")) return Double.parseDouble(raw);

        return raw;
    }


    /** 따옴표 제거 */
    private static String unquote(String s) {
        if (s.startsWith("\"") && s.endsWith("\"")) {
            return s.substring(1, s.length() - 1);
        }
        return s;
    }


    /** 괄호 쌍 찾기 (Object `{}` 또는 Array `[]`) */
    private static int findMatchingBracket(String text, int start) {
        char open = text.charAt(start);
        char close = (open == '{') ? '}' : ']';
        int count = 0;

        for (int i = start; i < text.length(); i++) {
            if (text.charAt(i) == open) count++;
            else if (text.charAt(i) == close) count--;

            if (count == 0) return i;
        }
        return -1;
    }
}
