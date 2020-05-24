%{
        #include <stdio.h>
        #include <string.h>
        #include "y.tab.h"
        int yylex();
        void yyerror(char* error_message);      
%}

%union {
        char stringval[10000];
}

/* primitive datatypes */
%token <stringval> DATATYPE_INT DATATYPE_DOUBLE DATATYPE_CHAR DATATYPE_FLOAT
/* operators */
%token <stringval> PLUS MINUS MULTIPLE DIVIDE MOD INCREMENT DECREMENT LESS_THAN LESS_EQUAL_THAN GREATER_THAN GREATER_EQUAL_THAN EQUAL_TO NOT_EQUAL_TO ASSIGN_EQUAL LOGICAL_AND LOGICAL_OR LOGICAL_NOT POINTER BITWISE_AND BITWISE_COMPLEMENT BITWISE_OR BITWISE_XOR LEFT_SHIFT RIGHT_SHIFT

/* punctuations */
%token <stringval> GRAVE_ACCENT POUND DOLLAR AT_SIGN COLON SEMICOLON COMMA DOT LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET

/* keywords */
%token <stringval> VOID FOR WHILE DO IF ELSE SWITCH RETURN BREAK CONTINUE CONST TRUE FALSE STRUCT CASE DEFAULT AUTO STATIC UNION ENUM GOTO REGISTER SIZEOF TYPEDEF VOLATILE EXTERN 

/* tokens */
%token <stringval> TOKEN_IDENTIFIER TOKEN_STRING TOKEN_CHARACTER TOKEN_INTEGER TOKEN_DOUBLE TOKEN_SCI_NOT


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type <stringval> program
%type <stringval> zero_or_more_declaration
%type <stringval> external_declaration
%type <stringval> declaration_list
%type <stringval> declaration
%type <stringval> declaration_const
%type <stringval> declaration_specifiers_const
%type <stringval> type_specifier
%type <stringval> type_qualifier
%type <stringval> init_declarator_list_const
%type <stringval> init_declarator_const
%type <stringval> declaration_const
%type <stringval> direct_declarator_const
%type <stringval> declaration_no_const 
%type <stringval> declaration_specifiers_no_const
%type <stringval> init_declarator_list_no_const
%type <stringval> init_declarator_no_const
%type <stringval> declarator_no_const
%type <stringval> direct_declarator_no_const
%type <stringval> function_definition
%type <stringval> initializer
%type <stringval> initializer_list
%type <stringval> designation
%type <stringval> designator_list
%type <stringval> designator
%type <stringval> identifier_list
%type <stringval> parameter_list
%type <stringval> parameter_declaration
%type <stringval> compound_statement
%type <stringval> block_item_list
%type <stringval> zero_or_more_statement
%type <stringval> statement
%type <stringval> expression_statement
%type <stringval> expression
%type <stringval> assignment_expression
%type <stringval> assignment_expression_without_func
%type <stringval> logical_or_expression
%type <stringval> logical_and_expression
%type <stringval> and_expression
%type <stringval> equality_expression
%type <stringval> relational_expression
%type <stringval> additive_expression
%type <stringval> multiplicative_expression
%type <stringval> unary_expression
%type <stringval> unary_operator
%type <stringval> postfix_expression
%type <stringval> primary_expression
%type <stringval> constant
%type <stringval> logical_or_expression_without_func
%type <stringval> logical_and_expression_without_func
%type <stringval> and_expression_without_func
%type <stringval> equality_expression_without_func
%type <stringval> relational_expression_without_func
%type <stringval> additive_expression_without_func
%type <stringval> multiplicative_expression_without_func
%type <stringval> unary_expression_without_func
%type <stringval> postfix_expression_without_func
%type <stringval> primary_expression_without_func
%type <stringval> argument_expression_list
%type <stringval> selection_statement
%type <stringval> switch_content
%type <stringval> one_or_more_case
%type <stringval> case_statement
%type <stringval> default_statement
%type <stringval> int_or_char_const
%type <stringval> iteration_statement
%type <stringval> jump_statement

%start program

%%

program: 
        zero_or_more_declaration function_definition
		;

zero_or_more_declaration:
		/* does nothing */ | 
        zero_or_more_declaration external_declaration
		;

external_declaration: 
        function_definition | 
        declaration
		;

declaration_list: 
        declaration | 
        declaration_list declaration 
		;

declaration: 
        declaration_const | 
        declaration_no_const 
		;

declaration_const: 
        declaration_specifiers_const SEMICOLON |
        declaration_specifiers_const init_declarator_list_const SEMICOLON  
		;

declaration_specifiers_const: 
        type_qualifier type_specifier 
		;

type_specifier: 
        DATATYPE_CHAR { fprintf(stdout, "%s", $1); } | 
        DATATYPE_INT { fprintf(stdout, "%s", $1); } | 
        DATATYPE_DOUBLE { fprintf(stdout, "%s", $1); } | 
        DATATYPE_FLOAT { fprintf(stdout, "%s", $1); }
		; 

type_qualifier: 
        CONST { fprintf(stdout, "%s", $1); }
		; 

init_declarator_list_const: 
        init_declarator_const | 
        init_declarator_list_const COMMA init_declarator_const
		;

init_declarator_const: 
        declarator_const ASSIGN_EQUAL initializer | 
        declarator_const
		;

declarator_const: 
        direct_declarator_const
		; 

direct_declarator_const: 
        TOKEN_IDENTIFIER | 
        LEFT_BRACKET declarator_const RIGHT_BRACKET | 
        direct_declarator_const LEFT_BRACKET RIGHT_BRACKET | 
        direct_declarator_const LEFT_BRACKET parameter_list RIGHT_BRACKET | 
        direct_declarator_const LEFT_BRACKET identifier_list RIGHT_BRACKET
		;

declaration_no_const: 
        declaration_specifiers_no_const SEMICOLON | 
        declaration_specifiers_no_const init_declarator_list_no_const SEMICOLON 
		;

declaration_specifiers_no_const
		: type_specifier
		| type_specifier declaration_specifiers_no_const
		;


init_declarator_list_no_const
		: init_declarator_no_const 
		| init_declarator_list_no_const COMMA init_declarator_no_const 
		;

init_declarator_no_const
		: declarator_no_const ASSIGN_EQUAL initializer 
		| declarator_no_const
		;

declarator_no_const
		: direct_declarator_no_const
		; 

direct_declarator_no_const
		: TOKEN_IDENTIFIER 
		| LEFT_BRACKET declarator_no_const RIGHT_BRACKET
		| direct_declarator_no_const LEFT_SQUARE_BRACKET TOKEN_INTEGER RIGHT_SQUARE_BRACKET
		| direct_declarator_no_const LEFT_BRACKET RIGHT_BRACKET
		| direct_declarator_no_const LEFT_BRACKET parameter_list RIGHT_BRACKET
		| direct_declarator_no_const LEFT_BRACKET identifier_list RIGHT_BRACKET
		;


function_definition
		: declaration_specifiers_no_const declarator_no_const declaration_list compound_statement {fprintf(stdout, "<func_def>%s%s%s</func_def>", $1, $2, $4);}
		| declaration_specifiers_no_const declarator_no_const compound_statement {fprintf(stdout, "<func_def>%s%s%s</func_def>", $1, $2, $3);}
		| VOID declarator_no_const declaration_list compound_statement { fprintf(stdout, "<func_def>void</func_def>"); }
		| VOID declarator_no_const compound_statement { fprintf(stdout, "<func_def>void</func_def>"); }
		;


initializer
		: LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET
		| LEFT_CURLY_BRACKET initializer_list RIGHT_CURLY_BRACKET
		| LEFT_CURLY_BRACKET initializer_list COMMA RIGHT_CURLY_BRACKET
		| assignment_expression_without_func
		;

initializer_list
		: designation initializer
		| initializer
		| initializer_list COMMA designation initializer
		| initializer_list COMMA initializer
		;

designation
		: designator_list ASSIGN_EQUAL
		;

designator_list
		: designator
		| designator_list designator
		;

designator
		: DOT TOKEN_IDENTIFIER
		;


identifier_list
		: TOKEN_IDENTIFIER
		| identifier_list COMMA TOKEN_IDENTIFIER
		;


parameter_list
		: parameter_declaration
		| parameter_list COMMA parameter_declaration
		;

parameter_declaration
		: declaration_specifiers_no_const declarator_no_const
		| declaration_specifiers_no_const
		; /* ignore abstract delaration here */

compound_statement
		: LEFT_CURLY_BRACKET block_item_list RIGHT_CURLY_BRACKET { fprintf(stdout, "{%s}", $2); }
		;

block_item_list
		: zero_or_more_declaration zero_or_more_statement
		;


zero_or_more_statement
		: /* empty */
		| zero_or_more_statement statement { fprintf(stdout, "%s%s", $1,$2); }
		;

statement
		: compound_statement { fprintf(stdout, "%s", $1); }
		| expression_statement { fprintf(stdout, "%s", $1); }
		| selection_statement { fprintf(stdout, "%s", $1); }
		| iteration_statement { fprintf(stdout, "%s", $1); }
		| jump_statement { fprintf(stdout, "%s", $1); }
		;

expression_statement
		: SEMICOLON { fprintf(stdout, ";"); }
		| expression SEMICOLON { fprintf(stdout, "%s;", $1); }
		;

expression
		: assignment_expression
		| expression COMMA assignment_expression
		;

assignment_expression
		: logical_or_expression
		| unary_expression ASSIGN_EQUAL assignment_expression
		;

unary_expression
		: postfix_expression
		| INCREMENT unary_expression 
		| DECREMENT unary_expression
		| unary_operator unary_expression
		; 

logical_or_expression
		: logical_and_expression
		| logical_or_expression LOGICAL_OR logical_and_expression
		;

logical_and_expression
		: and_expression
		| logical_and_expression LOGICAL_AND and_expression
		;

and_expression
		: equality_expression
		| and_expression BITWISE_AND equality_expression
		;

equality_expression
		: relational_expression
		| equality_expression EQUAL_TO relational_expression
		| equality_expression NOT_EQUAL_TO relational_expression
		;

relational_expression
		: additive_expression
		| relational_expression GREATER_THAN additive_expression
		| relational_expression GREATER_EQUAL_THAN additive_expression
		| relational_expression LESS_THAN additive_expression
		| relational_expression LESS_EQUAL_THAN additive_expression
		;

additive_expression
		: multiplicative_expression
		| additive_expression PLUS multiplicative_expression
		| additive_expression MINUS multiplicative_expression
		;

multiplicative_expression
		: unary_expression
		| multiplicative_expression MULTIPLE unary_expression
		| multiplicative_expression DIVIDE unary_expression
		| multiplicative_expression MOD unary_expression
		;

unary_operator
		: BITWISE_AND 
        | BITWISE_COMPLEMENT 
        | BITWISE_OR 
        | BITWISE_XOR
		| POINTER
		| PLUS
		| MINUS
		| LOGICAL_NOT
		;

postfix_expression
		: primary_expression
		| postfix_expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
		| postfix_expression LEFT_BRACKET RIGHT_BRACKET
		| postfix_expression LEFT_BRACKET argument_expression_list RIGHT_BRACKET 
		| postfix_expression DOT TOKEN_IDENTIFIER { fprintf(stdout, "%s.%s", $1, $3); }
		| postfix_expression INCREMENT { fprintf(stdout, "%s%s", $1, $2); }
		| postfix_expression DECREMENT { fprintf(stdout, "%s%s", $1, $2); }
		; 

primary_expression
		: TOKEN_IDENTIFIER { fprintf(stdout, "%s", $1); }
		| constant { fprintf(stdout, "%s", $1); }
		| TOKEN_STRING { fprintf(stdout, "%s", $1); }
		| LEFT_BRACKET expression RIGHT_BRACKET 
		;

constant
		: TOKEN_INTEGER { fprintf(stdout, "%s", $1); }
		| TOKEN_DOUBLE { fprintf(stdout, "%s", $1); }
		| TOKEN_SCI_NOT { fprintf(stdout, "%s", $1); }
		;

assignment_expression_without_func
		: logical_or_expression_without_func
		| unary_expression_without_func ASSIGN_EQUAL assignment_expression_without_func
		;

logical_or_expression_without_func
		: logical_and_expression_without_func
		| logical_or_expression_without_func LOGICAL_OR logical_and_expression_without_func
		;

logical_and_expression_without_func
		: and_expression_without_func
		| logical_and_expression_without_func LOGICAL_AND and_expression_without_func
		;

and_expression_without_func
		: equality_expression_without_func
		| and_expression_without_func BITWISE_AND equality_expression_without_func
		;

equality_expression_without_func
		: relational_expression_without_func
		| equality_expression_without_func EQUAL_TO relational_expression_without_func
		| equality_expression_without_func NOT_EQUAL_TO relational_expression_without_func
		;

relational_expression_without_func
		: additive_expression_without_func
		| relational_expression_without_func GREATER_THAN additive_expression_without_func
		| relational_expression_without_func GREATER_EQUAL_THAN additive_expression_without_func
		| relational_expression_without_func LESS_THAN additive_expression_without_func
		| relational_expression_without_func LESS_EQUAL_THAN additive_expression_without_func
		;

additive_expression_without_func
		: multiplicative_expression_without_func
		| additive_expression_without_func PLUS multiplicative_expression_without_func
		| additive_expression_without_func MINUS multiplicative_expression_without_func
		;

multiplicative_expression_without_func
		: unary_expression_without_func
		| multiplicative_expression_without_func MULTIPLE unary_expression_without_func
		| multiplicative_expression_without_func DIVIDE unary_expression_without_func
		| multiplicative_expression_without_func MOD unary_expression_without_func
		;

unary_expression_without_func
		: postfix_expression_without_func
		| INCREMENT unary_expression_without_func
		| DECREMENT unary_expression_without_func
		| unary_operator unary_expression_without_func
		; 

postfix_expression_without_func
		: primary_expression_without_func
		| postfix_expression_without_func LEFT_SQUARE_BRACKET TOKEN_INTEGER RIGHT_SQUARE_BRACKET
		| postfix_expression_without_func DOT TOKEN_IDENTIFIER
		| postfix_expression_without_func INCREMENT
		| postfix_expression_without_func DECREMENT
		; 

primary_expression_without_func
		: TOKEN_IDENTIFIER
		| constant
		| TOKEN_STRING
		| LEFT_BRACKET expression RIGHT_BRACKET
		;


argument_expression_list
		: assignment_expression
		| argument_expression_list COMMA assignment_expression
		;

selection_statement
		: IF LEFT_BRACKET expression RIGHT_BRACKET statement ELSE statement
		| IF LEFT_BRACKET expression RIGHT_BRACKET statement %prec LOWER_THAN_ELSE
		| SWITCH LEFT_BRACKET identifier_list RIGHT_BRACKET LEFT_CURLY_BRACKET switch_content RIGHT_CURLY_BRACKET
		;

switch_content
		: one_or_more_case
		| one_or_more_case default_statement
		;

one_or_more_case: 
        case_statement | 
        one_or_more_case case_statement
		;

case_statement: 
        CASE int_or_char_const COLON zero_or_more_statement
		;

default_statement: 
        DEFAULT COLON zero_or_more_statement
		;

int_or_char_const: 
        TOKEN_INTEGER | 
        TOKEN_CHARACTER
		;

iteration_statement: 
        WHILE LEFT_BRACKET expression RIGHT_BRACKET statement 
		| DO statement WHILE LEFT_BRACKET expression RIGHT_BRACKET SEMICOLON 
		| FOR LEFT_BRACKET expression_statement expression_statement RIGHT_BRACKET statement 
		| FOR LEFT_BRACKET expression_statement expression_statement expression RIGHT_BRACKET statement 
		| FOR LEFT_BRACKET declaration expression_statement RIGHT_BRACKET statement 
		| FOR LEFT_BRACKET declaration expression_statement expression RIGHT_BRACKET statement 
		;

jump_statement: 
    CONTINUE SEMICOLON | 
    BREAK SEMICOLON | 
    RETURN SEMICOLON | 
    RETURN expression SEMICOLON { fprintf(stdout, "return%s;", $2); }

%% 

int main () {
    yyparse();
    printf("Parsed Successfully");
    return 0;
}