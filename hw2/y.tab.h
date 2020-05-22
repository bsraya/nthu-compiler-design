#define DATATYPE_INT 257
#define DATATYPE_DOUBLE 258
#define DATATYPE_FLOAT 259
#define DATATYPE_CHAR 260
#define DATATYPE_BOOL 261
#define RESERVED_TRUE 262
#define RESERVED_FALSE 263
#define RESERVED_NULL 264
#define PLUS 265
#define MINUS 266
#define MULTIPLE 267
#define DIVIDE 268
#define MOD 269
#define INCREMENT 270
#define DECREMENT 271
#define LESS 272
#define LESS_THAN 273
#define GREATER 274
#define GREATER_THAN 275
#define EQUAL_TO 276
#define NOT_EQUAL_TO 277
#define ASSIGN_EQUAL 278
#define LOGICAL_AND 279
#define LOGICAL_OR 280
#define LOGICAL_NOT 281
#define BITWISE_AND 282
#define BITWISE_OR 283
#define BITWISE_XOR 284
#define BITWISE_COMPLEMENT 285
#define LEFT_SHIFT 286
#define RIGHT_SHIFT 287
#define GRAVE_ACCENT 288
#define POUND 289
#define DOLLAR 290
#define COLON 291
#define SEMICOLON 292
#define COMMA 293
#define DOT 294
#define LEFT_SQUARE_BRACKET 295
#define RIGHT_SQUARE_BRACKET 296
#define LEFT_BRACKET 297
#define RIGHT_BRACKET 298
#define LEFT_CURLY_BRACKET 299
#define RIGHT_CURLY_BRACKET 300
#define AT_SIGN 301
#define VOID 302
#define FOR 303
#define DO 304
#define WHILE 305
#define BREAK 306
#define CONTINUE 307
#define IF 308
#define ELSE 309
#define AUTO 310
#define CONST 311
#define STATIC 312
#define UNION 313
#define ENUM 314
#define GOTO 315
#define REGISTER 316
#define SIZEOF 317
#define TYPEDEF 318
#define VOLATILE 319
#define EXTERN 320
#define RETURN 321
#define STRUCT 322
#define SWITCH 323
#define CASE 324
#define DEFAULT 325
#define TRUE 326
#define FALSE 327
#define TOKEN_IDENTIFIER 328
#define TOKEN_STRING 329
#define TOKEN_CHARACTER 330
#define TOKEN_INTEGER 331
#define TOKEN_DOUBLE 332
#define TOKEN_SCI_NOT 333
#define declaration_with_const 334
#define declaration_without_const 335
#define scalar_with_const 336
#define scalar_wihtout_const 337
#define OR 338
#define relational_expression_without_function 339
#define AND 340
#define and 341
#define PUNC_LBRACKET 342
#define expression 343
#define PUNC_RBRACKET 344
#define postfix_expression_without_func 345
#define TOKEN_ID 346
#define const_varibles 347
#define EQUAL 348
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
        int intValue;
        char charValue;
        char *stringValue;
        double doubleValue;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
