
@import "../TDParser.j"
@import "../TDTokenAssembly.j"
@import "../TDTokenTerminals.j"

@implementation TDLowercaseWordTest : OJTestCase
{
    TDParser p;
    CPString s;
    TDAssembly a;
    TDAssembly res;
}

- (void)testFoobar {
    s = @"Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNull:res];
}


- (void)testfoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNotNull:res];
    [self assert:@"[foobar]foobar^" equals:[res description]];
}


- (void)test123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNull:res];
}


- (void)testPercentFoobar {
    s = @"%Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNull:res];
}

@end