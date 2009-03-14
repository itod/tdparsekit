@import "TDArithmeticParser.j"

@implementation TDArithmeticParserTest : OJTestCase {
    CPString s;
    TDArithmeticParser p;
    float res;
}

- (void)setUp {
    p = [TDArithmeticParser parser];
}

- (void)testOne {
    s = @"1";
    res = [p parse:s];
    [self assert:1.0 equals:res];
}


- (void)testFortySeven {
    s = @"47";
    res = [p parse:s];
    [self assert:47.0 equals:res];
}


- (void)testNegativeZero {
    s = @"-0";
    res = [p parse:s];
    [self assert:-0.0 equals:res];
}


- (void)testNegativeOne {
    s = @"-1";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testOnePlusOne {
    s = @"1 + 1";
    res = [p parse:s];
    [self assert:2.0 equals:res];
}


- (void)testOnePlusNegativeOne {
    s = @"1 + -1";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testNegativeOnePlusOne {
    s = @"-1 + 1";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testOneHundredPlusZero {
    s = @"100 + 0";
    res = [p parse:s];
    [self assert:100.0 equals:res];
}


- (void)testNegativeOnePlusZero {
    s = @"-1 + 0";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testNegativeZeroPlusZero {
    s = @"-0 + 0";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testNegativeZeroPlusNegativeZero {
    s = @"-0 + -0";
    res = [p parse:s];
    [self assert:-0.0 equals:res];
}


- (void)testOneMinusOne {
    s = @"1 - 1";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testOneMinusNegativeOne {
    s = @"1 - -1";
    res = [p parse:s];
    [self assert:2.0 equals:res];
}


- (void)testNegativeOneMinusOne {
    s = @"-1 - 1";
    res = [p parse:s];
    [self assert:-2.0 equals:res];
}


- (void)testOneHundredMinusZero {
    s = @"100 - 0";
    res = [p parse:s];
    [self assert:100.0 equals:res];
}


- (void)testNegativeOneMinusZero {
    s = @"-1 - 0";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testNegativeZeroMinusZero {
    s = @"-0 - 0";
    res = [p parse:s];
    [self assert:-0.0 equals:res];
}


- (void)testNegativeZeroMinusNegativeZero {
    s = @"-0 - -0";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testOneTimesOne {
    s = @"1 * 1";
    res = [p parse:s];
    [self assert:1.0 equals:res];
}


- (void)testTwoTimesFour {
    s = @"2 * 4";
    res = [p parse:s];
    [self assert:8.0 equals:res];
}


- (void)testOneTimesNegativeOne {
    s = @"1 * -1";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testNegativeOneTimesOne {
    s = @"-1 * 1";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testOneHundredTimesZero {
    s = @"100 * 0";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testNegativeOneTimesZero {
    s = @"-1 * 0";
    res = [p parse:s];
    [self assert:-0.0 equals:res];
}


- (void)testNegativeZeroTimesZero {
    s = @"-0 * 0";
    res = [p parse:s];
    [self assert:-0.0 equals:res];
}


- (void)testNegativeZeroTimesNegativeZero {
    s = @"-0 * -0";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)testOneDivOne {
    s = @"1 / 1";
    res = [p parse:s];
    [self assert:1.0 equals:res];
}


- (void)testTwoDivFour {
    s = @"2 / 4";
    res = [p parse:s];
    [self assert:0.5 equals:res];
}


- (void)testFourDivTwo {
    s = @"4 / 2";
    res = [p parse:s];
    [self assert:2.0 equals:res];
}


- (void)testOneDivNegativeOne {
    s = @"1 / -1";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testNegativeOneDivOne {
    s = @"-1 / 1";
    res = [p parse:s];
    [self assert:-1.0 equals:res];
}


- (void)testOneHundredDivZero {
    s = @"100 / 0";
    res = [p parse:s];
    [self assert:Infinity equals:res];
}


- (void)testNegativeOneDivZero {
    s = @"-1 / 0";
    res = [p parse:s];
    [self assert:-Infinity equals:res];
}


- (void)testNegativeZeroDivZero {
    s = @"-0 / 0";
    res = [p parse:s];
    [self assert:NaN equals:res];
}


- (void)testNegativeZeroDivNegativeZero {
    s = @"-0 / -0";
    res = [p parse:s];
    [self assert:NaN equals:res];
}


- (void)test1Exp1 {
    s = @"1 ^ 1";
    res = [p parse:s];
    [self assert:1.0 equals:res];
}


- (void)test1Exp2 {
    s = @"1 ^ 2";
    res = [p parse:s];
    [self assert:1.0 equals:res];
}


- (void)test9Exp2 {
    s = @"9 ^ 2";
    res = [p parse:s];
    [self assert:81.0 equals:res];
}


- (void)test9ExpNegative2 {
    s = @"9 ^ -2";
    res = [p parse:s];
    [self assert:9.0 equals:res];
}


// #pragma mark Associativity

- (void)test7minus3minus1 { // minus associativity
    s = @"7 - 3 - 1";
    res = [p parse:s];
    [self assert:3.0 equals:res];
}


- (void)test9exp2minus81 { // exp associativity
    s = @"9^2 - 81";
    res = [p parse:s];
    [self assert:0.0 equals:res];
}


- (void)test2exp1exp4 { // exp
    s = @"2 ^ 1 ^ 4";
    res = [p parse:s];
    [self assert:2.0 equals:res];
}


- (void)test100minus5exp2times3 { // exp
    s = @"100 - 5^2*3";
    res = [p parse:s];
    [self assert:25.0 equals:res];
}


- (void)test100minus25times3 { // precedence
    s = @"100 - 25*3";
    res = [p parse:s];
    [self assert:25.0 equals:res];
}


- (void)test100minus25times3Parens { // precedence
    s = @"(100 - 25)*3";
    res = [p parse:s];
    [self assert:225.0 equals:res];
}


- (void)test100minus5exp2times3Parens { // precedence
    s = @"(100 - 5^2)*3";
    res = [p parse:s];
    [self assert:225.0 equals:res];
}

@end
