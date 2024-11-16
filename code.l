%{
#include <stdio.h>
#include <stdlib.h>

int keyword = 0;
int identifier = 0;
int number = 0;
int operator = 0;
int macro = 0;
int header = 0;
int punctuation = 0;
int unknown = 0;
FILE *outputFile;
%}

ASSUME dhoro
EQUAL soman
DUPLICATE nokol
TYPE bag
CONDITION sorto
THEN tarpor
PRINT dekhau
LOOP ghuro
FUN dako_function
STOP thamo
RETURN ferot
NEWKEYWORD1 shuru
NEWKEYWORD2 sesh
NEWKEYWORD3 moddhye

C_KEYWORDS int|float|if|else|return|while|for|do|switch|case
MACRO #define
HEADER #include[ \t]*<[^>]+>
RELATIONAL_OP ">"|"<"|">="|"<="|"=="|"!="
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
NUMBER [0-9]+
WHITESPACE [ \t\n]+
PUNCTUATION [;,\(\)\{\}]

%%

{RELATIONAL_OP}  { operator++; }
{ASSUME}         { keyword++; }
{FUN}            { keyword++; }
{EQUAL}          { operator++; }
{TYPE}           { keyword++; }
{DUPLICATE}      { keyword++; }
{PRINT}          { keyword++; }
{THEN}           { keyword++; }
{CONDITION}      { keyword++; }
{LOOP}           { keyword++; }
{STOP}           { keyword++; }
{RETURN}         { keyword++; }
{NEWKEYWORD1}    { keyword++; }
{NEWKEYWORD2}    { keyword++; }
{NEWKEYWORD3}    { keyword++; }
{C_KEYWORDS}     { keyword++; }
{MACRO}          { macro++; }
{HEADER}         { header++; }
{IDENTIFIER}     { identifier++; }
{NUMBER}         { number++; }
{WHITESPACE}     { /* Ignore whitespace */ }
{PUNCTUATION}    { punctuation++; }
"+"|"-"|"*"|"/"  { operator++; }
"="              { operator++; }
"."              { punctuation++; }
.                { unknown++; fprintf(stderr, "Unknown keyword or symbol: %s\n", yytext); }

%%

int main() {
    FILE *inputFile = fopen("input.txt", "r");
    if (!inputFile) {
        perror("Error opening input.txt");
        return 1;
    }
    yyin = inputFile;

    outputFile = fopen("output.txt", "w");
    if (!outputFile) {
        perror("Error opening output.txt");
        fclose(inputFile);
        return 1;
    }

    if (yylex() < 0) {
        fprintf(stderr, "An error occurred during lexical analysis.\n");
        fclose(inputFile);
        fclose(outputFile);
        return 1;
    }

    fprintf(outputFile, "Keywords: %d\n", keyword);
    fprintf(outputFile, "Identifiers: %d\n", identifier);
    fprintf(outputFile, "Numbers: %d\n", number);
    fprintf(outputFile, "Operators: %d\n", operator);
    fprintf(outputFile, "Macros: %d\n", macro);
    fprintf(outputFile, "Headers: %d\n", header);
    fprintf(outputFile, "Punctuation: %d\n", punctuation);
    fprintf(outputFile, "Unknown tokens: %d\n", unknown);

    fclose(inputFile);
    fclose(outputFile);
    return 0;
}

int yywrap() {
    return 1;
}
