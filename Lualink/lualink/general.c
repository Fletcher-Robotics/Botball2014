/// General functions
// @module general
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>

/// Sends enqueued packages to kmod
// @function publish
static int l_publish(lua_State *L) {
    publish();
    return 0;
}

/// Whether to send commands to kmod one by one or not
// @tparam bool pub auto publish
// @function set_auto_publish
static int l_set_auto_publish(lua_State *L) {
	int auto_pub = lua_toboolean(L, 1);
    printf("Setting auto publish to %d\n", auto_pub);

	set_auto_publish(auto_pub);

	return 0;
}

static const struct luaL_Reg l_general [] = {
    {"publish", l_publish},
    {"set_auto_publish", l_set_auto_publish},
    {NULL, NULL}
};

int luaopen_lualink_general(lua_State *L) {
    luaL_newlib(L, l_general);
    return 1;
}
