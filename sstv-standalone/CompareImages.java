import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.File;

/**
 * Quick tool to compare original vs decoded images
 */
public class CompareImages {
    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            System.out.println("Usage: java CompareImages <original.bmp> <decoded.png>");
            return;
        }
        
        BufferedImage original = ImageIO.read(new File(args[0]));
        BufferedImage decoded = ImageIO.read(new File(args[1]));
        
        System.out.println("Original: " + original.getWidth() + "x" + original.getHeight());
        System.out.println("Decoded:  " + decoded.getWidth() + "x" + decoded.getHeight());
        
        // Sample a few pixels to see color channel mapping
        System.out.println("\nPixel comparison (original -> decoded):");
        
        int[][] testPoints = {
            {10, 10},    // Top left
            {160, 128},  // Center
            {310, 10},   // Top right
            {10, 240},   // Bottom left
            {310, 240}   // Bottom right
        };
        
        for (int[] point : testPoints) {
            int x = point[0];
            int y = point[1];
            
            if (x < original.getWidth() && y < original.getHeight() &&
                x < decoded.getWidth() && y < decoded.getHeight()) {
                
                int origRGB = original.getRGB(x, y);
                int decRGB = decoded.getRGB(x, y);
                
                int origR = (origRGB >> 16) & 0xFF;
                int origG = (origRGB >> 8) & 0xFF;
                int origB = origRGB & 0xFF;
                
                int decR = (decRGB >> 16) & 0xFF;
                int decG = (decRGB >> 8) & 0xFF;
                int decB = decRGB & 0xFF;
                
                System.out.printf("(%3d,%3d): Orig RGB(%3d,%3d,%3d) -> Dec RGB(%3d,%3d,%3d)\n",
                    x, y, origR, origG, origB, decR, decG, decB);
            }
        }
        
        // Analyze color channel correlation
        System.out.println("\nAnalyzing channel correlation (first 100x100 pixels):");
        
        long rr=0, rg=0, rb=0;  // Red original correlates with which decoded channel?
        long gr=0, gg=0, gb=0;  // Green original correlates with which decoded channel?
        long br=0, bg=0, bb=0;  // Blue original correlates with which decoded channel?
        
        int samples = 0;
        for (int y = 0; y < Math.min(100, Math.min(original.getHeight(), decoded.getHeight())); y++) {
            for (int x = 0; x < Math.min(100, Math.min(original.getWidth(), decoded.getWidth())); x++) {
                int origRGB = original.getRGB(x, y);
                int decRGB = decoded.getRGB(x, y);
                
                int origR = (origRGB >> 16) & 0xFF;
                int origG = (origRGB >> 8) & 0xFF;
                int origB = origRGB & 0xFF;
                
                int decR = (decRGB >> 16) & 0xFF;
                int decG = (decRGB >> 8) & 0xFF;
                int decB = decRGB & 0xFF;
                
                // Calculate absolute differences
                rr += Math.abs(origR - decR);
                rg += Math.abs(origR - decG);
                rb += Math.abs(origR - decB);
                
                gr += Math.abs(origG - decR);
                gg += Math.abs(origG - decG);
                gb += Math.abs(origG - decB);
                
                br += Math.abs(origB - decR);
                bg += Math.abs(origB - decG);
                bb += Math.abs(origB - decB);
                
                samples++;
            }
        }
        
        System.out.println("Average difference (lower = better match):");
        System.out.printf("  Original RED   best matches: R=%.1f, G=%.1f, B=%.1f\n",
            rr/(double)samples, rg/(double)samples, rb/(double)samples);
        System.out.printf("  Original GREEN best matches: R=%.1f, G=%.1f, B=%.1f\n",
            gr/(double)samples, gg/(double)samples, gb/(double)samples);
        System.out.printf("  Original BLUE  best matches: R=%.1f, G=%.1f, B=%.1f\n",
            br/(double)samples, bg/(double)samples, bb/(double)samples);
        
        // Determine mapping
        System.out.println("\nDiagnosis:");
        String[] channels = {"R", "G", "B"};
        double[][] scores = {{rr, rg, rb}, {gr, gg, gb}, {br, bg, bb}};
        String[] origNames = {"RED", "GREEN", "BLUE"};
        
        for (int i = 0; i < 3; i++) {
            int bestIdx = 0;
            double bestScore = scores[i][0];
            for (int j = 1; j < 3; j++) {
                if (scores[i][j] < bestScore) {
                    bestScore = scores[i][j];
                    bestIdx = j;
                }
            }
            System.out.printf("  Original %s → Decoded %s (diff=%.1f)\n",
                origNames[i], channels[bestIdx], bestScore / samples);
        }
    }
}
