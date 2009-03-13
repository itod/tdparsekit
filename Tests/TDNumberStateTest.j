@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDNumberState.j"

@implementation TDNumberStateTest : OJTestCase
{
    TDTokenizer t;
    TDReader r;
    TDNumberState ns;
}

- (void)setUp
{
    t = [[TDTokenizer alloc] init];
    r = [[TDReader alloc] init];
    ns = t.numberState;
}

- (void)testSingleDigit
{
    s = @"3";
    [t setString:s];
    [r setString:s];
    
    var c = [r read];
    [self assert:c equals:"3"];
    
    var tok = [ns nextTokenFromReader:r startingWith:c tokenizer:t];
    [self assert:3.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"3" equals:tok.stringValue];
}

- (void)testDoubleDigit
{
    s = @"47";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:47.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"47" equals:tok.stringValue];
}

- (void)testTripleDigit
{
    s = @"654";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:654.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"654" equals:tok.stringValue];
}

- (void)testSingleDigitPositive
{
    s = "+3";
    [t setString:s];
    [r setString:s];

    var c = [r read];
    [self assert:c equals:"+"];
    
    var tok = [ns nextTokenFromReader:r startingWith:c tokenizer:t];
    [self assert:3.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:"+3" equals:tok.stringValue];
}

- (void)testDoubleDigitPositive
{
    s = @"+22";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:22.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
}

// - (void)testDoubleDigitPositiveSpace
// {
//     s = @"+22 ";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:22.0 equals:tok.floatValue];
//     [self assertTrue:tok.isNumber];
// }

- (void)testMultipleDots
{
    s = @"1.1.1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"1.1" equals:tok.stringValue];

    tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@".1" equals:tok.stringValue];
}

- (void)testOneDot
{
    s = @"1.";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"1" equals:tok.stringValue];
}

- (void)testCustomOneDot
{
    s = @"1.";
    [t setString:s];
    [r setString:s];
    ns.allowsTrailingDot = YES;
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"1." equals:tok.stringValue];    
}

- (void)testOneDotZero
{
    s = @"1.0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"1.0" equals:tok.stringValue];
}

- (void)testPositiveOneDot
{
    s = @"+1.";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+1" equals:tok.stringValue];
}

- (void)testPositiveOneDotCustom
{
    s = @"+1.";
    [t setString:s];
    [r setString:s];
    ns.allowsTrailingDot = YES;
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+1." equals:tok.stringValue];
}

- (void)testPositiveOneDotZero
{
    s = @"+1.0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+1.0" equals:tok.stringValue];
}

// - (void)testPositiveOneDotZeroSpace
// {
//     s = @"+1.0 ";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:1.0 equals:tok.floatValue];
//     [self assertTrue:tok.isNumber];
//     [self assert:@"+1.0" equals:tok.stringValue];
// }
// 
- (void)testNegativeOneDot
{
    s = @"-1.";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-1" equals:tok.stringValue];
}

- (void)testNegativeOneDotCustom
{
    s = @"-1.";
    [t setString:s];
    [r setString:s];
    ns.allowsTrailingDot = YES;
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-1." equals:tok.stringValue];
}

- (void)testNegativeOneDotSpace
{
    s = @"-1. ";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-1" equals:tok.stringValue];
}

- (void)testNegativeOneDotZero
{
    s = @"-1.0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-1.0" equals:tok.stringValue];
}

- (void)testNegativeOneDotZeroSpace
{
    s = @"-1.0 ";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-1.0" equals:tok.stringValue];
}

- (void)testOneDotOne
{
    s = @"1.1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"1.1" equals:tok.stringValue];
}

- (void)testZeroDotOne
{
    s = @"0.1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"0.1" equals:tok.stringValue];
}

- (void)testDotOne
{
    s = @".1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@".1" equals:tok.stringValue];
}

- (void)testDotZero
{
    s = @".0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@".0" equals:tok.stringValue];
}

- (void)testNegativeDotZero
{
    s = @"-.0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.0" equals:tok.stringValue];
}

- (void)testPositiveDotZero
{
    s = @"+.0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+.0" equals:tok.stringValue];
}

- (void)testPositiveDotOne
{
    s = @"+.1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+.1" equals:tok.stringValue];
}

- (void)testNegativeDotOne
{
    s = @"-.1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.1 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.1" equals:tok.stringValue];
}

- (void)testNegativeDotOneOne
{
    s = @"-.11";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.11 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.11" equals:tok.stringValue];
}

- (void)testNegativeDotOneOneOne
{
    s = @"-.111";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.111 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.111" equals:tok.stringValue];
}

- (void)testNegativeDotOneOneOneZero
{
    s = @"-.1110";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.111 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.1110" equals:tok.stringValue];
}

- (void)testNegativeDotOneOneOneZeroZero
{
    s = @"-.11100";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.111 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.11100" equals:tok.stringValue];
}

- (void)testNegativeDotOneOneOneZeroSpace
{
    s = @"-.1110 ";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.111 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-.1110" equals:tok.stringValue];
}

- (void)testZeroDotThreeSixtyFive
{
    s = @"0.365";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.365 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"0.365" equals:tok.stringValue];
}

- (void)testNegativeZeroDotThreeSixtyFive
{
    s = @"-0.365";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.365 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-0.365" equals:tok.stringValue];
}

- (void)testNegativeTwentyFourDotThreeSixtyFive
{
    s = @"-24.365";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-24.365 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-24.365" equals:tok.stringValue];
}

- (void)testTwentyFourDotThreeSixtyFive
{
    s = @"24.365";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:24.365 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"24.365" equals:tok.stringValue];
}

- (void)testZero
{
    s = @"0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"0" equals:tok.stringValue];
}

- (void)testNegativeOne
{
    s = @"-1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-1" equals:tok.stringValue];
}

- (void)testOne
{
    s = @"1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"1" equals:tok.stringValue];
}

- (void)testPositiveOne
{
    s = @"+1";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:1.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+1" equals:tok.stringValue];
}

- (void)testPositiveZero
{
    s = @"+0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+0" equals:tok.stringValue];
}

- (void)testPositiveZeroSpace
{
    s = @"+0 ";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"+0" equals:tok.stringValue];
}

- (void)testNegativeZero
{
    s = @"-0";
    [t setString:s];
    [r setString:s];
    var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
    [self assert:-0.0 equals:tok.floatValue];
    [self assertTrue:tok.isNumber];
    [self assert:@"-0" equals:tok.stringValue];
}

// - (void)testNull
// {
//     s = @"NULL";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testNil
// {
//     s = @"nil";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testEmptyString
// {
//     s = @"";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testDot
// {
//     s = @".";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testDotSpace
// {
//     s = @". ";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testDotSpaceOne
// {
//     s = @". 1";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testPlus
// {
//     s = @"+";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testPlusSpace
// {
//     s = @"+ ";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testPlusSpaceOne
// {
//     s = @"+ 1";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testMinus
// {
//     s = @"-";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testMinusSpace
// {
//     s = @"- ";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testMinusSpaceOne
// {
//     s = @"- 1";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//     [self assert:0.0 equals:tok.floatValue];
//     TDFalse(tok.isNumber];
// }
// 
// - (void)testInitSig
// {
//     s = @"- (id)init {";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//  [self assertTrue:tok.isSymbol];
//     [self assert:tok.stringValue equals:@"-"];
//     [self assert:0.0 equals:tok.floatValue];
// }
// 
// - (void)testInitSig2
// {
//     s = @"-(id)init {";
//     [t setString:s];
//     [r setString:s];
//     var tok = [ns nextTokenFromReader:r startingWith:[r read] tokenizer:t];
//  [self assertTrue:tok.isSymbol];
//     [self assert:tok.stringValue equals:@"-"];
//     [self assert:0.0 equals:tok.floatValue];
// }
// 
// - (void)testParenStuff
// {
//     s = @"-(ab+5)";
//     [t setString:s];
//     [r setString:s];
//     var tok = [t nextToken];
//  [self assertTrue:tok.isSymbol];
//     [self assert:tok.stringValue equals:@"-"];
//     [self assert:0.0 equals:tok.floatValue];
// 
//     tok = [t nextToken];
//  [self assertTrue:tok.isSymbol];
//     [self assert:tok.stringValue equals:@"("];
//     [self assert:0.0 equals:tok.floatValue];
// }

@end