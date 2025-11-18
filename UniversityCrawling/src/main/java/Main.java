import java.util.*;
import java.io.*;

public class Main {

    private static final String OUTPUT_FILE = "result.sql";

    public static void main(String[] args) throws Exception {

        AcademyClient client = new AcademyClient();
        SqlWriter writer = new SqlWriter(OUTPUT_FILE);

        List<Map<String, Object>> schoolList = fetchAllSchools(client);

        System.out.println("총 학교 수: " + schoolList.size());

        for (Map<String, Object> school : schoolList) {
            String schlId = (String) school.get("schl_id");
            String schoolName = (String) school.get("schl_full_nm");

            System.out.println("학교 처리중: " + schlId + " / " + schoolName);

            String majorJson = client.fetchMajors(schlId);
            List<Map<String, Object>> majors = JsonUtils.extractResultList(majorJson);

            // majors가 비어 있으면 그냥 넘어가기
            if (majors.isEmpty()) continue;

            for (Map<String, Object> major : majors) {
                writer.processRow(school, major);
            }
        }

        writer.close();
        System.out.println("완료! → " + OUTPUT_FILE);
    }

    private static List<Map<String, Object>> fetchAllSchools(AcademyClient client) throws Exception {

        String json = client.fetchSchoolList();
        return JsonUtils.extractResultList(json);
    }
}
