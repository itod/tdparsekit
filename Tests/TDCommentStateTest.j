@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDCommentState.j"

@implementation TDCommentStateTest : OJTestCase
{
    CPString s;
    TDTokenizer t;
    TDReader r;
    TDCommentState cs;
    TDToken tok;
}

- (void)setUp
{
    r = [[TDReader alloc] init];
    t = [[TDTokenizer alloc] init];
    cs = t.commentState;
}

- (void)testSlashSlashFoo
{
    s = @"// foo";
    [r setString:s];
    [t setString:s];
    tok = [cs nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:tok same:[TDToken EOFToken]];
    [self assert:[r read] equals:-1];
}

- (void)testReportSlashSlashFoo
{
    s = @"// foo";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:s];
    [self assert:[t nextToken] same:[TDToken EOFToken]];
    //[self assert:[r read] equals:-1];
}

- (void)testTurnOffSlashSlashFoo
{
    s = @"// foo";
    [r setString:s];
    [t setString:s];
    [cs removeSingleLineStartSymbol:@"//"];
    tok = [cs nextTokenFromReader:r startingWith:'/'.charCodeAt(0) tokenizer:t];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"/"];
    [self assert:[r read] equals:'/'.charCodeAt(0)];
}

- (void)testHashFoo
{
    s = @"# foo";
    [r setString:s];
    [t setString:s];
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"#"];
    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"foo"];

    [r setString:s];
    [t setString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"#"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testAddHashFoo
{
    s = @"# foo";
    [r setString:s];
    [t setString:s];
    [cs addSingleLineStartSymbol:@"#"];
    [t setTokenizerState:cs from:'#'.charCodeAt(0) to:'#'.charCodeAt(0)];
    tok = [cs nextTokenFromReader:r startingWith:'#'.charCodeAt(0) tokenizer:t];
    [self assert:tok same:[TDToken EOFToken]];
    [self assert:[r read] equals:-1];
}

- (void)testReportAddHashFoo
{
    s = @"# foo";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    [cs addSingleLineStartSymbol:@"#"];
    [t setTokenizerState:cs from:'#'.charCodeAt(0) to:'#'.charCodeAt(0)];
    tok = [cs nextTokenFromReader:r startingWith:'#'.charCodeAt(0) tokenizer:t];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:s];
    [self assert:[r read] equals:-1];
}

- (void)testSlashStarFooStarSlash
{
    s = @"/* foo */";
    [r setString:s];
    [t setString:s];
    tok = [cs nextTokenFromReader:r startingWith:'/'.charCodeAt(0) tokenizer:t];
    [self assert:tok same:[TDToken EOFToken]];
    [self assert:[r read] equals:-1];
}

- (void)testSlashStarFooStarSlashSpace
{
    s = @"/* foo */ ";
    [r setString:s];
    [t setString:s];
    tok = [cs nextTokenFromReader:r startingWith:'/'.charCodeAt(0) tokenizer:t];
    [self assert:tok same:[TDToken EOFToken]];
    [self assert:[r read] equals:-1];
}

- (void)testReportSlashStarFooStarSlash
{
    s = @"/* foo */";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    [self assert:[t nextToken] same:[TDToken EOFToken]];
}

- (void)testReportSlashStarFooStarSlashSpace
{
    s = @"/* foo */ ";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    tok = [t nextToken];
    [self assert:tok same:[TDToken EOFToken]];

    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testReportSlashStarFooStarSlashSpaceA
{
    s = @"/* foo */ a";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"a"];
    
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testReportSlashStarStarFooStarSlashSpaceA
{
    s = @"/** foo */ a";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/** foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"a"];
    
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/** foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testReportSlashStarFooStarStarSlashSpaceA
{
    s = @"/* foo **/ a";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo **/"];
    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"a"];
    
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo **/"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testReportSlashStarFooStarSlashSpaceStarSlash
{
    s = @"/* foo */ */";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"*"];
    
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testTurnOffSlashStarFooStarSlash
{
    s = @"/* foo */";
    [r setString:s];
    [t setString:s];
    [cs removeMultiLineStartSymbol:@"/*"];
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"/"];
}

- (void)testReportSlashStarFooStar
{
    s = @"/* foo *";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:s];
}

- (void)testReportBalancedSlashStarFooStar
{
    s = @"/* foo *";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    cs.balancesEOFTerminatedComments = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo **/"];
}

- (void)testReportBalancedSlashStarFoo
{
    s = @"/* foo ";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    cs.balancesEOFTerminatedComments = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"/* foo */"];
}

- (void)testXMLFooStarXMLA
{
    s = @"<!-- foo --> a";
    [r setString:s];
    [t setString:s];
    [cs addMultiLineStartSymbol:@"<!--" endSymbol:@"-->"];
    [t setTokenizerState:cs from:'<'.charCodeAt(0) to:'<'.charCodeAt(0)];
    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"a"];
    
    [r setString:s];
    [t setString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

- (void)testReportXMLFooStarXMLA
{
    s = @"<!-- foo --> a";
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    [cs addMultiLineStartSymbol:@"<!--" endSymbol:@"-->"];
    [t setTokenizerState:cs from:'<'.charCodeAt(0) to:'<'.charCodeAt(0)];
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"<!-- foo -->"];
    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"a"];
    
    [r setString:s];
    [t setString:s];
    cs.reportsCommentTokens = YES;
    t.whitespaceState.reportsWhitespaceTokens = YES;
    tok = [t nextToken];
    [self assertTrue:tok.isComment];
    [self assert:tok.stringValue equals:@"<!-- foo -->"];
    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
}

@end
