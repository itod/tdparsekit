@import "../TDReader.j"
@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDWhitespaceState.j"

@implementation TDWhitespaceStateTest : OJTestCase
{
    CPString s;
    TDTokenizer t;
    TDReader r;
    TDWhitespaceState ws;
}

- (void)setUp
{
    ws = [[TDWhitespaceState alloc] init];
    r = [[TDReader alloc] init];
}

- (void)testSpace
{
    s = @" ";
    [r setString:s];
    
    var c = [r read];
    [self assert:String.fromCharCode(c) equals:@" "];
    
    var tok = [ws nextTokenFromReader:r startingWith:c tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testTwoSpaces
{
    s = @"  ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testNil
{
    s = nil;
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testNull
{
    s = NULL;
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testEmptyString
{
    s = @"";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testTab
{
    s = @"\t";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testNewLine
{
    s = @"\n";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testCarriageReturn
{
    s = @"\r";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testSpaceCarriageReturn
{
    s = @" \r";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testSpaceTabNewLineSpace
{
    s = @" \t\n ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:-1 equals:[r read]];
}

- (void)testSpaceA
{
    s = @" a";
    [r setString:s];
    
    var c = [r read];
    [self assert:String.fromCharCode(c) equals:' '];
    
    var tok = [ws nextTokenFromReader:r startingWith:c tokenizer:nil];
    [self assertNull:tok];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSpaceASpace
{
    s = @" a ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testTabA
{
    s = @"\ta";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testNewLineA
{
    s = @"\na";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testCarriageReturnA
{
    s = @"\ra";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testNewLineSpaceCarriageReturnA
{
    s = @"\n \ra";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNull:tok];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSignificantSpace
{
    ws.reportsWhitespaceTokens = YES;
    s = @" ";
    [r setString:s];
    
    var c = [r read];
    [self assert:String.fromCharCode(c) equals:' '];
    
    var tok = [ws nextTokenFromReader:r startingWith:c tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantTwoSpaces
{
    ws.reportsWhitespaceTokens = YES;
    s = @"  ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantEmptyString
{
    ws.reportsWhitespaceTokens = YES;
    s = @"";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantTab
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\t";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantNewLine
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\n";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantCarriageReturn
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\r";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantSpaceCarriageReturn
{
    ws.reportsWhitespaceTokens = YES;
    s = @" \r";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantSpaceTabNewLineSpace
{
    ws.reportsWhitespaceTokens = YES;
    s = @" \t\n ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:s equals:tok.stringValue];
    [self assert:-1 equals:[r read]];
}

- (void)testSignificantSpaceA
{
    ws.reportsWhitespaceTokens = YES;
    s = @" a";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:@" " equals:tok.stringValue];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSignificantSpaceASpace
{
    ws.reportsWhitespaceTokens = YES;
    s = @" a ";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:@" " equals:tok.stringValue];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSignificantTabA
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\ta";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:@"\t" equals:tok.stringValue];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSignificantNewLineA
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\na";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:@"\n" equals:tok.stringValue];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSignificantCarriageReturnA
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\ra";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:@"\r" equals:tok.stringValue];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

- (void)testSignificantNewLineSpaceCarriageReturnA
{
    ws.reportsWhitespaceTokens = YES;
    s = @"\n \ra";
    [r setString:s];
    var tok = [ws nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    [self assertNotNull:tok];
    [self assert:@"\n \r" equals:tok.stringValue];
    [self assert:'a'.charCodeAt(0) equals:[r read]];
}

@end