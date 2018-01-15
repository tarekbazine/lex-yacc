%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

FILE *yyin;

%}

%error-verbose

%union {
	float  val;
} 

%token  <val> NOMBRE

%left '+'  '-'
%left '*'  '/'
%right moins_unaire
%right '^'

%type <val> E
%%

Input:
    /* Vide */
  | Input Ligne
  ;

Ligne:
    '\n'
  | E '\n'    { printf("Resultat : %f\n",$1); }
  ;

E: NOMBRE      { $$ = $1; }
| E '+' E { $$ = $1 + $3; }
| E '-' E { $$ = $1 - $3; }
| E '*' E { $$ = $1 * $3; }
| E '/' E { $$ = $1 / $3; }
| E '^' E { $$ = pow($1,$3); }
| '-' E %prec moins_unaire { $$ = - $2; }
| '(' E ')' { $$ = $2; }
;

%%

int yyerror(char *s) {
printf("%s\n",s);
}

int main(void) {

	//yyin=fopen("./in","r");

	yyparse();

	//fclose(yyin);

}


