package sneakpeak.control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sneakpeak.model.Utente;
import sneakpeak.model.UtenteDAO;


//Servlet che gestisce la richiesta di registrazione di un nuovo utente.
 
@WebServlet("/registrazione")
public class RegistrazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Se si tenta di accedere via GET, rimandiamo alla pagina del form
        response.sendRedirect("registrazione.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Recupero dei parametri inviati dal form
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        //Validazione lato server (doppia sicurezza oltre a JavaScript)
        if (nome == null || nome.trim().isEmpty() ||
            cognome == null || cognome.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errore", "Tutti i campi sono obbligatori.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/registrazione.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        nome = nome.trim();
        cognome = cognome.trim();
        email = email.trim();
        
        UtenteDAO utenteDAO = new UtenteDAO();
        
        //Controllo duplicazione email anche lato server
        Utente utenteEsistente = utenteDAO.doRetrieveByEmail(email);
        if (utenteEsistente != null) {
            request.setAttribute("errore", "Questa email è già associata a un account.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/registrazione.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        //Creazione dell'oggetto Bean Utente da salvare
        Utente nuovoUtente = new Utente();
        nuovoUtente.setNome(nome);
        nuovoUtente.setCognome(cognome);
        nuovoUtente.setEmail(email);
        nuovoUtente.setPassword(password); // La cifratura SHA-256 avviene dentro UtenteDAO.doSave()
        nuovoUtente.setTipo("CLIENTE"); // Di default inseriamo un utente di tipo cliente
        
        //Salvataggio nel database
        boolean registrato = utenteDAO.doSave(nuovoUtente);
        
        if (registrato) {
            // Se la registrazione ha successo, reindirizziamo alla pagina di login con un messaggio di successo
            response.sendRedirect("login.jsp?registrato=true");
        } else {
            // Se c'è stato un errore nel DB
            request.setAttribute("errore", "Errore del server durante la registrazione. Riprova più tardi.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/registrazione.jsp");
            dispatcher.forward(request, response);
        }
    }
}
