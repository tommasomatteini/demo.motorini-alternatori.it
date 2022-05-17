package it.motorinialternatori.demo.api;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.concurrent.TimeUnit;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import javax.servlet.jsp.jstl.sql.Result;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

import com.google.gson.Gson;
import it.motorinialternatori.demo.core.Sql;
import it.motorinialternatori.demo.models.VehicleManufacturer;

@WebServlet(name = "apiManufacturersServlet", value = "/api/manufacturers")
public class VehicleManufacturersServlet extends HttpServlet {

    public static Cache<String, Collection<VehicleManufacturer>> cache = null;

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
     */
    private static Collection<VehicleManufacturer> getVehicleManufacturers() {

        String cache_key = "api_manufacturers";
        Collection<VehicleManufacturer> manufacturers = cache.getIfPresent(cache_key);

        if (manufacturers == null) {

            manufacturers = new ArrayList<>();

            Sql database = new Sql("jdbc/motorinialternatori");
            Connection connection = database.getConnection();
            try {
                String sql = "SELECT " +
                        " veicoli_marche.id, " +
                        " veicoli_marche.description " +
                        "FROM " +
                        " motorinialternatori_main.veicoli_marche_visibility " +
                        "JOIN motorinialternatori_main.veicoli_marche_media ON veicoli_marche_visibility.id_marca = veicoli_marche_media.id_marca " +
                        "JOIN tecdoc.veicoli_marche ON veicoli_marche.id = veicoli_marche_visibility.id_marca AND veicoli_marche_visibility.visible = 1 " +
                        "INNER JOIN ( SELECT id, id_marca FROM tecdoc.veicoli_modelli GROUP BY id_marca) AS veicoli_modelli ON veicoli_marche.id = veicoli_modelli.id_marca " +
                        "INNER JOIN ( SELECT id, id_modello FROM tecdoc.veicoli_tipi GROUP BY id_modello ) AS veicoli_tipi ON veicoli_tipi.id_modello = veicoli_modelli.id " +
                        "WHERE EXISTS( SELECT article_id FROM kuhner.articles_vehicles INNER JOIN tecdoc.articoli_categorie ON articoli_categorie.id_articolo = articles_vehicles.article_id INNER JOIN motorinialternatori_main.categorie_visibility ON ( articoli_categorie.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1 ) WHERE veicoli_tipi.id = articles_vehicles.link_target_id ) " +
                        "ORDER BY " +
                        " veicoli_marche.description";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                ResultSet resultSet = preparedStatement.executeQuery();
                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String name = resultSet.getString("description");
                    manufacturers.add(new VehicleManufacturer(id, name));
                }
                connection.close();
            } catch (SQLException e) {
                System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
            }

            cache.put(cache_key, manufacturers);

        }

        return manufacturers;
    }

    /**
     *
     * @param request ...
     * @param response ...
     * @throws IOException ...
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String jsonString = new Gson().toJson(getVehicleManufacturers());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(jsonString);
        out.flush();

    }

    public void destroy() {

    }

}
