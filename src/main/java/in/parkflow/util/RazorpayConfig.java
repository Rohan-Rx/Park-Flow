package in.parkflow.util;

public final class RazorpayConfig {

    private RazorpayConfig() {}

    public static String getKeyId() {
        return requireEnv("RAZORPAY_KEY_ID");
    }

    public static String getKeySecret() {
        return requireEnv("RAZORPAY_KEY_SECRET");
    }

    private static String requireEnv(String name) {
        String value = System.getenv(name);

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException(
                    "Missing environment variable: " + name);
        }

        return value;
    }
}