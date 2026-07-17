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
        
        if (idString != null && qtyString != null) {
            try {
                int idProdotto = Integer.parseInt(idString);
                int quantita = Integer.parseInt(qtyString);
                
                HttpSession session = request.getSession();
                Carrello carrello = (Carrello) session.getAttribute("carrello");
                
                if (carrello != null) {
                    carrello.updateQuantita(idProdotto, quantita);
                    session.setAttribute("messaggioSuccesso", "Quantità aggiornata con successo!");
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
