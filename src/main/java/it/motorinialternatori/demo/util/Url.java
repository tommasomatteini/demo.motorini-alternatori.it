package it.motorinialternatori.demo.util;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Url {

    /**
     *
     * @param request ...
     * @param pattern ...
     * @return ...
     */
    public static ArrayList<String> getParams(HttpServletRequest request, String pattern) {
        ArrayList<String> res = new ArrayList<>();
        String path = request.getPathInfo();
        if (path != null) {
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(path);
            try {
                if (m.find()) {
                    for (int i = 1; i <= m.groupCount(); i++) {
                        res.add(String.valueOf(m.group(i)));
                    }
                }
            } catch (Exception exception) {
                System.out.println(exception.getMessage());
            }
        }
        return res;
    }

}
