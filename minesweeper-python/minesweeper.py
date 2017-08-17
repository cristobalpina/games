# -*- coding: utf-8 -*-
"""
Created on Tue Sep 27 09:48:13 2016

@author: cristobal
"""
import math
import random as rand
import time
import sys

sys.setrecursionlimit(999999)
rand.seed(time.time())

matrizMinas = []
matrizAdj = []
matrizGrafica = []

firstClick = True
endGame = False

def setBoardSize():
    print('¿De que tamaño debe ser el tablero?')
    while True:
        try:
            n = int(input())
            if(n > 10):
                print('el maximo es 10, intente nuevamente.\n')
            elif(n < 0):
                    print('ingrese un valor positivo.\n')
            else:
                   return n
        except (NameError, SyntaxError):
            print('Valor ingresado inválido.\n')

def setBombNumber(max_bombs):
    print('¿Cuantas minas habrá?')
    while True:
        try:
            m = int(input())
            if(m > max_bombs):
                print('El número de bombas no puede superar\n')
                print('a un tercio del numero de casillas.')
            elif(m < 0):
                    print('ingrese un valor positivo.\n')
            else:
                    return m
        except (NameError, SyntaxError):
            print('Valor ingresado inválido.\n')
            
def setMines(board, board_size, bomb_number):
    for i in range(bomb_number):
        while True:
            x = rand.randint(0,board_size - 1)
            y = rand.randint(0,board_size - 1)
            if(board[x][y] == 0 and matrizGrafica[x][y] != 1):
                board[x][y] = 'x'
                break
def checkVictory(board,board_size, bomb_number):
    count = 0
    for i in range(board_size):
        for j in range(board_size):
            if(board[i][j] == 0):
                count = count + 1
    if(count == bomb_number):
        print('FELICITACIONES, GANASTE!!!!!!!!!!!!!')
        sys.exit()
                
def enterRow(n):
    print('Ingrese una fila. \n')
    while True:
        try:
            x = int(input())
            if(x >= n):
                print('Valor fuera del rango permitido.\n')
            elif(x < 0):
                print('ingrese un valor positivo.\n')
            else:
                return x
        except (NameError, SyntaxError):
                print('Valor ingresado inválido.\n')

def enterColumn(n):
    print('Ingrese una columna. \n')
    while True:
            try:
                x = int(input())
                if(x >= n):
                    print('Valor fuera del rango permitido.\n')
                elif(x < 0):
                    print('ingrese un valor positivo.\n')
                else:
                    return x
            except (NameError, SyntaxError):
                print('Valor ingresado inválido.\n')
def pressBox(x, y):
    if(matrizMinas[x][y] == 'x'):
        matrizGrafica[x][y] = 8
        print('BOOM')
        sys.exit()
    else:
        matrizGrafica[x][y] = 1
        checkNearBoxes(matrizMinas, x, y)
        
def userClick(board_size):
    x = enterRow(board_size)
    y = enterColumn(board_size)
    pressBox(x, y)
    

     
def showBoard():
    print('Tablero')
    for row in matrizGrafica:
        print row
    print('\n')

def printInstructions():
    print('\n')
    print('===================================================\n')
    print('Para jugar debe ingresar una fila y una columna')
    print('Esto representara un click en aquella casilla\n')
    print('La primera fila es la n° 0 contando de arriba a abajo')
    print('La primer columna es la n° 0 contando de izquierda a derecha.\n')
    print('===================================================\n')
    
    
def initMatrix(tamano):
    matrizGrafica = [[0 for i in xrange(tamano)] for j in xrange(tamano)]
    matrizMinas = [[0 for i in xrange(tamano)] for j in xrange(tamano)]
    matrizAdj = [[0 for i in xrange(tamano)] for j in xrange(tamano)]
    matriz = [[0 for i in xrange(tamano*tamano)] for j in xrange(tamano*tamano)] 
    
    return matrizGrafica, matrizMinas, matrizAdj

def setNumberOfNearBombs(board, board_size):
    for i in range(board_size):
        for j in range(board_size):
            count = 0
            if(board[i][j] != 'x'):
                if(i > 0):
                    if(j > 0):
                        if(board[i - 1][j - 1] == 'x'):
                            count = count + 1
                    if(board[i - 1][j] == 'x'):
                        count = count + 1
                    if(j < board_size - 1):
                        if(board[i - 1][j + 1] == 'x'):
                            count = count + 1
                if(j > 0):
                    if(board[i][j - 1] == 'x'):
                        count = count + 1
                if(j < board_size - 1):
                    if(board[i][j + 1] == 'x'):
                        count = count + 1
                if(i < board_size - 1):
                    if(j > 0):
                        if(board[i + 1][j - 1] == 'x'):
                            count = count + 1
                    if(board[i + 1][j] == 'x'):
                        count = count + 1
                    if(j < board_size - 1):
                        if(board[i + 1][j + 1] == 'x'):
                            count = count + 1
                board[i][j] = count
                
def checkNearBoxes(board, x, y):
        if(x > 0):
            if(y > 0):
                if(board[x - 1][y - 1] == 0):
                    pressBox(x-1, y-1)
                elif(board[x - 1][y - 1] != 'x'):
                    matrizGrafica[x-1][y-1] = str(board[x-1][y-1])
            if(board[x - 1][y] == 0):
                pressBox(x-1, y)
            elif(board[x - 1][y] != 'x'):
                    matrizGrafica[x-1][y] = str(board[x-1][y])
            if(y < board_size - 1):
                if(board[x - 1][y + 1] == 0):
                    pressBox(x-1, y+1)
                elif(board[x - 1][y + 1] != 'x'):
                    matrizGrafica[x-1][y+1] = str(board[x-1][y+1])
        if(y > 0):
            if(board[x][y - 1] == 0):
                pressBox(x, y-1)
            elif(board[x][y-1] != 'x'):
                    matrizGrafica[x][y-1] = str(board[x][y-1])
        if(y < board_size - 1):
            if(board[x][y + 1] == 0):
                pressBox(x, y+1)
            elif(board[x][y+1] != 'x'):
                    matrizGrafica[x][y+1] = str(board[x][y+1])
        if(x < board_size - 1):
            if(y > 0):
                if(board[x + 1][y - 1] == 0):
                    pressBox(x+1, y-1)
                elif(board[x+1][y-1] != 'x'):
                    matrizGrafica[x+1][y-1] = str(board[x+1][y-1])
            if(board[x + 1][y] == 0):
                pressBox(x+1, y)
            elif(board[x+1][y] != 'x'):
                    matrizGrafica[x+1][y] = str(board[x+1][y])
            if(y < board_size - 1):
                if(board[x + 1][y + 1] == 0):
                    pressBox(x+1, y+1)
                elif(board[x+1][y+1] != 'x'):
                    matrizGrafica[x+1][y+1] = str(board[x+1][y+1])
    
def showMatrix(matrix):
    print('bombas')
    for row in matrix:
        print row
          
print('=============================\n')
print('BUSCAMINAS PYTHON\n')
print('=============================\n')


board_size = setBoardSize()

max_bombs = math.ceil(float(board_size*board_size) / 3)

bomb_number = setBombNumber(max_bombs)

matrizGrafica, matrizMinas, matrizAdj = initMatrix(board_size)


print('\n')
print(('Se generó un tablero de {} x {} con {} minas.')
    .format(board_size, board_size, bomb_number))
raw_input("Presiona Enter para continuar...")

printInstructions()
raw_input("Presiona Enter para continuar...")

setMines(matrizMinas, board_size, bomb_number)

setNumberOfNearBombs(matrizMinas, board_size)

showBoard()

#showMatrix(matrizMinas)

userClick(board_size)
firstClick = False




while True:
    showBoard()
    #showMatrix(matrizMinas)
    userClick(board_size)
    checkVictory(matrizGrafica,board_size, bomb_number)

    


