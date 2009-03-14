
@import "../TDSequence.j"
@import "../TDTokenAssembly.j"
@import "../TDCollectionParser.j"

@implementation TDSequenceTest : OJTestCase
{
    TDCollectionParser p;
    TDAssembly a;
    NSString s;
}


- (void)testDiscard {
    s = @"foo -";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo]foo/-^" equals:[result description]];
}


- (void)testDiscard2 {
    s = @"foo foo -";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo, foo]foo/foo/-^" equals:[result description]];
}


- (void)testDiscard3 {
    s = @"foo - foo";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo, foo]foo/-/foo^" equals:[result description]];
}


- (void)testDiscard1 {
    s = @"- foo";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo]-/foo^" equals:[result description]];
}


- (void)testDiscard4 {
    s = @"- foo -";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo]-/foo/-^" equals:[result description]];
}


- (void)testDiscard5 {
    s = @"- foo + foo";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[[TDSymbol symbolWithString:@"-"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[[TDSymbol symbolWithString:@"+"] discard]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo, foo]-/foo/+/foo^" equals:[result description]];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo, bar, baz]foo/bar/baz^" equals:[result description]];
}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p completeMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo, bar, baz]foo/bar/baz^" equals:[result description]];
}


- (void)testTrueLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDWord word]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p completeMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foo, bar, baz]foo/bar/baz^" equals:[result description]];
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testFalseLiteralCompleteMatchForFooSpaceBarSpaceBaz1 {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDNum num]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}


- (void)testTrueLiteralAllMatchsForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSequence sequence];
    [p add:[TDLiteral literalWithString:@"foo"]];
    [p add:[TDLiteral literalWithString:@"bar"]];
    [p add:[TDLiteral literalWithString:@"baz"]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
}

- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
   s = @"foo bar baz";
   a = [TDTokenAssembly assemblyWithString:s];
   
   p = [TDSequence sequence];
   [p add:[TDLiteral literalWithString:@"foo"]];
   [p add:[TDLiteral literalWithString:@"baz"]];
   [p add:[TDLiteral literalWithString:@"bar"]];
   
   var result = [p bestMatchFor:a];
   
   [self assertNull:result];
}


- (void)testFalseLiteralBestMatchForFooSpaceBarSpaceBaz {
   s = @"foo bar baz";
   a = [TDTokenAssembly assemblyWithString:s];
   
   p = [TDSequence sequence];
   [p add:[TDLiteral literalWithString:@"foo"]];
   [p add:[TDLiteral literalWithString:@"foo"]];
   [p add:[TDLiteral literalWithString:@"baz"]];
   
   var result = [p bestMatchFor:a];
   [self assertNull:result];
}

- (void)testFalseLiteralAllMatchsForFooSpaceBarSpaceBaz {
   s = @"foo bar baz";
   a = [TDTokenAssembly assemblyWithString:s];
   
   p = [TDSequence sequence];
   [p add:[TDLiteral literalWithString:@"foo"]];
   [p add:[TDLiteral literalWithString:@"123"]];
   [p add:[TDLiteral literalWithString:@"baz"]];
   
   var result = [p allMatchesFor:[CPSet setWithObject:a]];
   
   [self assertNotNull:result];
   var c = [result count];
   [self assert:0 equals:c];
}

@end
