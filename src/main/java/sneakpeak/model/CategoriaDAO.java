package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import sneakpeak.util.DBConnectionPool;

public class CategoriaDAO {

    public List<Categoria> doRetrieveAll() {
        List<Categoria> categorie = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement("SELECT * FROM CATEGORIA");
            rs = ps.executeQuery();

            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNome(rs.getString("nome"));
                categorie.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Errore nel recupero delle categorie: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return categorie;
    }
}
