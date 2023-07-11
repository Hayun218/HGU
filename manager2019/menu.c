#include "menu.h"

char* ask_menu(int is_login){ // 문자열을 return하므로 포인터 반환
// 파라미터 : 로그인여부 (0 No, 1Yes)
  static char menu[10];
  if(is_login==0)
    printf("> ");
  else
    printf("# ");
  scanf("%s", menu);
  return menu;
}
#ifndef SYMBOL
#define  value
#endif

