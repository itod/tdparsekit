@import "TDToken.j"

@implementation TDLowercaseWord : TDWord
{
    
}

- (BOOL)qualifies:(id)obj
{
    if (!obj.isWord) {
        return NO;
    }
    
    CPString s = obj.stringValue;
    return s.length && islower([s characterAtIndex:0]);
}

@end
