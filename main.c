#include <stdlib.h>
#include <stdio.h>
#include "Slice.h"

void print_slice (uint32_t *array, uint32_t array_length, uint32_t start, uint32_t stop) {
  uint32_t *sliced = (uint32_t *)malloc(array_length * sizeof(uint32_t));
  uint32_t sliced_length = slice(array, array_length, sliced, start, stop); // ここでセキュアなスライス関数を呼び出している
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
  uint32_t array[] = {0, 1, 2, 3, 4}; // スライス元の配列
  uint32_t array_length = sizeof(array) / sizeof(uint32_t);
  print_slice(array, array_length, 0, 5);
  print_slice(array, array_length, 2, 4);
  print_slice(array, array_length, 5, 0);
  print_slice(array, array_length, 0, 6);
  return 0;
}