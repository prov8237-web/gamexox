package src5;

public final class RoleConstants {
    private RoleConstants() {
    }

    // 7 bytes with all bits set => permissions 1..56 (covers all client AvatarPermission indexes)
    public static final String FULL_ACCESS_ROLES = "/////////w==";
}
