package sneakpeak.control;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;

/**
 * Questa Servlet intercetta le richieste dirette alla Home Page ("/home").
 *
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        //Chiamiamo il nostro DAO
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        // Leggiamo se c'è un filtro categoria
        String idCategoriaStr = request.getParameter("categoria");
        List<Prodotto> catalogo;
        
        if (idCategoriaStr != null && !idCategoriaStr.isEmpty()) {
            int idCategoria = Integer.parseInt(idCategoriaStr);
            catalogo = prodottoDAO.doRetrieveByCategory(idCategoria);
        } else {
            catalogo = prodottoDAO.doRetrieveAll();
        }
        
        //Inseriamo questa lista di scarpe dentro la richiesta
        request.setAttribute("listaProdotti", catalogo);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); // Se arriva una richiesta POST, la trattiamo come una GET
    }
}