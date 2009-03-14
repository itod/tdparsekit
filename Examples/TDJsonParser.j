@import "../TDParseKit.j"

@implementation TDJsonParser : TDAlternation {
    BOOL shouldAssemble;
    TDParser stringParser;
    TDParser numberParser;
    TDParser nullParser;
    TDCollectionParser booleanParser;
    TDCollectionParser arrayParser;
    TDCollectionParser objectParser;
    TDCollectionParser valueParser;
    TDCollectionParser commaValueParser;
    TDCollectionParser propertyParser;
    TDCollectionParser commaPropertyParser;
    
    TDToken curly;
    TDToken bracket;
}

- (id)init {
    return [self initWithIntentToAssemble:YES];
}


- (id)initWithIntentToAssemble:(BOOL)yn {
    self = [super init];
    if (self) {
        shouldAssemble = yn;
        curly = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0.0];
        bracket = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"[" floatValue:0.0];
        
        tokenizer = [TDTokenizer tokenizer];
        [tokenizer setTokenizerState:tokenizer.symbolState from: '/'.charCodeAt(0) to: '/'.charCodeAt(0)]; // JSON doesn't have slash slash or slash star comments
        [tokenizer setTokenizerState:tokenizer.symbolState from: '\''.charCodeAt(0) to: '\''.charCodeAt(0)]; // JSON does not have single quoted strings
        
        [self add:[self objectParser]];
        [self add:[self arrayParser]];
    }
    return self;
}


- (id)parse:(CPString)s {
    [tokenizer setString:s];
    var a = [TDTokenAssembly assemblyWithTokenizer:tokenizer];
    
    var result = [self completeMatchFor:a];
    return [result pop];
}


- (TDParser)stringParser {
    if (!stringParser) {
        stringParser = [TDQuotedString quotedString];
        if (shouldAssemble) {
            [stringParser setAssembler:self selector:@selector(workOnStringAssembly:)];
        }
    }
    return stringParser;
}


- (TDParser)numberParser {
    if (!numberParser) {
        numberParser = [TDNum num];
        if (shouldAssemble) {
            [numberParser setAssembler:self selector:@selector(workOnNumberAssembly:)];
        }
    }
    return numberParser;
}


- (TDParser)nullParser {
    if (!nullParser) {
        nullParser = [[TDLiteral literalWithString:@"null"] discard];
        if (shouldAssemble) {
            [nullParser setAssembler:self selector:@selector(workOnNullAssembly:)];
        }
    }
    return nullParser;
}


- (TDCollectionParser)booleanParser {
    if (!booleanParser) {
        booleanParser = [TDAlternation alternation];
        [booleanParser add:[TDLiteral literalWithString:@"true"]];
        [booleanParser add:[TDLiteral literalWithString:@"false"]];
        if (shouldAssemble) {
            [booleanParser setAssembler:self selector:@selector(workOnBooleanAssembly:)];
        }
    }
    return booleanParser;
}


- (TDCollectionParser)arrayParser {
    if (!arrayParser) {

        // array = '[' content ']'
        // content = Empty | actualArray
        // actualArray = value commaValue*

        var actualArray = [TDTrack sequence];
        [actualArray add:[self valueParser]];
        [actualArray add:[TDRepetition repetitionWithSubparser:[self commaValueParser]]];

        var content = [TDAlternation alternation];
        [content add:[TDEmpty empty]];
        [content add:actualArray];
        
        arrayParser = [TDSequence sequence];
        [arrayParser add:[TDSymbol symbolWithString:@"["]]; // serves as fence
        [arrayParser add:content];
        [arrayParser add:[[TDSymbol symbolWithString:@"]"] discard]];
        
        if (shouldAssemble) {
            [arrayParser setAssembler:self selector:@selector(workOnArrayAssembly:)];
        }
    }
    return arrayParser;
}


- (TDCollectionParser)objectParser {
    if (!objectParser) {
        
        // object = '{' content '}'
        // content = Empty | actualObject
        // actualObject = property commaProperty*
        // property = QuotedString ':' value
        // commaProperty = ',' property
        
        var actualObject = [TDTrack sequence];
        [actualObject add:[self propertyParser]];
        [actualObject add:[TDRepetition repetitionWithSubparser:[self commaPropertyParser]]];
        
        var content = [TDAlternation alternation];
        [content add:[TDEmpty empty]];
        [content add:actualObject];
        
        objectParser = [TDSequence sequence];
        [objectParser add:[TDSymbol symbolWithString:@"{"]]; // serves as fence
        [objectParser add:content];
        [objectParser add:[[TDSymbol symbolWithString:@"}"] discard]];

        if (shouldAssemble) {
            [objectParser setAssembler:self selector:@selector(workOnObjectAssembly:)];
        }
    }
    return objectParser;
}


- (TDCollectionParser)valueParser {
    if (!valueParser) {
        valueParser = [TDAlternation alternation];
        [valueParser add:[self stringParser]];
        [valueParser add:[self numberParser]];
        [valueParser add:[self nullParser]];
        [valueParser add:[self booleanParser]];
        [valueParser add:[self arrayParser]];
        [valueParser add:[self objectParser]];
    }
    return valueParser;
}


- (TDCollectionParser)commaValueParser {
    if (!commaValueParser) {
        commaValueParser = [TDTrack sequence];
        [commaValueParser add:[[TDSymbol symbolWithString:@","] discard]];
        [commaValueParser add:[self valueParser]];
    }
    return commaValueParser;
}


- (TDCollectionParser)propertyParser {
    if (!propertyParser) {
        propertyParser = [TDSequence sequence];
        [propertyParser add:[TDQuotedString quotedString]];
        [propertyParser add:[[TDSymbol symbolWithString:@":"] discard]];
        [propertyParser add:[self valueParser]];
        if (shouldAssemble) {
            [propertyParser setAssembler:self selector:@selector(workOnPropertyAssembly:)];
        }
    }
    return propertyParser;
}


- (TDCollectionParser)commaPropertyParser {
    if (!commaPropertyParser) {
        commaPropertyParser = [TDTrack sequence];
        [commaPropertyParser add:[[TDSymbol symbolWithString:@","] discard]];
        [commaPropertyParser add:[self propertyParser]];
    }
    return commaPropertyParser;
}


- (void)workOnNullAssembly:(TDAssembly)a {
    [a push:[CPNull null]];
}


- (void)workOnNumberAssembly:(TDAssembly)a {
    var tok = [a pop];
    [a push:[NSNumber numberWithFloat:tok.floatValue]];
}


- (void)workOnStringAssembly:(TDAssembly)a {
    var tok = [a pop];
    [a push:tok.stringValue.substr(1, -1)];
}


- (void)workOnBooleanAssembly:(TDAssembly)a {
    var tok = [a pop];
    [a push:[tok.stringValue isEqualToString:@"true"] ? YES : NO];
}


- (void)workOnArrayAssembly:(TDAssembly)a {
    var elements = [a objectsAbove:bracket];
    var array = [];
    
    for (var i = elements.length -1; i >= 0; i--) {
        var element = elements[i];
        if (element) {
            [array addObject:element];
        }
    }
    [a pop]; // pop the [
    [a push:array];
}


- (void)workOnObjectAssembly:(TDAssembly)a {
    var elements = [a objectsAbove:curly];
    var d = [CPDictionary dictionaryWithCapacity:[elements count] / 2];
    
    for (var i = 0, count = [elements count] - 1; i < count; i++) {
        var value = elements[i++];
        var  key = elements[i];
        if (key && value) {
            [d setObject:value forKey:key];
        }
    }
    
    [a pop]; // pop the {
    [a push:d];
}


- (void)workOnPropertyAssembly:(TDAssembly)a {
    var value = [a pop];
    var tok = [a pop];
    var key = tok.stringValue.substr(1, -1);
    
    [a push:key];
    [a push:value];
}

@end
