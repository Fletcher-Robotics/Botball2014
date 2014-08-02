#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lua.h>
#include <libgen.h>
#include <lauxlib.h>
#include <lualib.h>

void wait_for_light_2(int light_port_)
{
    int xBut, l_on_, l_off_, l_mid_, t, OK = 0;
    float s;
    xBut = get_extra_buttons_visible();
    set_extra_buttons_visible(0);
    set_a_button_text("-");
    set_c_button_text("-");
    while (!OK) {
        set_b_button_text("Light is On");
        display_clear();
        display_printf (0, 0, "CALIBRATE: sensor port #%d", light_port_);
        display_printf(0, 1, "   press button when light is on");
        while(b_button_clicked() == 0) {
            l_on_ = analog_et (light_port_);
            display_printf(0,1,"   light on value is = %d        ", l_on_);
            msleep(50);
        }
        l_on_ = analog_et(light_port_); /* sensor value when light is on */

        set_b_button_text("Light is Off");

        display_printf(0,1,"   light on value is = %d        ", l_on_);
        msleep(200);
        beep();

        display_printf(0,2,"   press button when light off");
        while(b_button_clicked() == 0) {
            l_off_ = analog_et(light_port_);
            display_printf(0,3,"   light off value is = %d         ", l_off_);
            msleep(50);
        }
        l_off_ = analog_et(light_port_); /* sensor value when light is off */

        display_printf(0,3,"   light off value is = %d         ", l_off_);
        msleep(200);

        if((l_off_ - l_on_) >= 60) { /* bright = small values */
            OK = 1;
            l_mid_ = (l_on_ + l_off_) / 2;
            display_printf(0, 5, "Good Calibration!");
            display_printf(0, 7, "Diff = %d:  WAITING", l_off_ - l_on_);
            while(analog_et(light_port_) > l_mid_);
        } else {
            s = seconds();
            display_printf(0,7,"BAD CALIBRATION");
            if(l_off_ < 512){
                display_printf(0,8,"   Add Shielding!!");
                msleep(5000);
            } else {
                display_printf(0,8,"   Aim sensor!!");
                msleep(5000);
            }
        }
    }
    set_extra_buttons_visible(xBut);
    set_a_button_text("A");
    set_b_button_text("B");
    set_c_button_text("C");
}

void set_lpath(char *fpath) {
    char *dir = dirname(fpath);

    /* Create string to put package path */
    char *lpath = (char *) malloc(80);
    lpath[0] = '\0';

    /* Fill package path */
    strcat(lpath, dir);
    strcat(lpath, "/?.lua;;");

    /* Set the results */
    printf("Path: %s\n", lpath);
    setenv("LUA_PATH", lpath, 1);

    /* Free & Return 0 */
    free(lpath);
}

int main(int argc, char *argv[]) {
    printf("Args: %s %s\n", argv[0], argv[1]);
    set_lpath(strdup(argv[1]));
    int error;

    printf("Setting up the Lua state\n");
    lua_State *L = luaL_newstate(); /* Open Lua */
    luaL_openlibs(L); /* Open the standard libraries */

    printf("Loading file\n");
    error = luaL_loadfile(L, argv[1]);
    if (error) {
        fprintf(stderr, "%s\n", lua_tostring(L, -1)); /* Show error */
        lua_pop(L, 1); /* Pop error from stack */
        return 1;
    }

    /* Setup light, etc
    printf("Lights!\n");
    wait_for_light_2(atoi(argv[2])); */

    // Setup shutdown
    shut_down_in(119);

    printf("Running actual program\n");
    error = lua_pcall(L, 0, 0, 0);

    if (error) {
        fprintf(stderr, "%s\n", lua_tostring(L, -1)); /* Show error */
        lua_pop(L, 1); /* Pop error from the stack */
        return 2;
    }

    return 0;
}
