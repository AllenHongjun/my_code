#include <stdio.h>
#include <math.h> 


// ����ѭ�� �����Ľ׳ˡ���ѭ���ǿ��� �����㷨Ҳ���ӵ���Ҫ������������㡣�ټ����㷨���ͳ����Ľ��Ҳ�Ͳ�һ���ˡ�
// ��һѭ�������Ľ׳˵�ֵ �ڶ���ѭ����ӡ�����������Լ�ϲ���Ĵ��� Ҳ��һ���ȽϿ��ĵ����顣�� 
double fact(int n);
int main(void){
	int i, n;
	double result;
	
	printf("Enter n:");
	scanf("%d",&n);
	for(i = 1; i <= n; i++){
		result = fact(i);
		printf("%d!=%.0f\n",i,result);
	}
	
}


double fact(int n){
	int i;
	double product;
	product = 1;
	for(i = 1; i <= n; i ++){
		product = product * i;
	}
	return product;
}




//int main(void){
//	int i,n;
//	double power;
//	
//	printf("Enter n:");
//	scanf("%d",&n);
//	
//	for(i = 0; i <= n; i++){
//		power = pow(2,i);
//		printf("pow(2,%d) = %.0f\n",i,power);
//	}
//	
//	return 0;
//} 


// double ���� �������͵Ĵ�С  
//int main(void){
//	int i, n;
//	
//	double product;
//	
//	printf("Enter n:");
//	scanf("%d",&n);
//	
//	i = 1;
//	product = 1;
//	for(i = 1; i <= n; i++){
//		product = product * i;
//		
//	}
//	printf("product = %.0f\n",product);
//	
//}




//int main(void){
//	int denominator, flag, i, n;
//	double item, sum;
//	
//	printf("Enter n:");
//	scanf("%d",&n);
//	
//	flag = 1;
//	denominator = 1;
//	sum = 0;
//	
//	for(i = 1; i <= n; i++){
//		item = flag * 1.0 / denominator;
//		sum = sum + item;
//		flag = -flag;
//		denominator = denominator + 2;
//	}
//	
//	printf("sum = %f\n",sum);
//	
//}




//int main(void){
//	int i , n, sum;
//	printf("Enter n:");
//	scanf("%d",&n);
//	sum = 0;
//	for(i = 1; i <= n; i++){
//		sum = sum +i;
//	}
//	
//	printf("Sum of number from 1 to %d is %d\n",n,sum);
//}



// 2-06 �����¶� �������¶�ת�������ͺ�easy  
//int main(void){
//	int fahr,lower,upper;
//	double celsius;
//	printf("Enter lower:");
//	scanf("%d",&lower);
//	printf("Enter upper:");
//	scanf("%d,",&upper);
//	
//	printf("fahr celsius");
//	for(fahr =lower;fahr <= upper;fahr ++){
//		celsius = (5.0 / 9.0) * (fahr - 32);
//		printf("%d%6.1f\n",fahr,celsius);
//	}
//	return 0 ;
//}




// 2-05 
//int main(void){
//	// C�����Դ��кܶ�ĺ����� ��������û����ô�ķḻ�ˡ� 
//	int money, year;
//	double rate,sum;
//	// ���� ָ��  ָ���ֵ  
//	printf("Enter money:");
//	scanf("%d",&money);
//	
//	printf("Enter year:");
//	scanf("%d",&year);
//	
//	printf("Enter rate:");
//	scanf("%lf",&rate);
//	
//	sum = money * pow((1+rate),year);
//	printf("sum= %.2f\n",sum);
//	return 0;
//}









// 2-03 
//int main(void){
//	int celsius,fahr;
//	fahr = 100;
//	celsius = 5 * (fahr - 32) / 9;
//	// ���˽�һ��C���Ե���ʷ ����ʹ�� sumline ������ �����ô�����ӵ����  
//	printf("fahr = %d,celsius = %d\n",fahr,celsius);
//}

// 2-04 
// ǿ��������
// �����ٶȷǳ��� дһ������ ���� ���� ������ �����Ȼ���������������жϾ���һֱ������ 
//int main(void){
//	double x,y;
//	printf("Enter x(x>=0):\n");
//	scanf("%lf",&x);
//	if(x <= 15){
//		y = 4 * x /3;
//	}
//	else{
//		y = 2.5 * x - 10.5;
//	}
//	printf("y = f(%f) = %.2f\n",x,y);
//	return 0;
//} 
