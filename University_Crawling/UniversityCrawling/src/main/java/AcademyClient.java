import java.net.URI;
import java.net.URLEncoder;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.util.Map;

public class AcademyClient {

    private static final String URL = "https://www.academyinfo.go.kr/pubinfo/pubinfo1600/selectMjrList.do";
    private final HttpClient http = HttpClient.newHttpClient();

    public String fetchMajors(String schoolId) throws Exception {

        String form = buildForm(Map.of(
                "svyYr", "2025",
                "schlId", schoolId,
                "pulYn", "true",
                "schl_div_cd", "02",
                "schl_knd_cd", "03",
                "COLUMLAUNG", "KOR"
        ));

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(URL))
                .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                .header("X-Requested-With", "XMLHttpRequest")
                .POST(HttpRequest.BodyPublishers.ofString(form))
                .build();

        HttpResponse<String> res =
                http.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

        return res.body();
    }

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
