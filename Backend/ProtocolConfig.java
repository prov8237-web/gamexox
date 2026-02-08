package src5;

public final class ProtocolConfig {
    private ProtocolConfig() {}

    public static boolean strictProtocol() {
        return readFlag("STRICT_PROTOCOL");
    }

    public static boolean devFallback() {
        return readFlag("DEV_FALLBACK");
    }

    public static boolean movementTrace() {
        return readFlag("MOVE_TRACE");
    }

    public static boolean chatEnabled() {
        return readFlag("CHAT_ENABLED");
    }

    private static boolean readFlag(String key) {
        String value = System.getProperty(key);
        if (value == null || value.isEmpty()) {
            value = System.getenv(key);
        }
        if (value == null) {
            return true;
        }
        String normalized = value.trim().toLowerCase();
        return normalized.equals("true") || normalized.equals("1") || normalized.equals("yes");
    }
}
