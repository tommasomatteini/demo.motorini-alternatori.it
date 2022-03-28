package it.motorinialternatori.demo.core;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 *
 */
public final class Sql {

    private static InitialContext context = null;

    /**
     *
     */
    static {
        try {
            Sql.context = new InitialContext();
        } catch (NamingException e) {
            e.printStackTrace(System.out);
        }
    }

    private DataSource dataSource = null;

    public Sql(String source) {
        this.dataSource = this.getDataSource(source);
    }

    /**
     *
     * @param source ...
     * @return ...
     */
    private DataSource getDataSource(String source) {
        DataSource dataSource = null;
        try {
            dataSource = (DataSource) Sql.context.lookup("java:comp/env/" + source);
        } catch (NamingException e) {
            e.printStackTrace(System.out);
        }
        return dataSource;
    }

    /**
     *
     * @return ...
     */
    public DataSource getDataSource() {
        return this.dataSource;
    }

    /**
     *
     * @return ...
     */
    public Connection getConnection() {
        Connection connection = null;
        try {
            if (this.dataSource != null) connection = this.dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        return connection;
    }

}
