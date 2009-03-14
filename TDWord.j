@import "TDTerminal.j"
@import "TDToken.j"

@implementation TDWord : TDTerminal {
    
}

+ (id)word
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return obj.isWord;
}

@end
