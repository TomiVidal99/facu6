#include "../include/alarma.h"
#include "../include/include.h"
#include <stdint.h>
#include <stdio.h>

float muestra = 0;
uint8_t contador = 0;

int main(void) {
  al_estado_e state;
  al_evento_e event;
  char c;

  // Se inicia la máquina de estados
  state = fsm_inicio();

  // Acá simulo lo que serían los eventos
  // los inserta manualmente el usuario cuando ejecuta el programa
  // esto en realidad serían sensores
  while (1) {
    c = '\n';
    do {
      printf("\n1) Nueva muestra\n2) Desarmar alarma\n3) Salir \n");
      c = getchar();
      while (getchar() != '\n')
        ; // limpia el buffer del teclado fflush no me funcionaba bien en linux
    } while (c != INPUT_CHAR_E1 && c != INPUT_CHAR_E2 && c != INPUT_CHAR_EXIT);

    if (c == INPUT_CHAR_EXIT)
      return 0;

    // Se procesa la entrada
    switch (c) {
    case INPUT_CHAR_E1:
      printf("Ingrese muestra: ");
      scanf("%f", &muestra);
      while (getchar() != '\n')
        ; // limpia el buffer del teclado fflush no me funcionaba bien en linux
      event = EVENT_NUEVA_MUESTRA;
      break;
    case INPUT_CHAR_E2:
      event = EVENT_DESARMAR_ALARMA;
      break;
    default:
      break;
    }

    state = fsm_procesar_evento(state, event);

    al_debug(state);
  }

  return 0;
}

al_estado_e fsm_inicio(void) {
  contador = 0;
  return STATE_REPOSO;
}

al_estado_e fsm_procesar_evento(al_estado_e actual, al_evento_e evento) {
  switch (actual) {

  case STATE_REPOSO:

    if (evento == EVENT_NUEVA_MUESTRA) {

      if (muestra >= UMBRAL) {
        contador = 1;
        return STATE_PRE_DISPARO;
      }
    }

    break;

  case STATE_PRE_DISPARO:

    if (evento == EVENT_NUEVA_MUESTRA) {

      if (muestra >= UMBRAL) {
        contador++;

        if (contador < MAX_CUENTAS) {
          return STATE_PRE_DISPARO;
        } else {
          disparar_alarma();
          return STATE_DISPARO;
        }
      }
    } else {
      contador = 0;
      return STATE_REPOSO;
    }

    break;

  case STATE_DISPARO:

    if (evento == EVENT_DESARMAR_ALARMA && muestra < UMBRAL) {
      detener_alarma();
      return STATE_REPOSO;
    }

    break;

  default:
    break;
  }

  return actual;
}

void al_debug(al_estado_e estado) {
  printf("DEBUG -> muestra=%.2f | estado=%d | contador=%d\n", muestra, estado,
         contador);
}