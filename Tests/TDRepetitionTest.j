
@import "../TDRepetition.j"
@import "../TDTokenAssembly.j"
@import "../TDCollectionParser.j"

@implementation TDRepetitionTest : OJTestCase
{
    TDCollectionParser p;
    TDAssembly a;
    NSString s;
}


- (void)testWordRepetitionAllMatchesForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var all = [p allMatchesFor:[CPSet setWithObject:a]];
    //CPLog(@"all: %@", [all allObjects]);
    
    [self assertNotNull:all];
    var c = [all count];
    [self assert:4 equals:c];
}


- (void)testWordRepetitionBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    
    var result = [p bestMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[foo, bar, baz]foo/bar/baz^" equals:[result description]];
}


- (void)testWordRepetitionBestMatchForFooSpaceBarSpace123 {
    s = @"foo bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];

    var result = [p bestMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[foo, bar]foo/bar^123" equals:[result description]];
}


- (void)testWordRepetitionAllMatchesForFooSpaceBarSpace123 {
    s = @"foo bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var all = [p allMatchesFor:[CPSet setWithObject:a]];
    //CPLog(@"all: %@", [all allObjects]);
    
    [self assertNotNull:all];
    var c = [all count];
    [self assert:3 equals:c];
}    


- (void)testWordRepetitionAllMatchesFooSpace123SpaceBaz {
    s = @"foo 123 baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var all = [p allMatchesFor:[CPSet setWithObject:a]];
    //CPLog(@"all: %@", [all allObjects]);
    
    [self assertNotNull:all];
    var c = [all count];
    [self assert:2 equals:c];
}    


- (void)testNumRepetitionAllMatchesForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    var all = [p allMatchesFor:[CPSet setWithObject:a]];
    //CPLog(@"all: %@", [all allObjects]);
    
    [self assertNotNull:all];
    var c = [all count];
    [self assert:1 equals:c];
}    


- (void)testWordRepetitionCompleteMatchForFooSpaceBarSpaceBaz {
    s = @"foo bar baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var result = [p completeMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[foo, bar, baz]foo/bar/baz^" equals:[result description]];
}    


- (void)testWordRepetitionCompleteMatchForFooSpaceBarSpace123 {
    s = @"foo bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}    


- (void)testWordRepetitionCompleteMatchFor456SpaceBarSpace123 {
    s = @"456 bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}    


- (void)testNumRepetitionCompleteMatchFor456SpaceBarSpace123 {
    s = @"456 bar 123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    var result = [p completeMatchFor:a];
    [self assertNull:result];
}    


- (void)testNumRepetitionAllMatchesFor123Space456SpaceBaz {
    s = @"123 456 baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    var all = [p allMatchesFor:[CPSet setWithObject:a]];
    
    [self assertNotNull:all];
    var c = [all count];
    [self assert:3 equals:c];
}    


- (void)testNumRepetitionBestMatchFor123Space456SpaceBaz {
    s = @"123 456 baz";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    var result = [p bestMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[123, 456]123/456^baz" equals:[result description]];
}    


- (void)testNumRepetitionCompleteMatchFor123 {
    s = @"123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDNum num]];
    
    var result = [p completeMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[123]123^" equals:[result description]];
}    


- (void)testWordRepetitionCompleteMatchFor123 {
    s = @"123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var result = [p completeMatchFor:a];
    
    [self assertNull:result];
}    


- (void)testWordRepetitionBestMatchForFoo {
    s = @"foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [[TDRepetition alloc] initWithSubparser:[TDWord word]];
    
    var result = [p bestMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[foo]foo^" equals:[result description]];
}

@end

