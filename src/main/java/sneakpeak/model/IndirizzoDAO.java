package sneakpeak.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import sneakpeak.util.DBConnectionPool;

public class IndirizzoDAO {

    // Recupera tutti gli indirizzi salvati da un determinato utente
    public List<Indirizzo> doRetrieveByUtente(int idUtente) {
        List<Indirizzo> indirizzi = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String selectSQL = "SELECT * FROM INDIRIZZO WHERE id_utente = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            ps.setInt(1, idUtente);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Indirizzo ind = new Indirizzo();
                ind.setIdIndirizzo(rs.getInt("id_indirizzo"));
                ind.setIdUtente(rs.getInt("id_utente"));
                ind.setVia(rs.getString("via"));
                ind.setCitta(rs.getString("citta"));
                ind.setCap(rs.getString("cap"));
                ind.setCivico(rs.getString("civico"));
                ind.setProvincia(rs.getString("provincia"));
                ind.setNazione(rs.getString("nazione"));
                indirizzi.add(ind);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero indirizzi: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return indirizzi;
    }

    // Salva un nuovo indirizzo 
    public int doSave(Indirizzo indirizzo) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;
        
        String insertSQL = "INSERT INTO INDIRIZZO (id_utente, via, civico, citta, cap, provincia, nazione) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, indirizzo.getIdUtente());
            ps.setString(2, indirizzo.getVia());
            ps.setString(3, indirizzo.getCivico());
            ps.setString(4, indirizzo.getCitta());
            ps.setString(5, indirizzo.getCap());
            ps.setString(6, indirizzo.getProvincia());
            ps.setString(7, indirizzo.getNazione());
            
            
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Errore salvataggio indirizzo: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return generatedId;
    }
}