package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Carrello;
import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;

// Questa Servlet risponderà all'URL "/aggiungiCarrello"
@WebServlet("/aggiungiCarrello")
public class AggiungiCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Leggiamo l'ID del prodotto inviato dal bottone/form
        String idString = request.getParameter("id");
        
        if (idString != null) {
            try {
                int idProdotto = Integer.parseInt(idString);
                
                // 2. Chiediamo al DAO di pescare la scarpa dal Database
                ProdottoDAO dao = new ProdottoDAO();
                Prodotto prodotto = dao.doRetrieveById(idProdotto);
                
                if (prodotto != null) {
                    // 3. Recupero della sessione
                    HttpSession session = request.getSession(true);
                    
                    // 4. Estraiamo l'oggetto carrello dalla sessione
                    Carrello carrello = (Carrello) session.getAttribute("carrello");
                    
                    // Se l'utente non ha mai aggiunto nulla, l'oggetto non esiste (è null). Lo creiamo noi.
                    if (carrello == null) {
                        carrello = new Carrello();
                        // Lo salviamo nella sessione così Tomcat lo ricorderà nelle prossime pagine
                        session.setAttribute("carrello", carrello);
                    }
                    
                    // 5. Inseriamo la scarpa nel carrello
                    carrello.addProdotto(prodotto);
                    session.setAttribute("messaggioSuccesso", "Prodotto aggiunto al carrello con successo!");
                }
            } catch (NumberFormatException e) {
                System.out.println("Errore formato ID nel carrello: " + e.getMessage());
            }
        }
        
        response.sendRedirect("carrello.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
