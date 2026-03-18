import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;

/**
 * Visualize each Scottie S2 channel separately as grayscale images
 * to see what data is actually in each position
 */
public class VisualizeChannels {
    public static void main(String[] args) throws Exception {
        // Load the decoded image
        BufferedImage decoded = ImageIO.read(new File("sstv_decoded.png"));
        int width = decoded.getWidth();
        int height = decoded.getHeight();
        
        // Create separate images for R, G, B channels
        BufferedImage redChannel = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);
        BufferedImage greenChannel = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);
        BufferedImage blueChannel = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);
        
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int rgb = decoded.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = rgb & 0xFF;
                
                // Set each channel as grayscale
                redChannel.setRGB(x, y, (r << 16) | (r << 8) | r);
                greenChannel.setRGB(x, y, (g << 16) | (g << 8) | g);
                blueChannel.setRGB(x, y, (b << 16) | (b << 8) | b);
            }
        }
        
        // Save channel images
        ImageIO.write(redChannel, "PNG", new File("channel_R.png"));
        ImageIO.write(greenChannel, "PNG", new File("channel_G.png"));
        ImageIO.write(blueChannel, "PNG", new File("channel_B.png"));
        
        System.out.println("Channels saved:");
        System.out.println("  channel_R.png - RED channel (from Scottie 'GREEN' position)");
        System.out.println("  channel_G.png - GREEN channel (from Scottie 'BLUE' position) - PERFECT!");
        System.out.println("  channel_B.png - BLUE channel (from Scottie 'RED' position)");
    }
}
