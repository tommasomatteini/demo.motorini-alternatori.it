package it.motorinialternatori.demo.models;

import java.time.YearMonth;

public class VehicleModel {

    private final VehicleManufacturer vehicleManufacturer;
    private final int id;
    private final String name;
    private YearMonth from = null;
    private YearMonth to = null;

    public VehicleModel(VehicleManufacturer vehicleManufacturer, int id, String name) {
        this.vehicleManufacturer = vehicleManufacturer;
        this.id = id;
        this.name = name;
    }

    public void setFrom(YearMonth from) {
        this.from = from;
    }

    public void setFrom(int year, int month) {
        this.from = YearMonth.of(year, month);
    }

    public void setTo(YearMonth to) {
        this.to = to;
    }

    public void setTo(int year, int month) {
        this.to = YearMonth.of(year, month);
    }

    public VehicleManufacturer getVehicleManufacturer(){
        return this.vehicleManufacturer;
    }

    public int getId(){
        return this.id;
    }

    public String getName(){
        return this.name;
    }

    public YearMonth getFrom() { return this.from; }

    public YearMonth getTo() { return this.to; }

}
