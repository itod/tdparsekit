@import "../TDParseKit.j"

/*
 expr           = term (plusTerm | minusTerm)*
 term           = factor (timesFactor | divFactor)*
 plusTerm       = '+' term
 minusTerm      = '-' term
 factor         = phrase exponentFactor | phrase
 timesFactor	= '*' factor
 divFactor      = '/' factor
 exponentFactor = '^' factor
 phrase         = '(' expr ')' | Num
*/

@implementation TDArithmeticParser : TDSequence {
    TDCollectionParser exprParser;
    TDCollectionParser termParser;
    TDCollectionParser plusTermParser;
    TDCollectionParser minusTermParser;
    TDCollectionParser factorParser;
    TDCollectionParser timesFactorParser;
    TDCollectionParser divFactorParser;
    TDCollectionParser exponentFactorParser;
    TDCollectionParser phraseParser;
}

- (id)init {
    if (self = [super init]) {
        [self add:[self exprParser]];
    }
    return self;
}


- (float)parse:(CPString)s {
    var a = [TDTokenAssembly assemblyWithString:s];
    a = [self completeMatchFor:a];
    //CPLog(@"\n\na: %@\n\n", a);
    var n = parseFloat([a pop]);
    return n;
}


// expr            = term (plusTerm | minusTerm)*
- (TDCollectionParser)exprParser {
    if (!exprParser) {
        exprParser = [TDSequence sequence];
        [exprParser add:[self termParser]];
        
        var a = [TDAlternation alternation];
        [a add:[self plusTermParser]];
        [a add:[self minusTermParser]];
        
        [exprParser add:[TDRepetition repetitionWithSubparser:a]];
    }
    return exprParser;
}


// term            = factor (timesFactor | divFactor)*
- (TDCollectionParser)termParser {
    if (!termParser) {
        termParser = [TDSequence sequence];
        [termParser add:[self factorParser]];
        
        var a = [TDAlternation alternation];
        [a add:[self timesFactorParser]];
        [a add:[self divFactorParser]];
        
        [termParser add:[TDRepetition repetitionWithSubparser:a]];
    }
    return termParser;
}


// plusTerm        = '+' term
- (TDCollectionParser)plusTermParser {
    if (!plusTermParser) {
        plusTermParser = [TDSequence sequence];
        [plusTermParser add:[[TDSymbol symbolWithString:@"+"] discard]];
        [plusTermParser add:[self termParser]];
        [plusTermParser setAssembler:self selector:@selector(workOnPlusAssembly:)];
    }
    return plusTermParser;
}


// minusTerm    = '-' term
- (TDCollectionParser)minusTermParser {
    if (!minusTermParser) {
        minusTermParser = [TDSequence sequence];
        [minusTermParser add:[[TDSymbol symbolWithString:@"-"] discard]];
        [minusTermParser add:[self termParser]];
        [minusTermParser setAssembler:self selector:@selector(workOnMinusAssembly:)];
    }
    return minusTermParser;
}


// factor        = phrase exponentFactor | phrase
- (TDCollectionParser)factorParser {
    if (!factorParser) {
        factorParser = [TDAlternation alternation];
        
        var s = [TDSequence sequence];
        [s add:[self phraseParser]];
        [s add:[self exponentFactorParser]];
        
        [factorParser add:s];
        [factorParser add:[self phraseParser]];
    }
    return factorParser;
}


// timesFactor    = '*' factor
- (TDCollectionParser)timesFactorParser {
    if (!timesFactorParser) {
        timesFactorParser = [TDSequence sequence];
        [timesFactorParser add:[[TDSymbol symbolWithString:@"*"] discard]];
        [timesFactorParser add:[self factorParser]];
        [timesFactorParser setAssembler:self selector:@selector(workOnTimesAssembly:)];
    }
    return timesFactorParser;
}


// divFactor    = '/' factor
- (TDCollectionParser)divFactorParser {
    if (!divFactorParser) {
        divFactorParser = [TDSequence sequence];
        [divFactorParser add:[[TDSymbol symbolWithString:@"/"] discard]];
        [divFactorParser add:[self factorParser]];
        [divFactorParser setAssembler:self selector:@selector(workOnDivideAssembly:)];
    }
    return divFactorParser;
}


// exponentFactor    = '^' factor
- (TDCollectionParser)exponentFactorParser {
    if (!exponentFactorParser) {
        exponentFactorParser = [TDSequence sequence];
        [exponentFactorParser add:[[TDSymbol symbolWithString:@"^"] discard]];
        [exponentFactorParser add:[self factorParser]];
        [exponentFactorParser setAssembler:self selector:@selector(workOnExpAssembly:)];
    }
    return exponentFactorParser;
}


// phrase        = '(' expr ')' | Num
- (TDCollectionParser)phraseParser {
    if (!phraseParser) {
        phraseParser = [TDAlternation alternation];
        
        var s = [TDSequence sequence];
        [s add:[[TDSymbol symbolWithString:@"("] discard]];
        [s add:[self exprParser]];
        [s add:[[TDSymbol symbolWithString:@")"] discard]];
        
        [phraseParser add:s];
        
        var n = [TDNum num];
        [n setAssembler:self selector:@selector(workOnNumAssembly:)];
        [phraseParser add:n];
    }
    return phraseParser;
}


- (void)workOnNumAssembly:(TDAssembly)a {
    var tok = [a pop];
    [a push:tok.floatValue];
}


- (void)workOnPlusAssembly:(TDAssembly)a {
    var n2 = [a pop];
    var n1 = [a pop];
    [a push:n1 + n2];
}


- (void)workOnMinusAssembly:(TDAssembly)a {
    var n2 = [a pop];
    var n1 = [a pop];
    var n = n1 - n2;
    [a push:n];
}


- (void)workOnTimesAssembly:(TDAssembly)a {
    var n2 = [a pop];
    var n1 = [a pop];
    [a push:n1 * n2];
}


- (void)workOnDivideAssembly:(TDAssembly)a {
    var n2 = [a pop];
    var n1 = [a pop];
    [a push:n1 / n2];
}


- (void)workOnExpAssembly:(TDAssembly)a {
    var n2 = [a pop];
    var n1 = [a pop];
    
    var n1 = n1;
    var n2 = n2;
    
    var total = n1;
    for (var i = 1; i < n2; i++) {
        total *= n1;
    }
    
    [a push:total];
}

@end
