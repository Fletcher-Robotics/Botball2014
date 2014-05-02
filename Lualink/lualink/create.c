/// Create functions
// Includes some [OpenCode](https://github.com/normanadvanced/OpenCode) functions
// @module create
#include <lua.h>
#include <lauxlib.h>
#include <kovan/kovan.h>
#include "OpenCode/opencode/create/create_drive.h"
#include "OpenCode/opencode/create/create_accel.h"

// Indexes and accesors
#define NPACKETS (sizeof spackets / sizeof(struct namedPacket))
struct namedPacket {
    char *word;
    int pack;
} spackets[] = {
    "Bump", 5,
    "Left Bump", 6,
    "Right Bump", 7,
    "Play Button", 17
};

int packet_to_n(const char *word, struct namedPacket tab[], int n)
{
    int cond;
    int low, high, mid;

    low = 0;
    high = n - 1;
    while (low <= high) {
        mid = (low+high) / 2;
        if ((cond = strcmp(word, tab[mid].word)) < 0)
            high = mid - 1;
        else if (cond > 0)
            low = mid + 1;
        else
            return tab[mid].pack;
    }
    return 0;
}


/// Serial Interface
// @section serial

/// The connect connect function
// @function connect
// @see k:create_connect
static int l_connect(lua_State *L) {
    create_connect();
    msleep(800);

    return 0;
}

/// The disconnect link function
// @function disconnect
// @see k:create_disconnect
static int l_disconnect(lua_State *L) {
    create_disconnect();

    return 0;
}

/// Movement
// @section move

/// The stop link function
// @function stop
// @see k:create_stop
static int l_stop() {
    create_stop();

    return 0;
}

/// The drive link function
// @function drive
// @see k:create_drive
// @tparam int speed speed (-500 - 500)
// @tparam int radius arc radius
static int l_drive(lua_State *L) {
    int speed = luaL_checkint(L, 1);
    int radius = luaL_checkint(L, 2);

    create_drive(speed, radius);

    return 0;
}

/// The drive_direct link function
// @function drive_direct
// @see k:create_drive_direct
// @tparam int r_speed right wheel speed
// @tparam int l_speed left wheel speed
static int l_drive_direct(lua_State *L) {
    int r_speed = luaL_checkint(L, 1);
    int l_speed = luaL_checkint(L, 2);

    create_drive_direct(r_speed, l_speed);

    return 0;
}

/// The drive_straight link function
// @function drive_straight
// @see k:create_drive_straight
// @tparam int speed speed (-500 - 500)
static int l_drive_straight(lua_State *L) {
    int speed = luaL_checkint(L, 1);

    create_drive_straight(speed);

    return 0;
}

/// The spin_CW and spin_CCW link functions
// @function spin
// @see k:create_spin_CW
// @see k:create_spin_CCW
// @tparam int speed speed (-500 (CCW) - 500 (CW))
static int l_spin(lua_State *L) {
    int speed = luaL_checkint(L, 1);

    create_spin_CW(speed);

    return 0;
}

/// The OpenCode drive_segment function
// @function drive_segment
// @tparam int speed speed (0 - 500)
// @tparam int dist distance (mm)
// @see accel_straight
static int l_drive_segment(lua_State *L) {
    unsigned int speed = (unsigned int)luaL_checkint(L, 1);
    int dist = luaL_checkint(L, 2);

    create_drive_segment(speed, dist);

    return 0;
}

/// The OpenCode drive_arc function
// @function drive_arc
// @tparam int speed speed (0 - 500)
// @tparam int radius arc radius
// @tparam number angle angle covered by arc
// @see accel_arc
static int l_drive_arc(lua_State *L) {
    unsigned int speed = (unsigned int)luaL_checkint(L, 1);
    int radius = luaL_checkint(L, 2);
    float angle = luaL_checknumber(L, 3);

    create_drive_arc(speed, radius, angle);

    return 0;
}

/// The OpenCode spin_angle function
// @function spin_angle
// @tparam int speed speed (0 - 500)
// @tparam int angle angle
// @see accel_spin
static int l_spin_angle(lua_State *L) {
    unsigned int speed = (unsigned int)luaL_checkint(L, 1);
    int angle = luaL_checkint(L, 2);

    create_spin_angle(speed, angle);

    return 0;
}

/// OpenCode Acceleration
// @section accel

/// The OpenCode accel_straight function
// @function accel_straight
// @tparam int profile speed profile (0-1)
// @tparam number max_velocity highest velocity during execution
// @tparam number dist distance
// @see drive_segment
static int l_accel_straight(lua_State *L) {
    int profile = luaL_checkint(L, 1);
    float max_velocity = luaL_checknumber(L, 2);
    float dist = luaL_checknumber(L, 3);

    create_accel_straight(profile, max_velocity, dist);

    return 0;
}

/// The OpenCode accel_arc function
// @function accel_arc
// @tparam int profile speed profile (0-1)
// @tparam number max_velocity highest velocity during execution
// @tparam number radius arc radius
// @tparam number angle angle covered by arc
// @see drive_arc
static int l_accel_arc(lua_State *L) {
    int profile = luaL_checkint(L, 1);
    float max_velocity = luaL_checknumber(L, 2);
    float radius = luaL_checknumber(L, 3);
    float angle = luaL_checknumber(L, 4);

    create_accel_arc(profile, max_velocity, radius, angle);

    return 0;
}

/// The OpenCode accel_spin function
// @function accel_spin
// @tparam int profile speed profile (0-1)
// @tparam number max_omega max angle change speed
// @tparam number angle angle
// @see spin_angle
static int l_accel_spin(lua_State *L) {
    int profile = luaL_checkint(L, 1);
    float max_omega = luaL_checknumber(L, 2);
    float angle = luaL_checknumber(L, 3);

    create_accel_spin(profile, max_omega, angle);

    return 0;
}

/// Sensor
// @section sensor

/// The OpenCode wait_length function
// @function wait_length
// @tparam int dist distance
static int l_wait_length(lua_State *L) {
    int dist = luaL_checkint(L, 1);

    create_wait_length(dist);

    return 0;
}

/// The OpenCode wait_sensor function
// @function wait_sensor
// @tparam int event event number
static int l_wait_sensor(lua_State *L) {
    const char *pname = luaL_checkstring(L, 1);
    int pnum = packet_to_n(pname, spackets, NPACKETS);

    create_wait_sensor(pnum);

    return 0;
}

/// The OpenCode sync function
// @function sync
static int l_sync(lua_State *L) {
    create_sync();
    return 0;
}

/// Sync then make sure the create stops. Should be run
// after successive create movement commands, especially when
// some other operation is going on at the same time
// @see sync
// @see stop
// @function force_wait
static int l_force_wait(lua_State *L) {
    create_sync();
    create_stop();
    return 0;
}

/// Music
// @section music

/// Load in a song
// @function load_song
// @tparam int song_number song number
// @param song table of notes in the song
// @param song table of lengths of the notes in the song
static int l_load_song(lua_State *L) {
    lua_settop(L, 3);
    luaL_checktype(L, 2, LUA_TTABLE);
    luaL_checktype(L, 3, LUA_TTABLE);

    create_write_byte(140);
    create_write_byte(luaL_checkint(L, 1));

    int len = luaL_len(L, 2);
    create_write_byte(len);

    int i;
    for (i = 1; i <= len; i++){
        lua_pushnumber(L, i);
        lua_gettable(L, 2);
        create_write_byte(luaL_checkint(L, -1));
        lua_pop(L, 1);

        lua_pushnumber(L, i);
        lua_gettable(L, 3);
        create_write_byte(luaL_checkint(L, -1));
        lua_pop(L, 1);
    }

    return 0;
}

/// Play a song
// @function play_song
// @tparam int song_number the number of an internally stored song
static int l_play_song(lua_State *L) {
    int song = luaL_checkint(L, 1);

    create_write_byte(141);
    create_write_byte(song);

    return 0;
}


// Register functions
static const struct luaL_Reg create [] = {
    {"connect", l_connect},
    {"disconnect", l_disconnect},

    {"stop", l_stop},
    {"drive", l_drive},
    {"drive_direct", l_drive_direct},
    {"drive_straight", l_drive_straight},
    {"spin", l_spin},
    {"drive_segment", l_drive_segment},
    {"drive_arc", l_drive_arc},
    {"spin_angle", l_spin_angle},
    {"accel_straight", l_accel_straight},
    {"accel_arc", l_accel_arc},
    {"accel_spin", l_accel_spin},

    {"wait_length", l_wait_length},
    {"wait_sensor", l_wait_sensor},
    {"sync", l_sync},
    {"force_wait", l_force_wait},

    {"load_song", l_load_song},
    {"play_song", l_play_song},

    {NULL, NULL}
};

int luaopen_lualink_create(lua_State *L) {
    luaL_newlib(L, create);
    return 1;
}
