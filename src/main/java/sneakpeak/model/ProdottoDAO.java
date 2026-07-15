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
}