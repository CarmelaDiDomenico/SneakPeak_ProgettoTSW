package sneakpeak.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Importiamo la classe di utilità che abbiamo scritto nella Fase 3
import sneakpeak.util.DBConnectionPool;

/**
 * L'annotazione @WebServlet dice a Tomcat che quando l'utente digita 
 * l'URL "/TestDB" nel browser, deve essere eseguita questa specifica classe.
 */
@WebServlet("/TestDB")
public class TestDBServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Il metodo doGet gestisce le richieste standard inviate dal browser (es. quando scrivi l'URL)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Diciamo al browser che risponderemo generando una pagina HTML testuale
        response.setContentType("text/html");
        
        // Il PrintWriter ci permette di "scrivere" codice HTML che l'utente vedrà sullo schermo
        PrintWriter out = response.getWriter();

        // Stampiamo l'inizio della pagina HTML di test
        out.println("<html><head><title>Test SneakPeak</title></head><body>");
        out.println("<h2>Verifica Configurazione Progetto - SneakPeak</h2>");
        out.println("<hr>");

        // Dichiariamo gli oggetti JDBC fuori dal blocco try per poterli chiudere alla fine nel 'finally'
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            // 2. PROVA DI CONNESSIONE
            // Chiediamo una connessione al nostro Pool personalizzato
            connection = DBConnectionPool.getConnection();
            
            // Se non va in errore (eccezione), significa che il Driver .jar è letto e le credenziali sono giuste
            out.println("<p style='color:green; font-weight:bold;'>[OK] Connessione al database riuscita tramite il Pool!</p>");

            // 3. PROVA DI LETTURA DATI
            // Creiamo un oggetto Statement per poter lanciare una query SQL
            statement = connection.createStatement();
            
            // Eseguiamo una query per contare quanti prodotti ci sono nel DB (dovrebbero essere 5 grazie al nostro script di popolazione)
            resultSet = statement.executeQuery("SELECT COUNT(*) AS totale_scarpe FROM PRODOTTO");

            // Leggiamo il risultato della query
            if (resultSet.next()) {
                int quantita = resultSet.getInt("totale_scarpe");
                out.println("<p style='color:blue;'>[OK] Query eseguita correttamente!</p>");
                out.println("<p>Numero di scarpe trovate nel catalogo del database: <b>" + quantita + "</b> (Dovrebbero essere 5).</p>");
            }

        } catch (Exception e) {
            // 4. GESTIONE ERRORI
            // Se qualcosa fallisce, stampiamo l'errore direttamente sulla pagina web per capire il problema
            out.println("<p style='color:red; font-weight:bold;'>[ERRORE] Qualcosa è andato storto nella connessione!</p>");
            out.println("<p><b>Messaggio di errore:</b> " + e.getMessage() + "</p>");
            
            // Questo stampa l'intera traccia dell'errore (stack trace) sulla pagina web
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            
        } finally {
            // 5. RILASCIO DELLE RISORSE (Obbligatorio per la checklist del progetto)
            // Qualunque cosa accada (successo o errore), dobbiamo chiudere le risorse aperte
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                
                // IMPORTANTE: Non chiudiamo la connessione con .close(), ma la restituiamo al pool!
                if (connection != null) {
                    DBConnectionPool.releaseConnection(connection);
                    out.println("<p style='color:gray; font-size:12px;'>Connessione riposta correttamente nel Pool.</p>");
                }
            } catch (Exception ex) {
                out.println("<p style='color:red;'>Errore nel rilascio delle risorse: " + ex.getMessage() + "</p>");
            }
        }

        // Chiudiamo i tag HTML della pagina
        out.println("</body></html>");
    }
}