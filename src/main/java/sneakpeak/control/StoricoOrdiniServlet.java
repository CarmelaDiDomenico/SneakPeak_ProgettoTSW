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

import sneakpeak.model.Ordine;
import sneakpeak.model.OrdineDAO;
import sneakpeak.model.Utente;

@WebServlet("/storicoOrdini")
public class StoricoOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        // Controllo sicurezza
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Il Cameriere (Servlet) chiede al Cuoco (DAO) tutti gli ordini del cliente
        OrdineDAO ordineDAO = new OrdineDAO();
        List<Ordine> ordiniCliente = ordineDAO.doRetrieveByUtente(utente.getIdUtente());
        
        // Li prepara sul vassoio per la sala (JSP)
        request.setAttribute("ordiniCliente", ordiniCliente);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("storicoOrdini.jsp");
        dispatcher.forward(request, response);
    }
}
