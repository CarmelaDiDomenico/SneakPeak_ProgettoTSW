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
        
        //Leggiamo l'ID del prodotto e la taglia da rimuovere
        String idString = request.getParameter("id");
        String taglia = request.getParameter("taglia");
        
        if (idString != null && taglia != null) {
            try {
                int idProdotto = Integer.parseInt(idString);
                
                //Recuperiamo la sessione attuale dell'utente
                HttpSession session = request.getSession();
                
                //Estraiamo il carrello dalla sessione
                Carrello carrello = (Carrello) session.getAttribute("carrello");
                
                //Se il carrello esiste, rimuoviamo la scarpa tramite il suo ID e la taglia
                if (carrello != null) {
                    carrello.removeProdotto(idProdotto, taglia);
                    session.setAttribute("messaggioSuccesso", "Prodotto rimosso dal carrello.");
                }
                
            } catch (NumberFormatException e) {
                System.out.println("Errore ID durante la rimozione dal carrello: " + e.getMessage());
            }
        }
        
        // Ricarichiamo la pagina del carrello in modo che l'utente veda la lista aggiornata
        response.sendRedirect("carrello.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}