package sneakpeak.model;

public class DettaglioOrdine {
    private int idOrdine;
    private int idProdotto;
    private double prezzoAcquisto;

    public DettaglioOrdine() {}

    public int getIdOrdine() 
    { return idOrdine; }
    
    public void setIdOrdine(int idOrdine) 
    { this.idOrdine = idOrdine; }

    public int getIdProdotto() 
    { return idProdotto; }
    
    public void setIdProdotto(int idProdotto) 
    { this.idProdotto = idProdotto; }

    public double getPrezzoAcquisto() 
    { return prezzoAcquisto; }
    
    public void setPrezzoAcquisto(double prezzoAcquisto) 
    { this.prezzoAcquisto = prezzoAcquisto; }
}