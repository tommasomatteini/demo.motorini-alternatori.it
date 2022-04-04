package it.motorinialternatori.demo.api;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "apiServlet", value = "/api/*")
public class RootServlet extends HttpServlet {

    /**
     *
     */
    public void init() {

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

        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

        out.print("400 Bad Request");

        out.flush();

    }

    /**
     *
     */
    public void destroy() {

    }

}
