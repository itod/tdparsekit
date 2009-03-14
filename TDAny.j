@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDAny : TDTerminal
{
}

+ (id)any
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return [obj isKindOfClass:[TDToken class]];
}

@end
