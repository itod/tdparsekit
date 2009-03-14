@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDQuoteState.j"

@implementation TDQuoteStateTest : OJTestCase
{
    CPString s;
    TDTokenizer t;
    TDReader r;
    TDQuoteState qs;
}

- (void)setUp
{
    qs = [[TDQuoteState alloc] init];
    r = [[TDReader alloc] init];
}

- (void)testQuotedString
{
    s = @"'stuff'";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    
}

- (void)testQuotedStringEOFTerminated
{
    s = @"'stuff";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
}

- (void)testQuotedStringRepairEOFTerminated
{
    s = @"'stuff";
    [r setString:s];
    qs.balancesEOFTerminatedQuotes = YES;
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"'stuff'" equals:tok.stringValue];
}

- (void)testQuotedStringPlus
{
    s = @"'a quote here' more";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:@"'a quote here'" equals:tok.stringValue];
}

- (void)test14CharQuotedString
{
    s = @"'123456789abcef'";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assertTrue:tok.isQuotedString];
}

- (void)test15CharQuotedString
{
    s = @"'123456789abcefg'";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assertTrue:tok.isQuotedString];
}

- (void)test16CharQuotedString
{
    s = @"'123456789abcefgh'";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assertTrue:tok.isQuotedString];
}

- (void)test31CharQuotedString
{
    s = @"'123456789abcefgh123456789abcefg'";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assertTrue:tok.isQuotedString];
}

- (void)test32CharQuotedString
{
    s = @"'123456789abcefgh123456789abcefgh'";
    [r setString:s];
    var tok = [qs nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assert:s equals:tok.stringValue];
    [self assertTrue:tok.isQuotedString];
}

@end
