@import "TDArithmeticParser.j"

@implementation TDArithmeticParserTest : OJTestCase {
    CPString s;
    TDArithmeticParser p;
    float result;
}

- (void)setUp {
    p = [TDArithmeticParser parser];
}

- (void)testOne {
    s = @"1";
    result = [p parse:s];
    [self assert:1.0 equals:result];
}


- (void)testFortySeven {
    s = @"47";
    result = [p parse:s];
    [self assert:47.0 equals:result];
}


- (void)testNegativeZero {
    s = @"-0";
    result = [p parse:s];
    [self assert:-0.0 equals:result];
}


- (void)testNegativeOne {
    s = @"-1";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testOnePlusOne {
    s = @"1 + 1";
    result = [p parse:s];
    [self assert:2.0 equals:result];
}


- (void)testOnePlusNegativeOne {
    s = @"1 + -1";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testNegativeOnePlusOne {
    s = @"-1 + 1";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testOneHundredPlusZero {
    s = @"100 + 0";
    result = [p parse:s];
    [self assert:100.0 equals:result];
}


- (void)testNegativeOnePlusZero {
    s = @"-1 + 0";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testNegativeZeroPlusZero {
    s = @"-0 + 0";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testNegativeZeroPlusNegativeZero {
    s = @"-0 + -0";
    result = [p parse:s];
    [self assert:-0.0 equals:result];
}


- (void)testOneMinusOne {
    s = @"1 - 1";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testOneMinusNegativeOne {
    s = @"1 - -1";
    result = [p parse:s];
    [self assert:2.0 equals:result];
}


- (void)testNegativeOneMinusOne {
    s = @"-1 - 1";
    result = [p parse:s];
    [self assert:-2.0 equals:result];
}


- (void)testOneHundredMinusZero {
    s = @"100 - 0";
    result = [p parse:s];
    [self assert:100.0 equals:result];
}


- (void)testNegativeOneMinusZero {
    s = @"-1 - 0";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testNegativeZeroMinusZero {
    s = @"-0 - 0";
    result = [p parse:s];
    [self assert:-0.0 equals:result];
}


- (void)testNegativeZeroMinusNegativeZero {
    s = @"-0 - -0";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testOneTimesOne {
    s = @"1 * 1";
    result = [p parse:s];
    [self assert:1.0 equals:result];
}


- (void)testTwoTimesFour {
    s = @"2 * 4";
    result = [p parse:s];
    [self assert:8.0 equals:result];
}


- (void)testOneTimesNegativeOne {
    s = @"1 * -1";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testNegativeOneTimesOne {
    s = @"-1 * 1";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testOneHundredTimesZero {
    s = @"100 * 0";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testNegativeOneTimesZero {
    s = @"-1 * 0";
    result = [p parse:s];
    [self assert:-0.0 equals:result];
}


- (void)testNegativeZeroTimesZero {
    s = @"-0 * 0";
    result = [p parse:s];
    [self assert:-0.0 equals:result];
}


- (void)testNegativeZeroTimesNegativeZero {
    s = @"-0 * -0";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)testOneDivOne {
    s = @"1 / 1";
    result = [p parse:s];
    [self assert:1.0 equals:result];
}


- (void)testTwoDivFour {
    s = @"2 / 4";
    result = [p parse:s];
    [self assert:0.5 equals:result];
}


- (void)testFourDivTwo {
    s = @"4 / 2";
    result = [p parse:s];
    [self assert:2.0 equals:result];
}


- (void)testOneDivNegativeOne {
    s = @"1 / -1";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testNegativeOneDivOne {
    s = @"-1 / 1";
    result = [p parse:s];
    [self assert:-1.0 equals:result];
}


- (void)testOneHundredDivZero {
    s = @"100 / 0";
    result = [p parse:s];
    [self assert:Infinity equals:result];
}


- (void)testNegativeOneDivZero {
    s = @"-1 / 0";
    result = [p parse:s];
    [self assert:-Infinity equals:result];
}


- (void)testNegativeZeroDivZero {
    s = @"-0 / 0";
    result = [p parse:s];
    [self assert:NaN equals:result];
}


- (void)testNegativeZeroDivNegativeZero {
    s = @"-0 / -0";
    result = [p parse:s];
    [self assert:NaN equals:result];
}


- (void)test1Exp1 {
    s = @"1 ^ 1";
    result = [p parse:s];
    [self assert:1.0 equals:result];
}


- (void)test1Exp2 {
    s = @"1 ^ 2";
    result = [p parse:s];
    [self assert:1.0 equals:result];
}


- (void)test9Exp2 {
    s = @"9 ^ 2";
    result = [p parse:s];
    [self assert:81.0 equals:result];
}


- (void)test9ExpNegative2 {
    s = @"9 ^ -2";
    result = [p parse:s];
    [self assert:9.0 equals:result];
}


// #pragma mark Associativity

- (void)test7minus3minus1 { // minus associativity
    s = @"7 - 3 - 1";
    result = [p parse:s];
    [self assert:3.0 equals:result];
}


- (void)test9exp2minus81 { // exp associativity
    s = @"9^2 - 81";
    result = [p parse:s];
    [self assert:0.0 equals:result];
}


- (void)test2exp1exp4 { // exp
    s = @"2 ^ 1 ^ 4";
    result = [p parse:s];
    [self assert:2.0 equals:result];
}


- (void)test100minus5exp2times3 { // exp
    s = @"100 - 5^2*3";
    result = [p parse:s];
    [self assert:25.0 equals:result];
}


- (void)test100minus25times3 { // precedence
    s = @"100 - 25*3";
    result = [p parse:s];
    [self assert:25.0 equals:result];
}


- (void)test100minus25times3Parens { // precedence
    s = @"(100 - 25)*3";
    result = [p parse:s];
    [self assert:225.0 equals:result];
}


- (void)test100minus5exp2times3Parens { // precedence
    s = @"(100 - 5^2)*3";
    result = [p parse:s];
    [self assert:225.0 equals:result];
}

@end
