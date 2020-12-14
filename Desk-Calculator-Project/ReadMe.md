
### Description

--> Implemenation of Desk calculator which supports operations such as: + , * , ^ , unary minus and brackets.

--> Method: After writing the postfix SDT for the calculator, LR(1) automaton and CLR parse table for the grammar is found. LR parsing is done and the semantic action for a particular production is executed when the reduction happens. This performs translation of the given input string into the answer.


----------------------------------------------------------------------------------------------------------------------------------------------------------------

### Commands to run the code:

1) To run the code which uses flex for generating lexical analysis:
```

flex++ S20180010067_Desk_calculator.l
g++ -std=c++11 lex.yy.cc
./a.out

```
Note: This only works for linux systems as integrating flex with C++ is only possible on linux OS.

Therefore, for Windows OS another implementation is there without lex which uses C++ code for generating lexical analysis.




2)To run the code implemented without lex:

```
g++ -std=c++11 S20180010067_Desk_Calculator.cpp

```
Now you can run the executable file.


------------------------------------------------------------------------------------------------------------------------------------------------------------------

### To give the input string:

Please enter the input as a string without any space in between and finally press enter to terminate the input.

Example: 2*3+8*-9ENTER
