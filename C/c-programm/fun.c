#include <stdio.h>
#include <math.h> 
#include <stdlib.h>
// �ַ����� ���� ���� ���ݽṹ ��� �����е����ġ����ṹ����
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

    // fwrite fread ���� �ṹ�Ķ��� ��ʹ��
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
//     // ��Ҫ��ѧϰһ��������﷨
//     // ��������ȫ���������10���ַ�֮�� �Ż����������ȥ���С���
//     // c# ��c��ʵû��ʲô���ʵ����� �����ļ� ����Ҳ�Ǵ���2�������� �ײ����±߱��ʻ��Ƕ��Ǵ���1��1���ֽڵ����ݡ�������ͬ�ĵط���
//     // CLR ����ֱ��дC#����Ͱ���CLR�����һЩ�������������һ���м���롣������ֱ�ӵ��� ����ô���������ˡ�
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





// ��Ϊ�����ʡ���Ǻܻ����Ŀγ� ���� ���������������� ��ʵ�ܼ� Ҳ����
// һ������ϰ�ָС���֪���ײ��һ����֪ʶ�� ��Ҫ���ǻ����γ̵�ѧϰ�����
// C���� ��Զ����ǱȽϵײ�����ԡ����ǺͲ���ϵͳӲ���бȽϴ�Ĺ�����
// ���� �ļ� ���� �Ⱥܶ඼��һһ��Ӧ����һ��һ�����ġ�
// linux windows ������ ����C�����ġ��������Ľӿڵ�Ȼ
// C# .net ���������� ���� �ļ� ���� ͼƬ �ȵײ�Ľӿڵ��� ��������ķ�����
// C���б�׼�� ����ֱ�ӵ��ò���ϵͳ�ķ�����
//ע�����ִ�Сд
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



// ��һ���ļ�����ȥд���� ���ֻ��ȥ���ñ�׼�⵱�еķ�����
// ˵ʵ�� ���C����ѧϰ�����ݻ��ǱȽϵ��١�����������ļ��ķ�������ôʵ�ֵ�
//������������ô����ġ�
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












// #define CIVET 0  // ��è
// #define PRINCE 1 // ̫��

// void replace(int boby);

// // ָ����Ϊ�����Ĳ������� ���Ըı�����ֵ Ȼ��ͨ��ָ�뷵�س�ȥ
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

//     // &boby��ֵ��ʵ�Ǻ� p��ֵ��һ���� ��Ϊ p�����ŵľ���һ����ַ
//     replace1(&boby);
//     display(boby);


//     return 0;
// }



// void replace(int boby){
//     boby = CIVET;
// }

// void replace1(int *p){
//     // ���pָ�����ָ��ľ���boby ���Ǻ�bobyͬһ�� �������ں�������� *p�ı��� ��ʵ���� ��boby ��ֵ���ı��ˡ�
//     // ѧ������� c�Ϳ��� ѧ���ݽṹ ѧ ����ϵͳ ѧ�����������㷨�γ� �ȵ� ������ �м���Ŀ�����
//     *p = CIVET;
// }


// void display(int boby){
//     if (boby == 0)
//     {
//        printf("��è");
//     }else{
//         printf("̫��");
//     }
    
// }

// ��Ҫ����ȫ�ֵİ��� �﷨��֪ʶ�� Ūһ�����ݡ�
// ��һ���ô���ĸо� ָ�� ����ָ�� Ϊ������ѧϰ���¼�ʵ�Ļ���
// ָ�������Ϊ������ʱ�� �ǽ���һ����ַ

// ����̫�� չʾ �ж��Ƿ���̫�� 


// int main(void)
// {   
//     // a p1 *p1 &a p1->a
//     int a = 1, b = 2;
//     int *p1 = &a, *p2 = &b, *pt;
//     // ��Ҫcopy ���� ��Ҫ copy���� ��Ҫcopy����
//     printf("a = %d, b = %d, *p1 = %d, *p2 = %d \n", a, b, *p1, *p2);
//     //�����һ�����ʾ��������ʲô��˼ Ȼ����������˼ �Լ����չ淶�ܹ�д����
//     pt = p1;
//     p1 = p2;
//     p2 = pt;
//     printf("a = %d, b = %d, *p1 = %d, *p2 = %d \n", a, b, *p1, *p2);

// }






// int main(void){
//     int a,b,c, *p1,*p2;
//     a =2;b=4;c=6;

//     p1 = &a; p2 = &b;
//     // ע��һ�±���Ĺ淶
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
//     // c ���Կ��Ի�ڴ�ĵ�ַ�ռ�
//     // �Լ�д���������
//     // ���Ƿ�ʱ�� �Ѿ��������ǲ�׬Ǯ

//     // ����������΢�ܹ�Ӧ����ȥ�Ͳ���ˡ� 
//     // ����Ĳ�������ȫȫ��ȫ���ȥ���ĸ����� �һ��Ǻúõ������Լ��Ĵ����

//     t = *p1; *p1 = *p2; *p2 = t;
//     printf("a=%d,b=%d,*p1=%d,*p2=%d,p1=%d,p2=%d\n",a,b,*p1,*p2,p1,p2);

//     // a�ĵ�ַ �� b�ĵ�ַ �����������ĵ�ַ �϶��ǲ����ġ� ������������ַ�����ŵı�����ֵ�ı��ˡ�
//     return 0;

// }







// int main(void){
//     int a = 3, *p;
//     p = &a;
//     // int *p  �� *p ����ȫ��һ����
//     printf("%d\n",p);
//     printf("a = %d, *p = %d\n", a, *p);

//     *p = 10;
//     printf("a = %d, *p = %d\n", a, *p);

//     printf("Enter a: ");
//     scanf("%d", &a);

//     printf("a = %d, *p = %d\n", a, *p);

//     (*p)++;// ָ��ָ����ĸ������Ӽ� *p++ 

//     printf("a = %d, *p = %d\n",a , *p);



//     printf("%d\n",p);


//     *p++;
//     printf("a = %d, *p = %d\n",a , *p);
//     printf("%d\n",p);
//     return 0;
// }









// int main(){
//     int  key = 911;
//     int* addr = NULL; // �Ҿ���Ӧ�÷���ǰ�� ��ȫһ���Ķ������ŵ���������󵼱��ˡ���
//     // ������ȫ���ű��ˡ�������ҪдһЩ���� ���ܹ����ס�
//     int  *addr1 =NULL; // �����ʱ�������ôд �������һ��ָ�����

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
//     //���ģʽ
//     scanf("%d",&n);
//     printf("%d\n",factorial(n));
//     return 0;
// }

// // ������ʾ ��������
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
//    int digit, i, letter, other;     /* ����3�������ֱ���ͳ�ƽ�� */
//    char ch;                         /* ����1���ַ�����ch */

//    digit = letter = other = 0;      /* �ô��ͳ�ƽ����3�������ĳ�ֵΪ�� */
//    printf("Enter 10 characters: "); /* ������ʾ */
//    for(i = 1; i <= 10; i++){        /* ѭ��ִ����10�� */
//        ch = getchar();              /* �Ӽ�������һ���ַ�����ֵ������ ch   �����Ĵ�������� shell������д�� �������� ����ִ�е�ʱ���һ��һ����ִ��*/
//        if((ch >= 'a' && ch <= 'z' ) || ( ch >= 'A' && ch <= 'Z'))
//            letter ++;                /* ���ch��Ӣ����ĸ���ۼ�letter */
//        else if(ch >= '0' && ch <= '9')
//     	      digit ++;              /* ���ch�������ַ����ۼ�digit */
//        else                	
//            other ++;                 /* ch�ǳ���ĸ�������ַ�����������ַ����ۼ�other */
//    }
//    printf("letter=%d, digit=%d, other=%d\n", letter, digit, other);

//    return 0;
// }







// ����ѭ�� �����Ľ׳ˡ���ѭ���ǿ��� �����㷨Ҳ���ӵ���Ҫ������������㡣�ټ����㷨���ͳ����Ľ��Ҳ�Ͳ�һ���ˡ�
// ��һѭ�������Ľ׳˵�ֵ �ڶ���ѭ����ӡ�����������Լ�ϲ���Ĵ��� Ҳ��һ���ȽϿ��ĵ����顣�� 
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



// // ��ѡ����һ���½� ���ͻ���������һ���ļ�
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
