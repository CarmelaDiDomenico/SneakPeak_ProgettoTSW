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


@WebServlet("/TestDB")
public class TestDBServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
       
        response.setContentType("text/html");
      
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Test SneakPeak</title></head><body>");
        out.println("<h2>Verifica Configurazione Progetto - SneakPeak</h2>");
        out.println("<hr>");

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            
            connection = DBConnectionPool.getConnection();
            
           
            out.println("<p style='color:green; font-weight:bold;'>[OK] Connessione al database riuscita tramite il Pool!</p>");
            statement = connection.createStatement();
           
            resultSet = statement.executeQuery("SELECT COUNT(*) AS totale_scarpe FROM PRODOTTO");

           
            if (resultSet.next()) {
                int quantita = resultSet.getInt("totale_scarpe");
                out.println("<p style='color:blue;'>[OK] Query eseguita correttamente!</p>");
                out.println("<p>Numero di scarpe trovate nel catalogo del database: <b>" + quantita + "</b> (Dovrebbero essere 5).</p>");
            }

        } catch (Exception e) {
          
            out.println("<p style='color:red; font-weight:bold;'>[ERRORE] Qualcosa è andato storto nella connessione!</p>");
            out.println("<p><b>Messaggio di errore:</b> " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) {
                    DBConnectionPool.releaseConnection(connection);
                    out.println("<p style='color:gray; font-size:12px;'>Connessione riposta correttamente nel Pool.</p>");
                }
            } catch (Exception ex) {
                out.println("<p style='color:red;'>Errore nel rilascio delle risorse: " + ex.getMessage() + "</p>");
            }
        }
        
        out.println("</body></html>");
    }
}