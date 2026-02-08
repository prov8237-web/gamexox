package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class RolesHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        MainExtension extension = (MainExtension) getParentExtension();
        InMemoryStore store = extension.getStore();

        // Always compute fresh roles from owned cards + privilege.
        String roles = store.recomputeRoles(user.getId(), user.getPrivilegeId());
        store.getOrCreateUser(user).setRoles(roles);

        SFSObject response = new SFSObject();
        response.putUtfString("roles", roles);
        send("roles", response, user);

        extension.markResponseSent("roles", user);
    }
}