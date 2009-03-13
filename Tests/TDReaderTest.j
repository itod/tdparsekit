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
