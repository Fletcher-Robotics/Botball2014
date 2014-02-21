#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>
#include "OpenCode/opencode/cbc/drive/drivelib.h"

// Motors
static int l_mrp(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int vel = luaL_checkint(L, 2);
    int pos = luaL_checkint(L, 3);

    mrp(m, vel, pos);

    return 0;
}

static int l_bmd(lua_State *L) {
    int m = luaL_checkint(L, 1);

    bmd(m);

    return 0;
}

static int l_motor(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int p = luaL_checkint(L, 2);

    motor(m, p);

    return 0;
}

static int l_mav(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int vel = luaL_checkint(L, 2);

    mav(m, vel);

    return 0;
}

static int l_ao(lua_State *L) {
    ao();
    return 0;
}

static int l_off(lua_State *L) {
    int m = luaL_checkint(L, 1);

    off(m);

    return 0;
}

static int l_clear_motor_position_counter(lua_State *L) {
    int m = luaL_checkint(L, 1);

    clear_motor_position_counter(m);

    return 0;
}

static int l_mtp(lua_State *L) {
    int m = luaL_checkint(L, 1);
    int speed = luaL_checkint(L, 2);
    int pos = luaL_checkint(L, 3);

    mtp(m, speed, pos);

    return 0;
}

// Norman Stuff
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

static int l_wait(lua_State *L) {
    cbc_wait();
    return 0;
}

// Time
static int l_msleep(lua_State *L) {
    int msec = luaL_checkint(L, 1);

    msleep(msec);

    return 0;
}

// Servos
static int l_set_servo_position(lua_State *L) {
    int srv = luaL_checkint(L, 1);
    int pos = luaL_checkint(L, 2);

    set_servo_position(srv, pos);

    return 0;
}

static int l_enable_servo(lua_State *L) {
    int p = luaL_checkint(L, 1);

    enable_servo(p);

    return 0;
}

static int l_disable_servo(lua_State *L) {
    int p = luaL_checkint(L, 1);

    disable_servo(p);

    return 0;
}

// Sensors
static int l_analog(lua_State *L) {
    int p = luaL_checkint(L, 1);

    lua_pushnumber(L, analog(p));

    return 1;
}


static const struct luaL_Reg linklib [] = {
    {"mrp", l_mrp},
    {"bmd", l_bmd},
    {"motor", l_motor},
    {"ao", l_ao},
    {"off", l_off},
    {"clear_motor_position_counter", l_clear_motor_position_counter},
    {"mtp", l_mtp},
    {"mav", l_mav},
    // Norman
    {"build_left_wheel", l_build_left_wheel},
    {"build_right_wheel", l_build_right_wheel},
    {"straight", l_straight},
    {"arc", l_arc},
    {"spin", l_spin},
    {"wait", l_wait},

    {"msleep", l_msleep},

    {"set_servo_position", l_set_servo_position},
    {"enable_servo", l_enable_servo},
    {"disable_servo", l_disable_servo},

    {"analog", l_analog},

    {NULL, NULL}
};

int luaopen_linklib(lua_State *L) {
    luaL_newlib(L, linklib);
    return 1;
}
