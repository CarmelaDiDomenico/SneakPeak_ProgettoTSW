package sneakpeak.model;

public class MetodoPagamento {
    private int idPagamento;
    private int idUtente;
    private String tipo;
    private String intestatario;

    public MetodoPagamento() {}

    public int getIdPagamento() 
    { return idPagamento; }
   
    public void setIdPagamento(int idPagamento) 
    { this.idPagamento = idPagamento; }

    public int getIdUtente() 
    { return idUtente; }
    
    public void setIdUtente(int idUtente) 
    { this.idUtente = idUtente; }

    public String getTipo() 
    { return tipo; }
    
    public void setTipo(String tipo) 
    { this.tipo = tipo; }

    public String getIntestatario() 
    { return intestatario; }
    
    public void setIntestatario(String intestatario) 
    { this.intestatario = intestatario; }
}