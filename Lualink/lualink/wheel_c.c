#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>
#include "OpenCode/opencode/cbc/drive/drivelib.h"

static int l_build_left_wheel(lua_State *L) {
    build_left_wheel(luaL_checkint(L, 1), luaL_checklong(L, 2), luaL_checknumber(L, 3),
                     luaL_checknumber(L, 4), luaL_checknumber(L, 5));

    return 0;
}

static int l_build_right_wheel(lua_State *L) {
    build_right_wheel(luaL_checkint(L, 1), luaL_checklong(L, 2), luaL_checknumber(L, 3),
                      luaL_checknumber(L, 4), luaL_checknumber(L, 5));

    return 0;
}

static int l_straight(lua_State *L) {
    int speed = luaL_checkint(L, 1);
    int dist = luaL_checkint(L, 2);

    cbc_straight(speed, dist);

    return 0;
}

static int l_arc(lua_State *L) {
    int speed = luaL_checkint(L, 1);
    float radius = luaL_checknumber(L, 2);
    float angle = luaL_checknumber(L, 3);

    cbc_arc(speed, radius, angle);

    return 0;
}

static int l_spin(lua_State *L) {
    int speed = luaL_checkint(L, 1);
    float angle = luaL_checknumber(L, 2);

    cbc_spin(speed, angle);

    return 0;
}

static int l_halt(lua_State *L) {
    cbc_halt();
    return 0;
}

static const struct luaL_Reg wheel_c [] = {
    {"build_left_wheel", l_build_left_wheel},
    {"build_right_wheel", l_build_right_wheel},
    {"straight", l_straight},
    {"arc", l_arc},
    {"spin", l_spin},
    {"halt", l_halt},
    {NULL, NULL}
};

int luaopen_lualink_wheel_c(lua_State *L) {
    luaL_newlib(L, wheel_c);
    return 1;
}
