package it.motorinialternatori.demo.models;

import java.time.YearMonth;

/**
 *
 */
public class VehicleModel {

    private final VehicleManufacturer vehicleManufacturer;
    private final int id;
    private final String name;
    private String series;
    private YearMonth from = null;
    private YearMonth to = null;

    /**
     *
     * @param vehicleManufacturer ...
     * @param id ...
     * @param name ...
     */
    public VehicleModel(VehicleManufacturer vehicleManufacturer, int id, String name) {
        this.vehicleManufacturer = vehicleManufacturer;
        this.id = id;
        this.name = name;
    }

    /**
     *
     * @param name ...
     */
    public void setSeries(String name) {
        this.series = name;
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
     * @return ...
     */
    public VehicleManufacturer getVehicleManufacturer(){
        return this.vehicleManufacturer;
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
    public String getSeries(){
        return this.series;
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

}
