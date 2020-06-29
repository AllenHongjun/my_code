#include <stdio.h>
#include <math.h> 


// 两次循环 就他的阶乘。。循环是可以 但是算法也更加的重要。。如何来计算。少几次算法。就出来的结果也就不一样了。
// 第一循环就他的阶乘的值 第二次循环打印。。可以敲自己喜欢的代码 也是一件比较开心的事情。。 
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


// double 类型 数据类型的大小  
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



// 2-06 华氏温度 和摄制温度转换表。。就很easy  
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
//	// C语言自带有很多的函数库 但是类库就没有那么的丰富了。 
//	int money, year;
//	double rate,sum;
//	// 变量 指针  指针的值  
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
//	// 想了解一点C语言的历史 或者使用 sumline 来编译 可能敲代码更加的舒服  
//	printf("fahr = %d,celsius = %d\n",fahr,celsius);
//}

// 2-04 
// 强类型语言
// 计算速度非常快 写一个程序 运行 起来 有输入 输出。然后根据这个条件来判断就是一直来运行 
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
