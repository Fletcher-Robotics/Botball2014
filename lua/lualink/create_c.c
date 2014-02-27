#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>
#include "OpenCode/opencode/create/create_drive.h"
#include "OpenCode/opencode/create/create_accel.h"

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

/// Norman Accel
static int l_accel_straight(lua_State *L) {
    int profile = luaL_checkint(L, 1);
    float max_velocity = luaL_checknumber(L, 2);
    float distance = luaL_checknumber(L, 3);

    create_accel_straight(profile, max_velocity, distance);

    return 0;
}

static int l_accel_arc(lua_State *L) {
    int profile = luaL_checkint(L, 1);
    float max_velocity = luaL_checknumber(L, 2);
    float radius = luaL_checknumber(L, 3);
    float angle = luaL_checknumber(L, 4);

    create_accel_arc(profile, max_velocity, radius, angle);

    return 0;
}

static int l_accel_spin(lua_State *L) {
    int profile = luaL_checkint(L, 1);
    float max_omega = luaL_checknumber(L, 2);
    float angle = luaL_checknumber(L, 3);

    create_accel_spin(profile, max_omega, angle);

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
static const struct luaL_Reg create_c [] = {
    {"connect", l_connect},
    {"disconnect", l_disconnect},
    {"stop", l_stop},

    {"drive", l_drive},
    {"drive_straight", l_drive_straight},
    {"drive_segment", l_drive_segment},
    {"drive_arc", l_drive_arc},
    {"spin_angle", l_spin_angle},
    {"accel_straight", l_accel_straight},
    {"accel_arc", l_accel_arc},
    {"accel_spin", l_accel_spin},

    {"wait_length", l_wait_length},
    {"sync", l_sync},

    {NULL, NULL}
};

int luaopen_lualink_create_c(lua_State *L) {
    luaL_newlib(L, create_c);
    return 1;
}
