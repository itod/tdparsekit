@import "TDToken.j"

@implementation TDUppercaseWord : TDWord {
    
}

- (BOOL)qualifies:(id)obj
{
    if (!obj.isWord) {
        return NO;
    }
    
    var s = tok.stringValue;
    if (!s.length)
        return NO;
        
    var c = s.charCodeAt(0);
    return c >= 'A'.charCodeAt(0) && c <= 'Z'.charCodeAt(0);
}

@end
