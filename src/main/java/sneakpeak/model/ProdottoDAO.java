package sneakpeak.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sneakpeak.util.DBConnectionPool;

public class ProdottoDAO {

    public List<Prodotto> doRetrieveAll() {
        
        List<Prodotto> prodotti = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT * FROM PRODOTTO WHERE is_deleted = 0";

        try {
            connection = DBConnectionPool.getConnection();
            
            preparedStatement = connection.prepareStatement(selectSQL);
            
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                
                Prodotto p = new Prodotto();
                
                p.setIdProdotto(resultSet.getInt("id_prodotto"));
                p.setNome(resultSet.getString("nome"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setPrezzo(resultSet.getDouble("prezzo"));
                p.setMarca(resultSet.getString("marca"));
                p.setIsDeleted(resultSet.getInt("is_deleted"));
                p.setIdCategoria(resultSet.getInt("id_categoria"));
                
                prodotti.add(p);
            }

        } catch (SQLException e) {
            System.out.println("Errore in ProdottoDAO.doRetrieveAll: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                
                if (connection != null) {
                    DBConnectionPool.releaseConnection(connection);
                }
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse in ProdottoDAO: " + ex.getMessage());
            }
        }

        return prodotti;
    }
    
    public Prodotto doRetrieveById(int id) {
        Prodotto p = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT * FROM PRODOTTO WHERE id_prodotto = ?";

        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            
            preparedStatement.setInt(1, id);
            
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                p = new Prodotto();
                p.setIdProdotto(resultSet.getInt("id_prodotto"));
                p.setNome(resultSet.getString("nome"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setPrezzo(resultSet.getDouble("prezzo"));
                p.setMarca(resultSet.getString("marca"));
                p.setIsDeleted(resultSet.getInt("is_deleted"));
                p.setIdCategoria(resultSet.getInt("id_categoria"));
            }
        } catch (SQLException e) {
            System.out.println("Errore in ProdottoDAO.doRetrieveById: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                System.out.println("Errore chiusura risorse: " + ex.getMessage());
            }
        }

        return p; 
    }

    public boolean doSave(Prodotto prodotto) {
        Connection connection = null;
        PreparedStatement ps = null;
       
        String insertSQL = "INSERT INTO PRODOTTO (nome, descrizione, prezzo, marca, id_categoria) VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(insertSQL);
            
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getDescrizione());
            ps.setDouble(3, prodotto.getPrezzo());
            ps.setString(4, prodotto.getMarca());
            ps.setInt(5, prodotto.getIdCategoria()); 
            
            int result = ps.executeUpdate();
            return (result > 0);
            
        } catch (SQLException e) {
            System.out.println("Errore salvataggio prodotto: " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
    
 // Recupera tutto il catalogo per l'Admin
    public List<Prodotto> doRetrieveAllAdmin() {
        List<Prodotto> prodotti = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        
        String selectSQL = "SELECT * FROM PRODOTTO";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setIdProdotto(rs.getInt("id_prodotto"));
                p.setNome(rs.getString("nome"));
                p.setDescrizione(rs.getString("descrizione"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setMarca(rs.getString("marca"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setIsDeleted(rs.getInt("is_deleted")); 
                prodotti.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Errore recupero catalogo admin: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return prodotti;
    }

    // Modifica il prezzo di un prodotto
    public boolean updatePrezzo(int idProdotto, double nuovoPrezzo) {
        Connection connection = null;
        PreparedStatement ps = null;
        String updateSQL = "UPDATE PRODOTTO SET prezzo = ? WHERE id_prodotto = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(updateSQL);
            ps.setDouble(1, nuovoPrezzo);
            ps.setInt(2, idProdotto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // Nasconde un prodotto 
    public boolean nascondiProdotto(int idProdotto) {
        Connection connection = null;
        PreparedStatement ps = null;
        // Invece di DELETE, usiamo UPDATE per impostare is_deleted = 1
        String updateSQL = "UPDATE PRODOTTO SET is_deleted = 1 WHERE id_prodotto = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(updateSQL);
            ps.setInt(1, idProdotto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }
    
 //Riattiva un prodotto precedentemente nascosto
    public boolean riattivaProdotto(int idProdotto) {
        Connection connection = null;
        PreparedStatement ps = null;
        String updateSQL = "UPDATE PRODOTTO SET is_deleted = 0 WHERE id_prodotto = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(updateSQL);
            ps.setInt(1, idProdotto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }
}