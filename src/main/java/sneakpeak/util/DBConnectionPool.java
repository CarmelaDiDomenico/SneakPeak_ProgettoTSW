package sneakpeak.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 * Questa classe implementa un pool di connessioni elementare e thread-safe.
 * Invece di distruggere le connessioni, le conserva in una lista per poterle riutilizzare,
 * ottimizzando drasticamente i tempi di risposta del server Tomcat.
 */
public class DBConnectionPool {

    // Lista condivisa (pool) che memorizza le connessioni libere e attualmente inutilizzate
    private static List<Connection> freeDbConnections;

    // Stringa di connessione JDBC per MySQL con fuso orario UTC configurato
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sneakpeak?serverTimezone=UTC";
    private static final String DB_USER = "root";       
    private static final String DB_PASSWORD = "Password1";   
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Il blocco statico viene eseguito una sola volta quando la classe viene caricata in memoria
    static {
        freeDbConnections = new LinkedList<Connection>();
        try {
            // Carica dinamicamente il driver JDBC di MySQL
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println("Driver Database non trovato! Assicurati di aver inserito il connettore .jar in WEB-INF/lib: " + e.getMessage());
        }
    }

    /**
     * Fornisce una connessione prelevandola dal pool. Se il pool è vuoto, 
     * ne genera una nuova di zecca.
     * Il metodo è 'synchronized' per evitare conflitti quando più utenti effettuano richieste contemporanee.
     */
    public static synchronized Connection getConnection() throws SQLException {
        Connection connection;

        // Se ci sono connessioni disponibili nel pool (la lista non è vuota)
        if (!freeDbConnections.isEmpty()) {
            // Estrae la prima connessione disponibile (indice 0) e la rimuove dall'elenco delle connessioni libere
            connection = freeDbConnections.get(0);
            freeDbConnections.remove(0);

            // Se la connessione recuperata per qualche motivo è stata chiusa dal server SQL, 
            // chiama ricorsivamente il metodo per cercarne un'altra valida.
            if (connection.isClosed()) {
                connection = getConnection();
            }
        } else {
            // Se non ci sono connessioni pronte nel pool, ne crea una nuova tramite il DriverManager standard
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        }

        // Restituisce la connessione pronta per essere utilizzata dalle classi DAO
        return connection;
    }

    /**
     * Rilascia una connessione precedentemente utilizzata. 
     * Invece di richiamare il metodo .close() fisico, la rimette all'interno della lista 
     * in modo che possa essere riciclata per la prossima operazione.
     */
    public static synchronized void releaseConnection(Connection connection) throws SQLException {
        if (connection != null) {
            // Controlla che la connessione sia ancora aperta prima di rimetterla nel pool
            if (!connection.isClosed()) {
                freeDbConnections.add(connection);
            }
        }
    }
}