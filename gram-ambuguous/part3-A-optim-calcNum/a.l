%{

#include "a.tab.h"
#include<string.h>
#include <stdlib.h>

extern YYSTYPE yylval;
%}

blancs    [ \t]+

chiffre   [0-9]
entier    {chiffre}+

reel	  {entier}\.{entier}

%%

{blancs}  { /* On ignore */ }

{entier}    {
      yylval.val =atoi(yytext);
      return(NOMBRE);
    }

{reel}    {
      yylval.val =atof(yytext);
      return(NOMBRE);
    }

[a-zA-Z_][a-zA-Z0-9_]*    {
	strcpy(yylval.string,yytext);
	return ID; 
	}

[\+\-\*\/\)\(\n]   return(yytext[0]);
