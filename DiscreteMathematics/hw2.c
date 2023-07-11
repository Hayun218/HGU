// 21800409 Jiyoung Shin

#include <stdio.h>
#define N 5
#define M 5

int main (){
    int x,y,k;

    // scan the input file
    int input[N][M];
    char c;

    for (y = 0 ; y < N ; y++){
        for ( x = 0 ; x < M ; x++){
            scanf("%c ",&c);

            if(c=='?') input[y][x] = 0;
            else input[y][x] = c - '0';
        }
    }

    // write formula
	FILE * fp = fopen("formula", "w") ;

	for (y = 1 ; y <= N ; y++)
		for (x = 1 ; x <= M ; x++)
			fprintf(fp, "(declare-const a%d%d Int)\n", y, x) ;

    // 0<= a_yx <=1
    for (y = 1 ; y <= N ; y++)
		for (x = 1 ; x <= M ; x++)
			fprintf(fp, "(assert (and (<= 0 a%d%d) (<= a%d%d 1))) \n", y, x, y, x) ;

    // Q0 : sum of its neighbors is itself (?)
    for (y = 1 ; y <= N ; y++){
        for (x = 1 ; x <= M ; x++){
            if(input[y-1][x-1]>0){
                fprintf(fp,"(assert (= (+ \n");
                for(int m = -1 ; m <= 1 ; m++){
                    for(int n = -1 ; n <= 1 ; n++){
                        if(0<y+m && y+m<=N && 0<x+n && x+n<=M)
                            fprintf(fp,"a%d%d ",y+m,x+n);
                    }
                }
                fprintf(fp,") %d))\n",input[y-1][x-1]);
            }
        }
    }

    // check Satisfiable and get model
    fprintf(fp, "(check-sat)\n(get-model)\n") ;
    
    fclose(fp);
}