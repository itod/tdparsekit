
@import "../TDParser.j"
@import "../TDTokenAssembly.j"
@import "../TDTokenTerminals.j"

@implementation TDLowercaseWordTest : OJTestCase
{
    TDParser p;
    CPString s;
    TDAssembly a;
    TDAssembly result;
}

- (void)testFoobar {
    s = @"Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNull:result];
}


- (void)testfoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNotNull:result];
    [self assert:@"[foobar]foobar^" equals:[result description]];
}


- (void)test123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNull:result];
}


- (void)testPercentFoobar {
    s = @"%Foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDLowercaseWord word];
    result = [p completeMatchFor:a];
    
    [self assertNull:result];
}

@end