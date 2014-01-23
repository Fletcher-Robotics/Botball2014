/* This file contains all nice fucntions for sight, movement, etc in a bot.
 * DOES NOT CONTAIN CAMERA STUFF. This is so we can run it on CBC if we want.
 * We could also put the parts of Norman's code we want in here
 */

#include <stdlib.h>
#include "stdbball.h"

void turn_cw(int speed) {
	motor(LFT,-speed); //left
	motor(RGT,speed); //right
}

void turn_ccw(int speed) {
	turn_cw(-speed);
}

void forward(int speed){
	motor(LFT,speed);
	motor(RGT,speed);
}

void backward(int speed){
	forward(-speed);
}

void stopmotors(){
	freeze(LFT);
	freeze(RGT);
}

void rotate(int deg, int spd){
	int init = get_motor_position_counter(LFT); 
	int dir = 1;
	int targ = CMULTI * deg; //Multiplyer from deg to ticks
	printf("init: %d, targ: %d\n", GETMOVPOS, targ);
	//printf("Rotating %d cm @ %d speed, ticks:%d\n", deg, spd, targ);
	if(targ < 0)
		dir = -dir;

	turn_cw(spd * dir);
	while(10 < abs(abs(targ) - abs(GETMOVPOS)));

	stopmotors();
}

void move(int dist, int spd){
	int init = get_motor_position_counter(LFT);
	int dir = 1;
	int targ = FWDMULTI * dist; //Multiplyer from cm to ticks
	printf("Moving d cm @ %d speed, ticks:%d\n", dist, spd, targ);
	if(targ < 0)
		dir = -dir;

	forward(spd * dir);
	while(60 < abs(abs(targ) - abs(GETMOVPOS)));

	stopmotors();
}
