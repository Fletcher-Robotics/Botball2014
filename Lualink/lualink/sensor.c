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

/// Camera Functions
// @section camera

/// The camera_open link function
// @treturn bool success
// @function camera_open
// @see k:camera_open
static int l_camera_open(lua_State *L) {
    lua_pushboolean(L, camera_open());

    return 1;
}

/// The camera_open_device link function (no res option)
// @tparam int number device number
// @treturn bool success
// @see k:camera_open_device
static int l_camera_open_device(lua_State *L) {
    int num = luaL_checkint(L, 1);

    lua_pushboolean(L, camera_open_device(num, LOW_RES));

    return 1;
}

/// The camera_close link function
// @function camera_close
// @see k:camera_close
static int l_camera_close(lua_State *L) {
    camera_close();

    return 0;
}

/// The camera_update link function
// @treturn bool success
// @function camera_update
// @see k:camera_update
static int l_camera_update(lua_State *L) {
    lua_pushboolean(L, camera_update());

    return 1;
}

/// The get_object_center link function
// @tparam int channel configuration channel
// @tparam int object object number
// @treturn {x=int, y=int} point
// @function get_object_center
// @see k:get_object_center
static int l_get_object_center(lua_State *L) {
    int channel = luaL_checkint(L, 1);
    int object = luaL_checkint(L, 2);

    point2 center = get_object_center(channel, object);

    lua_newtable(L);
    lua_pushinteger(L, center.x);
    lua_setfield(L, -2, "x");
    lua_pushinteger(L, center.y);
    lua_setfield(L, -2, "y");

    return 1;
}

/// The get_object_confidence link function
// @tparam int channel configuration channel
// @tparam int object object number
// @treturn number confidence confidence that object is significant
// @function get_object_confidence
// @see k:get_object_confidence
static int l_get_object_confidence(lua_State *L) {
    int channel = luaL_checkint(L, 1);
    int object = luaL_checkint(L, 2);

    lua_pushnumber(L, get_object_confidence(channel, object));

    return 1;
}

/// The get_object_area link function
// @tparam int channel configuration channel
// @tparam int object object number
// @treturn int area object bounding box area
// @function get_object_area
// @see k:get_object_area
static int l_get_object_area(lua_State *L) {
    int channel = luaL_checkint(L, 1);
    int object = luaL_checkint(L, 2);

    lua_pushinteger(L, get_object_area(channel, object));

    return 1;
}

/// The get_object_count link function
// @tparam int channel configuration channel
// @treturn int count number of objects on channel
// @function get_object_count
// @see k:get_object_count
static int l_get_object_count(lua_State *L) {
    int channel = luaL_checkint(L, 1);

    lua_pushinteger(L, get_object_count(channel));

    return 1;
}

static const struct luaL_Reg sensor [] = {
    {"analog", l_analog},
    {"analog_et", l_analog_et},
    {"digital", l_digital},

    {"camera_open", l_camera_open},
    {"camera_open_device", l_camera_open_device},
    {"camera_close", l_camera_close},
    {"camera_update", l_camera_update},
    {"get_object_center", l_get_object_center},
    {"get_object_confidence", l_get_object_confidence},
    {"get_object_area", l_get_object_area},
    {"get_object_count", l_get_object_count},

    {NULL, NULL}
};

int luaopen_lualink_sensor(lua_State *L) {
    luaL_newlib(L, sensor);
    return 1;
}