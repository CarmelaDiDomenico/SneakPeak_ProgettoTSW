package sneakpeak.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Questa classe riceve una password in chiaro e la trasforma in un 
 * codice indecifrabile usando l'algoritmo SHA-256.
 */
public class PasswordHelper {

    /**
     * Metodo per cifrare la password.
     * @param password La password in chiaro inserita dall'utente.
     * @return La stringa cifrata in formato esadecimale (lunga 64 caratteri).
     */
    public static String hashPassword(String password) {
        try {
            // Selezioniamo l'algoritmo SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            
            // Convertiamo la password in byte e applichiamo l'algoritmo
            byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            
            // Convertiamo i byte cifrati in una stringa leggibile
            StringBuilder hexString = new StringBuilder(2 * encodedhash.length);
            for (int i = 0; i < encodedhash.length; i++) {
                String hex = Integer.toHexString(0xff & encodedhash[i]);
                if(hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Errore critico: Algoritmo di cifratura non trovato", e);
        }
    }
}
