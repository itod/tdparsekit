@import "TDToken.j"

@implementation TDCaseInsensitiveLiteral

- (BOOL)qualifies:(id)obj
{
    return CPOrderedSame == [literal.stringValue caseInsensitiveCompare:obj.stringValue];
//    return [literal isEqualIgnoringCase:obj];
}

@end
