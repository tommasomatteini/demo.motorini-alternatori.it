package it.motorinialternatori.demo.api;

import java.io.*;
import java.sql.*;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Collection;
import java.util.concurrent.TimeUnit;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

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

    public static Cache<String, Collection<VehicleModel>> cache = null;

    /**
     *
     */
    public void init() {
        if (cache == null) cache = Caffeine.newBuilder()
                .expireAfterWrite(60*60*24, TimeUnit.SECONDS)
                .maximumSize(100000)
                .build();
    }

    /**
     *
     * @param id ...
     * @return ...
     */
    private static Collection<VehicleModel> getVehicleModels(int id) {

        String cache_key = "api_models_" + String.valueOf(id);
        Collection<VehicleModel> models = cache.getIfPresent(cache_key);

        if (models == null) {

            models = new ArrayList<>();

            Sql database = new Sql("jdbc/motorinialternatori");
            Connection connection = database.getConnection();
            try {
                String sql = "SELECT " +
                        " veicoli_marche.id AS id_marca, " +
                        " veicoli_marche.description AS name_marca, " +
                        " veicoli_modelli.id AS id, " +
                        " veicoli_modelli.description AS name, " +
                        " IF(veicoli_serie_synonyms.name IS NULL, veicoli_serie.name, veicoli_serie_synonyms.name) AS name_serie, " +
                        " IF(veicoli_modelli._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._from, '%Y-%m-01')) AS _from, " +
                        " IF(veicoli_modelli._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._to, '%Y-%m-01')) AS _to " +
                        "FROM " +
                        " tecdoc.veicoli_modelli " +
                        "JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id " +
                        "JOIN tecdoc.veicoli_serie ON veicoli_modelli.id = veicoli_serie.id_modello " +
                        "INNER JOIN ( SELECT veicoli_tipi.id AS id, veicoli_tipi.id_modello AS id_modello FROM tecdoc.veicoli_tipi GROUP BY id_modello ) AS veicoli_tipi ON veicoli_modelli.id = veicoli_tipi.id_modello " +
                        "LEFT JOIN motorinialternatori_main.veicoli_serie_synonyms ON veicoli_modelli.id = veicoli_serie_synonyms.id_modello " +
                        "WHERE EXISTS( SELECT article_id FROM kuhner.articles_vehicles INNER JOIN tecdoc.articoli_categorie ON articoli_categorie.id_articolo = articles_vehicles.article_id INNER JOIN motorinialternatori_main.categorie_visibility ON ( articoli_categorie.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1 ) WHERE veicoli_tipi.id = articles_vehicles.link_target_id ) " +
                        "AND " +
                        " veicoli_marche.id = ? " +
                        "ORDER BY " +
                        " veicoli_serie.name";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setInt(1, id);
                ResultSet resultSet = preparedStatement.executeQuery();
                while (resultSet.next()) {
                    VehicleManufacturer vehicleManufacturer = new VehicleManufacturer(resultSet.getInt("id_marca"), resultSet.getString("name_marca"));
                    VehicleModel vehicleModel = new VehicleModel(vehicleManufacturer, resultSet.getInt("id"), resultSet.getString("name"));

                    vehicleModel.setSeries(resultSet.getString("name_serie"));

                    Date from = resultSet.getDate("_from");
                    if (from != null)
                        vehicleModel.setFrom(YearMonth.from(Time.tsToLocalDate(from.getTime()))); // Must be converted to LocalDate: the extraction to YearMonth is only permitted if the temporal object has an ISO chronology, or can be converted to a LocalDate; see https://docs.oracle.com/javase/8/docs/api/java/time/YearMonth.html#from-java.time.temporal.TemporalAccessor-

                    Date to = resultSet.getDate("_to");
                    if (to != null) vehicleModel.setTo(YearMonth.from(Time.tsToLocalDate(to.getTime())));

                    models.add(vehicleModel);
                }
                connection.close();
            } catch (SQLException e) {
                System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
            }

            cache.put(cache_key, models);

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
