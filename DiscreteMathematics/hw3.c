// 21800409 Jiyoung Shin

#include <stdio.h>
#include <stdlib.h>

#define N 6
#define M 6

int main (){
    int x,y,k;

    // scan the input file
    int input[N][M];
    char c[10000];

    for (y = 0 ; y < N ; y++){
        for ( x = 0 ; x < M ; x++){
            scanf("%s ",c);

            if(c[0]=='?') input[y][x] = 0;
            else input[y][x] = atoi(c);
        }
    }

    // write formula
	FILE * fp = fopen("formula", "w") ;

	for (y = 1 ; y <= N ; y++)
		for (x = 1 ; x <= M ; x++)
			fprintf(fp, "(declare-const a%d%d Int)\n", y, x) ;

    // Q0 : specific number
    for (y = 1 ; y <= N ; y++)
        for (x = 1 ; x <= M ; x++)
            if(input[y-1][x-1]>0)
                fprintf(fp, "(assert (= a%d%d %d))\n", y, x, input[y-1][x-1]) ;

    // Q1 : All values are between 1-N*M.
    for (y = 1 ; y <= N ; y++)
        for (x = 1 ; x <= M ; x++)
        fprintf(fp, "(assert (and (<= 1 a%d%d) (<= a%d%d %d)))\n",y,x,y,x,N*M);

    
    // Q2 : like snake
    for (y = 1 ; y <= N ; y++){
        for (x = 1 ; x <= M ; x++){
            fprintf(fp, "(assert (or \n");
            fprintf(fp, "(= a%d%d %d) \n",y,x,1);
            if(1 <= y-1)
                fprintf(fp, "(= (+ a%d%d -1) a%d%d) \n",y,x,y-1,x);
            if(y+1 <= N)
                fprintf(fp, "(= (+ a%d%d -1) a%d%d) \n",y,x,y+1,x);
            if(1 <= x-1)
                fprintf(fp, "(= (+ a%d%d -1) a%d%d) \n",y,x,y,x-1);
            if(x+1 <= M)
                fprintf(fp, "(= (+ a%d%d -1) a%d%d) \n",y,x,y,x+1);
            fprintf(fp,"))\n");
        }
    }

    for (y = 1 ; y <= N ; y++){
        for (x = 1 ; x <= M ; x++){
            fprintf(fp, "(assert (or \n");
            fprintf(fp, "(= a%d%d %d) \n",y,x,N*M);
            if(1 <= y-1)
                fprintf(fp, "(= (+ a%d%d 1) a%d%d) \n",y,x,y-1,x);
            if(y+1 <= N)
                fprintf(fp, "(= (+ a%d%d 1) a%d%d) \n",y,x,y+1,x);
            if(1 <= x-1)
                fprintf(fp, "(= (+ a%d%d 1) a%d%d) \n",y,x,y,x-1);
            if(x+1 <= M)
                fprintf(fp, "(= (+ a%d%d 1) a%d%d) \n",y,x,y,x+1);
            fprintf(fp,"))\n");
        }
    }

    // Q3 : Every row and column has only one every value.
    for (k = 1 ; k <= N*M ; k++){
        fprintf(fp,"(assert (= (+ ");
        for (y = 1 ; y <= N ; y++) 
            for (x =1 ; x <= M ; x++)
                fprintf(fp,"\t(ite (= a%d%d %d) 1 0)\n",y,x,k);
            
        fprintf(fp, ") 1))\n") ;
    }

    fprintf(fp, "(check-sat)\n(get-model)\n") ;
    
	fclose(fp) ;
}