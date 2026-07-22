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
                p.setImmagine(resultSet.getString("immagine"));
                
                VarianteDAO vDao = new VarianteDAO();
                p.setVarianti(vDao.doRetrieveByProdotto(p.getIdProdotto()));
                
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

    public List<Prodotto> doRetrieveByCategory(int idCategoria) {
        List<Prodotto> prodotti = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String selectSQL = "SELECT * FROM PRODOTTO WHERE is_deleted = 0 AND id_categoria = ?";

        try {
            connection = DBConnectionPool.getConnection();
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setInt(1, idCategoria);
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
                p.setImmagine(resultSet.getString("immagine"));
                
                VarianteDAO vDao = new VarianteDAO();
                p.setVarianti(vDao.doRetrieveByProdotto(p.getIdProdotto()));
                
                prodotti.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Errore in ProdottoDAO.doRetrieveByCategory: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
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
                p.setImmagine(resultSet.getString("immagine"));
                
                VarianteDAO vDao = new VarianteDAO();
                p.setVarianti(vDao.doRetrieveByProdotto(p.getIdProdotto()));
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
       
        String insertSQL = "INSERT INTO PRODOTTO (nome, descrizione, prezzo, marca, id_categoria, immagine) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(insertSQL);
            
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getDescrizione());
            ps.setDouble(3, prodotto.getPrezzo());
            ps.setString(4, prodotto.getMarca());
            ps.setInt(5, prodotto.getIdCategoria());
            ps.setString(6, prodotto.getImmagine());
            
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
                p.setImmagine(rs.getString("immagine"));
                
                VarianteDAO vDao = new VarianteDAO();
                p.setVarianti(vDao.doRetrieveByProdotto(p.getIdProdotto()));
                
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

    // Modifica completa di un prodotto
    public boolean updateProdottoCompleto(Prodotto p, boolean aggiornaImmagine) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        String updateSQL = "UPDATE PRODOTTO SET nome = ?, descrizione = ?, prezzo = ?, marca = ?, id_categoria = ?";
        if (aggiornaImmagine) {
            updateSQL += ", immagine = ?";
        }
        updateSQL += " WHERE id_prodotto = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(updateSQL);
            
            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescrizione());
            ps.setDouble(3, p.getPrezzo());
            ps.setString(4, p.getMarca());
            ps.setInt(5, p.getIdCategoria());
            
            int parameterIndex = 6;
            
            if (aggiornaImmagine) {
                ps.setString(parameterIndex++, p.getImmagine());
            }
            
            ps.setInt(parameterIndex, p.getIdProdotto());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Errore updateProdottoCompleto: " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // Elimina fisicamente un prodotto dal DB
    public boolean deleteProdotto(int idProdotto) {
        Connection connection = null;
        PreparedStatement ps = null;
        String deleteSQL = "DELETE FROM PRODOTTO WHERE id_prodotto = ?";
        
        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(deleteSQL);
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

    // Cerca prodotti per nome (usato per la barra di ricerca AJAX)
    public List<Prodotto> doSearch(String query) {
        List<Prodotto> prodotti = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Cerca i prodotti in cui il nome contiene la stringa cercata (ignorando maiuscole/minuscole in MySQL di default)
        // e si assicura che il prodotto non sia stato eliminato logicamente.
        String selectSQL = "SELECT id_prodotto, nome, prezzo, immagine FROM PRODOTTO WHERE is_deleted = 0 AND nome LIKE ?";

        try {
            connection = DBConnectionPool.getConnection();
            ps = connection.prepareStatement(selectSQL);
            // I % servono per dire "qualsiasi cosa prima e qualsiasi cosa dopo"
            ps.setString(1, "%" + query + "%");
            
            rs = ps.executeQuery();

            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setIdProdotto(rs.getInt("id_prodotto"));
                p.setNome(rs.getString("nome"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setImmagine(rs.getString("immagine"));
                // Non carichiamo tutti i campi perché per la tendina dei suggerimenti bastano questi
                prodotti.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Errore ricerca prodotti: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) DBConnectionPool.releaseConnection(connection);
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return prodotti;
    }
}