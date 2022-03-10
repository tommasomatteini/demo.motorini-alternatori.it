package it.motorinialternatori.demo.core;

import io.github.cdimascio.dotenv.Dotenv;
import org.jetbrains.annotations.NotNull;

/**
 *
 */
public final class Variables {

    private static String defalutLang = "en";
    private static Dotenv dotenv;

    /**
     *
     */
    static {
        Variables.dotenv = Dotenv.load();
    }

    /**
     *
     * @param lang ...
     */
    public static void setDefault(@NotNull String lang) {
        Variables.defalutLang = lang;
    }

    public String lang = null;

    /**
     *
     */
    public Variables() {
        this.lang = Variables.defalutLang;
    }

    /**
     *
     * @param lang ...
     */
    public Variables(String lang) {
        this.lang = lang;
    }

    /**
     *
     *
     * @param string ...
     * @return String
     */
    public String get(@NotNull String string) {
        if (Variables.defalutLang == null || Variables.defalutLang.equals(this.lang)) return Variables.dotenv.get(string);
        else return Variables.dotenv.get(string + "_" + this.lang);
    }

}
