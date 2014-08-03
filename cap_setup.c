#include <stdio.h>

void halt()
{
    // freeze wheels for active stop (cutting power ist inaccurate)
    set_auto_publish(0); // won't send every command one by one to kmod
    publish(); // send every enqueued package to kmod
    freeze(0);
    freeze(1);
    set_auto_publish(1); // send every command one by one to kmod
    publish(); // send enqueued driving commands at once to kmod
    
    msleep(100); // wait for bot to stop 
    
    // cut motor's power (for saving battery and fitting the rules)
    set_auto_publish(0); // won't send every command one by one to kmod
    publish(); // send every enqueued package to kmod
    off(0);
    off(1);
    set_auto_publish(1); // send every command one by one to kmod
    publish(); // send enqueued driving commands at once to kmod
}

int main() {
    enable_servo(1);
    set_servo_position(1, 1900);
    msleep(1000);
    disable_servo(1);

    motor(0, 100); motor(1, 100);
    msleep(100);
    motor(0, -100); motor(1, -100);
    msleep(100);
    halt();
 
    return 0;
}
