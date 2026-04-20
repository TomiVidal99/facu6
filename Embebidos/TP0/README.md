# Entrega obligatoria
Tengo que entregar obligatoriamente:
- EJERCICIO 1: P0E4 c y d.
- EJERCICIO 2: 22.

# Herramientas
- [GeneradorFSM](https://gibic-leici.github.io/GraficadorFSM/)

## Descripcion sensores

- S0: está el planta baja?
- S1: está el planta alta?
- S2: se quiere ir arriba (desde el asensor)
- S3: se quiere ir abajo (desde el asensor)
- S4: se quiere ir abajo (desde el planta alta)
- S5: se quiere ir arriba (desde el planta baja)
- S6: la puerta está abierta en planta alta (debería considerar el negado?)
- S7: la puerta está abierta en planta baja (debería considerar el negado?)

## Estados:

### En planta baja
- S00: STOP
- S01: ASCENDING
- S02: DESCENDING

### En planta alta
- S10: STOP
- S11: ASCENDING
- S12: DESCENDING