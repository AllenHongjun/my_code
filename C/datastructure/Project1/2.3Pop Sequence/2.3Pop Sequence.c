#include <stdio.h>
#include <stdlib.h>

typedef struct Snode{
	int data;
	struct Snode * next;

}*Prt;
typedef Prt Stack;

Stack Createsstack();
int IsEmpty(Stack s);
void Push(Stack S, int X);
void Pop(Stack S);
int Size(Stack S);
int Top(Stack S);

