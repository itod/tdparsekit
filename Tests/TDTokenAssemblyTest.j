
@import "../TDTokenAssembly.j"
@import "../TDParser.j"
@import "../TDToken.j"

@implementation TDTokenAssemblyTest : OJTestCase 
{
    TDAssembly a;
    CPString s;
    TDParser p;    
}

- (void)testWordOhSpaceHaiExclamation {
    s = @"oh hai!";
    a = [TDTokenAssembly assemblyWithString:s];

    [self assert:3 equals:[a length]];

    [self assert:0 equals:[a objectsConsumed]];
    [self assert:3 equals:[a objectsRemaining]];
    [self assert:@"[]^oh/hai/!" equals:[a description]];
    [self assertTrue:[a hasMore]];
    [self assert:@"oh" equals:[a next].stringValue];

    [self assert:1 equals:[a objectsConsumed]];
    [self assert:2 equals:[a objectsRemaining]];
    [self assert:@"[]oh^hai/!" equals:[a description]];
    [self assertTrue:[a hasMore]];
    [self assert:@"hai" equals:[a next].stringValue];

    [self assert:2 equals:[a objectsConsumed]];
    [self assert:1 equals:[a objectsRemaining]];
    [self assert:@"[]oh/hai^!" equals:[a description]];
    [self assertTrue:[a hasMore]];
    [self assert:@"!" equals:[a next].stringValue];

    [self assert:3 equals:[a objectsConsumed]];
    [self assert:0 equals:[a objectsRemaining]];
    [self assert:@"[]oh/hai/!^" equals:[a description]];
    [self assertFalse:[a hasMore]];
    [self assertNull:[a next]];

    [self assert:3 equals:[a objectsConsumed]];
    [self assert:0 equals:[a objectsRemaining]];
    [self assert:@"[]oh/hai/!^" equals:[a description]];
    [self assertFalse:[a hasMore]];
    [self assertNull:[a next]];

    [self assert:3 equals:[a length]];
}


- (void)testBestMatchForWordFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];

    [self assert:1 equals:[a length]];
    [self assert:@"[]^foobar" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[foobar]foobar^" equals:[result description]];
    [self assertFalse:result == a];


    result = [p bestMatchFor:result];
    [self assertNull:result];
}


- (void)testCompleteMatchForWordFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:1 equals:[a length]];
    [self assert:@"[]^foobar" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p completeMatchFor:a];
    [self assert:@"[foobar]foobar^" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testBestMatchForWordFooSpaceBar {
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:2 equals:[a length]];
    [self assert:@"[]^foo/bar" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[foo]foo^bar" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testCompleteMatchForWordFooSpaceBar {
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:2 equals:[a length]];
    [self assert:@"[]^foo/bar" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testBestMatchForNumFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:1 equals:[a length]];
    [self assert:@"[]^foobar" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p bestMatchFor:a];
    [self assertNull:result];
}


- (void)testCompleteMatchForNumFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:1 equals:[a length]];
    [self assert:@"[]^foobar" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testBestMatchForWord123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:1 equals:[a length]];
    [self assert:@"[]^123" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p bestMatchFor:a];
    [self assertNull:result];
}


- (void)testCompleteMatchForWord123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    
    p = [[TDWord alloc] init];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
    [self assert:1 equals:[a length]];
    [self assert:@"[]^123" equals:[a description]];
}


- (void)testBestMatchForNum123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:1 equals:[a length]];
    [self assert:@"[]^123" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[123]123^" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testCompleteMatchForNum123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:1 equals:[a length]];
    [self assert:@"[]^123" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[123]123^" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testBestMatchForNum123Space456 {
    s = @"123 456";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:2 equals:[a length]];
    [self assert:@"[]^123/456" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[123]123^456" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testCompleteMatchForNum123Space456 {
    s = @"123 456";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:2 equals:[a length]];
    [self assert:@"[]^123/456" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testBestMatchForWordFoobarSpace123 {
    s = @"foobar 123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:2 equals:[a length]];
    [self assert:@"[]^foobar/123" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[foobar]foobar^123" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testCompleteMatchForWordFoobarSpace123 {
    s = @"foobar 123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:2 equals:[a length]];
    [self assert:@"[]^foobar/123" equals:[a description]];
    
    p = [[TDWord alloc] init];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testBestMatchForNum123Space456Foobar {
    s = @"123 456 foobar";
    a = [TDTokenAssembly assemblyWithString:s];

    [self assert:3 equals:[a length]];
    [self assert:@"[]^123/456/foobar" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p bestMatchFor:a];
    [self assert:@"[123]123^456/foobar" equals:[result description]];
    [self assertFalse:result == a];
}


- (void)testCompleteMatchForNum123Space456Foobar {
    s = @"123 456 foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    [self assert:3 equals:[a length]];
    [self assert:@"[]^123/456/foobar" equals:[a description]];
    
    p = [[TDNum alloc] init];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}

@end

