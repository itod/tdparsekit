
@import "../TDAlternation.j"
@import "../TDTokenAssembly.j"
@import "../TDCollectionParser.j"

@implementation TDAlternationTest : OJTestCase
{
    TDCollectionParser p;
    TDAssembly a;
    NSString s;
}

- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo baz bar";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDAlternation alternation];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo]foo^baz/bar" equals:[result description]];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
    s = @"123 baz bar";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDAlternation alternation];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    [p add:[TDNum num]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[123]123^baz/bar" equals:[result description]];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz2 {
    s = @"123 baz bar";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDAlternation alternation];
    [p add:[TDWord word]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    [p add:[TDNum num]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[123]123^baz/bar" equals:[result description]];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz3 {
    s = @"123 baz bar";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDAlternation alternation];
    [p add:[TDWord word]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDNum num]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[123]123^baz/bar" equals:[result description]];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz4 {
    s = @"123 baz bar";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDAlternation alternation];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    [p add:[TDNum num]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[123]123^baz/bar" equals:[result description]];
}

@end
