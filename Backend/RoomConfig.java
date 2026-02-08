package src5;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class RoomConfig {
    private final String roomKey;
    private final String theme;
    private final int xOrigin;
    private final int yOrigin;
    private final List<FurnitureSpawn> furniture;
    private final List<BotSpawn> bots;
    private final List<DoorSpawn> doors;

    public RoomConfig(String roomKey, String theme, int xOrigin, int yOrigin,
                      List<FurnitureSpawn> furniture, List<BotSpawn> bots, List<DoorSpawn> doors) {
        this.roomKey = roomKey;
        this.theme = theme;
        this.xOrigin = xOrigin;
        this.yOrigin = yOrigin;
        this.furniture = furniture == null ? Collections.emptyList() : new ArrayList<>(furniture);
        this.bots = bots == null ? Collections.emptyList() : new ArrayList<>(bots);
        this.doors = doors == null ? Collections.emptyList() : new ArrayList<>(doors);
    }

    public static RoomConfig empty(String roomKey, String theme, int xOrigin, int yOrigin) {
        return new RoomConfig(roomKey, theme, xOrigin, yOrigin,
            Collections.emptyList(), Collections.emptyList(), Collections.emptyList());
    }

    public String getRoomKey() {
        return roomKey;
    }

    public String getTheme() {
        return theme;
    }

    public int getXOrigin() {
        return xOrigin;
    }

    public int getYOrigin() {
        return yOrigin;
    }

    public List<FurnitureSpawn> getFurniture() {
        return Collections.unmodifiableList(furniture);
    }

    public List<BotSpawn> getBots() {
        return Collections.unmodifiableList(bots);
    }

    public List<DoorSpawn> getDoors() {
        return Collections.unmodifiableList(doors);
    }
}
