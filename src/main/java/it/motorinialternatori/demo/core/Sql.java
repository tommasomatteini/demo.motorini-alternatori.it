package it.motorinialternatori.demo.core;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

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

    public DataSource dataSource = null;
    public Connection connection = null;

    /**
     *
     * @param source ...
     */
    public Sql(String source) {
        try {
            if (context != null) this.dataSource = (DataSource) Sql.context.lookup("java:comp/env/" + source);
        } catch (NamingException e) {
            e.printStackTrace(System.out);
        }
        try {
            if (dataSource != null) this.connection = this.dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        System.out.println("new connection");
    }

    /**
     *
     * @return DataSource
     */
    public DataSource getDataSource() {
        return this.dataSource;
    }

    /**
     *
     * @return Connection
     */
    public Connection getConnection() {
        return this.connection;
    }

}
