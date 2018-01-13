%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int Index=0;
int temp_var=0;

struct Quadruple{
char code_op[5];
char src1[10];
char src2[10];
char dest[10];
}QUAD[25];

struct Stack{
char *items[10]; //max 10 elem in stack
int top;
}Stk;


void generer_Quadruplet(char [],char [],char [],char []);
void afficher_Quadruplet();
void afficher_simplifie();
void push(char*);
char* pop();
void push_pile(char*,struct Stack *);
char* pop_pile(struct Stack *);
void traiter(char op[5]);

%}

%union {
	struct valTab{
		float vals[100];
		int size;
	} valTab;  
	float  val;
        char string[10];
	int size;
} 

%token  <val> NOMBRE
%token <string> ID
%token MOY VARIANCE MIN MAX SOMME SI PRODUIT

%left '+'  '-'
%left '*'  '/'
%right moins_unaire

%type <val> E
%type <size> L
%%



Ligne: E '\n'    {printf("\n\n");
	afficher_Quadruplet();
	printf("\n\n");
	afficher_simplifie();
	printf("\n\n"); return 0;}
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
  | '-' E %prec moins_unaire  { char str1[7];
				sprintf(str1, "tmp%d", temp_var);    
				//strcat(str1,str);
				temp_var++;
				generer_Quadruplet("NEG","",pop(),str1);  
				push(str1);
				
				 }
  //| E PUISSANCE E { $$=pow($1,$3); }
  | '(' E ')'  {}
  |	F
  ;

F : SOMME '(' L ')' { 
			//printf("\n %d lll %d",Stk.top,$3);
	if($3 > 0){

			/*printf("\n\nsom");
			for(int i=0;i<Stk.top+1;i++){
			printf("\n %s",Stk.items[i]);
			}
			printf("\n\n");
*/
			traiter("+");//when we have just numbers exmpl : som(2,2) so we get tmpX

			for(int k=0;k<$3-1;k++){

			char *src1=pop();
			generer_Quadruplet("+",src1,pop(),src1);  
			push(src1);

			}


	}//else (tmp ou nombre) ya93ad f stack
			}
|MOY '(' L ')' {

	if($3 > 0){

			/*printf("\n\nmoy");
			for(int i=0;i<Stk.top+1;i++){
			printf("\n %s",Stk.items[i]);
			}*/

			traiter("+");//when we have just numbers exmpl : som(2,2) so we get tmpX

			for(int k=0;k<$3-1;k++){

				char *src1=pop();
				generer_Quadruplet("+",src1,pop(),src1);  
				push(src1);

			}

			char str[7];
			sprintf(str, "%d", $3+1); 
			char *src1=pop();
			generer_Quadruplet("/",src1,str,src1);  
			push(src1);

	}//else (tmp ou nombre) ya93ad f stack

}
|PRODUIT '(' L ')' { 
			//printf("\n %d lll %d",Stk.top,$3);
	if($3 > 0){

			/*printf("\n\nsom");
			for(int i=0;i<Stk.top+1;i++){
			printf("\n %s",Stk.items[i]);
			}
			printf("\n\n");
*/
			traiter("*");//when we have just numbers exmpl : som(2,2) so we get tmpX

			for(int k=0;k<$3-1;k++){

			char *src1=pop();
			generer_Quadruplet("*",src1,pop(),src1);  
			push(src1);

			}


	}//else (tmp ou nombre) ya93ad f stack
			}
|VARIANCE '(' L ')' { 
 

if($3 > 0){//si il y plus d un element dans la list L


//************************calc moy************************
			/*printf("\n\nmoy");
			for(int i=0;i<Stk.top+1;i++){
			printf("\n %s",Stk.items[i]);
			}*/

			struct Stack stack; 
			stack.top = -1; 

			char str1[7];
			sprintf(str1, "tmp%d", temp_var);    
			//strcat(str1,str);
			temp_var++;
			char *src1=pop();push_pile(src1,&stack);//garder dans la pile local
			char *src2=pop();push_pile(src2,&stack);
			generer_Quadruplet("+",src1,src2,str1);  
			push(str1);


			//traiter("+");//when we have just numbers exmpl : som(2,2) so we get tmpX

			for(int k=0;k<$3-1;k++){

				src1=pop();
				src2=pop();push_pile(src2,&stack);
				generer_Quadruplet("+",src1,src2,src1);  
				push(src1);

			}

			sprintf(str1, "%d", $3+1); 
			char *moyTmp=pop();
			generer_Quadruplet("/",moyTmp,str1,moyTmp);  
			//push(src1);


			//print local stack 
			printf("\n\nlocal stack ");
			for(int i=0;i<stack.top+1;i++){
				printf("\n %s",stack.items[i]);
			}


//************************somme diff carre************************

			sprintf(src2, "tmp%d", temp_var);    
			temp_var++;

			for(int i=0;i<$3+1;i++){
				src1 = pop_pile(&stack);
				//printf("\n\n%s ----  %s %d\n",src1,stack.items[i],stack.top);
				generer_Quadruplet("-",moyTmp,src1,src1);  //diff avec moy
				generer_Quadruplet("*",src1,src1,src1);  //carre
				generer_Quadruplet("+",src1,src2,src2);  //somme des diff carre
			}

			generer_Quadruplet("/",src2,str1,src2);  //division (de somme des diff carre) sur n

			push(src2);//le resultat est mise dans la pile pour que l imbrication avec d autre function marche


			//printf("\n\nmoy");
			for(int i=0;i<Stk.top+1;i++){
				printf("\n %s",Stk.items[i]);
			}

	}//else (tmp ou nombre) ya93ad f stack




}
;

L : L ',' E {

/*char str[7],str1[7]="tmp";
	sprintf(str, "%d", temp_var-1);    
	strcat(str1,str);

	//generer_Quadruplet(op,pop(),pop(),str1);  
	push(str1);*/

	/*printf("bfffLIST : %f  size: %d\n",$3,$$.size);
	$$.vals[$$.size] = $3; 
	$$.size++;*/
//	printf("AdddLIST : %f size: %d vallist %f\n\n",$3,$$.size,$$.vals[0]); 
$$++;
 }
| E { 
$$ = 0;
	/*char str[7],str1[7]="tmp";
	sprintf(str, "%d", temp_var-1);    
	strcat(str1,str);

	//generer_Quadruplet(op,pop(),pop(),str1);  
	push(str1);*/
/*	printf("Bfff : %f  size: %d\n",$1,$$.size);
	$$.vals[$$.size] = $1; 
	$$.size++;*/
//	printf("Addd : %f size: %d\n\n",$1,$$.size);
 }
;

%%

int yyerror(char *s) {
printf("%s\n",s);
}

int main(void) {
	Stk.top = -1;

	yyparse();

	/*printf("\n\n");
	afficher_Quadruplet();
	printf("\n\n");
	afficher_simplifie();
	printf("\n\n");*/
}

void traiter(char op[5]){
	char str[7];
	sprintf(str, "tmp%d", temp_var);    
	//strcat(str1,str);
	temp_var++;
	generer_Quadruplet(op,pop(),pop(),str);  
	push(str);
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
	if(Stk.top==-1)
	{
	printf("\nStack Empty!! \n");
	exit(0);
	}
	char *str=(char *)malloc(strlen(Stk.items[Stk.top])+1);
	strcpy(str,Stk.items[Stk.top]);
	Stk.top--;
	return(str);
}
 
void push_pile(char *str,struct Stack *stack)
{
//printf("\nStack Empty!! %d\n",(*stack).top++);
	(*stack).top++;
	(*stack).items[(*stack).top]=(char *)malloc(strlen(str)+1);
	strcpy((*stack).items[(*stack).top],str);
}
char * pop_pile(struct Stack *stack)
{
	if((*stack).top==-1)
	{
	printf("\nStack Empty!! \n");
	exit(0);
	}
	char *str=(char *)malloc(strlen((*stack).items[(*stack).top])+1);
	strcpy(str,(*stack).items[(*stack).top]);
	(*stack).top--;
	return(str);
}
void generer_Quadruplet(char op[5],char op1[10],char op2[10],char res[10]){
                                        strcpy(QUAD[Index].code_op,op);
                                        strcpy(QUAD[Index].src1,op1);
                                        strcpy(QUAD[Index].src2,op2);
                                        strcpy(QUAD[Index].dest,res);
                    Index++;
}

