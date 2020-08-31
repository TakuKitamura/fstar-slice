#include <stdlib.h>
#include <stdio.h>
#include "Slice.h"

int main() {
  uint32_t u32_array[] = {0, 1, 2, 3, 4};
  uint32_t u32_array_length = sizeof(u32_array) / sizeof(uint32_t);
  struct_slice sliced = slice(u32_array, u32_array_length, 0, 5);
  for(uint32_t i = 0; i < sliced.sliced_length; i ++) {
    printf("%u\n", sliced.sliced[i]);
  }
}