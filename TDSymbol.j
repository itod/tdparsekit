@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDSymbol : TDTerminal
{
    TDToken symbol;
}

+ (id)symbol
{
    return [[self alloc] initWithString:nil];
}


+ (id)symbolWithString:(CPString)s
{
    return [[self alloc] initWithString:s];
}

- (id)initWithString:(CPString)s
{
    if (self = [super initWithString:s]) {
        if (s.length) {
            symbol = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:s floatValue:0.0];
        }
    }
    return self;
}

- (BOOL)qualifies:(id)obj
{
    if (symbol) {
        return [symbol isEqual:obj];
    } else {
        return tok.isSymbol;
    }
}

- (CPString)description
{
    var className = [[self className] substringFromIndex:2];
    if (name.length) {
        if (symbol) {
            return [CPString stringWithFormat:@"%s (%s) %s", className, name, symbol.stringValue];
        } else {
            return [CPString stringWithFormat:@"%s (%s)", className, name];
        }
    } else {
        if (symbol) {
            return [CPString stringWithFormat:@"%s %s", className, symbol.stringValue];
        } else {
            return [CPString stringWithFormat:@"%s", className];
        }
    }
}

@end
