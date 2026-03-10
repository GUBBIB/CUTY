import java.util.*;
import java.io.*;

public class Main {

    private static final String OUTPUT_FILE = "result.sql";

    public static void main(String[] args) throws Exception {

        AcademyClient client = new AcademyClient();
        SqlWriter writer = new SqlWriter(OUTPUT_FILE);

        List<Map<String, Object>> schoolList = fetchAllSchools(client);

        System.out.println("Total number of schools: " + schoolList.size());
        int i = 1;

        for (Map<String, Object> school : schoolList) {
            String schlId = (String) school.get("schl_id");
            String schoolName = (String) school.get("schl_full_nm");

            System.out.println("Processing school: " + schlId + " / " + schoolName);

            String majorJson = client.fetchMajors(schlId);
            List<Map<String, Object>> majors = JsonUtils.extractResultList(majorJson);

            System.out.println((i++) + " - Total number of majors: " + majors.size());

            if (majors.isEmpty()) {
                writer.processRow(school, null);
            } else {
                for (Map<String, Object> major : majors) {
                    writer.processRow(school, major);
                }
            }
        }

        writer.close();
        System.out.println("Finished! Saved to -> " + OUTPUT_FILE);
    }

    private static List<Map<String, Object>> fetchAllSchools(AcademyClient client) throws Exception {

        String json = client.fetchSchoolList();
        return JsonUtils.extractResultList(json);
    }
}