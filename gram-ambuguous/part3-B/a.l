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
      //yylval.val =atoi(yytext);
      	strcpy(yylval.string,yytext);

      return(NOMBRE);
    }

{reel}    {
      //yylval.val =atof(yytext);
       	strcpy(yylval.string,yytext);

      return(NOMBRE);
    }

"moy"  return(MOY);

"var"  return(VARIANCE);

"ecrt"  return(ECARTTYPE);

"min"  return(MIN);

"max"  return(MAX);

"som"  return(SOMME);

"si" return(SI);

"prod" return(PRODUIT);

[a-zA-Z_][a-zA-Z0-9_]*    {
	strcpy(yylval.string,yytext);
	return ID; 
	}

[\+\-\*\/\)\(\n,;=><]   return(yytext[0]);
