package src5;

public final class RoomPayload {
    private final String key;
    private final String doorKey;
    private final int pv;
    private final int dv;
    private final String mapBase64;

    public RoomPayload(String key, String doorKey, int pv, int dv, String mapBase64) {
        this.key = key;
        this.doorKey = doorKey;
        this.pv = pv;
        this.dv = dv;
        this.mapBase64 = mapBase64;
    }

    public String getKey() {
        return key;
    }

    public String getDoorKey() {
        return doorKey;
    }

    public int getPv() {
        return pv;
    }

    public int getDv() {
        return dv;
    }

    public String getMapBase64() {
        return mapBase64;
    }
}
