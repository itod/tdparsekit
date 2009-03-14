@import "TDToken.j"

@implementation TDNum

+ (id)num
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj
{
    return tok.isNumber;
}

@end