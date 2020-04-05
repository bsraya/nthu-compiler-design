%{
    void print(int token);
    void print_error();

    char cur_line_content[256];

    typedef enum TYPES {
	    INT = 1, DOUBLE, BOOL, CHAR = 4
    } TYPES;

    typedef enum KEYWORDS {
        VOID = 5, CONST, KEY_NULL, FOR, DO, 
        WHILE, BREAK, CONTINUE, IF, ELSE, 
        RETURN, STRUCT, SWITCH, CASE, DEFAULT = 19
    } KEYWORDS;

    typedef enum OPERATORS {
        PLUS = 20, MINUS, MULTIPLE, DIVIDE, MOD, 
        TWO_MINUS, TWO_PLUS, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, SAME, NOT_EQUAL, EQUAL, AND, 
        OR, NOT, BI_AND, BI_OR, BI_XOR, BI_COMPLEMENT, 
        LEFT_SHIFT, RIGHT_SHIFT = 42
    } OPERATORS;

    typedef enum PUNCTUANTIONS {
        COLON = 43, SEMICOLON, COMMA, DOT,
        LEFT_BRACKET, RIGHT_BRACKET, LEFT_BRACE, RIGHT_BRACE,
        LEFT_PERAN, RIGHT_PERAN = 53
    } PUNCTUANTIONS;
%}

%%
"int"           return INT;
"double"        return DOUBLE;
"bool"          return BOOL; 
"char"          return CHAR; 

"void"          return VOID;
"const"         return CONST;
"null"          return KEY_NULL;
"for"           return FOR;
"do"            return DO;
"while"         return WHILE;
"break"         return BREAK;
"continue"      return CONTINUE;
"if"            return IF;
"else"          return ELSE;
"return"        return RETURN;
"struct"        return STRUCT;
"switch"        return SWITCH;
"case"          return CASE;
"default"       return DEFAULT;

"+"             return PLUS;
"-"             return MINUS;
"*"             return MULTIPLE;
"/"             return DIVIDE;
"%"             return MOD;
"++"            return TWO_PLUS;
"--"            return TWO_MINUS;
"<"             return LESS;
"<="            return LESS_THAN;
">"             return GREATER;
">="            return GREATER_THAN;
"=="            return SAME;
"!="            return NOT_EQUAL;
"="             return EQUAL;
"&&"            return AND;
"||"            return OR;
"!"             return NOT;
"&"             return BI_AND;
"|"             return BI_OR;
"^"             return BI_XOR;
"~"             return BI_COMPLEMENT;
"<<"            return LEFT_SHIFT;
">>"            return RIGHT_SHIFT;

":"			    return COLON;
";"				return SEMICOLON;
","				return COMMA;
"."				return DOT;
"["				return LEFT_BRACKET;
"]"				return RIGHT_BRACKET;
"("				return LEFT_PERAN;
")"				return RIGHT_PERAN;
"{"				return LEFT_BRACE;
"}"				return RIGHT_BRACE;
%%

int yywrap() {return 1;}

void print(int token) {
    if(token >= 0 && token <= 3){ // print primitive datatypes
		printf("#token key:%s\n", yytext);
		return;
	}

    if(token >= 5 && token <= 19) { // print keywords
        printf("#token key:%s\n", yytext);
        return;
    }

    if(token >= 20 && token <= 42) { // print operators
        printf("#token op:%s\n", yytext);
        return;
    }

    if(token >= 43 && token <= 53) { // print punctuations
        printf("#token punc:%s\n", yytext);
        return;
    }
}

int main () {
    int token;
    while((token = yylex())) {
		strcat(cur_line_content, yytext);
	    print(token);
	}
    return 0;
}