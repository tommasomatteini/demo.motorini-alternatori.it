package it.motorinialternatori.demo.api;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.google.gson.Gson;
import it.motorinialternatori.demo.core.Sql;
import it.motorinialternatori.demo.models.VehicleManufacturer;

@WebServlet(name = "apiManufacturersServlet", value = "/api/manufacturers")
public class VehicleManufacturersServlet extends HttpServlet {

    Collection<VehicleManufacturer> vehicleManufacturers = new ArrayList<>();

    /**
     *
     */
    public void init() {
        Sql database = new Sql("jdbc/motorinialternatori");
        Connection connection = database.getConnection();
        try {
            String sql = "SELECT " +
                " id, " +
                " description " +
                "FROM " +
                " tecdoc.veicoli_marche " +
                "JOIN motorinialternatori_main.veicoli_marche_visibility ON veicoli_marche.id = veicoli_marche_visibility.id_marca AND veicoli_marche_visibility.visible = 1";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("description");
                this.vehicleManufacturers.add(new VehicleManufacturer(id, name));
            }
            connection.close();
        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * @param request ...
     * @param response ...
     * @throws IOException ...
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String jsonString = new Gson().toJson(this.vehicleManufacturers);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(jsonString);
        out.flush();

    }

    public void destroy() {

    }

}
