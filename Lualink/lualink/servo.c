/// Servo functions
// @module servo
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>

/// The set_servo_position link function
// @tparam int srv port
// @tparam int pos position
// @function set_servo_position
// @see k:set_servo_position
static int l_set_servo_position(lua_State *L) {
    int srv = luaL_checkint(L, 1);
    int pos = luaL_checkint(L, 2);

    set_servo_position(srv, pos);

    return 0;
}

/// The get_servo_position link function
// @tparam int srv port
// @treturn int servo position
// @function get_servo_position
// @see k:get_servo_position
static int l_get_servo_position(lua_State *L) {
    int srv = luaL_checkint(L, 1);

    lua_pushinteger(L, get_servo_position(srv));

    return 1;
}

/// The enable_servo link function
// @tparam int p port
// @function enable_servo
// @see k:enable_servo
static int l_enable_servo(lua_State *L) {
    int p = luaL_checkint(L, 1);

    enable_servo(p);

    return 0;
}

/// The disable_servo link function
// @tparam int p port
// @function disable_servo
// @see k:disable_servo
static int l_disable_servo(lua_State *L) {
    int p = luaL_checkint(L, 1);

    disable_servo(p);

    return 0;
}

static const struct luaL_Reg servo [] = {
    {"set_servo_position", l_set_servo_position},
    {"get_servo_position", l_get_servo_position},
    {"enable_servo", l_enable_servo},
    {"disable_servo", l_disable_servo},
    {NULL, NULL}
};

int luaopen_lualink_servo(lua_State *L) {
    luaL_newlib(L, servo);
    return 1;
}
