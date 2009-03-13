
@implementation TDTokenizerState : CPObject 
{
    CPString    string;
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(unsigned)cin tokenizer:(TDTokenizer)t 
{
    //NSAssert(0, @"TDTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
    return nil;
}

- (void)reset 
{
    string = "";
}

- (void)append:(int)c 
{
    string = string + String.fromCharCode(c);
}

- (void)appendString:(CPString)s 
{
    string = string + s;
}

- (CPString)bufferedString 
{
    return string;
}

@end
