/* c2tool: Codec 2 3200 encode/decode filter for the hotspot bench.
 *   c2tool enc  < 8 kHz s16le mono  > 8-byte Codec 2 frames (one per 160 samples)
 *   c2tool dec  < 8-byte frames     > 8 kHz s16le mono
 * Unbuffered frame by frame so it can sit in a live pipe. Links the upstream Codec 2 library (LGPL-2.1). */
#include <stdio.h>
#include <string.h>
#include "codec2.h"

int main(int argc, char **argv) {
    if (argc < 2 || (strcmp(argv[1], "enc") && strcmp(argv[1], "dec"))) { fprintf(stderr, "usage: c2tool enc|dec\n"); return 2; }
    struct CODEC2 *c = codec2_create(CODEC2_MODE_3200);
    int ns = codec2_samples_per_frame(c), nb = codec2_bytes_per_frame(c);
    short pcm[640]; unsigned char bits[16];
    if (!strcmp(argv[1], "enc")) {
        while (fread(pcm, sizeof(short), ns, stdin) == (size_t) ns) { codec2_encode(c, bits, pcm); fwrite(bits, 1, nb, stdout); fflush(stdout); }
    } else {
        while (fread(bits, 1, nb, stdin) == (size_t) nb) { codec2_decode(c, pcm, bits); fwrite(pcm, sizeof(short), ns, stdout); fflush(stdout); }
    }
    codec2_destroy(c);
    return 0;
}
