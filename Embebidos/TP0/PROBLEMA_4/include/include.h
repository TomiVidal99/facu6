#ifndef INCLUDE_H
#define INCLUDE_H

// COnfiguracion
#define UMBRAL       30.0f
#define MAX_CUENTAS  3

#define INPUT_CHAR_E1 '1'
#define INPUT_CHAR_E2 '2'
#define INPUT_CHAR_EXIT '3'

typedef enum {
  STATE_REPOSO = 0,
  STATE_PRE_DISPARO = 1,
  STATE_DISPARO = 2,
  STATE_ERROR = 3
} al_estado_e;

typedef enum {
  EVENT_NINGUNO = 0,
  EVENT_NUEVA_MUESTRA = 1,
  EVENT_DESARMAR_ALARMA = 2
} al_evento_e;

al_estado_e fsm_inicio(void);
al_estado_e fsm_procesar_evento(al_estado_e actual, al_evento_e evento);
void al_debug(al_estado_e estado);

#endif // INCLUDE_H
