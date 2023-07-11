# DiscreteMathematics Assignment 2

## Problem Set

### For all Fractal Problems (1~4)
- When changing the input of the fractal problems, it is necessary to clear what is drawn and then click the draw button in order to avoid replicated sections.

- Button: draw and clear
	- draw: Clicking the button executes the code with the other inputs.
	- clear: Clear everything that is drawn on the canvas.


### Fractal 1: Intersected Lines
- input: depth and ratio
  - The depth should be within 13 due to the delay when executing greater depths.
  - The ratio is used in a formula like the below when dx represents length:

  ```
  var xL = x1 - (dx/ratio);
  ```
  Therefore, the increase in ratio minimizes the result figure when the increase magnifies the scale.

  - It is recommended to test ratio 2 when depth is greater than 6.
  - In order to magnify the scale, put a number less than 1. The greater depth is also recommended in this case to generate a proper figure.

### Fractal 2: Flakes
- input: depth  
	- Only depth is necessary for the problem.

### Fractal 3: Creative Fractal
- input: depth  
	- Only depth is necessary for the problem.

### Fractal 4: Triangulation
- input: stack_x, stack_y
   - please type all point throught the interface.
- Draw: polygon
   - If there is no simple polygon case given points, draw nothing.
- Clear: reset
   - All clear
## How to build and execute?
- The first four fractal problems would be executed by clicking these html files. It will directly leads into the web browser.


### CNF Converter

- input: text file

- output: CNF

1. How to compile

     chmod 755 make 
            
        you must change mode for excuting ./make.
     
     ./make 'file name'
     
        ex) ./make input.txt

2. How to excute

    ./make 'file name'
        
        when you run ./make, the result is in solution file. 


## License  
Prof. Shin Hong hongshin@gmail.com  
Hayun Park gkahsdl@icloud.com
Narin Kang 21800001@handong.edu
HyunGyu Lee 21800601@handong.edu
MinJae Yi 21800511@handong.edu
SueGeun Song 21500359@handong.edu
.
.
.
