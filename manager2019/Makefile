CC = gcc 
CFLAGS = -W -Wall
TARGET = manager
TARGET2 = manager_d
OBJECTS = menu.o user.o main.o
D_OBJECTS = menu_d.o user_d.o main_d.o
DEBUG = -DDEBUG_MODE 

all : $(TARGET)
 
$(TARGET2) : $(D_OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^
 
$(TARGET) : $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^


user_d.o : user.c
	$(CC) $(DEBUG) $(CFLAGS) -c -o $@ $^
 
main_d.o : main.c
	$(CC) $(DEBUG) $(CFLAGS) -c -o $@ $^

menu_d.o : menu.c
	$(CC) $(DEBUG) $(CFLAGS) -c -o $@ $^ 
clean :
	rm *.o manager manager_d
