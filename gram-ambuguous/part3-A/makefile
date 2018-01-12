App = analyseur

$(App): a.tab.c a.tab.h lex.yy.c 
	gcc -o $(App) a.tab.c lex.yy.c -lm -ll;

a.tab.c: a.y
	bison -d a.y

lex.yy.c: a.l
	flex a.l

clean: 
	rm $(App) a.tab.c lex.yy.c a.tab.h

run:
	./$(App)

push: 
	git add .
	git commit -m "${msg}"
	git push -u origin master
