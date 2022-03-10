package it.motorinialternatori.demo.core;

public final class Commons {

    private static Variables env;

    /**
     *
     * @param env ...
     */
    public static void setEnv(Variables env) {
        Commons.env = env;
    }

    /**
     *
     * @param url ...
     * @return String
     */
    private String removeTrailingSlash(String url) {
        if (url.endsWith("/")) {
            url = url.substring(0, url.length() - 1);
        }
        return url;
    }

    /**
     *
     * @param url ...
     * @return String
     */
    public String assets(String url) {
        String base_url = removeTrailingSlash(Commons.env.get("APP_URL"));
        return base_url + "/assets/" + url;
    }

    /**
     *
     * @param path ...
     * @param filename ...
     * @return String
     */
    public String storage(String path, String filename) {
        String base_url = removeTrailingSlash(Commons.env.get("CDN_URL"));
        return base_url + "/" + this.removeTrailingSlash(path) + "/" + filename;
    }

}
