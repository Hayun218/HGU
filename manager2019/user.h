#ifndef STDIOH
  #include <stdio.h>
  #define STDIOH
#endif
#ifndef STRINGH
  #include <string.h>
  #define STRINGH
#endif
#ifndef STDLIBH
  #include <stdlib.h>
  #define STDLIBH
#endif

typedef struct login {
  char id[20];
  char password[20];
} LOGIN;

int load_file(LOGIN* list[], char* filename);
int join(LOGIN* list[], int count, char* filename);
int login(LOGIN* list[], int count);
void logout(int* is_login);
//void save_file(LOGIN* list[], int count, char* filename);
void print_list(LOGIN* list[], char* filename);

