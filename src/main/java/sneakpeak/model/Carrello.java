package sneakpeak.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Questa classe rappresenta il Carrello dell'utente.
 * Implementa Serializable perché verrà salvata nella Sessione di Tomcat.
 */
public class Carrello implements Serializable {
    private static final long serialVersionUID = 1L;

    // La lista che conterrà fisicamente gli oggetti Prodotto scelti dall'utente
    private List<Prodotto> articoli;

    // Il costruttore inizializza la lista vuota quando il carrello nasce
    public Carrello() {
        articoli = new ArrayList<>();
    }

    // Metodo per aggiungere una scarpa al carrello
    public void addProdotto(Prodotto p) {
        articoli.add(p);
    }

    // Metodo per rimuovere una scarpa dal carrello tramite il suo ID
    public void removeProdotto(int idProdotto) {
        for (int i = 0; i < articoli.size(); i++) {
            if (articoli.get(i).getIdProdotto() == idProdotto) {
                articoli.remove(i);
                break; // Interrompiamo il ciclo dopo aver rimosso la prima occorrenza
            }
        }
    }

    // Metodo per ottenere la lista di tutti i prodotti nel carrello
    public List<Prodotto> getArticoli() {
        return articoli;
    }

    // Metodo utilissimo che calcola la somma dei prezzi di tutte le scarpe nel carrello
    public double getPrezzoTotale() {
        double totale = 0;
        for (Prodotto p : articoli) {
            totale += p.getPrezzo();
        }
        return totale;
    }

    // Metodo per verificare al volo se il carrello è vuoto
    public boolean isEmpty() {
        return articoli.isEmpty();
    }
}