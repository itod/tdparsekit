@import "../TDParser.j"
@import "../TDTokenAssembly.j"
@import "../TDTokenTerminals.j"

@implementation TDUppercaseWordTest : OJTestCase
{
    TDParser p;
    CPString s;
    TDAssembly a;
    TDAssembly res;
}

- (void)testFoobar {
    s = @"Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNotNull:res];
    [self assert:@"[Foobar]Foobar^" equals:[res description]];
}


- (void)testfoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNull:res];
}


- (void)test123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNull:res];
}


- (void)testPercentFoobar {
    s = @"%Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    res = [p completeMatchFor:a];
    
    [self assertNull:res];
}

@end
