%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int Index=0;
int temp_var=0;

void generer_Quadruplet(char [],char [],char [],char []);
void afficher_Quadruplet();
void afficher_simplifie();
void push(char*);
char* pop();
void traiter(char op[5]);

struct Quadruple{
char code_op[5];
char src1[10];
char src2[10];
char dest[10];
}QUAD[25];

struct Stack{
char *items[10];
int top;
}Stk;

%}

%union {
	struct valTab{
		float vals[100];
		int size;
	} valTab;  
	float  val;
        char string[10];
} 

%token  <val> NOMBRE
%token <string> ID

%left '+'  '-'
%left '*'  '/'
%right moins_unaire

%type <val> E
%%



Ligne: E '\n'    {return;}
  ;

E:	ID	{char temp[10];
                snprintf(temp,10,"%s",$1);    
        	push(temp);}
  | NOMBRE      { char temp[10];
                snprintf(temp,10,"%f",$1);    
        	push(temp);}
  | E '+' E  { traiter("+");}
  | E '-' E { traiter("-");}
  | E '*' E  { traiter("*");}
  | E '/' E  { traiter("/"); }
  | '-' E %prec moins_unaire  { char str[7],str1[7]="tmp";
				sprintf(str, "%d", temp_var);    
				strcat(str1,str);
				temp_var++;
				generer_Quadruplet("NEG","",pop(),str1);  
				push(str1);
				 }
  //| E PUISSANCE E { $$=pow($1,$3); }
  | '(' E ')'  {}
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

void traiter(char op[5]){
	char str[7],str1[7]="tmp";
	sprintf(str, "%d", temp_var);    
	strcat(str1,str);
	temp_var++;
	generer_Quadruplet(op,pop(),pop(),str1);  
	push(str1);
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


void push(char *str)
{
	Stk.top++;
	Stk.items[Stk.top]=(char *)malloc(strlen(str)+1);
	strcpy(Stk.items[Stk.top],str);
}
char * pop()
{
	int i;
	if(Stk.top==-1)
	{
	printf("\nStack Empty!! \n");
	exit(0);
	}
	char *str=(char *)malloc(strlen(Stk.items[Stk.top])+1);;
	strcpy(str,Stk.items[Stk.top]);
	Stk.top--;
	return(str);
}
 
void generer_Quadruplet(char op[5],char op1[10],char op2[10],char res[10]){
                                        strcpy(QUAD[Index].code_op,op);
                                        strcpy(QUAD[Index].src1,op1);
                                        strcpy(QUAD[Index].src2,op2);
                                        strcpy(QUAD[Index].dest,res);
                    Index++;
}

