package in.parkflow.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;


public final class RazorpaySignature {

    private RazorpaySignature() {}

    public static boolean verify(
            String orderId,
            String paymentId,
            String signature,
            String secret) throws Exception {

        if (orderId == null || paymentId == null ||
                signature == null || secret == null) {
            return false;
        }

        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec key = new SecretKeySpec(
                secret.getBytes(StandardCharsets.UTF_8),
                "HmacSHA256");

        mac.init(key);

        String message = orderId + "|" + paymentId;
        byte[] digest = mac.doFinal(
                message.getBytes(StandardCharsets.UTF_8));

        StringBuilder hex = new StringBuilder();

        for (byte b : digest) {
            hex.append(String.format("%02x", b & 0xff));
        }

        String expected = hex.toString();

        return MessageDigest.isEqual(
                expected.getBytes(StandardCharsets.US_ASCII),
                signature.getBytes(StandardCharsets.US_ASCII));
    }
}