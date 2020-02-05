# Simulace Gaty 
![Schema2](Schema1.png)

| **A** | **NOT** |
| :-: | :-: |
| 0 | 1 |
| 1 | 0 |

| **A** | **B** | **AND** | **NAND** |
| :-: | :-: | :-: | :-: |
| 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1|
| 1 | 1 | 1 |  0|

| **A** | **B** | **OR** | **NOR** |
| :-: | :-: | :-: | :-: |
| 0 | 0 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 1 | 0 |

| **A** | **B** | **XOR** | **XNOR** |
| :-: | :-: | :-: | :-: |
| 0 | 0 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 |  1| 0 |
| 1 | 1 | 0 | 1 |

# De Morgans 

## Schéma
![Schema2](Schema2.png)

## Tabulka

| **A** | **B** |**C** | ![equation](https://latex.codecogs.com/gif.latex?f) | ![equation](https://latex.codecogs.com/gif.latex?f_%7BAND%7D) | ![equation](https://latex.codecogs.com/gif.latex?f_%7BOR%7D) |
| :-: | :-: | :-: | :-: | :-: | :-: |
| 0 | 0 | 0 | 1| 1|1 |
| 0 | 0 | 1 | 0| 0| 0|
| 0 | 1 | 0 |0 | 0| 0|
| 0 | 1 | 1 | 0| 0| 0|
| 1 | 0 | 0 | 1| 1|1 |
| 1 | 0 | 1 | 1| 1| 1|
| 1 | 1 | 0 | 0| 0| 0|
| 1 | 1 | 1 | 0| 0| 0|


# Navic

## Schéma
![Schema3](Schema3.png)

## Tabulka


| **A** | **B** | **Q3** | **Q2** | **Q1** | **Q0** |
| :-: | :-: | :-: | :-: | :-: | :-: |
| 0 | 0 | 0 | 0 |0|1|
| 0 | 1 | 0 | 0 |1|0|
| 1 | 0 | 0 | 1 |0|0|
| 1 | 1 | 1 | 0 |0|0|

Obvod funguje jako adresovač 2 bitový. Součást Multiplexoru.
