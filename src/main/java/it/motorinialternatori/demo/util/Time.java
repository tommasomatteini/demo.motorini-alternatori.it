package it.motorinialternatori.demo.util;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;

public class Time {

    /**
     *
     * @param timestamp ...
     * @param zoneId ...
     * @return ...
     */
    public static LocalDate tsToLocalDate(long timestamp, ZoneId zoneId) {
        return Instant.ofEpochMilli(timestamp).atZone(zoneId).toLocalDate();
    }

    /**
     *
     * @param timestamp ...
     * @return ...
     */
    public static LocalDate tsToLocalDate(long timestamp) {
        ZoneId zoneId = ZoneId.systemDefault();
        return Instant.ofEpochMilli(timestamp).atZone(zoneId).toLocalDate();
    }

}
