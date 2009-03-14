
@import "../TDTrack.j"
@import "../TDAlternation.j"
@import "../TDSequence.j"
@import "../TDRepetition.j"
@import "../TDTokenTerminals.j"
@import "../TDTokenAssembly.j"

@implementation TDTrackTest : OJTestCase {
    
}

//    list = '(' contents ')'
//    contents = empty | actualList
//    actualList = Word (',' Word)*


- (TDParser)listParser {
    var commaWord = [TDTrack track];
    [commaWord add:[[TDSymbol symbolWithString:@","] discard]];
    [commaWord add:[TDWord word]];
    
    var actualList = [TDSequence sequence];
    [actualList add:[TDWord word]];
    [actualList add:[TDRepetition repetitionWithSubparser:commaWord]];
    
    var contents = [TDAlternation alternation];
    [contents add:[TDEmpty empty]];
    [contents add:actualList];
    
    var list = [TDTrack track];
    [list add:[[TDSymbol symbolWithString:@"("] discard]];
    [list add:contents];
    [list add:[[TDSymbol symbolWithString:@")"] discard]];

    return list;
}


- (void)testTrack {
    
    var list = [self listParser];
    
    var test = [ @"()",
                 @"(pilfer)",
                 @"(pilfer, pinch)",
                 @"(pilfer, pinch, purloin)",
                 @"(pilfer, pinch,, purloin)",
                 @"(",
                 @"(pilfer",
                 @"(pilfer, ",
                 @"(, pinch, purloin)",
                 @"pilfer, pinch"];
    
    for (var i=0; i < test.length; i++) {
        var s = test[i]

        CPLog.info(@"\n----testing: %@", s);
        var a = [TDTokenAssembly assemblyWithString:s];
        try {
            var result = [list completeMatchFor:a];
            if (!result) {
                CPLog.info(@"[list completeMatchFor:] returns nil");
            } else {
                var stack = [[list completeMatchFor:a].stack description];
                CPLog.info(@"OK stack is: %@", stack);
            }
        } catch (e) {
            CPLog.info(@"\n\n%@\n\n", [e reason]);
        }
    }
    
}


- (void)testMissingParen {
    var track = [TDTrack track];
    [track add:[TDSymbol symbolWithString:@"("]];
    [track add:[TDSymbol symbolWithString:@")"]];
    
    var a = [TDTokenAssembly assemblyWithString:@"("];
    
    //STAssertThrowsSpecificNamed([track completeMatchFor:a], TDTrackException, TDTrackExceptionName, @"");
    
    try {
        [track completeMatchFor:a];
        [self assertTrue:0 message:@"Should not be reached"];
    } catch (e) {
        [self assert:[e class] equals:[CPException class]];
        [self assert:[e name] equals:"TDTrackException"];
        
        var s = "\n\nAfter : (\nExpected : Symbol )\nFound : -nothing-\n\n";
        [self assert:s equals:[e reason]];
    }
}

@end
