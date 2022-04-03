package it.motorinialternatori.demo.models;

public class VehicleManufacturer {

    private final int id;
    private final String name;

    public VehicleManufacturer(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId(){
        return this.id;
    }

    public String getName(){
        return this.name;
    }

}
