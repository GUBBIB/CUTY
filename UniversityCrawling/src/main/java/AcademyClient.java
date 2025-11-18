import java.net.URI;
import java.net.URLEncoder;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

public class AcademyClient {

    // ① 학교(대학) 목록 API
    private static final String SCHOOL_URL =
            "https://www.academyinfo.go.kr/mjrinfo/mjrinfo0430/selectList.do";

    // ② 단과대/학과 목록 API
    private static final String MAJOR_URL =
            "https://www.academyinfo.go.kr/pubinfo/pubinfo1600/selectMjrList.do";

    private final HttpClient http = HttpClient.newHttpClient();

    /**
     * 전체 학교 리스트 조회
     * - 네가 보여준 pramMap 기준으로 그대로 맞춤
     * - 이 호출 한 번으로 rn=1 ~ 1616 까지 전부 온다고 확인한 상태
     */
    public String fetchSchoolList() throws Exception {
        Map<String, String> params = new LinkedHashMap<>();
        params.put("pageindex", "");      // pramMap 그대로
        params.put("pageIdx", "01");
        params.put("schSchlDivCdArr", "");  // null → ""
        params.put("schZnCdArr", "");
        params.put("schEstbDivCdArr", "");
        params.put("schTxt", "");
        params.put("COLUMLAUNG", "KOR");
        params.put("lang", "ko-KR");
        params.put("svyYr", "2025");
        params.put("searchGbn", "0");
        params.put("searchValue", "");

        String form = buildForm(params);

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(SCHOOL_URL))
                .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                .header("X-Requested-With", "XMLHttpRequest")
                .POST(HttpRequest.BodyPublishers.ofString(form))
                .build();

        HttpResponse<String> res =
                http.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

        return res.body();
    }

    /**
     * 특정 학교(schlId)의 단과대/학과 리스트 조회
     * - pramMap 그대로 매핑
     */
    public String fetchMajors(String schoolId) throws Exception {
        Map<String, String> params = new LinkedHashMap<>();
        params.put("svyYr", "2025");
        params.put("schlId", schoolId);   // 이거만 학교마다 다르게
        params.put("pulYn", "true");
        params.put("schl_div_cd", "");
        params.put("schl_knd_cd", "");
        params.put("schlMjrId", "");
        params.put("mjrId", "");
        params.put("mjrNm", "");
        params.put("schNm", "");
        params.put("stsCode", "");
        params.put("pageIdx", "");
        params.put("dgHtDivCdArr", "");
        params.put("schMjrCharCdArr", "");
        params.put("schTxt", "");
        params.put("srsLclftCd", "");
        params.put("srsMclftCd", "");
        params.put("srsSclftCd", "");
        params.put("COLUMLAUNG", "KOR");

        String form = buildForm(params);

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(MAJOR_URL))
                .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                .header("X-Requested-With", "XMLHttpRequest")
                .POST(HttpRequest.BodyPublishers.ofString(form))
                .build();

        HttpResponse<String> res =
                http.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

        return res.body();
    }

    /** x-www-form-urlencoded 바디 만들기 */
    private String buildForm(Map<String, String> map) {
        StringBuilder sb = new StringBuilder();
        for (var e : map.entrySet()) {
            if (sb.length() > 0) sb.append("&");
            sb.append(URLEncoder.encode(e.getKey(), StandardCharsets.UTF_8));
            sb.append("=");
            sb.append(URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8));
        }
        return sb.toString();
    }
}
