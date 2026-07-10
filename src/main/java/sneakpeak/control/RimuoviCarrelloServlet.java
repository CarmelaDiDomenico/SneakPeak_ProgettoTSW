package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Carrello;

// Questa Servlet intercetta l'URL "/rimuoviCarrello"
@WebServlet("/rimuoviCarrello")
public class RimuoviCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Leggiamo l'ID del prodotto da rimuovere dall'URL (es. rimuoviCarrello?id=1)
        String idString = request.getParameter("id");
        
        if (idString != null) {
            try {
                int idProdotto = Integer.parseInt(idString);
                
                // 2. Recuperiamo la sessione attuale dell'utente
                HttpSession session = request.getSession();
                
                // 3. Estraiamo il carrello dalla sessione
                Carrello carrello = (Carrello) session.getAttribute("carrello");
                
                // 4. Se il carrello esiste, rimuoviamo la scarpa tramite il suo ID
                if (carrello != null) {
                    carrello.removeProdotto(idProdotto);
                }
                
            } catch (NumberFormatException e) {
                System.out.println("Errore ID durante la rimozione dal carrello: " + e.getMessage());
            }
        }
        
        // 5. Ricarichiamo la pagina del carrello in modo che l'utente veda la lista aggiornata
        response.sendRedirect("carrello.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}