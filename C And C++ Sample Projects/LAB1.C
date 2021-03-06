#include<stdio.h>
#include<conio.h>
#include<time.h>
#define N 2000
int a[N];
int maxsubsequenceN3(){
	 int maxSum = 0,i,j,k,thisSum;
	 for(i = 0; i < N; i++ ){
		 for(j = i; j < N; j++ )
		 {
		  int thisSum = 0;
		  for(k = i; k <= j; k++ )
			    thisSum += a[ k ];
		  if( thisSum > maxSum )
			    maxSum   = thisSum;
		 }
	 }
	 return maxSum;

}


int maxsubsequenceN2(){
	 int maxSum = 0,i=0,j=0,thisSum;

	 for(i = 0; i < N; i++ ){
		  thisSum = 0;

		  for(j=i;j<N;j++ )
		  {
		       thisSum += a[ j ];

		       if( thisSum > maxSum )
			      maxSum   = thisSum;

		  }
	   }
	 return maxSum;
}

int maxsubsequenceN(){
	int maxSum = 0,j,thisSum=0;
	for(j = 0; j < N; j++ )
	   {
	      thisSum+= a[ j ];
	      if ( thisSum > maxSum )
		 maxSum = thisSum;
	      else if ( thisSum < 0 )
		 thisSum = 0;
	   }

       return maxSum;

}

int main(){
clock_t start, end;
int result1,result2,result3;
float time3,time2,time1;
int i;
clrscr();
	  for(i=0;i<N;i++){
	      a[i]=rand()%10;

	  }
	  start = clock();
	  result3=maxsubsequenceN3();
	  end = clock();
	  time3= (end - start) / CLK_TCK;

	  start = clock();
	  result2=maxsubsequenceN2();
	  end = clock();
	  time2= (end - start) / CLK_TCK;


	  start = clock();
	  result1=maxsubsequenceN();
	  end = clock();
	  time1= (end - start) / CLK_TCK;


	printf("N^3 result:%d\nTime:%f\n\n",result3,time3);
	printf("N^2 result:%d\nTime:%f\n\n",result2,time2);
	printf("N result:%d\nTime:%f\n\n",result1,time1);
	return 0;
}


 