
@import "TDTokenizerState.j"

DOT   = '.'.charCodeAt(0);
MINUS = '-'.charCodeAt(0);
PLUS  = '+'.charCodeAt(0);
ZERO  = '0'.charCodeAt(0);
NINE  = '9'.charCodeAt(0);

@implementation TDNumberState : TDTokenizerState 
{
    BOOL    allowsTrailingDot;
    BOOL    gotADigit;
    BOOL    negative;
    int     c;
    float   floatValue;
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{
    [self reset];

    negative = NO;
    
    var originalCin = cin;
    
    if (MINUS == cin) {
        negative = YES;
        cin = [r read];
        [self appendString:'-'];
    } else if (PLUS == cin) {
        cin = [r read];
        [self appendString:'+'];
    }
    
    [self reset:cin];
    
    if (DOT == c) {
        [self parseRightSideFromReader:r];
    } else {
        [self parseLeftSideFromReader:r];
        [self parseRightSideFromReader:r];
    }
    
    // erroneous ., +, or -
    if (!gotADigit) {
        if (negative && -1 != c) { // ??
            [r unread];
        }
        return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
    }
    
    if (-1 != c) {
        [r unread];
    }

    if (negative) {
        floatValue = -floatValue;
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeNumber stringValue:[self bufferedString] floatValue:[self value]];
}

- (float)value 
{
    return floatValue;
}

- (float)absorbDigitsFromReader:(TDReader)r isFraction:(BOOL)isFraction 
{
    var divideBy = 1.0,
        v = 0.0;
    
    while (true) {
        if (c >= ZERO && c <= NINE) {
            [self append:c];
            gotADigit = YES;
            v = v * 10.0 + (c - ZERO);
            c = [r read];
            if (isFraction) {
                divideBy *= 10.0;
            }
        } else {
            break;
        }
    }
    
    if (isFraction) {
        v = v / divideBy;
    }

    return v;
}

- (void)parseLeftSideFromReader:(TDReader)r 
{
    floatValue = [self absorbDigitsFromReader:r isFraction:NO];
}

- (void)parseRightSideFromReader:(TDReader)r 
{
    if ('.'.charCodeAt(0) == c) 
    {
        var n = [r read],
            nextIsDigit = (n >= ZERO && n <= NINE);

        if (-1 != n)
            [r unread];

        if (nextIsDigit || allowsTrailingDot) {
            [self appendString:'.'];
            if (nextIsDigit) {
                c = [r read];
                floatValue += [self absorbDigitsFromReader:r isFraction:YES];
            }
        }
    }
}

- (void)reset:(int)cin 
{
    gotADigit = NO;
    floatValue = 0.0;
    c = cin;
}

@end
