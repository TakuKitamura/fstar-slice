#include <stdlib.h>
#include <stdio.h>
#include "Slice.h"

void print_sliced (uint32_t *u32_array, uint32_t u32_array_length, uint32_t from, uint32_t to) {
  uint32_t *sliced = (uint32_t *)malloc(u32_array_length * sizeof(uint32_t));
  uint32_t sliced_length = slice(u32_array, u32_array_length, sliced, from, to);
  printf("[");
  for(uint32_t i = 0; i < sliced_length; i ++) {
    printf("%u", sliced[i]);
    if (i != sliced_length - 1) {
      printf(", ");
    }
  }
  printf("]\n");
  free(sliced);
}

int main() {
  uint32_t u32_array[] = {0, 1, 2, 3, 4};
  uint32_t u32_array_length = sizeof(u32_array) / sizeof(uint32_t);
  print_sliced(u32_array, u32_array_length, 0, 5);
  print_sliced(u32_array, u32_array_length, 2, 4);
  print_sliced(u32_array, u32_array_length, 5, 0);
  return 0;
}