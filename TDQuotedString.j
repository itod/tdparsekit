@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDQuotedString : TDTerminal
{
    
}

+ (id)quotedString
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return tok.isQuotedString;
}

@end
