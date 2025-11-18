import java.io.*;
import java.util.*;

public class SqlWriter {

    private final BufferedWriter out;
    private int schoolSeq = 1;
    private int collegeSeq = 1;
    private int deptSeq = 1;

    private final Map<String, Integer> schoolMap = new HashMap<>();
    private final Map<String, Integer> collegeMap = new HashMap<>();

    public SqlWriter(String file) throws Exception {
        this.out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF-8"));
    }

    public void processRow(Map<String, Object> row, int idx) throws IOException {

        String schoolName = nvl(row.get("kor_schl_nm"));
        String collegeName = nvl(row.get("clg_nm"));
        if (collegeName.isBlank()) collegeName = "단과대구분없음";
        String deptName = nvl(row.get("mjr_nm"));

        // --- 학교 ---
        Integer schoolId = schoolMap.get(schoolName);
        if (schoolId == null) {
            schoolId = schoolSeq++;
            schoolMap.put(schoolName, schoolId);

            write(String.format(
                    "INSERT INTO schools (id, name, country_id) VALUES (%d, '%s', 1);",
                    idx, escape(schoolName)
            ));
        }

        // --- 단과대 ---
        String key = schoolName + "|" + collegeName;
        Integer collegeId = collegeMap.get(key);
        if (collegeId == null) {
            collegeId = collegeSeq++;
            collegeMap.put(key, collegeId);

            write(String.format(
                    "INSERT INTO colleges (id, name, school_id) VALUES (%d, '%s', %d);",
                    collegeId, escape(collegeName), schoolId
            ));
        }

        // --- 학과 ---
        int deptId = deptSeq++;

        write(String.format(
                "INSERT INTO departments (id, name, college_id) VALUES (%d, '%s', %d);",
                deptId, escape(deptName), collegeId
        ));
    }

    private void write(String line) throws IOException {
        out.write(line);
        out.newLine();
    }

    private String escape(String s) {
        return s.replace("'", "''");
    }

    private String nvl(Object o) {
        return o == null ? "" : o.toString().trim();
    }

    public void close() throws IOException {
        out.close();
    }
}
