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
            
            // RAGGRUPPIAMO I PRODOTTI UGUALI PER CALCOLARE LE QUANTITÀ
            Map<Integer, Integer> quantitaProdotti = new HashMap<>();
            Map<Integer, Double> prezziProdotti = new HashMap<>();
            
            for (Prodotto p : carrello.getArticoli()) {
                int idProd = p.getIdProdotto();
                // Se il prodotto c'è già, aggiungiamo 1 alla quantità, altrimenti lo inseriamo a 1
                quantitaProdotti.put(idProd, quantitaProdotti.getOrDefault(idProd, 0) + 1);
                // Salviamo anche il suo prezzo
                prezziProdotti.put(idProd, p.getPrezzo());
            }
            
           
            String insertDettaglio = "INSERT INTO DETTAGLIO_ORDINE (id_ordine, id_prodotto, quantita, prezzo_acquisto, iva_acquisto) VALUES (?, ?, ?, ?, ?)";
            psDettaglio = connection.prepareStatement(insertDettaglio);
            
            for (Integer idProd : quantitaProdotti.keySet()) {
                psDettaglio.setInt(1, idNuovoOrdine);
                psDettaglio.setInt(2, idProd);
                psDettaglio.setInt(3, quantitaProdotti.get(idProd)); 
                psDettaglio.setDouble(4, prezziProdotti.get(idProd));
                psDettaglio.setDouble(5, 22.00); // Fissiamo l'IVA storica per l'ordine al 22% come richiesto
                
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
    
 // Recupera TUTTI gli ordini per l'Amministratore
    public java.util.List<Ordine> doRetrieveAll() {
        java.util.List<Ordine> ordini = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
     
        String selectSQL = "SELECT * FROM ORDINE ORDER BY data_ordine DESC, id_ordine DESC";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Ordine o = new Ordine();
                o.setIdOrdine(rs.getInt("id_ordine"));
                o.setIdUtente(rs.getInt("id_utente"));
                o.setTotale(rs.getDouble("totale"));
                o.setDataOrdine(rs.getDate("data_ordine"));
                o.setIdIndirizzo(rs.getInt("id_indirizzo"));
                o.setIdPagamento(rs.getInt("id_pagamento"));
                o.setStato(rs.getString("stato"));
                ordini.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero tutti gli ordini: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return ordini;
    }

    // Aggiorna lo stato di un ordine
    public boolean updateStato(int idOrdine, String nuovoStato) {
        Connection connection = null;
        PreparedStatement ps = null;
        String updateSQL = "UPDATE ORDINE SET stato = ? WHERE id_ordine = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(updateSQL);
            ps.setString(1, nuovoStato);
            ps.setInt(2, idOrdine);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Errore aggiornamento stato ordine: " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // Recupera TUTTI gli ordini per un singolo Utente (Storico Ordini Cliente)
    public java.util.List<Ordine> doRetrieveByUtente(int idUtente) {
        java.util.List<Ordine> ordini = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
     
        String selectSQL = "SELECT * FROM ORDINE WHERE id_utente = ? ORDER BY data_ordine DESC, id_ordine DESC";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            ps.setInt(1, idUtente);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Ordine o = new Ordine();
                o.setIdOrdine(rs.getInt("id_ordine"));
                o.setIdUtente(rs.getInt("id_utente"));
                o.setTotale(rs.getDouble("totale"));
                o.setDataOrdine(rs.getDate("data_ordine"));
                o.setIdIndirizzo(rs.getInt("id_indirizzo"));
                o.setIdPagamento(rs.getInt("id_pagamento"));
                o.setStato(rs.getString("stato"));
                ordini.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero ordini utente: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return ordini;
    }

    // Filtra ordini per Admin (per cliente e/o date)
    public java.util.List<Ordine> doRetrieveFiltered(String clienteSearch, java.sql.Date dataInizio, java.sql.Date dataFine) {
        java.util.List<Ordine> ordini = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Costruiamo la query dinamicamente facendo una JOIN con la tabella UTENTE
        // per poter cercare per nome, cognome o email.
        StringBuilder query = new StringBuilder("SELECT o.* FROM ORDINE o JOIN UTENTE u ON o.id_utente = u.id_utente WHERE 1=1");
        
        if (clienteSearch != null && !clienteSearch.trim().isEmpty()) {
            query.append(" AND (u.nome LIKE ? OR u.cognome LIKE ? OR u.email LIKE ?)");
        }
        if (dataInizio != null) {
            query.append(" AND o.data_ordine >= ?");
        }
        if (dataFine != null) {
            query.append(" AND o.data_ordine <= ?");
        }
        
        query.append(" ORDER BY o.data_ordine DESC, o.id_ordine DESC");

        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(query.toString());
            
            int index = 1;
            if (clienteSearch != null && !clienteSearch.trim().isEmpty()) {
                String searchPattern = "%" + clienteSearch.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }
            if (dataInizio != null) {
                ps.setDate(index++, dataInizio);
            }
            if (dataFine != null) {
                ps.setDate(index++, dataFine);
            }

            rs = ps.executeQuery();
            
            while (rs.next()) {
                Ordine o = new Ordine();
                o.setIdOrdine(rs.getInt("id_ordine"));
                o.setIdUtente(rs.getInt("id_utente"));
                o.setTotale(rs.getDouble("totale"));
                o.setDataOrdine(rs.getDate("data_ordine"));
                o.setIdIndirizzo(rs.getInt("id_indirizzo"));
                o.setIdPagamento(rs.getInt("id_pagamento"));
                o.setStato(rs.getString("stato"));
                ordini.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero ordini filtrati (JOIN): " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return ordini;
    }
}