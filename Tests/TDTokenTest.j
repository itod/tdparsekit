@import "../TDToken.j"

@implementation TDTokenTest : OJTestCase
{
    TDToken eof;
}

- (void)setUp
{
    eof = [TDToken EOFToken];
}

- (void)testEOFTokenCopyIdentity
{
    var copy = [eof copy];
    [self assertTrue:(copy === eof)];
}

- (void)testProperties
{
    var tok = [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:@"foo" floatValue:0];
    [self assertTrue:tok != nil];
    [self assert:tok.stringValue equals:@"foo"];
    [self assert:tok.floatValue equals:0];
    [self assert:tok.tokenType equals:TDTokenTypeWord];
    [self assertTrue:tok.isWord];
}

@end
