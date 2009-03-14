@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDLiteral : TDTerminal
{
    TDToken literal;
}

+ (id)literalWithString:(CPString)s
{
    return [[self alloc] initWithString:s];
}

- (id)initWithString:(CPString)s
{
    //NSParameterAssert(s);
    if (self = [super initWithString:s]) {
        literal = [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:s floatValue:0.0];
    }
    return self;
}

- (BOOL)qualifies:(id)obj
{
    return [literal.stringValue isEqualToString:obj.stringValue];
    //return [literal isEqual:obj];
}

- (CPString)description
{
    CPString className = [[self className] substringFromIndex:2];
    if (name.length) {
        return [CPString stringWithFormat:@"%s (%s) %s", className, name, literal.stringValue];
    } else {
        return [CPString stringWithFormat:@"%s %s", className, literal.stringValue];
    }
}

@end
