
@import "TDParser.j"
@import "TDAssembly.j"

@implementation TDRepetition : TDParser 
{
    TDParser    subparser;
    id          preassembler;
    SEL         preassemblerSelector;
}

+ (id)repetitionWithSubparser:(TDParser *)p 
{
    return [[self alloc] initWithSubparser:p];
}

- (id)init 
{
    return [self initWithSubparser:nil];
}

- (id)initWithSubparser:(TDParser)p 
{
    if (self = [super init])
        self.subparser = p;

    return self;
}

- (void)setPreassembler:(id)a selector:(SEL)sel 
{
    preassembler = a;
    preassemblerSelector = sel;
}

- (TDParser)parserNamed:(CPString)s 
{
    if (name === s)
        return self;
    else
        return [subparser parserNamed:s];
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    if (preassembler) {
        //NSAssert2([preassembler respondsToSelector:preassemblerSelector], @"provided preassembler %@ should respond to %s", preassembler, preassemblerSelector);
        var values = [inAssemblies allObjects],
            length = [values count];

        for (var i=0; i<length; i++)
            [preassembler performSelector:preassemblerSelector withObject:values[a]];
    }
    
    // I think there's a bug in CPSet, otherwise either of these lines would work
    // var outAssemblies = [[CPSet alloc] initWithSet:inAssemblies copyItems:NO],
    // var outAssemblies = [inAssemblies copy];
    
    // instead, copy by hand
    // begin workaround
    var outAssemblies = [CPSet set];
    var items = [inAssemblies allObjects];
    for (var i = 0, count = [items count]; i < count; i++)
        [outAssemblies addObject:items[i]];
    // end

    var s = inAssemblies;

    while ([s count]) {
        s = [subparser matchAndAssemble:s];
        [outAssemblies unionSet:s];
    }
    
    return outAssemblies;
}

@end
