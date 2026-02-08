package src5;

public final class DoorSpawn {
    private final String key;
    private final int targetX;
    private final int targetY;
    private final int targetDir;
    private final String propertyCn;
    private final String destinationRoomKey;
    private final String destinationDoorKey;

    public DoorSpawn(String key, int targetX, int targetY, int targetDir, String propertyCn,
                     String destinationRoomKey, String destinationDoorKey) {
        this.key = key;
        this.targetX = targetX;
        this.targetY = targetY;
        this.targetDir = targetDir;
        this.propertyCn = propertyCn;
        this.destinationRoomKey = destinationRoomKey;
        this.destinationDoorKey = destinationDoorKey;
    }

    public DoorSpawn(String key, int targetX, int targetY, int targetDir, String propertyCn) {
        this(key, targetX, targetY, targetDir, propertyCn, null, null);
    }

    public String getKey() {
        return key;
    }

    public int getTargetX() {
        return targetX;
    }

    public int getTargetY() {
        return targetY;
    }

    public int getTargetDir() {
        return targetDir;
    }

    public String getPropertyCn() {
        return propertyCn;
    }

    public String getDestinationRoomKey() {
        return destinationRoomKey;
    }

    public String getDestinationDoorKey() {
        return destinationDoorKey;
    }
}
