@import "../TDReader.j"

@implementation TDReaderTest : OJTestCase
{
    var string;
    TDReader reader;
}

- (void)setUp
{
    string = @"abcdefghijklmnopqrstuvwxyz";
    reader = [[TDReader alloc] initWithString:string];
}

- (void)tearDown
{
    [string release];
    [reader release];
}

- (void)testReadCharsMatch
{
    for (var i = 0; i < [string length]; i++) {
        var c = [string characterAtIndex:i];
        [self assert:c equals:[reader read]];
    }
}

- (void)testReadTooFar
{
    for (var i = 0; i < [string length]; i++) {
        [reader read];
    }
    [self assert:-1 equals:[reader read]];
}

- (void)testUnread
{
    [reader read];
    [reader unread];
    var a = 'a';
    [self assert:a equals:[reader read]];

    [reader read];
    [reader read];
    [reader unread];
    var c = 'c';
    [self assert:c equals:[reader read]];
}

- (void)testUnreadTooFar
{
    [reader unread];
    var a = 'a';
    [self assert:a equals:[reader read]];

    [reader unread];
    [reader unread];
    [reader unread];
    [reader unread];
    var a2 = 'a';
    [self assert:a2 equals:[reader read]];
}

@end