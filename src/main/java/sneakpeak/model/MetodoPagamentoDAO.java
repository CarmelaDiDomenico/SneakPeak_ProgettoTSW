package sneakpeak.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import sneakpeak.util.DBConnectionPool;

public class MetodoPagamentoDAO {

    public List<MetodoPagamento> doRetrieveByUtente(int idUtente) {
        List<MetodoPagamento> metodi = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String selectSQL = "SELECT * FROM METODO_PAGAMENTO WHERE id_utente = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            ps.setInt(1, idUtente);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                MetodoPagamento mp = new MetodoPagamento();
                mp.setIdPagamento(rs.getInt("id_pagamento"));
                mp.setIdUtente(rs.getInt("id_utente"));
                mp.setTipo(rs.getString("tipo"));
                mp.setIntestatario(rs.getString("intestatario"));
                metodi.add(mp);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero carte: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return metodi;
    }

    public int doSave(MetodoPagamento mp) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;
        
        String insertSQL = "INSERT INTO METODO_PAGAMENTO (id_utente, tipo, intestatario) VALUES (?, ?, ?)";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, mp.getIdUtente());
            ps.setString(2, mp.getTipo());
            ps.setString(3, mp.getIntestatario());
            
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Errore salvataggio carta: " + e.getMessage());
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