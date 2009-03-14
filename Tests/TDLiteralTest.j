
@import "../TDAlternation.j"
@import "../TDTokenAssembly.j"
@import "../TDTokenTerminals.j"

@implementation TDLiteralTest : OJTestCase
{
    TDParser p;
    TDAssembly a;
    NSString s;
}

- (void)testTrueCompleteMatchForLiteral123 {
    s = @"123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    CPLog(@"a: %@", a);
    
    p = [TDNum num];
    var result = [p completeMatchFor:a];
    
    // -[TDParser completeMatchFor:]
    // -[TDParser bestMatchFor:]
    // -[TDParser matchAndAssemble:]
    // -[TDTerminal allMatchesFor:]
    // -[TDTerminal matchOneAssembly:]
    // -[TDLiteral qualifies:]
    // -[TDParser best:]
    
    CPLog(@"result: %@", result);
    [self assertNotNull:result];
    [self assert:@"[123]123^" equals:[result description]];
}


- (void)testFalseCompleteMatchForLiteral123 {
    s = @"1234";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"123"];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
    [self assert:@"[]^1234" equals:[a description]];
}


- (void)testTrueCompleteMatchForLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"Foo"];
    var result = [p completeMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[Foo]Foo^" equals:[result description]];
}


- (void)testFalseCompleteMatchForLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"foo"];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testFalseCompleteMatchForCaseInsensitiveLiteralFoo {
    s = @"Fool";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDCaseInsensitiveLiteral literalWithString:@"Foo"];
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testTrueCompleteMatchForCaseInsensitiveLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
        
    p = [TDCaseInsensitiveLiteral literalWithString:@"foo"];
    var result = [p completeMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[Foo]Foo^" equals:[result description]];
}

@end
