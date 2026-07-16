package sneakpeak.model;

public class Indirizzo {
    private int idIndirizzo;
    private int idUtente;
    private String via;
    private String citta;
    private String cap;
    private String civico;
    private String provincia;
    private String nazione;

    public Indirizzo() {}

    public int getIdIndirizzo() 
    { return idIndirizzo; }
    
    public void setIdIndirizzo(int idIndirizzo) 
    { this.idIndirizzo = idIndirizzo; }

    public int getIdUtente() 
    { return idUtente; }
    
    public void setIdUtente(int idUtente) 
    { this.idUtente = idUtente; }

    public String getVia() 
    { return via; }
    
    public void setVia(String via) 
    { this.via = via; }

    public String getCitta() 
    { return citta; }
    
    public void setCitta(String citta) 
    { this.citta = citta; }

    public String getCap() 
    { return cap; }
    
    public void setCap(String cap) 
    { this.cap = cap; }
    
    public String getCivico() 
    { return civico; }
   
    public void setCivico(String civico) 
    { this.civico = civico; }

    public String getProvincia() 
    { return provincia; }
    
    public void setProvincia(String provincia) 
    { this.provincia = provincia; }

    public String getNazione() 
    { return nazione; }
   
    public void setNazione(String nazione) 
    { this.nazione = nazione; }
}