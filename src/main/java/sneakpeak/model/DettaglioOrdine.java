package sneakpeak.model;

public class DettaglioOrdine {
    private int idOrdine;
    private int idProdotto;
    private String nomeProdotto;   // Recuperato via JOIN con PRODOTTO
    private String taglia;         
    private int quantita;
    private double prezzoAcquisto;
    private double ivaAcquisto;

    public DettaglioOrdine() {}

    public int getIdOrdine()
    { return idOrdine; }
    public void setIdOrdine(int idOrdine)
    { this.idOrdine = idOrdine; }

    public int getIdProdotto()
    { return idProdotto; }
    public void setIdProdotto(int idProdotto)
    { this.idProdotto = idProdotto; }

    public String getNomeProdotto()
    { return nomeProdotto; }
    public void setNomeProdotto(String nomeProdotto)
    { this.nomeProdotto = nomeProdotto; }

    public String getTaglia()
    { return taglia; }
    public void setTaglia(String taglia)
    { this.taglia = taglia; }

    public int getQuantita()
    { return quantita; }
    public void setQuantita(int quantita)
    { this.quantita = quantita; }

    public double getPrezzoAcquisto()
    { return prezzoAcquisto; }
    public void setPrezzoAcquisto(double prezzoAcquisto)
    { this.prezzoAcquisto = prezzoAcquisto; }

    public double getIvaAcquisto()
    { return ivaAcquisto; }
    public void setIvaAcquisto(double ivaAcquisto)
    { this.ivaAcquisto = ivaAcquisto; }

    /**
     * Restituisce il prezzo lordo (con IVA) della singola unità al momento dell'acquisto.
     */
    public double getPrezzoLordo() {
        return prezzoAcquisto * (1 + ivaAcquisto / 100.0);
    }

    /**
     * Restituisce il subtotale lordo (prezzo lordo × quantità).
     */
    public double getSubtotale() {
        return getPrezzoLordo() * quantita;
    }
}