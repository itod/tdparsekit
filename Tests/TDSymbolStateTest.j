@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDSymbolState.j"

@implementation TDSymbolStateTest : OJTestCase
{
    CPString s;
    TDTokenizer t;
    TDReader r;
    TDWhitespaceState ss;
}

- (void)setUp
{
    ss = [[TDSymbolState alloc] init];
    r = [[TDReader alloc] init];
}

- (void)testDot
{
    s = @".";
    [r setString:s];
    
    var c = [r read];
    [self assert:String.fromCharCode(c) equals:'.'];
    
    var tok = [ss nextTokenFromReader:r startingWith:c tokenizer:nil];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:-1 equals:[r read]];
}

- (void)testDotA
{
    s = @".a";
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testDotSpace
{
    s = @". ";
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:' '.charCodeAt(0) equals:[r read]];
}

- (void)testDotDot
{
    s = @"..";
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:'.'.charCodeAt(0) equals:[r read]];
}



- (void)testAddDotDot
{
    s = @"..";
    [ss add:s];
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@".." equals:tok.stringValue];
    [self assert:@".." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:-1 equals:[r read]];
}

- (void)testAddDotDotSpace
{
    s = @".. ";
    [ss add:@".."];
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@".." equals:tok.stringValue];
    [self assert:@".." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:' '.charCodeAt(0) equals:[r read]];
}

- (void)testAddColonEqual
{
    s = @":=";
    [ss add:s];
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@":=" equals:tok.stringValue];
    [self assert:@":=" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:-1 equals:[r read]];
}

- (void)testAddColonEqualSpace
{
    s = @":= ";
    [ss add:@":="];
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@":=" equals:tok.stringValue];
    [self assert:@":=" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:' '.charCodeAt(0) equals:[r read]];
}

- (void)testAddGtEqualLtSpace
{
    s = @">=< ";
    [ss add:@">=<"];
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:' '.charCodeAt(0) equals:[r read]];
}

- (void)testAddGtEqualLt
{
    s = @">=<";
    [ss add:s];
    [r setString:s];
    var tok = [ss nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    [self assert:-1 equals:[r read]];
}

- (void)testTokenzierAddGtEqualLt
{
    s = @">=<";
    var t = [TDTokenizer tokenizerWithString:s];
    [self assertNotNull:t];
    
    [t.symbolState add:s];
    var tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok.isSymbol];
    
    [self assert:s equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddGtEqualLtSpaceFoo
{
    s = @">=< foo";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    var tok = [t nextToken];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];

    // tok = [t nextToken];
    // [self assert:@"foo" equals:tok.stringValue];
    // [self assert:@"foo" equals:[tok value]];
    // [self assertTrue:tok.isWord];
    // 
    // [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddGtEqualLtFoo
{
    s = @">=<foo";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    var tok = [t nextToken];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    // tok = [t nextToken];
    // [self assert:@"foo" equals:tok.stringValue];
    // [self assert:@"foo" equals:[tok value]];
    // [self assertTrue:tok.isWord];
    // 
    // [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddGtEqualLtDot
{
    s = @">=<.";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    var tok = [t nextToken];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddGtEqualLtSpaceDot
{
    s = @">=< .";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    var tok = [t nextToken];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddGtEqualLtSpaceDotSpace
{
    s = @">=< . ";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@">=<"];
    var tok = [t nextToken];
    [self assert:@">=<" equals:tok.stringValue];
    [self assert:@">=<" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddLtBangDashDashSpaceDotSpace
{
    s = @"<!-- . ";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"<!--"];
    var tok = [t nextToken];
    [self assert:@"<!--" equals:tok.stringValue];
    [self assert:@"<!--" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddDashDashGt
{
    s = @"-->";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"-->"];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"-->" equals:tok.stringValue];
    [self assert:@"-->" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddDashDashGtSpaceDot
{
    s = @"--> .";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"-->"];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"-->" equals:tok.stringValue];
    [self assert:@"-->" equals:[tok value]];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddDashDashGtSpaceDotSpace
{
    s = @"--> . ";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"-->"];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"-->" equals:tok.stringValue];
    [self assert:@"-->" equals:[tok value]];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddDashDash
{
    s = @"--";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"--"];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"--" equals:tok.stringValue];
    [self assert:@"--" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddDashDashSpaceDot
{
    s = @"-- .";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"--"];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"--" equals:tok.stringValue];
    [self assert:@"--" equals:[tok value]];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierAddDashDashSpaceDotSpace
{
    s = @"-- . ";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"--"];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"--" equals:tok.stringValue];
    [self assert:@"--" equals:[tok value]];
    
    tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assert:@"." equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualEqualEqualButNotEqual
{
    s = @"=";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualEqualEqualButNotEqualEqual
{
    s = @"==";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"==" equals:tok.stringValue];
    [self assert:@"==" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualEqualEqualCompareEqualEqualEqualEqual
{
    s = @"====";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"===" equals:tok.stringValue];
    [self assert:@"===" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualEqualEqualCompareEqualEqualEqualEqualEqual
{
    s = @"=====";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"===" equals:tok.stringValue];
    [self assert:@"===" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"==" equals:tok.stringValue];
    [self assert:@"==" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualEqualEqualCompareEqualEqualEqualEqualEqualSpaceEqual
{
    s = @"===== =";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"==="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"===" equals:tok.stringValue];
    [self assert:@"===" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"==" equals:tok.stringValue];
    [self assert:@"==" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualEqualEqualEqual
{
    s = @"====";
    var t = [TDTokenizer tokenizerWithString:s];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"==" equals:tok.stringValue];
    [self assert:@"==" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"==" equals:tok.stringValue];
    [self assert:@"==" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualColonEqualButNotEqualColon
{
    s = @"=:";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"=:="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    tok = [t nextToken];
    [self assert:@":" equals:tok.stringValue];
    [self assert:@":" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierRemoveEqualEqual
{
    s = @"==";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState remove:@"=="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierRemoveEqualEqualAddEqualEqual
{
    s = @"====";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState remove:@"=="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=" equals:tok.stringValue];
    [self assert:@"=" equals:[tok value]];
    
    [t.symbolState add:@"=="];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"==" equals:tok.stringValue];
    [self assert:@"==" equals:[tok value]];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

- (void)testTokenzierEqualColonEqualAndThenEqualColonEqualColon
{
    s = @"=:=:";
    var t = [TDTokenizer tokenizerWithString:s];
    [t.symbolState add:@"=:="];
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:@"=:=" equals:tok.stringValue];
    [self assert:@"=:=" equals:[tok value]];
    
    tok = [t nextToken];
    [self assert:@":" equals:tok.stringValue];
    [self assert:@":" equals:[tok value]];
    [self assertTrue:tok.isSymbol];
    
    [self assertTrue:([TDToken EOFToken] === [t nextToken])];
}

@end
