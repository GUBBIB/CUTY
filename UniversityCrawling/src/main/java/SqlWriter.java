import java.io.Closeable;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class SqlWriter implements Closeable {

    private final PrintWriter out;

    private int schoolSeq = 1;
    private int collegeSeq = 1;
    private int deptSeq = 1;

    private final Map<String, Integer> schoolIdMap = new HashMap<>();   
    private final Map<String, Integer> collegeIdMap = new HashMap<>();  
    private final Map<String, Integer> deptIdMap = new HashMap<>();   

    public SqlWriter(String filePath) throws IOException {
        this.out = new PrintWriter(new OutputStreamWriter(
                new FileOutputStream(filePath), "UTF-8"
        ));

        writeHeader();
    }

    private void writeHeader() {
        out.println("-- Generated SQL for schools / colleges / departments");
        out.println("SET NAMES utf8mb4;");
        out.println();
    }

    public void processRow(Map<String, Object> schoolRow,
                           Map<String, Object> majorRow) {

        if (schoolRow == null || majorRow == null) return;

        // ======================
        // 1) 학교(schools) 처리
        // ======================
        String schlId = String.valueOf(schoolRow.get("schl_id"));       // 예: "0000046"
        String schoolName = stringOrEmpty(schoolRow.get("schl_full_nm"));

        // 이 schl_id가 처음 등장하면 schools에 INSERT
        int schoolPk = schoolIdMap.computeIfAbsent(schlId, id -> {
            int newId = schoolSeq++;

            String sql = String.format(
                    "INSERT INTO schools(id, name, country_id, created_at, updated_at, deleted_at) " +
                    "VALUES(%d, '%s', %d, now(), now(), null);",
                    newId,
                    escape(schoolName),
                    1 // country_id는 1로 고정
            );
            out.println(sql);
            return newId;
        });

        // =========================
        // 2) 단과대(colleges) 처리
        // =========================
        String collegeName = stringOrEmpty(majorRow.get("clg_nm"));
        if (collegeName.isEmpty()) {
            // 단과대명이 비어있으면 "단과대 구분 없음"으로 강제
            collegeName = "단과대 구분 없음";
        }

        // 같은 학교 안에서 단과대 이름이 같으면 같은 college로 취급
        String collegeKey = schlId + "|" + collegeName;

        int collegePk = collegeIdMap.computeIfAbsent(collegeKey, key -> {
            int newId = collegeSeq++;

            String sql = String.format(
                    "INSERT INTO colleges(id, name, school_id, created_at, updated_at, deleted_at) " +
                    "VALUES(%d, '%s', %d, now(), now(), null);",
                    newId,
                    escape(collegeName),
                    schoolPk
            );
            out.println(sql);
            return newId;
        });

        // ===========================
        // 3) 학과(departments) 처리
        // ===========================
        String deptName = stringOrEmpty(majorRow.get("mjr_nm"));        // 전공명 (학과명)
        String schlMjrId = stringOrEmpty(majorRow.get("schl_mjr_id"));  // 학교-전공 ID (중복 체크용)

        // 만약 중복 학과를 완전히 허용하고 싶으면 deptIdMap을 안 쓰고 그냥 매번 INSERT 해도 됨.
        // 여기서는 schl_mjr_id 기준으로 한 번만 INSERT 하도록 처리.
        if (!schlMjrId.isEmpty() && deptIdMap.containsKey(schlMjrId)) {
            // 이미 같은 schl_mjr_id로 학과를 추가한 적 있으면 스킵
            return;
        }

        int deptPk = deptSeq++;

        String deptSql = String.format(
                "INSERT INTO departments(id, name, college_id, created_at, updated_at, deleted_at) " +
                "VALUES(%d, '%s', %d, now(), now(), null);",
                deptPk,
                escape(deptName),
                collegePk
        );
        out.println(deptSql);

        if (!schlMjrId.isEmpty()) {
            deptIdMap.put(schlMjrId, deptPk);
        }
    }

    /** Object -> String 변환 (null 방지) */
    private String stringOrEmpty(Object o) {
        if (o == null) return "";
        return String.valueOf(o);
    }

    /** SQL용 작은따옴표 이스케이프 */
    private String escape(String s) {
        if (s == null) return "";
        return s.replace("'", "''");
    }

    @Override
    public void close() {
        out.flush();
        out.close();
    }
}
