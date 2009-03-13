#import "TDToken.j"

@implementation TDWord

+ (id)word {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    return obj.isWord;
}

@end
