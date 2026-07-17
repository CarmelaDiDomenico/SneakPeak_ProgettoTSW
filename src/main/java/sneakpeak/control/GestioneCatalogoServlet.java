package sneakpeak.control;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;
import sneakpeak.model.Utente;

@WebServlet("/gestioneCatalogo")
public class GestioneCatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // MOSTRA LA TABELLA
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp?errore=accesso_negato");
            return;
        }

        ProdottoDAO dao = new ProdottoDAO();
        List<Prodotto> listaProdotti = dao.doRetrieveAllAdmin();
        
        request.setAttribute("listaProdotti", listaProdotti);
        RequestDispatcher dispatcher = request.getRequestDispatcher("gestioneCatalogo.jsp");
        dispatcher.forward(request, response);
    }

    // GESTISCE LE MODIFICHE E LE ELIMINAZIONI
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
        ProdottoDAO dao = new ProdottoDAO();

        if ("modificaPrezzo".equals(action)) {
            double nuovoPrezzo = Double.parseDouble(request.getParameter("nuovoPrezzo"));
            dao.updatePrezzo(idProdotto, nuovoPrezzo);
        } 
        else if ("nascondi".equals(action)) {
            dao.nascondiProdotto(idProdotto);
        }
        else if ("riattiva".equals(action)) { 
            dao.riattivaProdotto(idProdotto);
        }

        // Ricarica la pagina 
        response.sendRedirect("gestioneCatalogo");
    }
}