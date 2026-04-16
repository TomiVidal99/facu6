#include <stdio.h>
#include "../include/alarma.h"

void disparar_alarma(void) {
  printf("\n*** ALARMA DISPARADA ***\n");
  getchar();
}

void detener_alarma(void) {
  printf("\n*** ALARMA DETENIDA ***\n");
  getchar();
}