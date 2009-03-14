@import "TDToken.j"

@implementation TDComment

+ (id)comment
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return tok.isComment;
}

@end