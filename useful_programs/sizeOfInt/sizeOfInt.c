#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  int Bsize = 0; // size of int in Bytes
  int bsize = 0; // size of int in bits
  Bsize = sizeof(int);
  bsize = 8*Bsize;
  printf("The size of type \"int\" is: %d bytes (i.e. %d bits)\n", Bsize, bsize);
  return 0;
}
