/*
 * variable.c
 *
 *  Created on: 10 abr 2026
 *      Author: Tomás Vidal
 */

#include "FSM.h"
#include "variable.h"

/* inicializa el valor de la variable v pasada por referencia, los umbrales de alarma
superior e inferior, e inicializa el estado interno*/
void var_init(var_t *v, float val_ini, float umbral_hi_ini, float umbral_lo_ini) {
	v->valor_anterior = val_ini;
	v->valor = val_ini;
	v->umbral_alto = umbral_hi_ini;
	v->umbral_bajo = umbral_lo_ini;
	v->estado = VAR_NORMAL;

	estado_t state = FSM_init(v);
	v->estado = state;

}

/* setea el valor de la variable v pasada por referencia*/
void var_set_val(var_t* v, float new_val) {
	v->valor = new_val;
	estado_t state = FSM_update(v, VAR_VAL_EVT);
	v->estado = state;
}

/*reconoce la alarma y reinicia el estado de la variable (si la situación de alarma se
extinguió)*/
void var_ack_alarm(var_t* v) {
	estado_t state = FSM_update(v, VAR_ACK_EVT);
	v->estado = state;
}

/*obtiene el estado interno de la variable*/
estado_t var_get_state(var_t* v) {
	// No entiendo lo que me piden acá
	return FSM_update(v, VAR_VAL_EVT);
}
