package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sneakpeak.util.DBConnectionPool;

public class RecensioneDAO {

    public List<Recensione> doRetrieveByProdotto(int idProdotto) {
        List<Recensione> recensioni = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Eseguiamo una JOIN con UTENTE per avere nome e cognome di chi ha scritto la recensione
        String selectSQL = "SELECT r.*, u.nome, u.cognome " +
                           "FROM RECENSIONE r " +
                           "JOIN UTENTE u ON r.id_utente = u.id_utente " +
                           "WHERE r.id_prodotto = ? " +
                           "ORDER BY r.data_recensione DESC";

        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            ps.setInt(1, idProdotto);
            rs = ps.executeQuery();

            while (rs.next()) {
                Recensione r = new Recensione();
                r.setIdRecensione(rs.getInt("id_recensione"));
                r.setTitolo(rs.getString("titolo"));
                r.setDescrizione(rs.getString("descrizione"));
                r.setValutazione(rs.getInt("valutazione"));
                r.setDataRecensione(rs.getDate("data_recensione"));
                r.setIdUtente(rs.getInt("id_utente"));
                r.setIdProdotto(rs.getInt("id_prodotto"));
                
                r.setNomeUtente(rs.getString("nome"));
                r.setCognomeUtente(rs.getString("cognome"));
                
                recensioni.add(r);
            }
        } catch (SQLException e) {
            System.out.println("Errore in RecensioneDAO.doRetrieveByProdotto: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return recensioni;
    }

    public boolean doSave(Recensione r) {
        Connection connection = null;
        PreparedStatement ps = null;

        String insertSQL = "INSERT INTO RECENSIONE (titolo, descrizione, valutazione, data_recensione, id_utente, id_prodotto) " +
                           "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(insertSQL);
            
            ps.setString(1, r.getTitolo());
            ps.setString(2, r.getDescrizione());
            ps.setInt(3, r.getValutazione());
            ps.setDate(4, r.getDataRecensione());
            ps.setInt(5, r.getIdUtente());
            ps.setInt(6, r.getIdProdotto());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Errore in RecensioneDAO.doSave: " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
