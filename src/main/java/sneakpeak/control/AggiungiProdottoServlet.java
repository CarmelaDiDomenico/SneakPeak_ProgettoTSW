package sneakpeak.control;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;
import sneakpeak.model.Utente;

@WebServlet("/aggiungiProdotto")
// ANNOTAZIONE PER GESTIRE I FILE
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AggiungiProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("aggiungiProdotto.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp?errore=accesso_negato");
            return;
        }

        // Recupero parametri testo
        String nome = request.getParameter("nome");
        String marca = request.getParameter("marca");
        String descrizione = request.getParameter("descrizione");
        
        double prezzo = 0;
        int idCategoria = 0;
        try {
            prezzo = Double.parseDouble(request.getParameter("prezzo"));
            idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        } catch (NumberFormatException e) {
            response.sendRedirect("aggiungiProdotto.jsp?errore=true");
            return;
        }

        // GESTIONE UPLOAD IMMAGINE
        Part filePart = request.getPart("immagine"); 
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        
        String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        
        filePart.write(uploadPath + File.separator + fileName);
        
        
        String percorsoDB = "img/" + fileName;
        

        Prodotto nuovoProdotto = new Prodotto();
        nuovoProdotto.setNome(nome);
        nuovoProdotto.setMarca(marca);
        nuovoProdotto.setDescrizione(descrizione);
        nuovoProdotto.setPrezzo(prezzo);
        nuovoProdotto.setIdCategoria(idCategoria); 
        nuovoProdotto.setImmagine(percorsoDB); 

        ProdottoDAO dao = new ProdottoDAO();
        boolean salvato = dao.doSave(nuovoProdotto);

        if (salvato) {
            response.sendRedirect("aggiungiProdotto.jsp?successo=true");
        } else {
            response.sendRedirect("aggiungiProdotto.jsp?errore=true");
        }
    }
}