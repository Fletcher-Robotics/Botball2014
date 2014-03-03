/// Motor functions
// @module motor
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>

/// The mrp link function
// @tparam int m port
// @tparam int vel velocity (1-1000)
// @tparam int pos target relative position
// @function mrp
// @see k:mrp
static int l_mrp(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int vel = luaL_checkint(L, 2);
    int pos = luaL_checkint(L, 3);

    mrp(m, vel, pos);

    return 0;
}

/// The bmd link function
// @tparam int m port
// @function bmd
// @see k:bmd
static int l_bmd(lua_State *L) {
    int m = luaL_checkint(L, 1);

    bmd(m);

    return 0;
}

/// The motor link function
// @tparam int m port
// @tparam int p power (1-100)
// @function motor
// @see k:motor
static int l_motor(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int p = luaL_checkint(L, 2);

    motor(m, p);

    return 0;
}

/// The mav link function
// @tparam int m port
// @tparam int vel velocity (-1000-1000)
// @function mav
// @see k:mav
static int l_mav(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int vel = luaL_checkint(L, 2);

    mav(m, vel);

    return 0;
}

/// The ao link function
// @see k:ao
static int l_ao(lua_State *L) {
    ao();
    return 0;
}

/// The off link function
// @tparam int m port
// @function off
// @see k:off
static int l_off(lua_State *L) {
    int m = luaL_checkint(L, 1);

    off(m);

    return 0;
}

/// The freeze link function
// @tparam int m port
// @function freeze
// @see k:freeze
static int l_freeze(lua_State *L) {
    int m = luaL_checkint(L, 1);

    freeze(m);

    return 0;
}

/// The clear_motor_position_counter link function
// @tparam int m port
// @function clear_motor_position_counter
// @see k:clear_motor_position_counter
static int l_clear_motor_position_counter(lua_State *L) {
    int m = luaL_checkint(L, 1);

    clear_motor_position_counter(m);

    return 0;
}

/// The mtp link function
// @tparam int m port
// @tparam int speed speed (1-1000)
// @tparam int pos absolute position
// @function mtp
// @see k:mtp
static int l_mtp(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int speed = luaL_checkint(L, 2);
    int pos = luaL_checkint(L, 3);

    mtp(m, speed, pos);

    return 0;
}

static const struct luaL_Reg motor_c [] = {
    {"mrp", l_mrp},
    {"bmd", l_bmd},
    {"motor", l_motor},
    {"ao", l_ao},
    {"off", l_off},
    {"freeze", l_freeze},
    {"clear_motor_position_counter", l_clear_motor_position_counter},
    {"mtp", l_mtp},
    {"mav", l_mav},
    {NULL, NULL}
};

int luaopen_lualink_motor(lua_State *L) {
    luaL_newlib(L, motor_c);
    return 1;
}