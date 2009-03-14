@import "TDToken.j"

@implementation TDSymbol

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
    self = [super initWithString:s];
    if (self) {
        if (s.length) {
            self.symbol = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:s floatValue:0.0];
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
    CPString className = [[self className] substringFromIndex:2];
    if (name.length) {
        if (symbol) {
            return [CPString stringWithFormat:@"%@ (%@) %@", className, name, symbol.stringValue];
        } else {
            return [CPString stringWithFormat:@"%@ (%@)", className, name];
        }
    } else {
        if (symbol) {
            return [CPString stringWithFormat:@"%@ %@", className, symbol.stringValue];
        } else {
            return [CPString stringWithFormat:@"%@", className];
        }
    }
}

@end
