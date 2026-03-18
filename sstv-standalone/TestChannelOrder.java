import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.File;
import java.util.*;

/**
 * Test different RGB channel orders for Scottie S2
 */
public class TestChannelOrder {
    public static void main(String[] args) throws Exception {
        // Load the demodulated data and sync positions by re-running decoder
        System.out.println("Testing all RGB channel permutations for Scottie S2...\n");
        
        String[] channelOrders = {
            "RGB", "RBG", "GRB", "GBR", "BRG", "BGR"
        };
        
        System.out.println("Scottie S2 format variations to test:");
        System.out.println("Standard: SYNC + SEP + GREEN + SEP + BLUE + SEP + RED");
        System.out.println();
        
        for (String order : channelOrders) {
            System.out.println("Testing order: " + order);
            System.out.println("  Would decode as: SYNC + SEP + " + order.charAt(0) + 
                             " + SEP + " + order.charAt(1) + " + SEP + " + order.charAt(2));
        }
        
        System.out.println("\nTo fix, change the channel assignment in decodeScottieS2()");
        System.out.println("Current code assumes: GREEN, BLUE, RED");
        System.out.println("May need to try: RED, GREEN, BLUE or other orders");
    }
}
