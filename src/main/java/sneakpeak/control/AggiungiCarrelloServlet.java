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
        
        //Leggiamo l'ID del prodotto inviato dal bottone/form
        String idString = request.getParameter("id");
        String taglia = request.getParameter("taglia");
        
        if (idString != null && taglia != null && !taglia.trim().isEmpty()) {
            try {
                int idProdotto = Integer.parseInt(idString);
                
                // 2. Chiediamo al DAO di pescare la scarpa dal Database
                ProdottoDAO dao = new ProdottoDAO();
                Prodotto prodotto = dao.doRetrieveById(idProdotto);
                
                if (prodotto != null) {
                    //Recupero della sessione
                    HttpSession session = request.getSession(true);
                    
                    //Estraiamo l'oggetto carrello dalla sessione
                    Carrello carrello = (Carrello) session.getAttribute("carrello");
                    
                    // Se l'utente non ha mai aggiunto nulla, l'oggetto non esiste (è null). Lo creiamo noi.
                    if (carrello == null) {
                        carrello = new Carrello();
                        // Lo salviamo nella sessione
                        session.setAttribute("carrello", carrello);
                    }
                    
                    //Controlliamo se ci sono abbastanza scorte per aggiungere un'altra unità
                    sneakpeak.model.Variante var = prodotto.getVarianti().stream()
                        .filter(v -> v.getTaglia().equals(taglia))
                        .findFirst().orElse(null);
                        
                    if (var != null) {
                        int currentQty = 0;
                        for (sneakpeak.model.CartItem item : carrello.getArticoli()) {
                            if (item.getProdotto().getIdProdotto() == idProdotto && item.getTaglia().equals(taglia)) {
                                currentQty = item.getQuantita();
                                break;
                            }
                        }
                        
                        if (currentQty + 1 <= var.getQuantita()) {
                            carrello.addProdotto(prodotto, taglia);
                            session.setAttribute("messaggioSuccesso", "Prodotto aggiunto al carrello con successo!");
                        } else {
                            session.setAttribute("erroreCarrello", "Non puoi aggiungere altre unità, giacenza massima raggiunta per questa taglia!");
                        }
                    } else {
                        session.setAttribute("erroreCarrello", "Variante non trovata.");
                    }
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
