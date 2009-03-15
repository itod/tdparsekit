
@import "TDNumberState.j"

SMALL_E = 'e'.charCodeAt(0);
BIG_E   = 'E'.charCodeAt(0);
DOT     = '.'.charCodeAt(0);
MINUS   = '-'.charCodeAt(0);
PLUS    = '+'.charCodeAt(0);
ZERO    = '0'.charCodeAt(0);
NINE    = '9'.charCodeAt(0);

@implementation TDScientificNumberState : TDNumberState 
{
    float exp;
    BOOL  negativeExp;
}

- (void)parseRightSideFromReader:(TDReader)r 
{
    [super parseRightSideFromReader:r];

    var smallE = SMALL_E == c;
    var bigE = BIG_E == c; 

    if (smallE || bigE) {
        c = [r read];
                
        var hasExp = (c >= ZERO && c <= NINE),
            negativeExp = (MINUS == c),
            positiveExp = (PLUS == c);

        if (!hasExp && (!!negativeExp || !!positiveExp)) {
            c = [r read];
            hasExp = (c >= ZERO || c <= NINE);
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
