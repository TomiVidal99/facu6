/*
 * FSM.h
 *
 *  Created on: 10 abr 2026
 *      Author: Tomás Vidal
 */

#ifndef INC_FSM_H_
#define INC_FSM_H_

#include "variable.h"

typedef enum {
	VAR_VAL_EVT,
	VAR_ACK_EVT
} senial_t;

#define FSM_DEBUG

/*
 * Inicializa la máquina de estados
 */
estado_t FSM_init(var_t* var);

/*
 * Avanza en una máquina de estados
 */
estado_t FSM_update(var_t* var, senial_t senial);

#endif /* INC_FSM_H_ */
