package it.motorinialternatori.demo.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import io.goodforgod.gson.configuration.serializer.YearMonthSerializer;
import it.motorinialternatori.demo.core.Sql;
import it.motorinialternatori.demo.models.VehicleManufacturer;
import it.motorinialternatori.demo.models.VehicleModel;
import it.motorinialternatori.demo.models.VehicleType;
import it.motorinialternatori.demo.util.Math;
import it.motorinialternatori.demo.util.Time;
import it.motorinialternatori.demo.util.Url;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Collection;

@WebServlet(name = "apiTypesServlet", value = "/api/types/*")
public class VehicleTypeServlet extends HttpServlet {

    /**
     *
     */
    public void init() {

    }

    /**
     *
     * @param id ...
     * @return ...
     */
    private static Collection<VehicleType> getVehicleTypes(int id) {

        Collection<VehicleType> types = new ArrayList<VehicleType>();

        Sql database = new Sql("jdbc/motorinialternatori");
        Connection connection = database.getConnection();

        try {
            String sql = "SELECT " +
                    " veicoli_tipi.id AS id, " +
                    " veicoli_tipi.description AS name, " +
                    " IF(veicoli_tipi._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._from, '%Y-%m-01')) AS _from, " +
                    " IF(veicoli_tipi._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._to, '%Y-%m-01')) AS _to, " +
                    " CAST(veicoli_tipi.engine_hp AS UNSIGNED) AS hp, " +
                    " CAST(veicoli_tipi.engine_kw AS UNSIGNED) AS kw, " +
                    " veicoli_tipi.fuel_type AS fuel_type, " +
                    " veicoli_modelli.id AS id_modello, " +
                    " veicoli_modelli.description AS name_modello, " +
                    " IF(veicoli_modelli._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._from, '%Y-%m-01')) AS _from__modello, " +
                    " IF(veicoli_modelli._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._to, '%Y-%m-01')) AS _to__modello, " +
                    " veicoli_serie.name AS name_serie, " +
                    " veicoli_marche.id AS id_marca, " +
                    " veicoli_marche.description AS name_marca " +
                    "FROM " +
                    " tecdoc.veicoli_tipi\n" +
                    "JOIN tecdoc.veicoli_modelli ON veicoli_modelli.id = veicoli_tipi.id_modello " +
                    "JOIN tecdoc.veicoli_serie ON veicoli_modelli.id = veicoli_serie.id_modello " +
                    "JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id " +
                    "WHERE " +
                    " veicoli_tipi.id_modello = ? " +
                    "ORDER BY " +
                    " fuel_type, name";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {

                VehicleManufacturer vehicleManufacturer = new VehicleManufacturer(resultSet.getInt("id_marca"), resultSet.getString("name_marca"));
                VehicleModel vehicleModel = new VehicleModel(vehicleManufacturer, resultSet.getInt("id_modello"), resultSet.getString("name_modello"));

                Date from_model = resultSet.getDate("_from__modello");
                if (from_model != null) vehicleModel.setFrom(YearMonth.from(Time.tsToLocalDate(from_model.getTime()))); // Must be converted to LocalDate: the extraction to YearMonth is only permitted if the temporal object has an ISO chronology, or can be converted to a LocalDate; see https://docs.oracle.com/javase/8/docs/api/java/time/YearMonth.html#from-java.time.temporal.TemporalAccessor-

                Date to_model = resultSet.getDate("_to__modello");
                if (to_model != null) vehicleModel.setTo(YearMonth.from(Time.tsToLocalDate(to_model.getTime())));

                vehicleModel.setSeries(resultSet.getString("name_serie"));

                VehicleType vehicleType = new VehicleType(vehicleModel, resultSet.getInt("id"), resultSet.getString("name"));

                Date from = resultSet.getDate("_from");
                if (from != null) vehicleType.setFrom(YearMonth.from(Time.tsToLocalDate(from.getTime())));

                Date to = resultSet.getDate("_to");
                if (to != null) vehicleType.setTo(YearMonth.from(Time.tsToLocalDate(to.getTime())));

                vehicleType.setProperty("hp", resultSet.getString("hp"));
                vehicleType.setProperty("kw", resultSet.getString("kw"));
                vehicleType.setProperty("fuel_type", resultSet.getString("fuel_type"));

                types.add(vehicleType);
            }
            connection.close();
        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return types;

    }

    /**
     *
     * @param request ...
     * @param response ...
     * @throws IOException ...
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        ArrayList<String> params = Url.getParams(request, "^/([0-9]+)$");
        String id = null;

        try {
            id = params.get(0);
        } catch(Exception exception) {}

        if (id != null && Math.isInteger(id)) {

            Gson gson = new GsonBuilder().registerTypeAdapter(java.time.YearMonth.class, YearMonthSerializer.INSTANCE).create();
            String jsonString = gson.toJson(getVehicleTypes(Integer.parseInt(id)));

            out.print(jsonString);

        } else {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            out.print("400 Bad Request");

        }
        out.flush();

    }

    /**
     *
     */
    public void destroy() {

    }

}
