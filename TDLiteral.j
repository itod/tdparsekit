@import "TDToken.j"

@implementation TDLiteral

+ (id)literalWithString:(CPString)s
{
    return [[self alloc] initWithString:s];
}

- (id)initWithString:(CPString)s
{
    //NSParameterAssert(s);
    self = [super initWithString:s];
    if (self) {
        self.literal = [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:s floatValue:0.0];
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
        return [CPString stringWithFormat:@"%@ (%@) %@", className, name, literal.stringValue];
    } else {
        return [CPString stringWithFormat:@"%@ %@", className, literal.stringValue];
    }
}

@end
