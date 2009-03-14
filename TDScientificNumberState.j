
@import "TDNumberState.j"

@implementation TDScientificNumberState : TDNumberState 
{
    float exp;
    BOOL  negativeExp;
}

- (void)parseRightSideFromReader:(TDReader)r 
{
    [super parseRightSideFromReader:r];

    var smallE = 'e'.charCodeAt(0) == c;
    var bigE = 'E'.charCodeAt(0) == c; 

    if (smallE || bigE) {
        c = [r read];
                
        var hasExp = (c >= '0'.charCodeAt(0) && c <= '9'.charCodeAt(0)),
            negativeExp = ('-'.charCodeAt(0) == c),
            positiveExp = ('+'.charCodeAt(0) == c);

        if (!hasExp && (!!negativeExp || !!positiveExp)) {
            c = [r read];
            hasExp = (c >= '0'.charCodeAt(0) || c <= '9'.charCodeAt(0));
        }
        if (-1 != c) {
            [r unread];
        }
        if (hasExp) {
            [self appendString:(smallE ? "e" : "E")];
            if (negativeExp) {
                [self appendString:'-'];
            } else if (positiveExp) {
                [self appendString:'+'];
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
            result = result / 10.0;
        } else {
            result *= 10.0;
        }
    }
    
    return result;
}

@end
