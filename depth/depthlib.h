#ifndef DEPTHLIB_
#define DEPTHLIB_

int match_point(int row, int col, int dist);
int match_vertical(int row_min, int row_max, int col, int dist);
int match_horizontal(int row, int col_min, int col_max, int dist);
int match_patch(int row_min, int row_max, int col_min, int col_max, int dist);
int blurry_equals(int cmpval, int target);

#endif