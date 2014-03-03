/// Time functions
// @module time
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>

/// The msleep link function
// @tparam int msec milliseconds to sleep for
// @function msleep
// @see k:msleep
static int l_msleep(lua_State *L) {
    int msec = luaL_checkint(L, 1);

    msleep(msec);

    return 0;
}

static const struct luaL_Reg l_time [] = {
    {"msleep", l_msleep},
    {NULL, NULL}
};

int luaopen_lualink_time(lua_State *L) {
    luaL_newlib(L, l_time);
    return 1;
}
