package it.motorinialternatori.demo.api;

import java.io.*;
import java.sql.*;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Collection;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import io.goodforgod.gson.configuration.serializer.YearMonthSerializer;
import it.motorinialternatori.demo.core.Sql;
import it.motorinialternatori.demo.models.VehicleManufacturer;
import it.motorinialternatori.demo.models.VehicleModel;
import it.motorinialternatori.demo.util.Time;
import it.motorinialternatori.demo.util.Url;
import it.motorinialternatori.demo.util.Math;

@WebServlet(name = "apiModelsServlet", value = "/api/models/*")
public class VehicleModelsServlet extends HttpServlet {

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
    private static Collection<VehicleModel> getVehicleModels(int id) {

        Collection<VehicleModel> models = new ArrayList<VehicleModel>();

        Sql database = new Sql("jdbc/motorinialternatori");
        Connection connection = database.getConnection();
        try {
            String sql = "SELECT " +
                " marche.codice AS id_manufacturer, " +
                " modelli.codice AS id, " +
                " marche_ext.descrizione AS name_manufacturer, " +
                " modelli_ext.descrizione_it AS name, " +
                " IF(modelli.anno_inizio IS NULL OR modelli.anno_inizio = '', NULL, STR_TO_DATE(CONCAT(modelli.anno_inizio, 1), '%Y%m%d')) AS date_from, " +
                " IF(modelli.anno_fine IS NULL OR modelli.anno_fine = '', NULL, STR_TO_DATE(CONCAT(modelli.anno_fine,1), '%Y%m%d')) AS date_to " +
                "FROM " +
                " marche " +
                "INNER JOIN modelli ON ( marche.codice = modelli.marca AND marche.codice = ? ) " +
                "INNER JOIN marche_ext ON marche.codice = marche_ext.marca " +
                "INNER JOIN modelli_ext ON modelli.codice = modelli_ext.codice " +
                "WHERE EXISTS ( " +
                " SELECT " +
                "  * " +
                " FROM " +
                "  motorizzazioni, " +
                "  tipo_ricambi_generico, " +
                "  motorizzazioni_articoli " +
                " WHERE " +
                "  modelli.codice = motorizzazioni.modello " +
                " AND " +
                "  tipo_ricambi_generico.codice = motorizzazioni_articoli.articolo_generico " +
                " AND " +
                "  motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice " +
                " AND " +
                "  ( tipo_ricambi_generico.codice = 2 OR tipo_ricambi_generico.codice = 4 OR tipo_ricambi_generico.codice = 1390 OR tipo_ricambi_generico.codice = 295 OR tipo_ricambi_generico.codice = 1561 ) " +
                ") " +
                "ORDER BY " +
                " modelli.descrizione_it ASC ";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                VehicleManufacturer vehicleManufacturer = new VehicleManufacturer(resultSet.getInt("id_manufacturer"), resultSet.getString("name_manufacturer"));
                VehicleModel vehicleModel = new VehicleModel(vehicleManufacturer, resultSet.getInt("id"), resultSet.getString("name"));

                Date from = resultSet.getDate("date_from");
                if (from != null) vehicleModel.setFrom(YearMonth.from(Time.tsToLocalDate(from.getTime()))); // Must be converted to LocalDate: the extraction to YearMonth is only permitted if the temporal object has an ISO chronology, or can be converted to a LocalDate; see https://docs.oracle.com/javase/8/docs/api/java/time/YearMonth.html#from-java.time.temporal.TemporalAccessor-

                Date to = resultSet.getDate("date_to");
                if (to != null) vehicleModel.setTo(YearMonth.from(Time.tsToLocalDate(to.getTime())));

                models.add(vehicleModel);
            }
            connection.close();
        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return models;
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
            String jsonString = gson.toJson(getVehicleModels(Integer.parseInt(id)));

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
