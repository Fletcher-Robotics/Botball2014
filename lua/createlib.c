#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>
#include "OpenCode/opencode/create/create_drive.h"

// Serial Interface functions
static int l_connect(lua_State *L) {
    create_connect();
    msleep(800);

    return 0;
}

static int l_disconnect(lua_State *L) {
    create_disconnect();

    return 0;
}
static int l_stop() {
    create_stop();

    return 0;
}

// Movement functions
static int l_drive(lua_State *L) {
    int speed = luaL_checkint(L, 1);
    int radius = luaL_checkint(L, 2);

    create_drive(speed, radius);

    return 0;
}

static int l_drive_straight(lua_State *L) {
    int speed = luaL_checkint(L, 1);

    create_drive_straight(speed);

    return 0;
}

/// Norman Drive
static int l_drive_segment(lua_State *L) {
    unsigned int speed = (unsigned int)luaL_checkint(L, 1);
    int dist = luaL_checkint(L, 2);

    create_drive_segment(speed, dist);

    return 0;
}

static int l_drive_arc(lua_State *L) {
    unsigned int speed = (unsigned int)luaL_checkint(L, 1);
    int radius = luaL_checkint(L, 2);
    float angle = luaL_checknumber(L, 3);

    create_drive_arc(speed, radius, angle);

    return 0;
}

static int l_spin_angle(lua_State *L) {
    unsigned int speed = (unsigned int)luaL_checkint(L, 1);
    int angle = luaL_checkint(L, 2);

    create_spin_angle(speed, angle);

    return 0;
}

// Sensor
/// Norman Sensor
static int l_wait_length(lua_State *L) {
    int dist = luaL_checkint(L, 1);

    create_wait_length(dist);

    return 0;
}

static int l_sync(lua_State *L) {
    create_sync();
    return 0;
}

// Register functions
static const struct luaL_Reg createlib [] = {
    {"connect", l_connect},
    {"disconnect", l_disconnect},
    {"stop", l_stop},

    {"drive", l_drive},
    {"drive_straight", l_drive_straight},
    {"drive_segment", l_drive_segment},
    {"drive_arc", l_drive_arc},
    {"spin_angle", l_spin_angle},

    {"wait_length", l_wait_length},
    {"sync", l_sync},

    {NULL, NULL}
};

int luaopen_createlib(lua_State *L) {
    luaL_newlib(L, createlib);
    return 1;
}
