package src5;

public final class BotSpawn {
    private final String key;
    private final String name;
    private final int x;
    private final int y;
    private final int width;
    private final int height;
    private final int length;
    private final String propertyCn;
    private final java.util.Map<String, Object> propertyData;
    private final String speechPropertyCn;
    private final java.util.Map<String, Object> speechPropertyData;

    public BotSpawn(String key, String name, int x, int y, int width, int height, int length, String propertyCn,
                    java.util.Map<String, Object> propertyData, String speechPropertyCn,
                    java.util.Map<String, Object> speechPropertyData) {
        this.key = key;
        this.name = name;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.length = length;
        this.propertyCn = propertyCn;
        this.propertyData = propertyData;
        this.speechPropertyCn = speechPropertyCn;
        this.speechPropertyData = speechPropertyData;
    }

    public String getKey() {
        return key;
    }

    public String getName() {
        return name;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getWidth() {
        return width;
    }

    public int getHeight() {
        return height;
    }

    public int getLength() {
        return length;
    }

    public String getPropertyCn() {
        return propertyCn;
    }

    public java.util.Map<String, Object> getPropertyData() {
        return propertyData;
    }

    public String getSpeechPropertyCn() {
        return speechPropertyCn;
    }

    public java.util.Map<String, Object> getSpeechPropertyData() {
        return speechPropertyData;
    }
}
