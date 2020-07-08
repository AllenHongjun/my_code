#include <stdio.h>
#include <stdlib.h>
 
int MaxSubseqSum( int A[] , int N , int* first , int* last); 
 
int main(){
 	int K;
 	scanf_s("%d",&K);
 	int *A;
 	A = (int*)malloc( K*sizeof(int));
 	int i;
 	int flag = 0;
 	for( i = 0; i < K; i++){
 		scanf_s("%d",&A[i]);
 		if(A[i] >= 0){
 			flag = 1;
		 }
	 }
	int sum = 0;
	if(flag){
	int first,last;
	first = last = 0;
	sum = MaxSubseqSum( A , K , &first , &last);
	printf("%d %d %d", sum , A[first] , A[last]);
	}else{
	printf("%d %d %d", sum , A[0] , A[K-1]);	
	}
	free(A);
 	return 0;
}
 
int MaxSubseqSum( int A[] , int N , int* first , int* last){
 	int ThisSum, MaxSum;
 	ThisSum = 0;
 	MaxSum = -1;
 	int i;
 	int t = 0;
 	for( i = 0; i < N ; i++){
 		ThisSum += A[i];
 		if(ThisSum > MaxSum){
 			MaxSum = ThisSum;
 			*first = t;
 			*last = i;
		}else if(ThisSum < 0){
		 	ThisSum = 0;
			if( A[i+1] >= 0 && i < N)	{
				t = i+1;	 
			}
		}
	 }
	 return MaxSum; 
}
