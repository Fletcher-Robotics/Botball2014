/* This file contains all nice fucntions for sight, movement, etc in a bot.
 * DOES NOT CONTAIN CAMERA STUFF. This is so we can run it on CBC if we want.
 * We could also put the parts of Norman's code we want in here
 */

#ifndef STDBBALL_
#define STDBBALL_

#define GETMOVPOS (get_motor_position_counter(LFT) - init)
#define CMULTI 11.1111 //4000 for 360
#define FWDMULTI 80

void turn_cw(int speed);
void turn_ccw(int speed);
void forward(int speed);
void backward(int speed);
void stopmotors();
void rotate(int deg, int spd);
void move(int dist, int spd);

#endif