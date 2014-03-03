/// Sensor functions
// @module sensor

#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>

/// The analog link function
// @tparam int port port
// @treturn int analog value
// @function analog
// @see k:analog
static int l_analog(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushinteger(L, analog(p));

    return 1;
}

/// The analog_et link function
// @tparam int port port
// @treturn int analog value
// @function analog_et
static int l_analog_et(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushinteger(L, analog_et(p));

    return 1;
}

/// The digital link function
// @tparam int port port
// @treturn bool digital value
// @function digital
// @see k:digital
static int l_digital(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushboolean(L, digital(p));

    return 1;
}

static const struct luaL_Reg sensor [] = {
    {"analog", l_analog},
    {"analog_et", l_analog_et},
    {"digital", l_digital},
    {NULL, NULL}
};

int luaopen_lualink_sensor(lua_State *L) {
    luaL_newlib(L, sensor);
    return 1;
}