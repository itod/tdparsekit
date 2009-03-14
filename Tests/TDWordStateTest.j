@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDWordState.j"

@implementation TDWordStateTest : OJTestCase
{
    CPString s;
    TDTokenizer t;
    TDReader r;
    TDWordState ws;
}

- (void)setUp
{
    ws = [[TDWordState alloc] init];
    r = [[TDReader alloc] init];
}

- (void)testA
{
    s = @"a";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"a" equals:tok.stringValue];
    [self assert:@"a" equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

- (void)testASpace
{
    s = @"a ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"a" equals:tok.stringValue];
    [self assert:@"a" equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:' '.charCodeAt(0) equals:[r read]];
}

- (void)testAb
{
    s = @"ab";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assert:s equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

- (void)testAbc
{
    s = @"abc";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assert:s equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

- (void)testItApostropheS
{
    s = @"it's";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assert:s equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

- (void)testTwentyDashFive
{
    s = @"twenty-five";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assert:s equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

- (void)testTwentyUnderscoreFive
{
    s = @"twenty_five";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assert:s equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

- (void)testNumber1
{
    s = @"number1";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assert:s equals:[tok value]];
    [self assertTrue:tok.isWord];
    [self assert:-1 equals:[r read]];
}

@end
