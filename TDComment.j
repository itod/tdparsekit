@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDComment : TDTerminal
{
    
}

+ (id)comment
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return tok.isComment;
}

@end