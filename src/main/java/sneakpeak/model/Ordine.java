package sneakpeak.model;

import java.sql.Date;

public class Ordine {
    private int idOrdine;
    private int idUtente;
    private double totale;
    private Date dataOrdine;
    private int idIndirizzo;
    private int idPagamento;
    private String stato;

    // Campi transient: non presenti nella tabella ORDINE,
    // vengono popolati dalla JOIN con UTENTE nelle query Admin.
    private String nomeCliente;
    private String emailCliente;

    // Costruttore vuoto
    public Ordine() {}

    public int getIdOrdine() 
    { return idOrdine; }
    
    public void setIdOrdine(int idOrdine)
    { this.idOrdine = idOrdine; }

    public int getIdUtente()
    { return idUtente; }
    
    public void setIdUtente(int idUtente) 
    { this.idUtente = idUtente; }

    public double getTotale() 
    { return totale; }
    
    public void setTotale(double totale) 
    { this.totale = totale; }

    public Date getDataOrdine() 
    { return dataOrdine; }
    
    public void setDataOrdine(Date dataOrdine) 
    { this.dataOrdine = dataOrdine; }
    
    public int getIdIndirizzo() 
    { return idIndirizzo; }
    
    public void setIdIndirizzo(int idIndirizzo) 
    { this.idIndirizzo = idIndirizzo; }

    public int getIdPagamento() 
    { return idPagamento; }
    
    public void setIdPagamento(int idPagamento) 
    { this.idPagamento = idPagamento; }
    
    public String getStato() 
    { return stato; }
    
    public void setStato(String stato) 
    { this.stato = stato; }

    public String getNomeCliente()
    { return nomeCliente; }

    public void setNomeCliente(String nomeCliente)
    { this.nomeCliente = nomeCliente; }

    public String getEmailCliente()
    { return emailCliente; }

    public void setEmailCliente(String emailCliente)
    { this.emailCliente = emailCliente; }
}