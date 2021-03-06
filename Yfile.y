%{
        #include <stdio.h>
        #include <string.h>
        #include <stdlib.h>
        extern int yylex();
        void yyerror(char *msg);
        extern FILE *yyin;
        char *p=NULL;

        char *r=NULL;

        char *temp; //for "for"

        char *id1=NULL;
        char *id2=NULL;
        int num1;
        int num2;
        int flag=-1;
        int count=0;
        char *op=NULL;

        char *fun;
%}

%token BEGN READ WRITE INT FLOAT CHAR INTS FLOATS CHARS ARRAY IF ENDIF ELSE ENDELSE ELSEIF ENDELSEIF ARROW FOR ENDFOR WHILE ENDWHILE EQ TO OPENBRACKET CLOSEBRACKET COMMA FUNCTION RETURNS RETURN END
%union
{
        char *f;
        char *str;
        int num;
        char *op;
        char *rside;
        char *arr;
        char *arrrside;
        char *function_name;
}
%token <f> ID
%type <f> identify
%type <f> rhs

%token <num> NUMBER
%token <op> RELOP
%type <f> identifier
%type <num> number
%type <op> operator

%token <rside> RSIDE
%type <rside> rightside

%token <arr> ARR
%type <arr> arrpt
%token <arrrside> ARRRSIDE
%type <arrrside> arr_rightside

%token <function_name> FUNCTIONNAME
%type <function_name> functionname
%type <f> id

%%
stmt: begin stmt
        | begin
        | read_stmt stmt
        | read_stmt
        | write_stmt stmt
        | write_stmt
        | if_stmt stmt
        | if_stmt
        | endif_stmt stmt
        | endif_stmt
        | elseif_stmt stmt
        | elseif_stmt
        | endelseif_stmt stmt
        | endelseif_stmt
        | else_stmt stmt
        | else_stmt
        | endelse_stmt stmt
        | endelse_stmt
        | regular_stmt stmt
        | regular_stmt
        | for_stmt stmt
        | for_stmt
        | while_stmt stmt
        | while_stmt
        | endwhile_stmt stmt
        | endwhile_stmt
        | endfor_stmt stmt
        | endfor_stmt
        | function_call_stmt stmt
        | function_call_stmt
        | return_stmt stmt
        | return_stmt
        | end functions_stmt
        | end;

functions_stmt : function_stmt stmt;

begin : BEGN
{
        printf("#include<stdio.h>\n#include<stdlib.h>\n\nvoid main()\n{\n\t");
};

return_stmt : return id {printf(";\n");};
            | return number {printf("%d;\n",num1); count = 0; flag = -1;};

return : RETURN {printf("\treturn ");};

end : END
{
        printf("}\n");
};

read_stmt : READ INT identify {printf("\t int %s;\n",p); printf("\t scanf(%s %c%s);\n","%d," ,'&',p);}
          | READ FLOAT identify {printf("\t float %s;\n",p); printf("\t scanf(%s %c%s);\n","%f,",'&',p);}
          | READ CHAR identify {printf("\t char %s;\n",p); printf("\t scanf(%s %c%s);\n","%c,",'&',p);};
          | READ ARRAY identify number
{
        char *temp1 = (char *)malloc(sizeof(sizeof(char)*strlen(p)));
        int i;
        for(i=0;i<strlen(p);i++)
        {
                if(p[i]==' ')
                        break;
                temp1[i]=p[i];
        }
        temp1[i]='\0';
        printf("\t int %s[%d];\n",temp1,num1);
        printf("\tfor(int i=0;i<%d;i++)\n\t{\n",num1);
        printf("\t\tscanf(%s ,%c%s[i]);","%d",'&',temp1);
        printf("\n\t}");
};

identify : ID
{
        p = $1;
};

write_stmt : WRITE rhs {printf("\t printf(%s);",p);};

rhs : ID
{
	p=$1;
};

regular_stmt : ident arrow rightside {count = 0;}
                | ident arrow ident {count = 0;}
                | ident arrow number {printf("%d;\n",num1); count = 0;}
                | ident arrow arrpt {printf(";\n"); count = 0;}
                | ident arrow arr_rightside
                | ident arrow function_call_stmt
                | arrpt arrow rightside
                | arrpt arrow arr_rightside
                | arrpt arrow ident
                | arrpt arrow number {printf("%d;\n",num1); count = 0;}
                | arrpt arrow arrpt {printf(";\n");}
                | arrpt arrow function_call_stmt;

arrpt : ARR {printf("\t %s ",$1);};

arr_rightside : ARRRSIDE {printf("\t %s; \n",$1);};

ident : identifier
{
        if(count == 1)
        {
                printf("\t %s ",id1);
        }
        else
        {
                printf("%s;\n",id2);
        }
};

arrow : ARROW {printf("= ");};

rightside : RSIDE
{
        printf("%s;\n",$1);
};
function_stmt : FUNCTION RETURNS datatype function_call {printf("{\n");};

datatype : INT {printf("int");}
         | FLOAT {printf("float");}
         | CHAR {printf("char");}
         | INTS {printf("int*");}
         | FLOATS {printf("float*");}
         | CHARS {printf("char*");};

function_call : functionname OPENBRACKET parameterlist CLOSEBRACKET {printf(")\n");};

function_call_stmt : functionname OPENBRACKET parameterlist CLOSEBRACKET {printf(");\n");};

functionname : FUNCTIONNAME {printf("\t%s(",$1);};

parameterlist : id
                | parameterlist comma id;

comma : COMMA {printf(", ");};

id : ID {printf("%s",$1);}

while_stmt : WHILE cond
{
        if(flag==0)
                printf("\twhile(%d %s)\n\t{\n",num1,op);
        else if(flag==1)
                printf("\twhile(%s)\n\t{\n",id1);
        flag=-1;
        count=0;

};

endwhile_stmt : ENDWHILE  {printf("\n\t}");};
if_stmt : IF cond
{
        if(flag==0)
                printf("\tif(%d %s)\n\t{\n",num1,op);
        else if(flag==1)
                printf("\tif(%s)\n\t{\n",id1);
        flag=-1;
        count=0;
};

endif_stmt : ENDIF {printf("\t}\n");};

elseif_stmt : ELSEIF cond
{
        if(flag==0)
                printf("\telse if(%d %s)\n\t{\n",num1,op);
        else if(flag==1)
                printf("\telse if(%s)\n\t{\n",id1);
        flag=-1;
        count=0;
};

endelseif_stmt : ENDELSEIF {printf("\t}\n");};

else_stmt : ELSE
{
        printf("\telse{\n");
};

endelse_stmt : ENDELSE {printf("\t}\n");};

for_stmt : for identi eq number TO number
{
        temp=(char *)malloc(sizeof(sizeof(char)*strlen(id1)));
        int i;
        for(i=0;i<strlen(id1);i++)
        {
                if(id1[i]==' ')
                        break;
                temp[i]=id1[i];
        }
        temp[i]='\0';
        if(num1<num2)
        {
                printf("%d;%s<=%d;%s++){\n",num1,temp,num2,temp);
        }
        else
        {
                printf("%d;%s>=%d;%s--){\n",num1,temp,num2,temp);
        }
        count=0;
};

for : FOR {printf("\tfor(");};

eq : EQ {printf("=");};

identi : identifier {printf("%s",id1); count = 0;};

endfor_stmt : ENDFOR {printf("\t}\n");};

cond: x operator x;

x: identifier
   | number;

identifier: ID
{
        count=count+1;
        if(count==1)
        {
                flag=1;
                id1=$1;
        }
        else
        {
                id2=$1;
        }
};
number: NUMBER
{
        count=count+1;
        if(count==1)
        {
                flag=0;
                num1=$1;
        }
        else
        {
                num2=$1;
        }
};

operator: RELOP
{
        op=$1;
};

%%

int yywrap()
{
        return 1;
}

void yyerror(char *msg)
{
        fprintf(stderr, "%s\n", msg);
        exit(1);
}

int main(int argc, char **argv)
{
        if(argc!=2)
        {
                printf("No file\n");
                exit(0);
        }
        if(!(yyin=fopen(argv[1],"r")))
        {
                printf("Can't open the file\n");
                exit(1);
        }
        do
        {
                yyparse();
        }while(!feof(yyin));
        fclose(yyin);
        return 0;
}
