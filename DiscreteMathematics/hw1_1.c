#include <stdio.h>

int main (){
    int x,y;

    //scan the input file
    int input[9][9];
    char c;
    for (int y = 0 ; y < 9 ; y++){
        for ( int x=0 ; x < 9 ; x++){
            scanf("%c ",&c);

            if(c=='?') input[y][x] = 0;
            else if(c=='*') input[y][x] = -1;
            else input[y][x] = c - '0';
        }
    }

    // write formula
	FILE * fp = fopen("formula", "w") ;

	for (y = 1 ; y <= 9 ; y++)
		for (x = 1 ; x <= 9 ; x++)
			fprintf(fp, "(declare-const a%d%d Int)\n", y, x) ;

    // debug
    #ifdef DEBUG
    fprintf(fp,"Debug Mode\n");
    for (y = 1 ; y <= 9 ; y++)
		for (x = 1 ; x <= 9 ; x++)
            fprintf(fp,"input[%d][%d] = %d\n",y,x,input[y-1][x-1]);
    #endif

    // Q0 : specific number
    for (y = 1 ; y <= 9 ; y++)
		for (x = 1 ; x <= 9 ; x++)
            if(input[y-1][x-1]>0)
			    fprintf(fp, "(assert (= a%d%d %d))\n", y, x, input[y-1][x-1]) ;

    // Q1 : 1-9행 검사
    for (int k = 1 ; k <= 9 ; k++){
        for (y = 1 ; y <= 9 ; y++){
            fprintf(fp, "(assert (or");
            for (x = 1 ; x <= 9 ; x++)
                fprintf(fp,"(= a%d%d %d) ", y, x, k) ;
            fprintf(fp,"))\n");
        }
    }

    // 한 행에 각 숫자 한 개씩만 존재
    for (y = 1 ; y <= 9 ; y++){
        fprintf(fp, "(assert (and ");
        for (x = 1 ; x <= 8 ; x++){
            for (int k = x+1 ; k <= 9 ; k++)
                fprintf(fp,"(not (= a%d%d a%d%d)) ", y, x, y, k);
        }
        fprintf(fp,"))\n");
    }

    // 한 열에 각 숫자 한 개씩만 존재
    for (x = 1 ; x <= 9 ; x++){
        fprintf(fp, "(assert (and ");
        for (y = 1 ; y <= 8 ; y++){
            for (int k = x+1 ; k <= 9 ; k++)
                fprintf(fp,"(not (= a%d%d a%d%d)) ", y, x, y, k);
        }
        fprintf(fp,"))\n");
    }

    // 한 박스에 각 숫자 한 개씩만 존재
    for (y = 2 ; y <= 9 ; y += 3 ){
        for (x = 2 ; x <= 9 ; x += 3 ){
            fprintf(fp, "(assert (and ");
        }
    }


    fprintf(fp, "(check-sat)\n(get-model)\n") ;

	fclose(fp) ;
}