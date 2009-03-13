
@import "TDNumberState.j"

@implementation TDScientificNumberState : TDNumberState 
{
    float exp;
    BOOL  negativeExp;
}

- (void)parseRightSideFromReader:(TDReader)r 
{
    [super parseRightSideFromReader:r];

    if ('e' == c || 'E' == c) {
        var e = c;
        c = [r read];
        
        var hasExp = (parseInt(c) >= 0 || parseInt(c) <= 9),
            negativeExp = ('-' == c),
            positiveExp = ('+' == c);

        if (!hasExp && (negativeExp || positiveExp)) {
            c = [r read];
            hasExp = (parseInt(c) >= 0 || parseInt(c) <= 9);
        }
        if (-1 != c) {
            [r unread];
        }
        if (hasExp) {
            [self append:e];
            if (negativeExp) {
                [self append:'-'];
            } else if (positiveExp) {
                [self append:'+'];
            }
            c = [r read];
            exp = [super absorbDigitsFromReader:r isFraction:NO];
        }
    }
}

- (void)reset:(int)cin 
{
    [super reset:cin];
    exp = 0.0;
    negativeExp = NO;
}

- (float)value 
{
    var result = floatValue;
    
    for (var i=0 ; i < exp; i++) {
        if (negativeExp) {
            result /= 10.0;
        } else {
            result *= 10.0;
        }
    }
    
    return result;
}

@end
