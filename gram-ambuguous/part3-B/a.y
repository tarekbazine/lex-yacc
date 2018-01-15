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

/*struct Stack{
char *items[10]; //max 10 elem in stack
int top;
}Stk;*/


void generer_Quadruplet(char [],char [],char [],char []);
void afficher_Quadruplet();
void afficher_simplifie();
//void push_pile(char*,struct Stack *);
//char* pop_pile(struct Stack *);
void traiter(char op[5],char *,char *,char *);

%}

%union {
	struct valTab{
		char vals[20][10];
		int size;
	} valTab;  
    char string[10];
} 

%token <string> ID NOMBRE
%token MOY VARIANCE MIN MAX SOMME SI PRODUIT ECARTTYPE

%left '+'  '-'
%left '*'  '/'
%right moins_unaire

%type <valTab> L
%type <string> E F

%%



Ligne: E '\n'    {	printf("\n\n");
					afficher_Quadruplet();
					printf("\n\n");
					afficher_simplifie();
					printf("\n\n"); return 0;	}
  ;


E:	ID	{	char temp[10];
            snprintf(temp,10,"%s",$1);
            strcpy($$,temp); 
        }
  | NOMBRE { char temp[10];
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
  |	F
  ;

F : SOMME '(' L ')' { 
		if($3.size > 0){

				char somme[10];
				traiter("+",$3.vals[0],$3.vals[1],somme);//when we have just numbers exmpl : som(2,2) so we get tmpX

				for(int k=2;k<$3.size+1;k++){
					generer_Quadruplet("+",$3.vals[k],somme,somme);  
				}

				strcpy($$,somme);
		}else{
			strcpy($$,$3.vals[0]);
		}
	}
|MOY '(' L ')' {
	  if($3.size > 0){

	      char moy[10];
	      traiter("+",$3.vals[0],$3.vals[1],moy);//when we have just numbers exmpl : som(2,2) so we get tmpX
	  
			for(int k=2;k<$3.size+1;k++){
				generer_Quadruplet("+",$3.vals[k],moy,moy);  
			}

	      char str[7];
	      sprintf(str, "%d", $3.size+1); 
	      generer_Quadruplet("/",moy,str,moy);  
	      strcpy($$,moy);

	  }else{
			strcpy($$,$3.vals[0]);
		}

	}
|PRODUIT '(' L ')' { 
	  if($3.size > 0){

	      char prd[10];
	      traiter("*",$3.vals[0],$3.vals[1],prd);//when we have just numbers exmpl : som(2,2) so we get tmpX

		for(int k=2;k<$3.size+1;k++){
			generer_Quadruplet("*",$3.vals[k],prd,prd);  
		}

		strcpy($$,prd);

	  }else{
		strcpy($$,$3.vals[0]);
	}
  }	

|VARIANCE '(' L ')' { 
 

if($3.size > 0){//si il y plus d un element dans la list L


//************************calc moy************************
      char moy[10];
      traiter("+",$3.vals[0],$3.vals[1],moy);//when we have just numbers exmpl : som(2,2) so we get tmpX
  
		for(int k=2;k<$3.size+1;k++){
			generer_Quadruplet("+",$3.vals[k],moy,moy);  
		}

      char str[7];
      sprintf(str, "%d", $3.size+1); 
      generer_Quadruplet("/",moy,str,moy);  


//************************somme diff carre************************//

      char src2[10],src1[10],r[10];
      sprintf(r, "tmp%d", temp_var);    
      temp_var++;
      sprintf(src1, "tmp%d", temp_var);    
      temp_var++;
      sprintf(src2, "tmp%d", temp_var);    
      temp_var++;

      generer_Quadruplet("-",moy,$3.vals[0],src1);  //diff avec moy
      generer_Quadruplet("*",src1,src1,src1);  //carre
      generer_Quadruplet("-",moy,$3.vals[1],r);  //diff avec moy
      generer_Quadruplet("*",r,r,r);  //carre
      generer_Quadruplet("+",src1,r,src2);  //somme des diff carre


      for(int i=2;i<$3.size+1;i++){
        generer_Quadruplet("-",moy,$3.vals[i],$3.vals[i]);  //diff avec moy
        generer_Quadruplet("*",$3.vals[i],$3.vals[i],$3.vals[i]);  //carre
        generer_Quadruplet("+",$3.vals[i],src2,src2);  //somme des diff carre
      }

      generer_Quadruplet("/",src2,str,src2);  //division (de somme des diff carre) sur n

      strcpy($$,src2);//le resultat est mise dans la pile pour que l imbrication avec d autre function marche


  	}else{
		strcpy($$,"0");//var(x) = 0
	}
}

|ECARTTYPE '(' L ')' { 
 

	if($3.size > 0){//si il y plus d un element dans la list L

//************************calc moy************************
      char moy[10];
      traiter("+",$3.vals[0],$3.vals[1],moy);//when we have just numbers exmpl : som(2,2) so we get tmpX
  
		for(int k=2;k<$3.size+1;k++){
			generer_Quadruplet("+",$3.vals[k],moy,moy);  
		}

      char str[7];
      sprintf(str, "%d", $3.size+1); 
      generer_Quadruplet("/",moy,str,moy);  


//************************somme diff carre************************//

      char src2[7],src1[7],r[7];
      sprintf(r, "tmp%d", temp_var);    
      temp_var++;
      sprintf(src1, "tmp%d", temp_var);    
      temp_var++;
      sprintf(src2, "tmp%d", temp_var);    
      temp_var++;

      generer_Quadruplet("-",moy,$3.vals[0],src1);  //diff avec moy
      generer_Quadruplet("*",src1,src1,src1);  //carre
      generer_Quadruplet("-",moy,$3.vals[1],r);  //diff avec moy
      generer_Quadruplet("*",r,r,r);  //carre
      generer_Quadruplet("+",src1,r,src2);  //somme des diff carre


      for(int i=2;i<$3.size+1;i++){
        generer_Quadruplet("-",moy,$3.vals[i],$3.vals[i]);  //diff avec moy
        generer_Quadruplet("*",$3.vals[i],$3.vals[i],$3.vals[i]);  //carre
        generer_Quadruplet("+",$3.vals[i],src2,src2);  //somme des diff carre
      }

      generer_Quadruplet("/",src2,str,src2);  //division (de somme des diff carre) sur n

      /**** scr2 contient la variance , utilisant l algo d babylonian pour recuperér la racin carre**/
      /*********
      const double epsilon = 0.0001;
      double guess = (double)n / 2.0;
      double r = 0.0;
      while( fabs(guess * guess - (double)n) > epsilon )
      {
          r = (double)n / guess;
          guess = (guess + r) / 2.0;
      }
      ***********/

      char guess[7],str1[7];
      sprintf(guess, "tmp%d", temp_var);    
      temp_var++;
      sprintf(r, "tmp%d", temp_var);    
      temp_var++;

      generer_Quadruplet("/",src2,"2",guess);//guess = var / 2;

      int jumpToBeforeCondAdd = Index;

      /*** start QUADs cond fabs(guess * guess - (double)n) > epsilon ***/
      sprintf(src1, "tmp%d", temp_var);    
      temp_var++;
      generer_Quadruplet("*",guess,guess,src1);
      generer_Quadruplet("-",src1,src2,src1);
      generer_Quadruplet("ABS",src1,"",src1);
      generer_Quadruplet("CMP",src1,"0.0001",""); //epsilon = 0.0001 c est erreur 
      int jlAddToBeModified = Index;
      generer_Quadruplet("JL","","","");  //jump less out of (after) the insts block ----->
      /*** end cond ***/

      /*** start QUADs loop inst ***/
      generer_Quadruplet("/",src2,guess,r);//r = (double)n / guess;
      generer_Quadruplet("+",guess,r,r); //r = (guess + r)
      generer_Quadruplet("/",r,"2",guess);//guess = r / 2.0;
      sprintf(str1, "@%d", jumpToBeforeCondAdd);          
      generer_Quadruplet("JMP",str1,"","");
      /*** end QUADs loop inst ***/

      //MAJ ADD OF THE JL INST
      sprintf(str1, "@%d", Index);    
      strcpy(QUAD[jlAddToBeModified].src1,str1);

      strcpy($$,guess);//le resultat (ecart-type) est mise dans la pile pour que l imbrication avec d autre function marche


  	}else{
		strcpy($$,"0");//var(x) = 0
	}

}
|MAX '(' L ')' { 

		if($3.size > 0){//si il y plus d un element dans la list L
	  
			char max[10],str[10];
			sprintf(max, "tmp%d", temp_var);    
      		temp_var++;

	  		//les deux premiers elements
		    /*generer_Quadruplet("CMP",$3.vals[0],$3.vals[1],"");
            sprintf(str, "@%d", Index+3);          
		    generer_Quadruplet("JG",str,"","");
		    generer_Quadruplet("MOV",$3.vals[1],"",max);
	        sprintf(str, "@%d", Index+2);          
		    generer_Quadruplet("JMP",str,"","");*/

   		    generer_Quadruplet("MOV",$3.vals[0],"",max); 

   		    for(int k=1;k<$3.size+1;k++){
   		    	generer_Quadruplet("CMP",max,$3.vals[k],"");
	            sprintf(str, "@%d", Index+2);          
			    generer_Quadruplet("JG",str,"","");
			    generer_Quadruplet("MOV",$3.vals[k],"",max);
			}

			strcpy($$,max);

		 }else{
			strcpy($$,$3.vals[0]);
		}
	
	}

|MIN '(' L ')' { 

		if($3.size > 0){//si il y plus d un element dans la list L
	  
			char min[10],str[10];
			sprintf(min, "tmp%d", temp_var);    
      		temp_var++;

   		    generer_Quadruplet("MOV",$3.vals[0],"",min); 

   		    for(int k=1;k<$3.size+1;k++){
   		    	generer_Quadruplet("CMP",min,$3.vals[k],"");
	            sprintf(str, "@%d", Index+2);          
			    generer_Quadruplet("JL",str,"","");
			    generer_Quadruplet("MOV",$3.vals[k],"",min);
			}

			strcpy($$,min);

		 }else{
			strcpy($$,$3.vals[0]);
		}
	
	}	
  
;


L : L ',' E {
	$$.size++;
	strcpy($$.vals[$$.size],$3);
 }
| E { 
	$$.size = 0;
	strcpy($$.vals[0],$1);
 }
;

%%

int yyerror(char *s) {
printf("%s\n",s);
}

int main(void) {

	yyparse();

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

/*
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
}*/
void generer_Quadruplet(char op[5],char op1[10],char op2[10],char res[10]){
                                        strcpy(QUAD[Index].code_op,op);
                                        strcpy(QUAD[Index].src1,op1);
                                        strcpy(QUAD[Index].src2,op2);
                                        strcpy(QUAD[Index].dest,res);
                    Index++;
}

