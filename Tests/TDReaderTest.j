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
        [self assert:string.charCodeAt(i) equals:[reader read]];
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
    [self assert:a.charCodeAt(0) equals:[reader read]];

    [reader read];
    [reader read];
    [reader unread];
    var c = 'c';
    [self assert:c.charCodeAt(0) equals:[reader read]];
}

- (void)testUnreadTooFar
{
    [reader unread];
    var a = 'a';
    [self assert:a.charCodeAt(0) equals:[reader read]];

    [reader unread];
    [reader unread];
    [reader unread];
    [reader unread];
    [self assert:a.charCodeAt(0) equals:[reader read]];
}

@end