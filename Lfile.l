%{
        #include <stdio.h>
        #include <stdlib.h>
        #include "y.tab.h"
%}

%%
"begin"|"BEGIN" {return BEGN;}

"int*"|"INT*" {return INTS;}
"float*"|"FLOAT*" {return FLOATS;}
"char*"|"CHAR*" {return CHARS;}

"read"|"READ" {return READ;}
"write"|"WRITE" {return WRITE;}
"int"|"INT" {return INT;}
"float"|"FLOAT" {return FLOAT;}
"char"|"CHAR" {return CHAR;}

"array"|"ARRAY"  {return ARRAY;}

"if"|"IF" {return IF;}
"endif"|"ENDIF" {return ENDIF;}
"else if"|"ELSE IF" {return ELSEIF;}
"endelseif"|"ENDELSEIF" {return ENDELSEIF;}
"else"|"ELSE" {return ELSE;}
"endelse"|"ENDELSE" {return ENDELSE;}

"for"|"FOR" {return FOR;}
"=" {return EQ;}
"to"|"TO" {return TO;}
"endfor"|"ENDFOR" {return ENDFOR;}

"while"|"WHILE" {return WHILE;}
"endwhile"|"ENDWHILE" {return ENDWHILE;}

"end"|"END" {return END;}

"<-" {return ARROW;}

"(" {return OPENBRACKET;}
")" {return CLOSEBRACKET;}
"," {return COMMA;}

"function"|"FUNCTION" {return FUNCTION;}
"returns"|"RETURNS" {return RETURNS;}
"return"|"RETURN" {return RETURN;}

"<"|">"|"=="|"<="|">="|"!=" {yylval.op = yytext; return RELOP;}
[0-9]+ {yylval.num = atoi(yytext); return NUMBER;}
[a-zA-Z][a-zA-Z0-9]*/[(] {yylval.function_name = yytext; return FUNCTIONNAME;}
[*]*[a-zA-Z][a-zA-Z0-9]* {yylval.f = yytext; return ID;}
[a-zA-Z][a-zA-Z0-9+*/-]* {yylval.rside = yytext; return RSIDE;}
[a-zA-Z][a-zA-Z0-9]*([\[][a-zA-Z][a-zA-Z0-9]*[\]])*([+*/-][a-zA-Z0-9]*([\[][a-zA-Z][a-zA-Z0-9]*[\]])*)+ {yylval.arrrside = yytext; return ARRRSIDE;}
[a-zA-Z][a-zA-Z0-9]*([\[][a-zA-Z][a-zA-Z0-9]*[\]])* {yylval.arr = yytext; return ARR;}
[ \t] ;
. ;
%%
