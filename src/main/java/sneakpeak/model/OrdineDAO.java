package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import sneakpeak.util.DBConnectionPool;

public class OrdineDAO {

    /**
     * Salva un nuovo ordine e i suoi dettagli in modo transazionale.
     */
    public boolean salvaOrdineCompleto(Ordine ordine, Carrello carrello) {
        Connection connection = null;
        PreparedStatement psOrdine = null;
        PreparedStatement psDettaglio = null;
        ResultSet rsGeneratedKeys = null;
        
        try {
            connection = DBConnectionPool.getConnection();
            
            //INIZIO TRANSAZIONE
            connection.setAutoCommit(false);
            
           
            String insertOrdine = "INSERT INTO ORDINE (id_utente, totale, data_ordine, id_indirizzo, id_pagamento) VALUES (?, ?, ?, ?, ?)";
            psOrdine = connection.prepareStatement(insertOrdine, Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, ordine.getIdUtente());
            psOrdine.setDouble(2, ordine.getTotale());
            psOrdine.setDate(3, ordine.getDataOrdine());
            psOrdine.setInt(4, ordine.getIdIndirizzo());
            psOrdine.setInt(5, ordine.getIdPagamento());
            
            psOrdine.executeUpdate();
            
           
            rsGeneratedKeys = psOrdine.getGeneratedKeys();
            int idNuovoOrdine = -1;
            if (rsGeneratedKeys.next()) {
                idNuovoOrdine = rsGeneratedKeys.getInt(1);
            }
            
            // 4. RAGGRUPPIAMO I PRODOTTI UGUALI PER CALCOLARE LE QUANTITÀ
            Map<Integer, Integer> quantitaProdotti = new HashMap<>();
            Map<Integer, Double> prezziProdotti = new HashMap<>();
            
            for (Prodotto p : carrello.getArticoli()) {
                int idProd = p.getIdProdotto();
                // Se il prodotto c'è già, aggiungiamo 1 alla quantità, altrimenti lo inseriamo a 1
                quantitaProdotti.put(idProd, quantitaProdotti.getOrDefault(idProd, 0) + 1);
                // Salviamo anche il suo prezzo
                prezziProdotti.put(idProd, p.getPrezzo());
            }
            
           
            String insertDettaglio = "INSERT INTO DETTAGLIO_ORDINE (id_ordine, id_prodotto, quantita, prezzo_acquisto) VALUES (?, ?, ?, ?)";
            psDettaglio = connection.prepareStatement(insertDettaglio);
            
            for (Integer idProd : quantitaProdotti.keySet()) {
                psDettaglio.setInt(1, idNuovoOrdine);
                psDettaglio.setInt(2, idProd);
                psDettaglio.setInt(3, quantitaProdotti.get(idProd)); 
                psDettaglio.setDouble(4, prezziProdotti.get(idProd));
                
                psDettaglio.executeUpdate();
            }
            
            //FINE TRANSAZIONE
            connection.commit();
            return true;
            
        } catch (SQLException e) {
            // Se c'è un errore, annulliamo tutto
            System.out.println("Errore fatale, eseguo rollback: " + e.getMessage());
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            //chiudiamo
            try {
                if (rsGeneratedKeys != null) rsGeneratedKeys.close();
                if (psOrdine != null) psOrdine.close();
                if (psDettaglio != null) psDettaglio.close();
                if (connection != null) {
                    connection.setAutoCommit(true);
                    DBConnectionPool.releaseConnection(connection);
                }
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse: " + ex.getMessage());
            }
        }
    }
}