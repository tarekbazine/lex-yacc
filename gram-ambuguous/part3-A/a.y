%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


int Index=0;
int temp_var=0;

void generer_Quadruplet(char [],char [],char [],char []);
void afficher_Quadruplet();
void afficher_simplifie();
void traiter(char op[5],char *,char *,char *);

struct Quadruple{
char code_op[5];
char src1[10];
char src2[10];
char dest[10];
}QUAD[25];

%}

%union {
	float  val;
    char string[10];
} 

%token  <string> NOMBRE
%token <string> ID

%left '+'  '-'
%left '*'  '/'
%right moins_unaire

%type <string> E
%%



Ligne: E '\n'    {return;}
  ;

E:	ID	{	char temp[10];
            snprintf(temp,10,"%s",$1);
            strcpy($$,temp); 
        }
  | NOMBRE      { char temp[10];
                snprintf(temp,10,"%s",$1);    
                strcpy($$,temp); 
        }
  | E '+' E  { traiter("+",$1,$3,$$);}
  | E '-' E { traiter("-",$1,$3,$$);}
  | E '*' E  { traiter("*",$1,$3,$$);}
  | E '/' E  { traiter("/",$1,$3,$$); }
  | '-' E %prec moins_unaire  { 
  				char str[7];
				sprintf(str, "tmp%d", temp_var);    
				temp_var++;
				generer_Quadruplet("NEG","",$2,str);  
				strcpy($$,str); 
				 }
  //| E PUISSANCE E { $$=pow($1,$3); }
  | '(' E ')'  { strcpy($$,$2);}
  ;

%%

int yyerror(char *s) {
printf("%s\n",s);
}

int main(void) {

	yyparse();

	printf("\n\n");
	afficher_Quadruplet();
	printf("\n\n");
	afficher_simplifie();
	printf("\n\n");
}

void traiter(char op[5],char *src1,char *src2,char *dest){
	sprintf(dest, "tmp%d", temp_var);    
	temp_var++;
	generer_Quadruplet(op,src1,src2,dest);  
}

void afficher_Quadruplet()
{
	int i;
	printf("\n\n****** CODE INTERMEDAIRE ****** \n");
	printf("\n\t Table Des Quadruplets  \n");
	printf("\n     Code-op      source1	  source2     destination  ");
	for(i=0;i<Index;i++)
	printf("\n %d     %s          %s          %s          %s",i,QUAD[i].code_op,QUAD[i].src1,QUAD[i].src2,QUAD[i].dest);
}


void afficher_simplifie()
{
	int i;
	printf("\n\n****** CODE INTERMEDAIRE Simplifie****** \n");
	for(i=0;i<Index;i++)
	printf("\n %d     %s   :=       %s          %s          %s",i,QUAD[i].dest ,QUAD[i].src1,QUAD[i].code_op ,QUAD[i].src2);
}

 
void generer_Quadruplet(char op[5],char op1[10],char op2[10],char res[10]){
                                        strcpy(QUAD[Index].code_op,op);
                                        strcpy(QUAD[Index].src1,op1);
                                        strcpy(QUAD[Index].src2,op2);
                                        strcpy(QUAD[Index].dest,res);
                    Index++;
}

