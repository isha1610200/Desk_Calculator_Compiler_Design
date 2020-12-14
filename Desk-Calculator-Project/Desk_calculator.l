%{
    #include<iostream>
    #include<string>
    #include<vector>
    #include<cmath>
    #include<stdlib.h>
    #include<stdio.h>
    

    class Token {

      public:
        bool is_current = false;
        std::string token_class{};
        std::string token_val{};
    };

    Token current_token{}; //made it global so that both Lexical analyzer and Parser can modify this.
   
%}

%option noyywrap
%option c++

/*  regular definitions */

digit                 [0-9]
number                {digit}+(\.{digit}+)?(e[+-]?{digit}+)? 


%%  

{number}                       { current_token.token_val = yytext;
                                 current_token.token_class = "num";
                                 current_token.is_current = true;
                                  printf(" \n ACCESSED TOKEN NUMBER: %s \n",yytext); return 0;}

"+"                              {current_token.token_val = yytext;
                                   current_token.token_class = "OPERATOR";
                                   current_token.is_current = true;
                                  printf(" \n ACCESSED TOKEN  PLUS: %s\n",yytext); return 0;}

"-"                              { current_token.token_val = yytext;
                                   current_token.token_class = "OPERATOR";
                                   current_token.is_current = true;
                                   printf("\n ACCESSED TOKEN UNMINUS: %s\n",yytext); return 0;}

"*"                              { current_token.token_val = yytext;
                                   current_token.token_class = "OPERATOR";
                                   current_token.is_current = true;
                                   printf("\n ACCESSED TOKEN MUL: %s\n",yytext);return 0 ;}

"^"                             {current_token.token_val = yytext;
                                   current_token.token_class = "OPERATOR";
                                   current_token.is_current = true;
                                    printf("\n ACCESSED TOKEN POW: %s\n",yytext);  return 0;}

"("                             { current_token.token_val = yytext;
                                   current_token.token_class = "BRACKET";
                                   current_token.is_current = true;
                                   printf(" ACCESSED TOKEN OPEN_BRACKET: %s\n",yytext); return 0;}

")"                             {current_token.token_val = yytext;
                                   current_token.token_class = "BRACKET";
                                   current_token.is_current = true;
                                    printf("ACCESSED TOKEN CLOSE_BRACKET : %s\n",yytext); return 0;}

"\n"                            { current_token.token_val = "n";
                                   current_token.token_class = "ENTER";
                                   current_token.is_current = true;
                                   printf("ACCESSED TOKEN ENTER : %s\n",yytext);return 0;}    

                              

%%

int yywrap(void )
{
    return 1;
}


 


class Production {

public:
  std::string head{};
  std::vector<std::string> body{};
  //How to store semantic actions???

  void print_prod()
  {
    std::cout << head << "  <-  ";
    for (int i = 0; i < body.size(); i++)
      std::cout << body[i] << " ";
  }
};


class ParseInfoRow {

public:
  std::string dollar{ "" };
  std::string num{ "" };
  std::string close_bracket{ "" };
  std::string open_bracket{ "" };
  std::string unminus{ "" };
  std::string power{ "" };
  std::string mult{ "" };
  std::string plus{ "" };
  std::string newline{ "" };
  int goto_L = -1;
  int goto_T = -1;
  int goto_F = -1;
  int goto_A = -1;
  int goto_B = -1;
  int goto_E = -1;
  //These values indicate emptiness...

  ParseInfoRow()
  {

  }

  ParseInfoRow (std::string dollar, std::string num, std::string close_bracket, std::string open_bracket,
    std::string unminus , std::string power, std::string mult, std::string plus, std::string newline ,
    int goto_L, int goto_T , int goto_F , int goto_A, int goto_B, int goto_E)
  {
    this->dollar = dollar;
    this->num = num;
    this->open_bracket = open_bracket;
    this->close_bracket = close_bracket;
    this->unminus = unminus;
    this->power = power;
    this->mult = mult;
    this->plus = plus;
    this->newline = newline;
    this->goto_L = goto_L;
    this->goto_T = goto_T;
    this->goto_F = goto_F;
    this->goto_A = goto_A;
    this->goto_B = goto_B;
    this->goto_E = goto_E;

  }


  


};

FlexLexer* lexer = new yyFlexLexer;

std::vector<Production> Postfix_SDT;  //Production number given by indices in vector
std::vector<ParseInfoRow> LR_ParseTable; //Row number/LR-state same as index in vector

void Fill_Postfix_SDT()
{
  Production temp;

  // L -> E n
  temp.head = std::string{ "L" };
  temp.body.push_back(std::string{ "E" });
  temp.body.push_back(std::string{ "n" });
  Postfix_SDT.push_back(temp);

  //E -> E + T
  temp.head = std::string{ "E" };
  temp.body.clear();
  temp.body.push_back(std::string{ "E" });
  temp.body.push_back(std::string{ "+" });
  temp.body.push_back(std::string{ "T" });
  Postfix_SDT.push_back(temp);
  
  //E -> T
  temp.head = std::string{ "E" };
  temp.body.clear();
  temp.body.push_back(std::string{ "T" });
  Postfix_SDT.push_back(temp);

  //T -> T * F
  temp.head = std::string{ "T" };
  temp.body.clear();
  temp.body.push_back(std::string{ "T" });
  temp.body.push_back(std::string{ "*" });
  temp.body.push_back(std::string{ "F" });
  Postfix_SDT.push_back(temp);

  //T -> F
  temp.head = std::string{ "T" };
  temp.body.clear();
  temp.body.push_back(std::string{ "F" });
  Postfix_SDT.push_back(temp);

  //F -> F ^ A
  temp.head = std::string{ "F" };
  temp.body.clear();
  temp.body.push_back(std::string{ "F" });
  temp.body.push_back(std::string{ "^" });
  temp.body.push_back(std::string{ "A" });
  Postfix_SDT.push_back(temp);

  //F -> A
  temp.head = std::string{ "F" };
  temp.body.clear();
  temp.body.push_back(std::string{ "A" });
  Postfix_SDT.push_back(temp);


  //A -> - B
  temp.head = std::string{ "A" };
  temp.body.clear();
  temp.body.push_back(std::string{ "-" });
  temp.body.push_back(std::string{ "B" });
  Postfix_SDT.push_back(temp);


  //A -> B
  temp.head = std::string{ "A" };
  temp.body.clear();
  temp.body.push_back(std::string{ "B" });
  Postfix_SDT.push_back(temp);

  //B -> ( E )
  temp.head = std::string{ "B" };
  temp.body.clear();
  temp.body.push_back(std::string{ "(" });
  temp.body.push_back(std::string{ "E" });
  temp.body.push_back(std::string{ ")" });
  Postfix_SDT.push_back(temp);

  //B -> num
  temp.head = std::string{ "B" };
  temp.body.clear();
  temp.body.push_back(std::string{ "num" });
  Postfix_SDT.push_back(temp);
}




void Fill_Parse_Table() {

  // 0
  LR_ParseTable.push_back(ParseInfoRow{ "","s_9", "","s_8","s_7","","","","",6,5,4,3,2,1 });

  //1
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","","","s_22","s_21",-1,-1,-1,-1,-1,-1 });

  //2
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","r_8","r_8","r_8","r_8",-1,-1,-1,-1,-1,-1 });

  //3
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","r_6","r_6","r_6","r_6",-1,-1,-1,-1,-1,-1 });

  //4
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","s_20","r_4","r_4","r_4",-1,-1,-1,-1,-1,-1 });

  //5
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","","s_19","r_2","r_2",-1,-1,-1,-1,-1,-1 });

  //6
  LR_ParseTable.push_back(ParseInfoRow{ "acc","", "","","","","","","",-1,-1,-1,-1,-1,-1 });

  //7
  LR_ParseTable.push_back(ParseInfoRow{ "","s_9", "","s_8","","","","","",-1,-1,-1,-1,18,-1 });

  //8
  LR_ParseTable.push_back(ParseInfoRow{ "","s_17", "","s_16","s_15","","","","",-1,14,13,12,11,10 });


  //9
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","r_10","r_10","r_10","r_10",-1,-1,-1,-1,-1,-1 });


  //10
  LR_ParseTable.push_back(ParseInfoRow{ "","", "s_31","","","","","s_30","",-1,-1,-1,-1,-1,-1 });

  //11
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_8","","","r_8","r_8","r_8","",-1,-1,-1,-1,-1,-1 });

  //12
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_6","","","r_6","r_6","r_6","",-1,-1,-1,-1,-1,-1 });

  //13
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_4","","","s_29","r_4","r_4","",-1,-1,-1,-1,-1,-1 });

  //14
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_2","","","","S_28","r_2","",-1,-1,-1,-1,-1,-1 });

  //15
  LR_ParseTable.push_back(ParseInfoRow{ "","s_17", "s_16","","","","","","",-1,-1,-1,-1,27,-1 });

  //16
  LR_ParseTable.push_back(ParseInfoRow{ "","s_17", "","s_16","s_15","","","","",-1,14,13,12,11,26 });

  //17
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_10","","","r_10","r_10","r_10","",-1,-1,-1,-1,-1,-1 });

  //18
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","r_7","r_7","r_7","r_7",-1,-1,-1,-1,-1,-1 });

  //19
  LR_ParseTable.push_back(ParseInfoRow{ "","s_9", "","s_8","s_7","","","","",-1,-1,25,3,2,-1 });

  //20
  LR_ParseTable.push_back(ParseInfoRow{ "","s_9", "","s_8","s_7","","","","",-1,-1,-1,24,2,-1 });

  //21
  LR_ParseTable.push_back(ParseInfoRow{ "r_0","", "","","","","","","",-1,-1,-1,-1,-1,-1 });

  //22
  LR_ParseTable.push_back(ParseInfoRow{ "","s_9", "","s_8","s_7","","","","",-1,23,4,3,2,-1 });

  //23
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","","s_19","r_1","r_1",-1,-1,-1,-1,-1,-1 });

  //24
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","r_5","r_5","r_5","r_5",-1,-1,-1,-1,-1,-1 });

  //25
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","s_20","r_3","r_3","r_3",-1,-1,-1,-1,-1,-1 });

    //26
  LR_ParseTable.push_back(ParseInfoRow{ "","", "s_35","","","","","s_30","",-1,-1,-1,-1,-1,-1 });

  //27
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_7","","","r_7","r_7","r_7","",-1,-1,-1,-1,-1,-1 });

  //28
  LR_ParseTable.push_back(ParseInfoRow{ "","s_17", "","s_16","s_15","","","","",-1,-1,34,12,11,-1 });

  //29
  LR_ParseTable.push_back(ParseInfoRow{ "","s_17", "","s_16","s_15","","","","",-1,-1,-1,33,11,-1 });

  //30
  LR_ParseTable.push_back(ParseInfoRow{ "","s_17", "","s_16","s_15","","","","",-1,32,13,12,11,-1 });

  //31
  LR_ParseTable.push_back(ParseInfoRow{ "","", "","","","r_9","r_9","r_9","r_9",-1,-1,-1,-1,-1,-1 });

  //32
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_1","","","","s_28","r_1","",-1,-1,-1,-1,-1,-1 });

  //33
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_5","","","r_5","r_5","r_5","",-1,-1,-1,-1,-1,-1 });

  //34
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_3","","","s_29","r_3","r_3","",-1,-1,-1,-1,-1,-1 });

  //35
  LR_ParseTable.push_back(ParseInfoRow{ "","", "r_9","","","r_9","r_9","r_9","",-1,-1,-1,-1,-1,-1 });

}

void InitializeDeskCalculator()
{
  Fill_Postfix_SDT();
  Fill_Parse_Table();

}



 void Next_Token_from_Lexical_Analyzer()
{   
    
      if(current_token.token_val == "n")
      {
        current_token.token_val = "$";
        current_token.token_class = "Dollar";
        current_token.is_current = true;
      }

      else
         lexer->yylex();
     
     
}

template<typename T>
class Stack{

public:
  T  stack_vec[100]; //on local stack--> better on heap
  int top = -1;

  void Push(const T& ele)
  { 
    if (top == 99)
    {
      std::cout << "Sorry, stack can't accomodate more elements.";
      exit(0);
    }
    top = top + 1;
    stack_vec[top] = ele;
  }

  void Pop()
  {
    top = top - 1;
  }
  

  T Top()
  {
    if (top >= 0)
      return stack_vec[top];
    else
    {
      std::cout << "Error : Stack is empty!!";
      exit(0);
    }
  }

  void Print()
  {

    for (int i = 0; i <= top; i++)
    {
      std::cout << stack_vec[i] << "    ";
    }
    std::cout << std::endl;
  }

};


void Print_Computation_Array(int lim, float Calculator_Computation_Array[])
{
  for (int i = 0; i <= lim; i++)
  {
    std::cout << Calculator_Computation_Array[i] << "    ";
  }
  std::cout << std::endl;
}

void Shift(std::string action_to_be_done,Stack<int>& Automaton_States, Stack<std::string>& Stack_Grammar_Symbols,float Calculator_Computation_Array[])
{
  int new_state = stoi(action_to_be_done.substr(2, action_to_be_done.length() - 2));

  std::cout << " Action: Shifting token value:: " << current_token.token_val << " And going to state: " << new_state ;


  Automaton_States.Push(new_state); //Push the new state to which we'll shift

  //Push the token to the stack
  if (current_token.token_class == "num")
  {
    Stack_Grammar_Symbols.Push("num");
    Calculator_Computation_Array[Stack_Grammar_Symbols.top] = stof(current_token.token_val);
  }
  else {
    Stack_Grammar_Symbols.Push(current_token.token_val);
  }

  //Current token-> no more really current
  current_token.is_current = false;
  
}

void Reduce(std::string action_to_be_done, Stack<int>& Automaton_States, Stack<std::string>& Stack_Grammar_Symbols, float Calculator_Computation_Array[])
{
  int production_number = stoi(action_to_be_done.substr(2, action_to_be_done.length() - 2));

  //Now reduce on the basis of this production.
  Production prod = Postfix_SDT[production_number];

  std::cout << " Action: Reduce using production number: " << production_number <<  "  that is the production:  ";
  prod.print_prod();
  std::cout << std::endl;
  
  int r = prod.body.size();

  //Manipulate Array having values.
  switch (production_number)
  {
  case 0:
  {
    // Calculator_Computation_Array[Stack_Grammar_Symbols.top -1] = Calculator_Computation_Array[Stack_Grammar_Symbols.top - 1];
    std::cout << "    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   " << std::endl;
    std::cout << "              Answer is: " << Calculator_Computation_Array[Stack_Grammar_Symbols.top - 1] << std::endl;
    std::cout << "    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   " << std::endl;
    break;
  }
  case 1:
  {
    Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] = Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] + Calculator_Computation_Array[Stack_Grammar_Symbols.top];
    break;
  }
  case 3:
  { 
    //std::cout << "\ncheck purpose while reducing using production-3:" << std::endl;
    //std::cout << " \npos: " << Stack_Grammar_Symbols.top - 2 << "  stores: " << Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2];
    //std::cout << " \npos: " << Stack_Grammar_Symbols.top  << "  stores: " << Calculator_Computation_Array[Stack_Grammar_Symbols.top ];
    //std::cout << std::endl;
    Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] = Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] * Calculator_Computation_Array[Stack_Grammar_Symbols.top];
      //std::cout << " \npos_res: " << Stack_Grammar_Symbols.top - 2 << "  stores_res: " << Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2];
    break;
  }
  case 5:
  {
    Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] = pow(Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] , Calculator_Computation_Array[Stack_Grammar_Symbols.top]);
    break;
  }
  case 7:
  {
    Calculator_Computation_Array[Stack_Grammar_Symbols.top - 1] = -1 * Calculator_Computation_Array[Stack_Grammar_Symbols.top];
    break;
  }
  case 9:
  {
    Calculator_Computation_Array[Stack_Grammar_Symbols.top - 2] =  Calculator_Computation_Array[Stack_Grammar_Symbols.top - 1];
    break;
  }
  
  }

  for (int i = 1; i <= r; i++)
  {
    Stack_Grammar_Symbols.Pop();
    Automaton_States.Pop();
  }

  Stack_Grammar_Symbols.Push(prod.head);
  int st = Automaton_States.Top();
  int new_st = -1;

  if (prod.head == std::string("L"))
    new_st = LR_ParseTable[st].goto_L;
  else if (prod.head == std::string("A"))
    new_st = LR_ParseTable[st].goto_A;
  else if (prod.head == std::string("B"))
    new_st = LR_ParseTable[st].goto_B;
  else if (prod.head == std::string("E"))
    new_st = LR_ParseTable[st].goto_E;
  else if (prod.head == std::string("F"))
    new_st = LR_ParseTable[st].goto_F;
  else if (prod.head == std::string("T"))
    new_st = LR_ParseTable[st].goto_T;
  
  //Note;--> Now had to manipultae array storing computations (sematic actions).

  if (new_st > -1)
    Automaton_States.Push(new_st);
  else
  {
    std::cout << "Error in Parsing!" << std::endl;
    std::cout << "Got new state: after GOTO()--> less than 0" << std::endl;
    exit(0);
  }
}

void Parsing_and_Translation()
{
  float Calculator_Computation_Array[100];
  Stack<std::string> Stack_Grammar_Symbols;
  Stack<int> Automaton_States;

  //initialize this
  Stack_Grammar_Symbols.Push(std::string{ "$" });
  Automaton_States.Push(0);

  //Now we can start parsing and translating the sequence of tokens

  
  while (true) 
  {

   std::cout << " Printing automata_states_stack: ";
    Automaton_States.Print();

    std::cout << " Printing grammar_symbols_stack: ";
    Stack_Grammar_Symbols.Print();

    //std::cout << "  Printing compuatation  array: ";
    //Print_Computation_Array(Stack_Grammar_Symbols.top, Calculator_Computation_Array);

    std::cout << "\n-------------------------------------------------\n"; 

    if (current_token.is_current == false)
      Next_Token_from_Lexical_Analyzer();

    int curr_state = Automaton_States.Top();

    std::string action_to_be_done{};

    if (current_token.token_class == std::string("num")) {

      action_to_be_done = LR_ParseTable[curr_state].num;
    }
    else if (current_token.token_val == std::string("+"))
    {
      action_to_be_done = LR_ParseTable[curr_state].plus;
    }
    else if (current_token.token_val == std::string("*"))
    {
      action_to_be_done = LR_ParseTable[curr_state].mult;
    }
    else if (current_token.token_val == std::string("^"))
    {
      action_to_be_done = LR_ParseTable[curr_state].power;
    }
    else if(current_token.token_val == std::string("-"))
    {
      action_to_be_done = LR_ParseTable[curr_state].unminus;
    }
    else if (current_token.token_val == std::string("("))
    {
      action_to_be_done = LR_ParseTable[curr_state].open_bracket;

      //std::cout << "Hi there" << std::endl;
    }
    else if (current_token.token_val == std::string(")"))
    {
      action_to_be_done = LR_ParseTable[curr_state].close_bracket;
    }
    else if (current_token.token_val == std::string("n"))
    {
      action_to_be_done = LR_ParseTable[curr_state].newline;
    }
    else if(current_token.token_val == std::string("$"))
    {
      action_to_be_done = LR_ParseTable[curr_state].dollar;
    }
    
    //std::cout << "Check purpose:" <<  action_to_be_done << std::endl;
    //std::cout << "current token was:" << current_token.token_class << "  ,  " << current_token.token_val << std::endl;
    if (action_to_be_done == std::string(""))
    {
      std::cout << "The given arithmetic expression is not valid!!. Parsing failed.";
      exit(0);
    }
    else if (action_to_be_done[0] == 's')
    {
      Shift(action_to_be_done, Automaton_States, Stack_Grammar_Symbols, Calculator_Computation_Array);
    }
    else if (action_to_be_done[0] == 'r')
    {
      Reduce(action_to_be_done, Automaton_States, Stack_Grammar_Symbols, Calculator_Computation_Array);
    }
    else if (action_to_be_done == "acc")
    {
      std::cout << "Congrats! Parsing completed successfully!" << std::endl;
      break;
    }

    }
  
}


int main()
{  
   InitializeDeskCalculator();
   std::cout << "      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
   
   std::cout << "                                    Desk Calculator\n ";
   std::cout << "         Enter the input when asked and press enter to get the result. It supports + , * , ^ , ( , ), unminus. \n";
   std::cout << "      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";

   std::cout << "             Printing the parsing steps in detail       " << std::endl << std::endl;
   Parsing_and_Translation();
    return 0; 
}
