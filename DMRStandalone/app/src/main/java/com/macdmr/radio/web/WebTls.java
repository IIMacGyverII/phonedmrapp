/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.web;

import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;

import java.math.BigInteger;
import java.net.Socket;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.Principal;
import java.security.PrivateKey;
import java.security.cert.X509Certificate;
import java.security.spec.ECGenParameterSpec;
import java.util.Date;

import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLServerSocketFactory;
import javax.net.ssl.X509ExtendedKeyManager;
import javax.security.auth.x500.X500Principal;

/**
 * HTTPS for SignalDeck Web: browsers let a page use the microphone only on a secure origin. The phone makes its own
 * key pair in the Android key store (the private key never leaves it) with a self-signed certificate, so a browser
 * shows a warning once and the user accepts it; the certificate's fingerprint is shown on the phone to compare.
 */
public final class WebTls {
    private WebTls() { }
    static final String ALIAS = "signaldeck-web";

    private static KeyStore keyStore() throws Exception {
        KeyStore ks = KeyStore.getInstance("AndroidKeyStore"); ks.load(null);
        if (!ks.containsAlias(ALIAS)) {
            KeyPairGenerator g = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, "AndroidKeyStore");
            long now = System.currentTimeMillis();
            g.initialize(new KeyGenParameterSpec.Builder(ALIAS, KeyProperties.PURPOSE_SIGN)
                    .setAlgorithmParameterSpec(new ECGenParameterSpec("secp256r1"))
                    .setDigests(KeyProperties.DIGEST_NONE, KeyProperties.DIGEST_SHA256, KeyProperties.DIGEST_SHA384, KeyProperties.DIGEST_SHA512)
                    .setCertificateSubject(new X500Principal("CN=SignalDeck Web, O=SignalDeck"))
                    .setCertificateSerialNumber(BigInteger.valueOf(now))
                    .setCertificateNotBefore(new Date(now - 86_400_000L))
                    .setCertificateNotAfter(new Date(now + 10L * 365 * 86_400_000L))
                    .build());
            g.generateKeyPair();
        }
        return ks;
    }

    /** A server socket factory that presents the phone's certificate. */
    public static SSLServerSocketFactory serverFactory() throws Exception {
        KeyStore ks = keyStore();
        final PrivateKey key = (PrivateKey) ks.getKey(ALIAS, null);
        final X509Certificate cert = (X509Certificate) ks.getCertificate(ALIAS);
        X509ExtendedKeyManager km = new X509ExtendedKeyManager() {
            @Override public String chooseServerAlias(String keyType, Principal[] issuers, Socket socket) { return ALIAS; }
            @Override public String chooseEngineServerAlias(String keyType, Principal[] issuers, SSLEngine engine) { return ALIAS; }
            @Override public String[] getServerAliases(String keyType, Principal[] issuers) { return new String[] { ALIAS }; }
            @Override public X509Certificate[] getCertificateChain(String alias) { return new X509Certificate[] { cert }; }
            @Override public PrivateKey getPrivateKey(String alias) { return key; }
            @Override public String[] getClientAliases(String keyType, Principal[] issuers) { return null; }
            @Override public String chooseClientAlias(String[] keyType, Principal[] issuers, Socket socket) { return null; }
        };
        SSLContext ctx = SSLContext.getInstance("TLS");
        ctx.init(new KeyManager[] { km }, null, null);
        return ctx.getServerSocketFactory();
    }

    /** SHA-256 fingerprint of the certificate, "AB:CD:…", to compare with what the browser shows. */
    public static String fingerprint() {
        try {
            byte[] d = MessageDigest.getInstance("SHA-256").digest(keyStore().getCertificate(ALIAS).getEncoded());
            StringBuilder b = new StringBuilder(); for (int i = 0; i < d.length; i++) { if (i > 0) b.append(':'); b.append(String.format("%02X", d[i])); }
            return b.toString();
        } catch (Exception e) { return "?"; }
    }
}
