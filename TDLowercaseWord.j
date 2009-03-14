@import "TDToken.j"

@implementation TDLowercaseWord : TDWord
{
    
}

- (BOOL)qualifies:(id)obj
{
    if (!obj.isWord) {
        return NO;
    }
    
    var s = obj.stringValue;
    if (!s.length)
        return NO;
        
    var c = s.charCodeAt(0);
    return c >= 'a'.charCodeAt(0) && c <= 'z'.charCodeAt(0);
}

@end
