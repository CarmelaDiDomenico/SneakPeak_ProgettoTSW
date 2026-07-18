package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import sneakpeak.util.DBConnectionPool;


public class UtenteDAO {

    /**
     * 1. METODO PER LA REGISTRAZIONE
     * Riceve in ingresso un oggetto Utente con i dati inseriti dall'utente
     * e inserisce i dati nella tabella UTENTE di MySQL.
     */
    public boolean doSave(Utente utente) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        String insertSQL = "INSERT INTO UTENTE (email, password, nome, cognome) VALUES (?, ?, ?, ?)";
        
        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL);
            
            preparedStatement.setString(1, utente.getEmail());
            
            String hashedPassword = sneakpeak.util.PasswordHelper.hashPassword(utente.getPassword());
            preparedStatement.setString(2, hashedPassword);
            
            preparedStatement.setString(3, utente.getNome());
            preparedStatement.setString(4, utente.getCognome());
            
            int result = preparedStatement.executeUpdate();
            
            return (result > 0);
            
        } catch (SQLException e) {
            System.out.println("Errore durante la registrazione: " + e.getMessage());
            return false;
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                System.out.println("Errore chiusura: " + ex.getMessage());
            }
        }
    }

    /**
     * 1.1 METODO PER IL CONTROLLO EMAIL
     * Cerca nel database se esiste già un utente registrato con questa email.
     * Restituisce l'Utente se lo trova, altrimenti null.
     */
    public Utente doRetrieveByEmail(String email) {
        Utente u = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        // Query di ricerca per email
        String selectSQL = "SELECT * FROM UTENTE WHERE email = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            
            preparedStatement.setString(1, email);
            
            // Eseguiamo la query
            resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                u = new Utente();
                u.setIdUtente(resultSet.getInt("id_utente"));
                u.setEmail(resultSet.getString("email"));
                u.setPassword(resultSet.getString("password"));
                u.setNome(resultSet.getString("nome"));
                u.setCognome(resultSet.getString("cognome"));
                u.setTipo(resultSet.getString("tipo"));
            }
            
        } catch (SQLException e) {
            System.out.println("Errore durante il recupero utente per email: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse: " + ex.getMessage());
            }
        }
        
        return u;
    }


    /**
     * 2. METODO PER IL LOGIN
     * Cerca nel database se esiste un utente con quella specifica email e password.
     * Se lo trova, ci restituisce il Bean Utente pieno di dati, altrimenti null.
     */
    public Utente doRetrieveByEmailAndPassword(String email, String password) {
        Utente u = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        // Query di ricerca (SELECT)
        String selectSQL = "SELECT * FROM UTENTE WHERE email = ? AND password = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            
            preparedStatement.setString(1, email);
            
            // Cifratura della password inserita per confrontarla con quella cifrata nel DB
            String hashedPassword = sneakpeak.util.PasswordHelper.hashPassword(password);
            preparedStatement.setString(2, hashedPassword);
            
            resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                u = new Utente();
                
                u.setIdUtente(resultSet.getInt("id_utente"));
                u.setEmail(resultSet.getString("email"));
                u.setPassword(resultSet.getString("password")); 
                u.setNome(resultSet.getString("nome"));
                u.setCognome(resultSet.getString("cognome"));
                u.setTipo(resultSet.getString("tipo"));
            }
            
        } catch (SQLException e) {
            System.out.println("Errore durante il login: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                System.out.println("Errore chiusura: " + ex.getMessage());
            }
        }
        
        return u;
    }

    /**
     * 3. METODO PER AGGIORNARE IL PROFILO
     * Riceve un Utente e aggiorna i suoi dati nel database usando il suo ID.
     */
    public boolean doUpdate(Utente utente) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        String updateSQL = "UPDATE UTENTE SET nome = ?, cognome = ?, password = ? WHERE id_utente = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(updateSQL);
            
            preparedStatement.setString(1, utente.getNome());
            preparedStatement.setString(2, utente.getCognome());
            
            // La password deve arrivare a questo metodo GIA' CIFRATA, 
            // oppure vuota se non si vuole cambiare.
            preparedStatement.setString(3, utente.getPassword()); 
            
            preparedStatement.setInt(4, utente.getIdUtente());
            
            int result = preparedStatement.executeUpdate();
            return (result > 0);
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'aggiornamento profilo: " + e.getMessage());
            return false;
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse: " + ex.getMessage());
            }
        }
    }
}
