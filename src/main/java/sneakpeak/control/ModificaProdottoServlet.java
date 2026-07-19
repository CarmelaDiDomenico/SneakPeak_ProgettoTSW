package sneakpeak.control;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import sneakpeak.model.Categoria;
import sneakpeak.model.CategoriaDAO;
import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;
import sneakpeak.model.Utente;

@WebServlet("/modificaProdotto")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ModificaProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp?errore=accesso_negato");
            return;
        }

        try {
            int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            Prodotto prodotto = prodottoDAO.doRetrieveById(idProdotto);
            
            if (prodotto == null) {
                response.sendRedirect("gestioneCatalogo");
                return;
            }

            CategoriaDAO categoriaDAO = new CategoriaDAO();
            List<Categoria> categorie = categoriaDAO.doRetrieveAll();
            
            request.setAttribute("prodotto", prodotto);
            request.setAttribute("categorie", categorie);

            RequestDispatcher dispatcher = request.getRequestDispatcher("modificaProdotto.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("gestioneCatalogo");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp?errore=accesso_negato");
            return;
        }

        try {
            int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
            String nome = request.getParameter("nome");
            String marca = request.getParameter("marca");
            String descrizione = request.getParameter("descrizione");
            double prezzo = Double.parseDouble(request.getParameter("prezzo"));
            int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));

            Prodotto p = new Prodotto();
            p.setIdProdotto(idProdotto);
            p.setNome(nome);
            p.setMarca(marca);
            p.setDescrizione(descrizione);
            p.setPrezzo(prezzo);
            p.setIdCategoria(idCategoria);

            boolean aggiornaImmagine = false;
            Part filePart = request.getPart("immagine");
            
            // Se l'admin ha selezionato un file, lo salviamo
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                filePart.write(uploadPath + File.separator + fileName);
                
                String percorsoDB = "img/" + fileName;
                p.setImmagine(percorsoDB);
                aggiornaImmagine = true;
            }

            ProdottoDAO dao = new ProdottoDAO();
            boolean modificato = dao.updateProdottoCompleto(p, aggiornaImmagine);

            if (modificato) {
                response.sendRedirect("modificaProdotto?idProdotto=" + idProdotto + "&successo=true");
            } else {
                response.sendRedirect("modificaProdotto?idProdotto=" + idProdotto + "&errore=true");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("gestioneCatalogo");
        }
    }
}
