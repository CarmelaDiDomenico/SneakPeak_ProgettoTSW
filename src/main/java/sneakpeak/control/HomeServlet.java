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
        
        // Recuperiamo tutto il catalogo per estrarre le marche e poi filtrare
        List<Prodotto> tutto = prodottoDAO.doRetrieveAll();
        
        // Estrai tutte le marche uniche disponibili per popolare la tendina filtri
        List<String> marcheDisponibili = tutto.stream()
                .map(Prodotto::getMarca)
                .distinct()
                .sorted()
                .collect(java.util.stream.Collectors.toList());
        request.setAttribute("marcheDisponibili", marcheDisponibili);
        
        // Estrai tutte le taglie uniche disponibili da tutte le varianti
        List<String> taglieDisponibili = tutto.stream()
                .flatMap(p -> p.getVarianti().stream())
                .map(sneakpeak.model.Variante::getTaglia)
                .distinct()
                .sorted()
                .collect(java.util.stream.Collectors.toList());
        request.setAttribute("taglieDisponibili", taglieDisponibili);
        
        List<Prodotto> catalogo = tutto;
        
        // 1. Filtro Categoria
        String idCategoriaStr = request.getParameter("categoria");
        if (idCategoriaStr != null && !idCategoriaStr.isEmpty()) {
            int idCategoria = Integer.parseInt(idCategoriaStr);
            catalogo = catalogo.stream()
                    .filter(p -> p.getIdCategoria() == idCategoria)
                    .collect(java.util.stream.Collectors.toList());
        }
        
        // 2. Filtro Marca
        String marca = request.getParameter("marca");
        if (marca != null && !marca.isEmpty()) {
            catalogo = catalogo.stream()
                    .filter(p -> p.getMarca().equalsIgnoreCase(marca))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        // 3. Filtro Taglia (mostra solo prodotti che hanno quella taglia con quantità > 0)
        String taglia = request.getParameter("taglia");
        if (taglia != null && !taglia.isEmpty()) {
            catalogo = catalogo.stream()
                    .filter(p -> p.getVarianti().stream()
                            .anyMatch(v -> v.getTaglia().equalsIgnoreCase(taglia) && v.getQuantita() > 0))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        // 4. Ordinamento
        String ordinamento = request.getParameter("ordinamento");
        if (ordinamento != null && !ordinamento.isEmpty()) {
            switch (ordinamento) {
                case "prezzo_asc":
                    catalogo.sort(java.util.Comparator.comparingDouble(Prodotto::getPrezzo));
                    break;
                case "prezzo_desc":
                    catalogo.sort(java.util.Comparator.comparingDouble(Prodotto::getPrezzo).reversed());
                    break;
                case "nome_asc":
                    catalogo.sort(java.util.Comparator.comparing(Prodotto::getNome));
                    break;
                case "nome_desc":
                    catalogo.sort(java.util.Comparator.comparing(Prodotto::getNome).reversed());
                    break;
            }
        }
        
        //Inseriamo questa lista filtrata e ordinata dentro la richiesta
        request.setAttribute("listaProdotti", catalogo);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); // Se arriva una richiesta POST, la trattiamo come una GET
    }
}