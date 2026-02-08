package src5;

public final class FurnitureSpawn {
    private final String type;
    private final String def;
    private final int x;
    private final int y;
    private final int z;
    private final int rotation;

    public FurnitureSpawn(String type, String def, int x, int y, int z, int rotation) {
        this.type = type;
        this.def = def;
        this.x = x;
        this.y = y;
        this.z = z;
        this.rotation = rotation;
    }

    public String getType() {
        return type;
    }

    public String getDef() {
        return def;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getZ() {
        return z;
    }

    public int getRotation() {
        return rotation;
    }
}
