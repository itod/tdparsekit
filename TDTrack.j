
@import "TDSequence.j"
@import "TDAssembly.j"
//@import "TDTrackException.j"

@implementation TDTrack : TDSequence 
{
}

+ (id)track 
{
    return [[self alloc] init];
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    var inTrack = NO,
        lastAssemblies = inAssemblies,
        outAssemblies = inAssemblies;
    
    for (var i=0, count=[subparsers count]; i<count; i++)
    {
        var p = subparsers[i];
        
        outAssemblies = [p matchAndAssemble:outAssemblies];
        
        if (![outAssemblies count])
        {
            if (inTrack)
                [self throwTrackExceptionWithPreviousState:lastAssemblies parser:p];
            
            break;
        }
        
        inTrack = YES;
        lastAssemblies = outAssemblies;
    }

    return outAssemblies;
}

- (void)throwTrackExceptionWithPreviousState:(CPSet)inAssemblies parser:(TDParser)p 
{
    var best = [self best:inAssemblies];

    var after = [best consumedObjectsJoinedByString:@" "];
    if (!after.length) {
        after = @"-nothing-";
    }
    
    var expected = [p description];
    var next = [best peek];
    var found = next ? [next description] : @"-nothing-";
    
    var reason = [CPString stringWithFormat:@"\n\nAfter : %@\nExpected : %@\nFound : %@\n\n", after, expected, found];
    [CPException raise:"TDTrackException" reason:reason];
}

@end
