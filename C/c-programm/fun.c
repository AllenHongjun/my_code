#include <stdio.h>
#include <math.h> 
#include <stdlib.h>
// 字符数组 还有 链表 数据结构 这个 还是有点抽象的。。结构。。
struct stu
{
    char name[10];
    int num;
    int age;
    char addr[15];
} boya[2], boyb[2], *pp, *qq;

int main(void){
    FILE *fp;
    int i;

    pp = boya;
    qq = boyb;

    if ((fp = fopen("stu_list.txt","wb+")) == NULL)
    {
        printf(" Cannot open file strike any key exit!");
        getchar();
        exit(1);
    }

    printf("\n inut data \n");
    
    for (size_t i = 0; i < 2; i++,pp++  )
    {
        scanf("%s%d%d%s",pp->name, &pp->num, &pp->age, pp->addr);
    }

    pp = boya;

    // fwrite fread 方法 结构的定义 和使用
    fwrite(pp, sizeof(struct stu), 2, fp);
    rewind(fp);

    fread(qq, sizeof(struct stu), 2, fp);
    printf("\n\nname\tnumber age addr\n");
    for (i = 0; i < 2; i++, qq++)
        printf("%s\t%5d%7d\t%s\n", qq->name, qq->num, qq->age, qq->addr);
    fclose(fp);

    return 0;

}






















// int main(void){
//     int i;
//     int ch;
//     FILE *fp;
//     if ((fp = fopen("f2.txt","w")) == NULL)
//     {
//         printf("FILE open error !\n");
//         exit(0);
//     }
//     // 主要是学习一点基本的语法
//     // 这个会等你全部输入完成10个字符之后 才会继续往下面去运行。。
//     // c# 和c其实没有什么本质的区别 处理文件 本质也是处理2进制数据 底层最下边本质还是都是处理1个1个字节的数据。。有相同的地方。
//     // CLR 可以直接写C#代码低啊用CLR里面的一些东西。。翻译成一个中间代码。。可以直接调用 先这么理解就完事了。
//     for ( i = 0; i < 10; i++)
//     {
//        ch = getchar();
//        fputc(ch,fp);
//     }

//     if(fclose(fp)){
//         printf("Can not close the file!\n");
//         exit(0);
//     }

//     if((fp = fopen("f2.txt","r")) == NULL){
//         printf("File open error!\n");
//         exit(0);
//     }

//     for (size_t i = 0; i < 10; i++)
//     {
//         ch = fgetc(fp);
//         putchar(ch);
//     }

//     if (fclose(fp))
//     {
//         printf("Can not close the file!\n");
//         exit(0);
//     }
    
    
    
    



// }





// 因为这个本省就是很基础的课程 所以 看起来它做的事情 其实很简单 也很少
// 一个是练习手感。。知道底层的一点编程知识。 主要还是会后面课程的学习打基础
// C语言 相对而言是比较底层的语言。。是和操作系统硬件有比较大的关联的
// 操作 文件 数据 等很多都是一一对应。。一点一点做的。
// linux windows 都是用 汇编和C开发的。。开饭的接口当然
// C# .net 基础库里面 操作 文件 网络 图片 等底层的接口调用 的是哪里的方法。
// C是有标准库 可以直接调用操作系统的方法。
//注意区分大小写
// int main(void){
//     FILE *fp1, *fp2;
//     char c;
//     if((fp1 = fopen("f1.txt","r")) == NULL){
//         printf(" File open error!\n");
//         exit(0);
//     }

//     if((fp2 = fopen("f2.txt","r")) == NULL){
//         printf(" File open error!\n");
//         exit(0);
//     }

//     while(!feof(fp1)){
//         c = fgetc(fp1);
//         fputc(c,fp2);
//     }

//     fclose(fp1);
//     fclose(fp2);
// }





// int main(void){
//     FILE *fp;
//     long num;
//     char stname[20];
//     int score;
//     if ((fp = fopen("f.txt","r")) == NULL)
//     {
//         printf("File open error!\n");
//     }

//     while (!feof(fp))
//     {
//         fscanf(fp, "%ld%s%d", &num, &stname, &score);
//         printf("%ld  %s   %d\n",num, stname, score);
//     }

//     if (fclose(fp)) 
//     {
//         printf("can not close the file !\n");
//         exit(0);
//     }

//     return 0;
    
    
    


// }



// 向一个文件当中去写内容 这个只是去调用标准库当中的方法。
// 说实话 这个C语言学习的内容还是比较的少。。具体这个文件的方法是怎么实现的
//编译器又是怎么编译的。
// int main(void){
//     FILE *fp;

//     if ((fp = fopen("f1.txt","w")) == NULL)
//     {
//         printf("File open error!\n");
//     }

//     fprintf(fp,"%s","hello world!");

//     if(fclose(fp)){
//         printf("can not close the file!\n");
//         exit(0);
//     }

//     return 0;
    


// }












// #define CIVET 0  // 狸猫
// #define PRINCE 1 // 太子

// void replace(int boby);

// // 指针作为函数的参数传入 可以改变他的值 然后通过指针返回出去
// void replace1(int *p);

// void display(int boby);

// int main(void){
//     int boby ;
//     boby = PRINCE ;
//     printf("first \n");
//     display(boby);

//     printf("\n second \n");
//     replace(boby);
//     display(boby);


//     printf("\n thrid \n");

//     // &boby的值其实是和 p的值是一回事 因为 p里面存放的就是一个地址
//     replace1(&boby);
//     display(boby);


//     return 0;
// }



// void replace(int boby){
//     boby = CIVET;
// }

// void replace1(int *p){
//     // 这个p指针变量指向的就是boby 就是和boby同一个 所以你在函数里面把 *p改变了 其实就是 把boby 的值给改变了。
//     // 学会基础的 c就可以 学数据结构 学 操作系统 学后续其他的算法课程 等等 网络变成 中间件的开发。
//     *p = CIVET;
// }


// void display(int boby){
//     if (boby == 0)
//     {
//        printf("狸猫");
//     }else{
//         printf("太子");
//     }
    
// }

// 重要的是全局的把我 语法的知识。 弄一本数据。
// 找一找敲代码的感觉 指针 函数指针 为后续的学习打下坚实的基础
// 指针变量作为参数的时候 是接收一个地址

// 交换太子 展示 判断是否是太子 


// int main(void)
// {   
//     // a p1 *p1 &a p1->a
//     int a = 1, b = 2;
//     int *p1 = &a, *p2 = &b, *pt;
//     // 不要copy 代码 不要 copy代码 不要copy代码
//     printf("a = %d, b = %d, *p1 = %d, *p2 = %d \n", a, b, *p1, *p2);
//     //先理解一下这个示例代码是什么意思 然后按照他的意思 自己按照规范能够写出来
//     pt = p1;
//     p1 = p2;
//     p2 = pt;
//     printf("a = %d, b = %d, *p1 = %d, *p2 = %d \n", a, b, *p1, *p2);

// }






// int main(void){
//     int a,b,c, *p1,*p2;
//     a =2;b=4;c=6;

//     p1 = &a; p2 = &b;
//     // 注意一下编码的规范
//     printf("a = %d, b = %d, c = %d, *p1 = %d, *p2 = %d, p1 = %d, p2 = %d, \n",a, b, c, *p1, *p2, p1, p2);

//     p2 = p1;
//     p1 = &c;
//     printf("a = %d, b = %d, c = %d, *p1 = %d, *p2 = %d, p1 = %d, p2 = %d, \n",a, b, c, *p1, *p2, p1, p2);

// }








// int main(void){
//     int a = 1, b =2 ,t;
//     int *p1, *p2;
//     p1 = &a;
//     p2 = &b;

//     printf("a=%d,b=%d,*p1=%d,*p2=%d,p1=%d,p2=%d\n",a,b,*p1,*p2,p1,p2);
//     // c 语言可以活动内存的地址空间
//     // 自己写代码真好玩
//     // 就是费时间 费尽力。但是不赚钱

//     // 工作就是稍微能够应付过去就差不多了。 
//     // 我真的不不想完全全心全意的去做哪个工作 我还是好好的敲我自己的代码吧

//     t = *p1; *p1 = *p2; *p2 = t;
//     printf("a=%d,b=%d,*p1=%d,*p2=%d,p1=%d,p2=%d\n",a,b,*p1,*p2,p1,p2);

//     // a的地址 和 b的地址 着两个变量的地址 肯定是不会变的。 但是着两个地址里面存放的变量的值改变了。
//     return 0;

// }







// int main(void){
//     int a = 3, *p;
//     p = &a;
//     // int *p  和 *p 是完全不一样的
//     printf("%d\n",p);
//     printf("a = %d, *p = %d\n", a, *p);

//     *p = 10;
//     printf("a = %d, *p = %d\n", a, *p);

//     printf("Enter a: ");
//     scanf("%d", &a);

//     printf("a = %d, *p = %d\n", a, *p);

//     (*p)++;// 指针指向的哪个变量加加 *p++ 

//     printf("a = %d, *p = %d\n",a , *p);



//     printf("%d\n",p);


//     *p++;
//     printf("a = %d, *p = %d\n",a , *p);
//     printf("%d\n",p);
//     return 0;
// }









// int main(){
//     int  key = 911;
//     int* addr = NULL; // 我觉的应该放在前面 完全一样的东西。放到后面就是误导别人。。
//     // 不能完全相信别人。。就是要写一些代码 才能够明白。
//     int  *addr1 =NULL; // 定义的时候可以这么写 这个就是一个指针变量

//     addr = &key;
//     addr1 = &key;
//     printf("the key of velue is %d",key);
//     printf("the key is %d\n",addr);
//     printf("the key of addr1 is %d\n",addr1);
//     printf("abc");
// }






// int main(void){
//     int n;
//     int factorial(int n);
//     //设计模式
//     scanf("%d",&n);
//     printf("%d\n",factorial(n));
//     return 0;
// }

// // 智能提示 编译运行
// int factorial(int n){
//     int i, fact = 1;
//     for (size_t i = 1; i < n; i++)
//     {
//         /* code */
//         fact = fact *i;
//     }
//     return fact;
    
// }




// int main(void)
// {
//    int digit, i, letter, other;     /* 定义3个变量分别存放统计结果 */
//    char ch;                         /* 定义1个字符变量ch */

//    digit = letter = other = 0;      /* 置存放统计结果的3个变量的初值为零 */
//    printf("Enter 10 characters: "); /* 输入提示 */
//    for(i = 1; i <= 10; i++){        /* 循环执行了10次 */
//        ch = getchar();              /* 从键盘输入一个字符，赋值给变量 ch   这个你的代码可以在 shell里面先写完 。。但是 程序执行的时候会一个一个的执行*/
//        if((ch >= 'a' && ch <= 'z' ) || ( ch >= 'A' && ch <= 'Z'))
//            letter ++;                /* 如果ch是英文字母，累加letter */
//        else if(ch >= '0' && ch <= '9')
//     	      digit ++;              /* 如果ch是数字字符，累加digit */
//        else                	
//            other ++;                 /* ch是除字母、数字字符以外的其他字符，累加other */
//    }
//    printf("letter=%d, digit=%d, other=%d\n", letter, digit, other);

//    return 0;
// }







// 两次循环 就他的阶乘。。循环是可以 但是算法也更加的重要。。如何来计算。少几次算法。就出来的结果也就不一样了。
// 第一循环就他的阶乘的值 第二次循环打印。。可以敲自己喜欢的代码 也是一件比较开心的事情。。 
//double fact(int n);
//int main(void){
//	int i, n;
//	double result;
//	
//	printf("Enter n:");
//	scanf("%d",&n);
//	for(i = 1; i <= n; i++){
//		result = fact(i);
//		printf("%d!=%.0f\n",i,result);
//	}
//	
//}
////
////
//double fact(int n){
//	int i;
//	double product;
//	product = 1;
//	for(i = 1; i <= n; i ++){
//		product = product * i;
//	}
//	return product;
//}



// // 你选择哪一个温江 他就会帮你编译哪一个文件
// int main(void){
// 	int i,n;
// 	double power;
	
// 	printf("Enter n:");
// 	scanf("%d",&n);
	
// 	for(i = 0; i <= n; i++){
// 		power = pow(2,i);
// 		printf("pow(2,%d) = %.0f\n",i,power);
// 	}
	
// 	return 0;
// } 


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
