/// Sensor functions
// @module sensor

#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>

/// The analog link function
// @tparam int port port
// @treturn int analog value
// @function analog
// @see analog #Functions
static int l_analog(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushinteger(L, analog(p));

    return 1;
}

/// The analog_et link function
// @tparam int port port
// @treturn int analog value
// @function analog_et
// @see analog_et #Functions
static int l_analog_et(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushinteger(L, analog_et(p));

    return 1;
}

/// The digital link function
// @tparam int port port
// @treturn int digital value
// @function digital
// @see digital #Functions
static int l_digital(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushinteger(L, digital(p));

    return 1;
}

static const struct luaL_Reg sensor_c [] = {
    {"analog", l_analog},
    {"analog_et", l_analog_et},
    {"digital", l_digital},
    {NULL, NULL}
};

int luaopen_lualink_sensor_c(lua_State *L) {
    luaL_newlib(L, sensor_c);
    return 1;
}