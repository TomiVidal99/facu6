/*
 * FSM.c
 *
 *  Created on: 10 abr 2026
 *      Author: tomii
 */


#include "variable.h"
#include "FSM.h"

estado_t FSM_init(var_t* var) {
	if (var->valor > var->umbral_alto) return VAR_HI;
	if (var->valor < var->umbral_bajo) return VAR_LO;
	return VAR_NORMAL;
}

estado_t FSM_update(var_t* var, senial_t senial) {
	switch (var->estado) {
	case VAR_NORMAL:
		switch (senial) {
		case VAR_VAL_EVT:
			if (var->valor > var->umbral_alto) return VAR_HI;
			if (var->valor < var->umbral_bajo) return VAR_LO;
			break;
		case VAR_ACK_EVT:
			break;
		default:
			// TODO: error
			break;
		}
		break;
		case VAR_HI:
			switch (senial) {
			case VAR_VAL_EVT:
				if (var->valor > var->umbral_bajo && var->valor < var->umbral_alto) return VAR_WAITING_ACK;
				if (var->valor < var->umbral_bajo) return VAR_LO;
				break;
			case VAR_ACK_EVT:
				return VAR_NORMAL;
			default:
				// TODO: error
				break;
			}
			break;
			case VAR_LO:
				switch (senial) {
				case VAR_VAL_EVT:
					if (var->valor > var->umbral_bajo && var->valor < var->umbral_alto) return VAR_WAITING_ACK;
					if (var->valor > var->umbral_alto) return VAR_HI;
					break;
				case VAR_ACK_EVT:
					return VAR_NORMAL;
				default:
					// TODO: error
					break;
				}
				break;
				case VAR_WAITING_ACK:
					switch (senial) {
					case VAR_VAL_EVT:
						if (var->valor > var->umbral_alto) return VAR_HI;
						if (var->valor < var->umbral_bajo) return VAR_LO;
						break;
					case VAR_ACK_EVT:
						return VAR_NORMAL;
						break;
					default:
						// TODO: error
						break;
					}
					break;
					default:
						// TODO: error
						break;
	}
	return var->estado;
}
