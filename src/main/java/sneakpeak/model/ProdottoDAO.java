package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sneakpeak.util.DBConnectionPool;

/**
 * La classe ProdottoDAO (Data Access Object) gestisce tutte le operazioni 
 * sul database che riguardano i prodotti (le sneakers).
 */
public class ProdottoDAO {

    /**
     * Metodo per estrarre TUTTE le scarpe dal database che non sono state eliminate dall'admin.
     * Restituisce una lista di oggetti Prodotto pronta per essere inviata alla pagina web.
     */
    public List<Prodotto> doRetrieveAll() {
        
        // Creiamo la lista vuota che conterrà le scarpe
        List<Prodotto> prodotti = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        // Query SQL: Seleziona tutti i prodotti dove is_deleted è uguale a 0 (attivi)
        String selectSQL = "SELECT * FROM PRODOTTO WHERE is_deleted = 0";

        try {
            // 1. Chiediamo una connessione al nostro Pool
            connection = DBConnectionPool.getConnection();
            
            // 2. Prepariamo la query per inviarla a MySQL
            preparedStatement = connection.prepareStatement(selectSQL);
            
            // 3. Eseguiamo la query e salviamo il risultato nel ResultSet (una sorta di tabella virtuale)
            resultSet = preparedStatement.executeQuery();

            // 4. Scorriamo le righe del risultato una per una
            while (resultSet.next()) {
                
                // Per ogni riga del database, creiamo un nuovo oggetto Prodotto (il nostro Bean)
                Prodotto p = new Prodotto();
                
                // Riempiamo l'oggetto con i dati letti dalla colonna corrispondente del Database
                p.setIdProdotto(resultSet.getInt("id_prodotto"));
                p.setNome(resultSet.getString("nome"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setPrezzo(resultSet.getDouble("prezzo"));
                p.setMarca(resultSet.getString("marca"));
                p.setIsDeleted(resultSet.getInt("is_deleted"));
                p.setIdCategoria(resultSet.getInt("id_categoria"));
                
                // Aggiungiamo la scarpa appena letta alla lista finale
                prodotti.add(p);
            }

        } catch (SQLException e) {
            // Se la query fallisce, stampiamo l'errore nella console di Eclipse per capirne il motivo
            System.out.println("Errore in ProdottoDAO.doRetrieveAll: " + e.getMessage());
        } finally {
            // 5. Blocco 'finally': chiudiamo sempre le risorse per evitare memory leak!
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                
                // Restituiamo la connessione al Pool invece di distruggerla
                if (connection != null) {
                    DBConnectionPool.releaseConnection(connection);
                }
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse in ProdottoDAO: " + ex.getMessage());
            }
        }

        // Restituiamo la lista piena di sneakers alla Servlet che ne ha fatto richiesta
        return prodotti;
    }
    
    /**
     * Questo metodo cerca nel database una specifica scarpa utilizzando il suo ID.
     * Ci serve per la pagina di dettaglio del singolo prodotto.
     */
    public Prodotto doRetrieveById(int id) {
        Prodotto p = null; // Inizializziamo il prodotto a null
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        // La query SQL usa il punto interrogativo (?) come "segnaposto" per l'ID
        String selectSQL = "SELECT * FROM PRODOTTO WHERE id_prodotto = ?";

        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            
            // Sostituiamo il punto interrogativo (?) con l'ID vero e proprio che abbiamo passato al metodo
            preparedStatement.setInt(1, id);
            
            resultSet = preparedStatement.executeQuery();

            // Usiamo 'if' invece di 'while' perché sappiamo che l'ID è univoco (troveremo al massimo una scarpa)
            if (resultSet.next()) {
                p = new Prodotto();
                p.setIdProdotto(resultSet.getInt("id_prodotto"));
                p.setNome(resultSet.getString("nome"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setPrezzo(resultSet.getDouble("prezzo"));
                p.setMarca(resultSet.getString("marca"));
                p.setIsDeleted(resultSet.getInt("is_deleted"));
                p.setIdCategoria(resultSet.getInt("id_categoria"));
            }
        } catch (SQLException e) {
            System.out.println("Errore in ProdottoDAO.doRetrieveById: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse: " + ex.getMessage());
            }
        }

        return p; // Restituisce la scarpa trovata (oppure null se non esiste)
    }
}