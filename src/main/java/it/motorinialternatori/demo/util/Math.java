package it.motorinialternatori.demo.util;

public class Math {

    /**
     *
     * @param value ...
     * @return ...
     */
    public static boolean isInteger(String value) {
        try {
            Integer.parseInt(value);
            return true;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

}
