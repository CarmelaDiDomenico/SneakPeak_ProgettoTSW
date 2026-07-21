package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sneakpeak.util.DBConnectionPool;

public class VarianteDAO {

    public List<Variante> doRetrieveByProdotto(int idProdotto) {
        List<Variante> varianti = new ArrayList<>();
        String selectSQL = "SELECT * FROM VARIANTE_PRODOTTO WHERE id_prodotto = ? ORDER BY taglia ASC";

        try (Connection connection = DBConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(selectSQL)) {

            ps.setInt(1, idProdotto);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Variante v = new Variante();
                v.setIdVariante(rs.getInt("id_variante"));
                v.setIdProdotto(rs.getInt("id_prodotto"));
                v.setTaglia(rs.getString("taglia"));
                v.setQuantita(rs.getInt("quantita"));
                varianti.add(v);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return varianti;
    }

    public Variante doRetrieveById(int idVariante) {
        Variante v = null;
        String selectSQL = "SELECT * FROM VARIANTE_PRODOTTO WHERE id_variante = ?";

        try (Connection connection = DBConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(selectSQL)) {

            ps.setInt(1, idVariante);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                v = new Variante();
                v.setIdVariante(rs.getInt("id_variante"));
                v.setIdProdotto(rs.getInt("id_prodotto"));
                v.setTaglia(rs.getString("taglia"));
                v.setQuantita(rs.getInt("quantita"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return v;
    }

    public void doSave(Variante v) {
        String insertSQL = "INSERT INTO VARIANTE_PRODOTTO (id_prodotto, taglia, quantita) VALUES (?, ?, ?)";

        try (Connection connection = DBConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(insertSQL)) {

            ps.setInt(1, v.getIdProdotto());
            ps.setString(2, v.getTaglia());
            ps.setInt(3, v.getQuantita());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void doUpdateQuantita(int idVariante, int quantita) {
        String updateSQL = "UPDATE VARIANTE_PRODOTTO SET quantita = ? WHERE id_variante = ?";

        try (Connection connection = DBConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(updateSQL)) {

            ps.setInt(1, quantita);
            ps.setInt(2, idVariante);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void doDelete(int idVariante) {
        String deleteSQL = "DELETE FROM VARIANTE_PRODOTTO WHERE id_variante = ?";

        try (Connection connection = DBConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(deleteSQL)) {

            ps.setInt(1, idVariante);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
