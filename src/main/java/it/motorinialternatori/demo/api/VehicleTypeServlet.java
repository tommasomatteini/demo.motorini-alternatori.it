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
                " marche.codice AS id_manufacturer, " +
                " marche_ext.descrizione AS name_manufacturer, " +
                " modelli.codice AS id_model, " +
                " modelli_ext.descrizione_it AS name_model, " +
                " STR_TO_DATE(CONCAT(modelli.anno_inizio, 1), '%Y%m%d') AS date_from_model, " +
                " STR_TO_DATE(CONCAT(modelli.anno_fine,1), '%Y%m%d') AS date_to_model, " +
                " motorizzazioni.codice AS id, " +
                " motorizzazioni.descrizione_it AS name, " +
                " motorizzazioni.kw AS kw, " +
                " motorizzazioni.hp AS hp, " +
                " alimentazione.descrizione_it AS fuel_type, " +
                " STR_TO_DATE(CONCAT(modelli.anno_inizio, 1), '%Y%m%d') AS date_from, " +
                " STR_TO_DATE(CONCAT(modelli.anno_fine,1), '%Y%m%d') AS date_to " +
                "FROM " +
                " marche " +
                "INNER JOIN modelli ON marche.codice = modelli.marca " +
                "INNER JOIN modelli_ext ON modelli.codice = modelli_ext.codice " +
                "INNER JOIN marche_ext ON marche.codice = marche_ext.marca " +
                "INNER JOIN motorizzazioni ON modelli.codice = motorizzazioni.modello AND modelli.codice = ? " +
                "INNER JOIN alimentazione ON motorizzazioni.alimentazione = alimentazione.codice " +
                "WHERE EXISTS (" +
                " SELECT " +
                "  * " +
                " FROM " +
                "  tipo_ricambi_generico, motorizzazioni_articoli " +
                " WHERE " +
                "  tipo_ricambi_generico.codice = motorizzazioni_articoli.articolo_generico " +
                " AND " +
                "  motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice " +
                " AND " +
                "  (tipo_ricambi_generico.codice = 2 OR tipo_ricambi_generico.codice = 4 OR tipo_ricambi_generico.codice = 1390 OR tipo_ricambi_generico.codice = 295 OR tipo_ricambi_generico.codice = 1561) " +
                ")" +
                "ORDER BY " +
                " motorizzazioni.alimentazione ASC, " +
                " motorizzazioni.descrizione_it ASC;";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {

                VehicleManufacturer vehicleManufacturer = new VehicleManufacturer(resultSet.getInt("id_manufacturer"), resultSet.getString("name_manufacturer"));
                VehicleModel vehicleModel = new VehicleModel(vehicleManufacturer, resultSet.getInt("id_model"), resultSet.getString("name_model"));

                Date from_model = resultSet.getDate("date_from_model");
                if (from_model != null) vehicleModel.setFrom(YearMonth.from(Time.tsToLocalDate(from_model.getTime()))); // Must be converted to LocalDate: the extraction to YearMonth is only permitted if the temporal object has an ISO chronology, or can be converted to a LocalDate; see https://docs.oracle.com/javase/8/docs/api/java/time/YearMonth.html#from-java.time.temporal.TemporalAccessor-

                Date to_model = resultSet.getDate("date_to_model");
                if (to_model != null) vehicleModel.setTo(YearMonth.from(Time.tsToLocalDate(to_model.getTime())));

                VehicleType vehicleType = new VehicleType(vehicleModel, resultSet.getInt("id"), resultSet.getString("name"));

                Date from = resultSet.getDate("date_from");
                if (from != null) vehicleType.setFrom(YearMonth.from(Time.tsToLocalDate(from.getTime())));

                Date to = resultSet.getDate("date_to");
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
