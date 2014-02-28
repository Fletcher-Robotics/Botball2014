#include "depthlib.h"

int match_point(int row, int col, int dist){
   depth_update();
   int val = get_depth_value(row, col);
   return blurry_equals(val, dist);
}

int match_vertical(int row_min, int row_max, int col, int dist){
   int row, val;
   int match = 0;
   for(row = row_min; row < row_max; row++){
      val = get_depth_value(row, col);
      if (blurry_equals(val, dist))
         match = 1;
   }
   return match;
}

int match_horizontal(int row, int col_min, int col_max, int dist){
   int col, val;
   int match = 0;
   depth_update();
   for(col = col_min; col < col_max; col++){
      val = get_depth_value(row, col);
      if (blurry_equals(val, dist))
         match = 1;
   }
   return match;
}

int match_patch(int row_min, int row_max, int col_min, int col_max, int dist){
   int col, row, val;
   int match = 0;
   depth_update();
   for(row = row_min; row < row_max; row++){
      for(col = col_min; col < col_max; col++){
         val = get_depth_value(row, col);
         if (blurry_equals(val, dist))
            match = 1;
      }
   }
   return match;
}

int blurry_equals(int cmpval, int target){
   return cmpval > target - 50 && cmpval < target + 50;
}