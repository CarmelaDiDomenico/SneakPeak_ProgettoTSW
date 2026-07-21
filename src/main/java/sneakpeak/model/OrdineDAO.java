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
            
            // SALVIAMO I DETTAGLI E SOTTRAIAMO LE SCORTE
            String insertDettaglio = "INSERT INTO DETTAGLIO_ORDINE (id_ordine, id_prodotto, taglia, quantita, prezzo_acquisto, iva_acquisto) VALUES (?, ?, ?, ?, ?, ?)";
            psDettaglio = connection.prepareStatement(insertDettaglio);
            
            String updateStock = "UPDATE VARIANTE_PRODOTTO SET quantita = quantita - ? WHERE id_prodotto = ? AND taglia = ?";
            PreparedStatement psStock = connection.prepareStatement(updateStock);
            
            for (CartItem item : carrello.getArticoli()) {
                // Inserimento dettaglio
                psDettaglio.setInt(1, idNuovoOrdine);
                psDettaglio.setInt(2, item.getProdotto().getIdProdotto());
                psDettaglio.setString(3, item.getTaglia());
                psDettaglio.setInt(4, item.getQuantita()); 
                psDettaglio.setDouble(5, item.getProdotto().getPrezzo());
                psDettaglio.setDouble(6, 22.00); 
                psDettaglio.executeUpdate();
                
                // Aggiornamento stock
                psStock.setInt(1, item.getQuantita());
                psStock.setInt(2, item.getProdotto().getIdProdotto());
                psStock.setString(3, item.getTaglia());
                psStock.executeUpdate();
            }
            if (psStock != null) psStock.close();
            
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
    
 // Recupera TUTTI gli ordini per l'Amministratore (con JOIN su UTENTE per mostrare il nome del cliente)
    public java.util.List<Ordine> doRetrieveAll() {
        java.util.List<Ordine> ordini = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // LEFT JOIN: se l'utente è stato cancellato, l'ordine viene comunque restituito
        String selectSQL =
            "SELECT o.*, u.nome AS nome_utente, u.cognome AS cognome_utente, u.email AS email_utente " +
            "FROM ORDINE o LEFT JOIN UTENTE u ON o.id_utente = u.id_utente " +
            "ORDER BY o.data_ordine DESC, o.id_ordine DESC";

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
                // Campi dalla JOIN con UTENTE
                String nome    = rs.getString("nome_utente");
                String cognome = rs.getString("cognome_utente");
                o.setNomeCliente((nome != null ? nome + " " + cognome : "Utente eliminato"));
                o.setEmailCliente(rs.getString("email_utente") != null ? rs.getString("email_utente") : "—");
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

    // Recupera i dettagli di un singolo ordine (prodotti acquistati, quantità, prezzi storici)
    public java.util.List<DettaglioOrdine> doRetrieveDettagliByOrdine(int idOrdine) {
        java.util.List<DettaglioOrdine> dettagli = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // JOIN con PRODOTTO per ottenere il nome del prodotto al momento della visualizzazione.
        // prezzo_acquisto e iva_acquisto sono quelli storici salvati al momento dell'ordine.
        String selectSQL =
            "SELECT d.id_ordine, d.id_prodotto, p.nome AS nome_prodotto, " +
            "       d.taglia, d.quantita, d.prezzo_acquisto, d.iva_acquisto " +
            "FROM DETTAGLIO_ORDINE d " +
            "JOIN PRODOTTO p ON d.id_prodotto = p.id_prodotto " +
            "WHERE d.id_ordine = ?";

        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            ps.setInt(1, idOrdine);
            rs = ps.executeQuery();

            while (rs.next()) {
                DettaglioOrdine d = new DettaglioOrdine();
                d.setIdOrdine(rs.getInt("id_ordine"));
                d.setIdProdotto(rs.getInt("id_prodotto"));
                d.setNomeProdotto(rs.getString("nome_prodotto"));
                d.setTaglia(rs.getString("taglia"));
                d.setQuantita(rs.getInt("quantita"));
                d.setPrezzoAcquisto(rs.getDouble("prezzo_acquisto"));
                d.setIvaAcquisto(rs.getDouble("iva_acquisto"));
                dettagli.add(d);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero dettagli ordine #" + idOrdine + ": " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return dettagli;
    }

    // Filtra ordini per Admin (per cliente e/o date)
    public java.util.List<Ordine> doRetrieveFiltered(String clienteSearch, java.sql.Date dataInizio, java.sql.Date dataFine) {
        java.util.List<Ordine> ordini = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Costruiamo la query dinamicamente facendo una JOIN con la tabella UTENTE
        // per poter cercare per nome, cognome o email.
        StringBuilder query = new StringBuilder(
            "SELECT o.*, u.nome AS nome_utente, u.cognome AS cognome_utente, u.email AS email_utente " +
            "FROM ORDINE o LEFT JOIN UTENTE u ON o.id_utente = u.id_utente WHERE 1=1");
        
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
                // Campi dalla JOIN con UTENTE
                String nome    = rs.getString("nome_utente");
                String cognome = rs.getString("cognome_utente");
                o.setNomeCliente(nome != null ? nome + " " + cognome : "Utente eliminato");
                o.setEmailCliente(rs.getString("email_utente") != null ? rs.getString("email_utente") : "—");
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