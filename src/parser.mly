%token <int> INT
%token <string> ID
%token LPAREN LCURLY
%token RPAREN RCURLY
%token EOF LAMBDA ARROW END FUNC COMMA
%token ADD SUB MULT DIV

%left ADD SUB
%left MULT DIV
%nonassoc INT ID LPAREN

%start <Types.expr>  prog
%%

prog: 
  | expr EOF { $1 }

values:
  | i = INT                     { Types.Integer i } 
  | var = ID                    { Types.Var var }
  | LPAREN; e = expr; RPAREN    { e }; 

expr: 
  | e = values                    { e }
  | e = expr; LPAREN; s = application_list; RPAREN   { Types.Application (e, s) }
  | e1 = expr; ADD;  e2 = expr    { Types.Operator (e1, Types.ADD, e2) }
  | e1 = expr; SUB;  e2 = expr    { Types.Operator (e1, Types.SUB, e2)  }
  | e1 = expr; MULT; e2 = expr    { Types.Operator (e1, Types.MULT, e2)  }
  | e1 = expr; DIV;  e2 = expr    { Types.Operator (e1, Types.DIV, e2)  }
  | LAMBDA; LPAREN; idents = ident_list; RPAREN; ARROW; e = expr; END  { Types.Lambda (idents, e) }
  | FUNC; fname = ID; LPAREN; idents = ident_list; RPAREN;  ARROW; e1 = expr; LCURLY; e2 = expr; RCURLY { Types.Func (fname, (idents, e1), e2) }; 

application_list:
  | a = separated_list(COMMA, expr) { a } 

ident_list: 
  | s = separated_list(COMMA, ID) { s } 