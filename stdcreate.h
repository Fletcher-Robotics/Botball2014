#ifndef STDCREATE_
#define STDCREATE_

void moveCm(double dist, int speed);
double getEff(int speed, int deg);
void rotateDegrees(int degrees, int speed);
void lineUp(int time, int speed);
int menu();
int tol = 1;
void cameraSearch(int goal, int chan);
void cameraOn();
void cameraOff();
void wiggle();
int cameraSearchB(int goal, int chan);
void level();

#endif