@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDNum : TDTerminal 
{
    
}

+ (id)num
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return tok.isNumber;
}

@end