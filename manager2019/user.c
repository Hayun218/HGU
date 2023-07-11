#include "user.h"

int load_file(LOGIN* list[], char* filename){
  int count=0;
  FILE *datafile = fopen(filename, "rt");
  #ifdef DEBUG_MODE
         printf("DEBUG>> datafile opened!\n");
 #endif
  while(!feof(datafile)){
    list[count]=(LOGIN*)malloc(sizeof(LOGIN));
    fscanf(datafile,"%s %s",list[count]->id,list[count]->password);
    if(feof(datafile)) break;
    else count++;
  }
  printf("%d records read!\n",count);
  fclose(datafile);
  return count;
}

void print_list(LOGIN* list[], char*filename){
  printf("User list (id/password)\n");
  int count = 0;
  FILE *datafile = fopen(filename, "rt");
 #ifdef DEBUG_MODE
         printf("DEBUG>> datafile opened!\n");
#endif
  while(!feof(datafile)){
    list[count]=(LOGIN*)malloc(sizeof(LOGIN));
    fscanf(datafile,"%s %s",list[count]->id,list[count]->password);
    if(feof(datafile)) break;
    printf("[%d] %s / %s\n", count+1, list[count]->id,list[count]->password);
     count++;
  }
}

int join(LOGIN* list[], int count, char* filename){
  char id[20], pass[20];
  while(1){
    printf("Enter new user id >> ");
    scanf("%s", id);
    int dup=0;
    for(int i=0;i<count;i++){
      if(strcmp(id, list[i]->id)==0) {
        dup=1; break;
      }
    }
    if(dup==1){
      printf("Already exist!!\n");
    }
    else{
      printf("Enter password >> ");
      scanf("%s", pass);
      count++;
      list[count] = (LOGIN*)malloc(sizeof(LOGIN));
      strcpy(list[count]->id, id);
      strcpy(list[count]->password, pass);
      printf("New user added!\n");
      FILE *datafile = fopen(filename, "awt");
 #ifdef DEBUG_MODE
         printf("DEBUG>> datafile opened! \n");
 #endif
      fprintf(datafile,"%s %s\n", list[count]->id, list[count]->password);
      fclose(datafile);
      break;
    }
}
    return count;
}

int login(LOGIN* list[], int count){
  char id[20], pass[20];
  printf("Enter user id >> ");
  scanf("%s", id);
  int dup=0, found;
  for(int i=0;i<count;i++){
    if(strcmp(id, list[i]->id)==0) {
      dup=1;
      found = i;
      break;
    }
  }
  if(dup!=1){
    printf("No such user!!\n");
    return 0;
  }
  else{
    printf("Enter password >> ");
    scanf("%s", pass);
    if(strcmp(list[found]->password, pass) ==0){
      printf("Welcome %s!!\n", id);
      return 1;
    }
    else{
      printf("Password incorrect!!\n");
      return 0;
    }
  }
}

void logout(int* is_login){
  *is_login = 0;
  printf("Logout!!\n");
}

/*void save_file(LOGIN* list[], int count, char* filename){
  FILE *datafile = fopen(filename, "wt");
  for(int i=0; i<count; i++){
    fprintf(datafile, "%s %s\n", list[i]->id, list[i]->password);
  }
  printf("%s Saved!\n", filename);
  fclose(datafile);
}*/

