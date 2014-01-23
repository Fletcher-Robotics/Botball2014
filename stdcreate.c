#include "stdcreate.h"

void moveCm(double dist, int speed) {
	double efficiency = -.006*speed+10.7; //fix me later if you want
	int val = dist*efficiency;
	set_create_distance(0);
	if(val<0) {
		int bspeed = -speed;
		create_drive_direct(bspeed, bspeed);
		while(get_create_distance(5/speed)> val) { }  //suggested lag is 5/speed
		create_stop();
	}
	else {
		create_drive_direct(speed, speed);
		while(get_create_distance(5/speed)< val) {}
		create_stop();
	}
	
}

double getEff(int speed, int deg) {
	if(speed==FAST) {
		return .73;
	}
	else if(speed==MED) {
		if(deg== 90 || deg==-90) {
			return .8;
		}
		else {
			return .9;
		}
	}
	else if(speed==SLOW) {
		if(deg== 90 || deg == -90) {
			return .9;
		}
		else {
			return .95;
		}
	}
	else if(speed== SM) {
		return .85;
	}
}

void rotateDegrees(int degrees, int speed) {
	double efficiency = getEff(speed, degrees);
	int degval = degrees*efficiency;
	set_create_total_angle(0);
	if(degrees< 0) {
		create_spin_CW(speed);
		while(get_create_total_angle(10/(2*speed)) > degval) {}
		create_stop();
	}
	else {
		create_spin_CCW(speed);
		while(get_create_total_angle(10/(2*speed)) < degval) {}
		create_stop();
	}
}



// allows the create to just run at inputted speed for inputted time
void lineUp(int time, int speed) {
	create_drive_direct(speed, speed);  // uses inputted speed to start create
	msleep(time);  // lets it run inputted time
	create_stop();  // nuff said
}



int menu() {
	int coll = 0;
	printf("press B for teal or side button for pink \n");
	while(b_button() ==0 && side_button() == 0) {}
	if(side_button() == 1) {
		coll = 1;
	}
	return coll;
}


int tol = 1;

void cameraSearch(int goal, int chan) {
	int count = 0;
	while(count < 5) {
		camera_update();
		count++;
	}
	if(get_object_count(chan) >0) {
		point2 objcent = get_object_center(chan,0);
		if(objcent.x < goal-tol) {
			while(get_object_center(chan,0).x < goal-tol && get_object_count(chan) >0) {
				create_spin_CCW(25);
				camera_update();
			
			}
			create_stop();
		}
		else if(objcent.x >goal+tol) {
			while(get_object_center(chan,0).x > goal+tol && get_object_count(chan) >0) {
				create_spin_CW(25);
				camera_update();
			}
			create_stop();
		}
		else {create_stop(); }
	}
	else {create_stop(); }
}


void cameraOn() {
	camera_open(LOW_RES);
	int count = 0;
	while(count < 5) {
		camera_update();
		count++;
	}
}

void cameraOff() {
	camera_close();
}


void wiggle() {
		rotateDegrees(-1, SLOW);
		rotateDegrees(1, SLOW);
		rotateDegrees(-1, SLOW);
		rotateDegrees(1, SLOW);
}

int cameraSearchB(int goal, int chan) {
	int start = get_create_total_angle(10/MED);
	int count = 0;
	while(count < 5) {
		camera_update();
		count++;
	}
	if(get_object_count(chan) >0) {
		point2 objcent = get_object_center(chan,0);
		if(objcent.x < goal-tol) {
			while(get_object_center(chan,0).x < goal-tol && get_object_count(chan) >0) {
				create_spin_CCW(25);
				camera_update();
			}
			create_stop();
			return get_create_total_angle(10/MED) - start;
		}
		else if(objcent.x >goal+tol) {
			while(get_object_center(chan,0).x > goal+tol && get_object_count(chan) >0) {
				create_spin_CW(25);
				camera_update();
			}
			create_stop();
			return get_create_total_angle(10/MED) - start;
		}
		else {create_stop(); return get_create_total_angle(10/MED) - start;}
	}
	else {create_stop(); }
}

void level() {
	msleep(500);
	moveArm(-55);
}
