@import "TDToken.j"

@implementation TDUppercaseWord

- (BOOL)qualifies:(id)obj
{
    if (!obj.isWord) {
        return NO;
    }
    
    CPString s = tok.stringValue;
    return s.length && isupper([s characterAtIndex:0]);
}

@end
