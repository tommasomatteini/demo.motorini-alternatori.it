package it.motorinialternatori.demo.models;

import java.time.YearMonth;
import java.util.HashMap;
import java.util.Map;

/**
 *
 */
public class VehicleType {

    private final VehicleModel vehicleModel;
    private final int id;
    private final String name;
    private YearMonth from = null;
    private YearMonth to = null;
    private Map<String, String> properties = new HashMap<String, String>();

    /**
     *
     * @param vehicleModel ...
     * @param id ...
     * @param name ...
     */
    public VehicleType(VehicleModel vehicleModel, int id, String name) {
        this.vehicleModel = vehicleModel;
        this.id = id;
        this.name = name;
    }

    /**
     *
     * @param from ...
     */
    public void setFrom(YearMonth from) {
        this.from = from;
    }

    /**
     *
     * @param year ...
     * @param month ...
     */
    public void setFrom(int year, int month) {
        this.from = YearMonth.of(year, month);
    }

    /**
     *
     * @param to ...
     */
    public void setTo(YearMonth to) {
        this.to = to;
    }

    /**
     *
     * @param year ...
     * @param month ...
     */
    public void setTo(int year, int month) {
        this.to = YearMonth.of(year, month);
    }

    /**
     *
     * @param key ...
     * @param value ...
     */
    public void setProperty(String key, String value) { properties.put(key, value); }

    /**
     *
     * @return ...
     */
    public VehicleModel getVehicleModel(){
        return this.vehicleModel;
    }

    /**
     *
     * @return ...
     */
    public int getId(){
        return this.id;
    }

    /**
     *
     * @return ...
     */
    public String getName(){
        return this.name;
    }

    /**
     *
     * @return ...
     */
    public YearMonth getFrom() {
        return this.from;
    }

    /**
     *
     * @return ...
     */
    public YearMonth getTo() {
        return this.to;
    }

    /**
     *
     * @param key ...
     * @return ...
     */
    public String getProperty(String key) {
        return this.properties.get(key);
    }

}
