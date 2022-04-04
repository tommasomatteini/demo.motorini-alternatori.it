package it.motorinialternatori.demo.models;

/**
 *
 */
public class VehicleManufacturer {

    private final int id;
    private final String name;

    /**
     *
     * @param id ...
     * @param name ...
     */
    public VehicleManufacturer(int id, String name) {
        this.id = id;
        this.name = name;
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

}
