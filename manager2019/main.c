#include "user.h"
#include "menu.h"
#include <unistd.h>

int main(int argc, char* argv[]) {
  LOGIN* userlist[100]; // 사용자목록 포인터 배열 (최대 100)
  int is_login=0; // 로그인 여부 (0 NO, 1 Yes)
  int choice, count = 0;
  if (argc != 2) {
    printf("Usage : manager <datafile>\n");
    return 0;
  }
  int exit = access(argv[1], 0);
  if(exit == -1){
    printf("%s file not exist! make anyway? (Yes 1, No 2) >>  ", argv[1]);
    scanf("%d", &choice);
    if(choice == 1){
      FILE *fp = fopen(argv[1], "a");
      fclose(fp);
      printf("> Welcome!!\n");
    }
    else return 0;
  } else{
    printf("> Welcome!!\n");
   count = load_file(userlist, argv[1]);
  }
  char *menu_id;
  while(1){
    if(is_login==0 || is_login==1) menu_id = ask_menu(is_login); // 현재 로그인 되었는지의 여부를 파라미터로 알려야 한다.
    if(is_login ==1){
      if(!(strcmp(menu_id, "logout") == 0)){
        char word[100];
        fgets(word, 100, stdin);
        printf("%s%s", menu_id, word);
        continue;
      }
    }
    if(strcmp(menu_id, "join") == 0) count = join(userlist, count, argv[1]);
    else if (strcmp(menu_id, "login") == 0) is_login = login(userlist, count);
    else if (strcmp(menu_id, "list") == 0) print_list(userlist, argv[1]);
    else if (strcmp(menu_id, "logout") == 0) {
      if(is_login == 0) {
        printf("No such command!\n");
      }
      else  {
        printf("Bye!!\n");
        logout(&is_login);
      }
    }
    else if(strcmp(menu_id, "exit") == 0 ) {
      printf("%d records saved to %s\n", count, argv[1]);
      return 0;
    }
    else printf("No such command\n");
  }
}

