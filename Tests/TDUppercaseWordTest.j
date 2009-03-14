@import "../TDParser.j"
@import "../TDTokenAssembly.j"
@import "../TDTokenTerminals.j"

@implementation TDUppercaseWordTest : OJTestCase
{
    TDParser p;
    CPString s;
    TDAssembly a;
    TDAssembly result;
}

- (void)testFoobar {
    s = @"Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[Foobar]Foobar^" equals:[result description]];
}


- (void)testfoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNull:result];
}


- (void)test123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNull:result];
}


- (void)testPercentFoobar {
    s = @"%Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDUppercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNull:result];
}

@end
