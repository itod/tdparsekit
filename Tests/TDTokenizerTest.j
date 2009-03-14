@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDWordState.j"
@import "../TDQuoteState.j"
@import "../TDNumberState.j"
@import "../TDScientificNumberState.j"
@import "../TDWhitespaceState.j"
@import "../TDCommentState.j"

@implementation TDTokenizerTest : OJTestCase
{
    CPString s;
    TDTokenizer t;
    TDReader r;
}

- (void)setUp
{
    t = [[TDTokenizer alloc] init];
    r = t.reader;
    
}

- (void)testBlastOff
{
    s = "\"It's 123 blast-off!\" equals:she said equals:// watch out!\n" +
        "and <= 3 'ticks' later /* wince */ equals:it's blast-off!";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = nil;
    
    //NSLog(@"\n\n starting!!! \n\n"];
    while ((tok = [t nextToken]) != eof) {
        //NSLog(@"(%@)" equals:tok.stringValue];
    }
    //NSLog(@"\n\n done!!! \n\n"];
    
}

- (void)testStuff
{
    s = @"2 != 47. Blast-off!! 'Woo-hoo!'";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = nil;
    
    while ((tok = [t nextToken]) != eof) {
        //NSLog(@"(%@) (%.1f) : %@" equals:tok.stringValue equals:tok.floatValue equals:[tok debugDescription]];
    }
}

- (void)testStuff2
{
    s = @"2 != 47. Blast-off!! 'Woo-hoo!'";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = nil;
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"2"];
    [self assert:[tok value] equals:2.0];

    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"!="];
    [self assert:[tok value] equals:@"!="];

    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"47"];
    [self assert:[tok value] equals:47.0];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"."];
    [self assert:[tok value] equals:@"."];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"Blast-off"];
    [self assert:[tok value] equals:@"Blast-off"];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"!"];
    [self assert:[tok value] equals:@"!"];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"!"];
    [self assert:[tok value] equals:@"!"];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isQuotedString];
    [self assert:tok.stringValue equals:@"'Woo-hoo!'"];
    [self assert:[tok value] equals:@"'Woo-hoo!'"];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok == eof];
}

- (void)testFortySevenDot
{
    s = @"47.";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = nil;
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"47"];
    [self assert:[tok value] equals:47.0];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"."];
    [self assert:[tok value] equals:@"."];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok == eof];
}

- (void)testFortySevenDotSpaceFoo
{
    s = @"47. foo";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = nil;
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"47"];
    [self assert:[tok value] equals:47.0];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"."];
    [self assert:[tok value] equals:@"."];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok != eof];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"foo"];
    [self assert:[tok value] equals:@"foo"];
    
    tok = [t nextToken];
    [self assertNotNull:tok];
    [self assertTrue:tok == eof];
}

- (void)testDotOne
{
    s = @"   .999";
    t = [TDTokenizer tokenizerWithString:s];
    
    var tok = [t nextToken];
    [self assert:0.999 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];

//    if ([TDToken EOFToken] == token) break;
    
}

- (void)testSpaceDotSpace
{
    s = @" . ";
    t = [TDTokenizer tokenizerWithString:s];
    
    var tok = [t nextToken];
    [self assert:@"." equals:tok.stringValue];
    [self assertTrue:tok.isSymbol];
    
    //    if ([TDToken EOFToken] == token) break;
    
}

- (void)testInitSig
{
    s = @"- (id)init {";
    t = [TDTokenizer tokenizerWithString:s];
    
    var tok = [t nextToken];
    [self assert:@"-" equals:tok.stringValue];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isSymbol];

    tok = [t nextToken];
    [self assert:@"(" equals:tok.stringValue];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isSymbol];
}

- (void)testInitSig2
{
    s = @"-(id)init {";
    t = [TDTokenizer tokenizerWithString:s];
    
    var tok = [t nextToken];
    [self assert:@"-" equals:tok.stringValue];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isSymbol];
 
    tok = [t nextToken];
    [self assert:@"(" equals:tok.stringValue];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isSymbol];
}

- (void)testMinusSpaceTwo
{
    s = @"- 2";
    t = [TDTokenizer tokenizerWithString:s];
    
    var tok = [t nextToken];
    [self assert:@"-" equals:tok.stringValue];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isSymbol];
    
    tok = [t nextToken];
    [self assert:@"2" equals:tok.stringValue];
    [self assert:2.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
}

- (void)testMinusPlusTwo
{
    s = @"+2";
    t = [TDTokenizer tokenizerWithString:s];
    
    var tok = [t nextToken];
    [self assert:@"+" equals:tok.stringValue];
    [self assertTrue:tok.isSymbol];

    tok = [t nextToken];
    [self assert:2.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"2" equals:tok.stringValue];

    [self assert:[TDToken EOFToken] same:[t nextToken]];
}

- (void)testMinusPlusTwoCustom
{
    s = @"+2";
    t = [TDTokenizer tokenizerWithString:s];
    [t setTokenizerState:t.numberState from:'+'.charCodeAt(0) to:'+'.charCodeAt(0)];
    
    var tok = [t nextToken];
    [self assert:2.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+2" equals:tok.stringValue];
    
    [self assert:[TDToken EOFToken] same:[t nextToken]];
}

- (void)testSimpleAPIUsage
{
    s = @".     equals:   ()  12.33333 .:= .456\n\n>=<     'boooo'fasa  this should /*     not*/ appear \r /*but  */this should >=<//n't";

    t = [TDTokenizer tokenizerWithString:s];
    
    [t.symbolState add:@":="];
    [t.symbolState add:@">=<"];
    
    var toks = [];
    
    var eof = [TDToken EOFToken];
    var token = nil;
    while (token = [t nextToken]) {
        if (eof === token) break;
        
        [toks addObject:token];

    }

    //NSLog(@"\n\n\n\ntoks: %@\n\n\n\n" equals:toks];
}

- (void)testKatakana1
{
    s = @"ア";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = [t nextToken];
    
    [self assertNotNull:tok];
    [self assertTrue:tok.isWord];
    [self assert:s equals:tok.stringValue];
    
    tok = [t nextToken];
    [self assert:eof same:tok];
}

- (void)testKatakana2
{
    s = @"アア";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = [t nextToken];
    
    [self assertNotNull:tok];
    [self assertTrue:tok.isWord];
    [self assert:s equals:tok.stringValue];
    
    tok = [t nextToken];
    [self assert:eof same:tok];
}

- (void)testKatakana3
{
    s = @"アェ";
    t = [TDTokenizer tokenizerWithString:s];
    
    var eof = [TDToken EOFToken];
    var tok = [t nextToken];
    
    [self assertNotNull:tok];
    [self assertTrue:tok.isWord];
    [self assert:s equals:tok.stringValue];
    
    tok = [t nextToken];
    [self assert:eof same:tok];
}

- (void)testParenStuff
{
    s = @"-(ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
 
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"-"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"("];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"ab"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"+"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"5"];
    [self assert:5.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@")"];
    [self assert:0.0 equals:tok.floatValue];
}

- (void)testParenStuff2
{
    s = @"- (ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;

    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"-"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"("];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"ab"];
    [self assert:0.0 equals:tok.floatValue];
}

- (void)testParenStuff3
{
    s = @"+(ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
 
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"+"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"("];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"ab"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"+"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"5"];
    [self assert:5.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@")"];
    [self assert:0.0 equals:tok.floatValue];
}

- (void)testParenStuff4
{
    s = @"+ (ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;

    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"+"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"("];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"ab"];
    [self assert:0.0 equals:tok.floatValue];
}

- (void)testParenStuff5
{
    s = @".(ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
 
    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"."];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"("];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"ab"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"+"];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isNumber];
    [self assert:tok.stringValue equals:@"5"];
    [self assert:5.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@")"];
    [self assert:0.0 equals:tok.floatValue];
}

- (void)testParenStuff6
{
    s = @". (ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;

    var tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"."];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWhitespace];
    [self assert:tok.stringValue equals:@" "];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isSymbol];
    [self assert:tok.stringValue equals:@"("];
    [self assert:0.0 equals:tok.floatValue];

    tok = [t nextToken];
    [self assertTrue:tok.isWord];
    [self assert:tok.stringValue equals:@"ab"];
    [self assert:0.0 equals:tok.floatValue];
}

- (void)testParenStuff7
{
    s = @"-(ab+5)";
    t = [TDTokenizer tokenizerWithString:s];
    
    var s1 = "";
    
    var eof = [TDToken EOFToken];
    var tok = nil;
    while ((tok = [t nextToken]) != eof) {
        s1 += tok.stringValue;
    }
    
    [self assertNotNull:tok];
    [self assert:s1 equals:s];
    [self assert:eof same:[t nextToken]];
}

@end
