package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Carrello;

@WebServlet("/modificaCarrello")
public class ModificaCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idString = request.getParameter("id");
        String qtyString = request.getParameter("quantita");
        String taglia = request.getParameter("taglia");
        
        if (idString != null && qtyString != null && taglia != null) {
            try {
                int idProdotto = Integer.parseInt(idString);
                int quantita = Integer.parseInt(qtyString);
                
                HttpSession session = request.getSession();
                Carrello carrello = (Carrello) session.getAttribute("carrello");
                
                if (carrello != null) {
                    sneakpeak.model.ProdottoDAO dao = new sneakpeak.model.ProdottoDAO();
                    sneakpeak.model.Prodotto prodotto = dao.doRetrieveById(idProdotto);
                    
                    if (prodotto != null) {
                        sneakpeak.model.Variante var = prodotto.getVarianti().stream()
                            .filter(v -> v.getTaglia().equals(taglia))
                            .findFirst().orElse(null);
                            
                        if (var != null) {
                            if (quantita <= var.getQuantita()) {
                                carrello.updateQuantita(idProdotto, taglia, quantita);
                                session.setAttribute("messaggioSuccesso", "Quantità aggiornata con successo!");
                            } else {
                                carrello.updateQuantita(idProdotto, taglia, var.getQuantita());
                                session.setAttribute("erroreCarrello", "Hai richiesto più unità di quante disponibili. Quantità impostata al massimo disponibile (" + var.getQuantita() + ").");
                            }
                        }
                    }
                }
            } catch (NumberFormatException e) {
                System.out.println("Errore formato parametri in ModificaCarrelloServlet: " + e.getMessage());
            }
        }
        
        response.sendRedirect("carrello.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
