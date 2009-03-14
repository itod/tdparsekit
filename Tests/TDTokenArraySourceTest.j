@import "../TDTokenizer.j"
@import "../TDToken.j"
@import "../TDTokenArraySource.j"

@implementation TDTokenArraySourceTest : OJTestCase
{
    CPString d;
    CPString s;
    TDTokenizer t;
    TDTokenArraySource tas;
}

- (void)setUp
{
        
}

- (void)testFoo
{
    d = @";";
    s = @"I came; I saw; I left in peace.;";
    t = [[TDTokenizer alloc] initWithString:s];
    tas = [[TDTokenArraySource alloc] initWithTokenizer:t delimiter:d];
    
    [self assertTrue:[tas hasMore]];
    var a = [tas nextTokenArray];
    [self assertNotNull:a];
    [self assert:2 equals:a.count];
    [self assert:@"I" equals:[a objectAtIndex:0].stringValue];
    [self assert:@"came" equals:[a objectAtIndex:1].stringValue];

    [self assertTrue:[tas hasMore]];
    a = [tas nextTokenArray];
    [self assertNotNull:a];
    [self assert:2 equals:a.count];
    [self assert:@"I" equals:[a objectAtIndex:0].stringValue];
    [self assert:@"saw" equals:[a objectAtIndex:1].stringValue];

    [self assertTrue:[tas hasMore]];
    a = [tas nextTokenArray];
    [self assertNotNull:a];
    [self assert:5 equals:a.count];
    [self assert:@"I" equals:[a objectAtIndex:0].stringValue];
    [self assert:@"left" equals:[a objectAtIndex:1].stringValue];
    [self assert:@"in" equals:[a objectAtIndex:2].stringValue];
    [self assert:@"peace" equals:[a objectAtIndex:3].stringValue];
    [self assert:@"." equals:[a objectAtIndex:4].stringValue];

    [self assertFalse:[tas hasMore]];
    a = [tas nextTokenArray];
    [self assertNull:a];
}

@end
