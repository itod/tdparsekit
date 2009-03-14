@import "TDToken.j"

@implementation TDQuotedString

+ (id)quotedString
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return tok.isQuotedString;
}

@end
