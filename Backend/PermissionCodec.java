package src5;

import java.util.*;
import java.util.Base64;

/**
 * Encodes/decodes role bitsets exactly like the client Permission.as
 * (bit positions 1..N packed into bytes, where position 8 is bit7).
 */
public final class PermissionCodec {
    private PermissionCodec() {}

    public static String empty() {
        return "AA=="; // one zero byte (matches client default)
    }

    public static String fromGrantedIndexes(Collection<Integer> indexes) {
        if (indexes == null || indexes.isEmpty()) {
            return empty();
        }
        byte[] data = new byte[1];
        for (int idx : indexes) {
            if (idx <= 0) {
                continue;
            }
            data = grant(data, idx);
        }
        return Base64.getEncoder().encodeToString(data);
    }

    public static byte[] decode(String base64) {
        if (base64 == null || base64.trim().isEmpty()) {
            return new byte[] {0};
        }
        try {
            byte[] d = Base64.getDecoder().decode(base64);
            return d.length == 0 ? new byte[] {0} : d;
        } catch (IllegalArgumentException e) {
            return new byte[] {0};
        }
    }

    public static String encode(byte[] data) {
        if (data == null || data.length == 0) {
            return empty();
        }
        return Base64.getEncoder().encodeToString(data);
    }

    public static String or(String a, String b) {
        byte[] da = decode(a);
        byte[] db = decode(b);
        int len = Math.max(da.length, db.length);
        byte[] out = new byte[len];
        for (int i = 0; i < len; i++) {
            int va = i < da.length ? (da[i] & 0xFF) : 0;
            int vb = i < db.length ? (db[i] & 0xFF) : 0;
            out[i] = (byte) (va | vb);
        }
        return encode(out);
    }

    public static byte[] grant(byte[] data, int permissionIndex) {
        int byteIndex = (int) Math.ceil(permissionIndex / 8.0) - 1;
        int bitIndex = permissionIndex % 8 - 1;

        int neededLen = byteIndex + 1;
        byte[] out = (data == null) ? new byte[0] : data;
        if (out.length < neededLen) {
            out = Arrays.copyOf(out, neededLen);
        }

        int mask;
        if (bitIndex == -1) {
            // permission index 8,16,24,... => bit7
            mask = 1 << 7;
        } else {
            mask = 1 << bitIndex;
        }

        out[byteIndex] = (byte) ((out[byteIndex] & 0xFF) | mask);
        return out;
    }


/** Returns true if roles base64 bitset grants the given permission index (1-based). */
public static boolean hasPermission(String rolesBase64, int permissionIndex) {
    if (permissionIndex <= 0) return false;
    byte[] data = decode(rolesBase64);
    int byteIndex = (int) Math.ceil(permissionIndex / 8.0) - 1;
    int bitIndex = permissionIndex % 8 - 1;
    if (bitIndex < 0) bitIndex = 7;
    if (byteIndex < 0 || byteIndex >= data.length) return false;
    int mask = 1 << (7 - bitIndex);
    return (data[byteIndex] & mask) != 0;
}

}