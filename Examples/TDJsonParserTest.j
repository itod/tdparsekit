@import "../TDParseKit.j"
@import "TDJsonParser.j"

@implementation TDJsonParserTest : OJTestCase {
    TDJsonParser p;
    CPString s;
    TDAssembly a;
    TDAssembly result;
}

- (void)setUp {
    p = [TDJsonParser parser];
}


// - (void)testForAppleBossResultTokenization {
//     var path = [[CPBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"json"];
//     s = [CPString stringWithContentsOfFile:path encoding:CPUTF8StringEncoding error:nil];
//     var t = [[[TDTokenizer alloc] initWithString:s] autorelease];
//     
//     var eof = [TDToken EOFToken];
//     var tok = nil;
//     while (eof != (tok = [t nextToken])) {
//         //CPLog(@"tok: %@", tok);
//     }
// }
// 
// 
// - (void)testForAppleBossResult {
//     var path = [[CPBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"json"];
//     s = [CPString stringWithContentsOfFile:path encoding:CPUTF8StringEncoding error:nil];
//     
//     try {
//         result = [p parse:s];
//     }
//     catch (e) {
//         //CPLog(@"\n\n\nexception:\n\n %@", [e reason]);
//     }
//     
//     //CPLog(@"result %@", result);
// }


- (void)testEmptyString {
    s = @"";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [p bestMatchFor:a];
    [self assertNull:result];
}


- (void)testNum {
    s = @"456";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p numberParser] bestMatchFor:a];
    [self assertNotNull:result];

    [self assert:@"[456]456^" equals:[result description]];
    var obj = [result pop];
    [self assertNotNull:obj];
    [self assert:456 equals:obj];

    
    s = @"-3.47";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p numberParser] bestMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[-3.47]-3.47^" equals:[result description]];
    obj = [result pop];
    [self assertNotNull:obj];
    [self assert:-3.47 equals:obj];
}


- (void)testString {
    s = @"'foobar'";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p stringParser] bestMatchFor:a];
    [self assertNotNull:result];
    [self assert:@"[foobar]'foobar'^" equals:[result description]];
    var obj = [result pop];
    [self assertNotNull:obj];
    [self assert:@"foobar" equals:obj];

    s = @"\"baz boo boo\"";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p stringParser] bestMatchFor:a];
    [self assertNotNull:result];
    
    [self assert:@"[baz boo boo]\"baz boo boo\"^" equals:[result description]];
    obj = [result pop];
    [self assertNotNull:obj];
    [self assert:@"baz boo boo" equals:obj];
}


- (void)testBoolean {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p booleanParser] bestMatchFor:a];
    [self assertNotNull:result];

    [self assert:@"[1]true^" equals:[result description]];
    var obj = [result pop];
    [self assertNotNull:obj];
    [self assert:YES equals:obj];

    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p booleanParser] bestMatchFor:a];
    [self assertNotNull:result];

    [self assert:@"[0]false^" equals:[result description]];
    obj = [result pop];
    [self assertNotNull:obj];
    [self assert:NO equals:obj];
}


- (void)testArray {
    s = @"[1, 2, 3]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    
    CPLog(@"result: %@", result);
    [self assertNotNull:result];
    var obj = [result pop];
    [self assert:3 equals:[obj count]];
    [self assert:1 equals:[obj objectAtIndex:0]];
    [self assert:2 equals:[obj objectAtIndex:1]];
    [self assert:3 equals:[obj objectAtIndex:2]];
    [self assert:@"[][/1/,/2/,/3/]^" equals:[result description]];

    s = @"[true, 'garlic jazz!', .888]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    [self assertNotNull:result];
    
    //[self assert:@"[true, 'garlic jazz!', .888]true/'garlic jazz!'/.888^", [result description]];
    obj = [result pop];
    [self assert:YES equals:[obj objectAtIndex:0]];
    [self assert:@"garlic jazz!" equals:[obj objectAtIndex:1]];
    [self assert:.888 equals:[obj objectAtIndex:2]];

    s = @"[1, [2, [3, 4]]]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    [self assertNotNull:result];
    //CPLog(@"result: %@", [a stack]);
    [self assert:1 equals:[obj objectAtIndex:0]];
}


- (void)testObject {
    s = @"{'key': 'value'}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    [self assertNotNull:result];
    
    var obj = [result pop];
    [self assert:[obj objectForKey:@"key"] equals:@"value"];

    s = @"{'foo': false, 'bar': true, \"baz\": -9.457}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    [self assertNotNull:result];
    
    obj = [result pop];
    [self assert:[obj objectForKey:@"foo"] equals:NO];
    [self assert:[obj objectForKey:@"bar"] equals:YES];
    [self assert:[obj objectForKey:@"baz"] equals:-9.457];

    s = @"{'baz': {'foo': [1,2]}}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    [self assertNotNull:result];
    
    obj = [result pop];
    var dict = [obj objectForKey:@"baz"];
    [self assertTrue:[dict isKindOfClass:[NSDictionary class]]];
    var arr = [dict objectForKey:@"foo"];
    [self assertTrue:[arr isKindOfClass:[CPArray class]]];
    [self assert:1 equals:[arr objectAtIndex:0]];
    
    //    [self assert:@"['baz', 'foo', 1, 2]'baz'/'foo'/1/2^", [result description]];
}


// - (void)testCrunchBaseJsonParser {
//     var path = [[CPBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
//     s = [CPString stringWithContentsOfFile:path encoding:CPUTF8StringEncoding error:nil];
//     TDJsonParser *parser = [[[TDJsonParser alloc] init] autorelease];
//     [parser parse:s];
//     // var res = [parser parse:s];
//     //CPLog(@"res %@", res);
// }
// 
// 
// - (void)testCrunchBaseJsonParserTokenization {
//     var path = [[CPBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
//     s = [CPString stringWithContentsOfFile:path encoding:CPUTF8StringEncoding error:nil];
//     var t = [[[TDTokenizer alloc] initWithString:s] autorelease];
//     
//     var eof = [TDToken EOFToken];
//     var tok = nil;
//     while (eof != (tok = [t nextToken])) {
//         //CPLog(@"tok: %@", tok);
//     }    
// }
// 
// 
// - (void)testCrunchBaseJsonTokenParser {
//     var path = [[CPBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
//     s = [CPString stringWithContentsOfFile:path encoding:CPUTF8StringEncoding error:nil];
//     var parser = [[[TDFastJsonParser alloc] init] autorelease];
//     [parser parse:s];
//     //var res = [parser parse:s];
//     //CPLog(@"res %@", res);
// }


- (void)testYahoo1 {
    s = 
    @"{"
        @"\"name\": \"Yahoo!\","
        @"\"permalink\": \"yahoo\","
        @"\"homepage_url\": \"http://www.yahoo.com\","
        @"\"blog_url\": \"http://yodel.yahoo.com/\","
        @"\"blog_feed_url\": \"http://ycorpblog.com/feed/\","
        @"\"category_code\": \"web\","
        @"\"number_of_employees\": 13600,"
        @"\"founded_year\": 1994,"
        @"\"founded_month\": null,"
        @"\"founded_day\": null,"
        @"\"deadpooled_year\": null,"
        @"\"deadpooled_month\": null,"
        @"\"deadpooled_day\": null,"
        @"\"deadpooled_url\": null,"
        @"\"tag_list\": \"search, portal, webmail, photos\","
        @"\"email_address\": \"\","
        @"\"phone_number\": \"(408) 349-3300\""
    @"}";
    result = [p parse:s];
    //CPLog(@"result %@", result);
    [self assertNotNull:result];
    var d = result;
    [self assertNotNull:d];
    [self assertTrue:[d isKindOfClass:[NSDictionary class]]];
    [self assert:[d objectForKey:@"name"] equals:@"Yahoo!"];
    [self assert:[d objectForKey:@"permalink"] equals:@"yahoo"];
    [self assert:[d objectForKey:@"homepage_url"] equals:@"http://www.yahoo.com"];
    [self assert:[d objectForKey:@"blog_url"] equals:@"http://yodel.yahoo.com/"];
    [self assert:[d objectForKey:@"blog_feed_url"] equals:@"http://ycorpblog.com/feed/"];
    [self assert:[d objectForKey:@"category_code"] equals:@"web"];
    [self assert:[d objectForKey:@"number_of_employees"] equals:13600];
    [self assert:[d objectForKey:@"founded_year"] equals:1994];
    [self assert:[d objectForKey:@"founded_month"] equals:[NSNull null]];
    [self assert:[d objectForKey:@"founded_day"] equals:[NSNull null]];
    [self assert:[d objectForKey:@"deadpooled_year"] equals:[NSNull null]];
    [self assert:[d objectForKey:@"deadpooled_month"] equals:[NSNull null]];
    [self assert:[d objectForKey:@"deadpooled_day"] equals:[NSNull null]];
    [self assert:[d objectForKey:@"deadpooled_url"] equals:[NSNull null]];
    [self assert:[d objectForKey:@"tag_list"] equals:@"search, portal, webmail, photos"];
    [self assert:[d objectForKey:@"email_address"] equals:@""];
    [self assert:[d objectForKey:@"phone_number"] equals:@"(408) 349-3300"];
}


- (void)testYahoo2 {
    s = @"{\"image\":"
        @"    {\"available_sizes\":"
        @"        [[[150, 37],"
        @"        \"assets/images/resized/0001/0836/10836v1-max-250x150.png\"],"
        @"        [[200, 50],"
        @"        \"assets/images/resized/0001/0836/10836v1-max-250x250.png\"],"
        @"        [[200, 50],"
        @"        \"assets/images/resized/0001/0836/10836v1-max-450x450.png\"]],"
        @"    \"attribution\": null}"
        @"}";
    result = [p parse:s];
    //CPLog(@"result %@", result);

    [self assertNotNull:result];

    var d = result;
    [self assertNotNull:d];
    [self assertTrue:[d isKindOfClass:[NSDictionary class]]];
    
    var image = [d objectForKey:@"image"];
    [self assertNotNull:image];
    [self assertTrue:[image isKindOfClass:[NSDictionary class]]];

    var sizes = [image objectForKey:@"available_sizes"];
    [self assertNotNull:sizes];
    [self assertTrue:[sizes isKindOfClass:[CPArray class]]];
    
    [self assert:3 equals:sizes.count];
    
    var first = [sizes objectAtIndex:0];
    [self assertNotNull:first];
    [self assertTrue:[first isKindOfClass:[CPArray class]]];
    [self assert:2 equals:first.count];
    
    var firstKey = [first objectAtIndex:0];
    [self assertNotNull:firstKey];
    [self assertTrue:[firstKey isKindOfClass:[CPArray class]]];
    [self assert:2 equals:firstKey.count];
    [self assert:150 equals:[firstKey objectAtIndex:0]];
    [self assert:37 equals:[firstKey objectAtIndex:1]];
    
    var second = [sizes objectAtIndex:1];
    [self assertNotNull:second];
    [self assertTrue:[second isKindOfClass:[CPArray class]]];
    [self assert:2 equals:second.count];
    
    var secondKey = [second objectAtIndex:0];
    [self assertNotNull:secondKey];
    [self assertTrue:[secondKey isKindOfClass:[CPArray class]]];
    [self assert:2 equals:secondKey.count];
    [self assert:200 equals:[secondKey objectAtIndex:0]];
    [self assert:50 equals:[secondKey objectAtIndex:1]];
    
    var third = [sizes objectAtIndex:2];
    [self assertNotNull:third];
    [self assertTrue:[third isKindOfClass:[CPArray class]]];
    [self assert:2 equals:third.count];
    
    var thirdKey = [third objectAtIndex:0];
    [self assertNotNull:thirdKey];
    [self assertTrue:[thirdKey isKindOfClass:[CPArray class]]];
    [self assert:2 equals:thirdKey.count];
    [self assert:200 equals:[thirdKey objectAtIndex:0]];
    [self assert:50 equals:[thirdKey objectAtIndex:1]];
    
    
//    [self assert:[d objectForKey:@"name"], @"Yahoo!"];
}


- (void)testYahoo3 {
    s = 
    @"{\"products\":"
        @"["
            @"{\"name\": \"Yahoo.com\", \"permalink\": \"yahoo-com\"},"
            @"{\"name\": \"Yahoo! Mail\", \"permalink\": \"yahoo-mail\"},"
            @"{\"name\": \"Yahoo! Search\", \"permalink\": \"yahoo-search\"},"
            @"{\"name\": \"Yahoo! Directory\", \"permalink\": \"yahoo-directory\"},"
            @"{\"name\": \"Yahoo! Finance\", \"permalink\": \"yahoo-finance\"},"
            @"{\"name\": \"My Yahoo\", \"permalink\": \"my-yahoo\"},"
            @"{\"name\": \"Yahoo! News\", \"permalink\": \"yahoo-news\"},"
            @"{\"name\": \"Yahoo! Groups\", \"permalink\": \"yahoo-groups\"},"
            @"{\"name\": \"Yahoo! Messenger\", \"permalink\": \"yahoo-messenger\"},"
            @"{\"name\": \"Yahoo! Games\", \"permalink\": \"yahoo-games\"},"
            @"{\"name\": \"Yahoo! People Search\", \"permalink\": \"yahoo-people-search\"},"
            @"{\"name\": \"Yahoo! Movies\", \"permalink\": \"yahoo-movies\"},"
            @"{\"name\": \"Yahoo! Weather\", \"permalink\": \"yahoo-weather\"},"
            @"{\"name\": \"Yahoo! Video\", \"permalink\": \"yahoo-video\"},"
            @"{\"name\": \"Yahoo! Music\", \"permalink\": \"yahoo-music\"},"
            @"{\"name\": \"Yahoo! Sports\", \"permalink\": \"yahoo-sports\"},"
            @"{\"name\": \"Yahoo! Maps\", \"permalink\": \"yahoo-maps\"},"
            @"{\"name\": \"Yahoo! Auctions\", \"permalink\": \"yahoo-auctions\"},"
            @"{\"name\": \"Yahoo! Widgets\", \"permalink\": \"yahoo-widgets\"},"
            @"{\"name\": \"Yahoo! Shopping\", \"permalink\": \"yahoo-shopping\"},"
            @"{\"name\": \"Yahoo! Real Estate\", \"permalink\": \"yahoo-real-estate\"},"
            @"{\"name\": \"Yahoo! Travel\", \"permalink\": \"yahoo-travel\"},"
            @"{\"name\": \"Yahoo! Classifieds\", \"permalink\": \"yahoo-classifieds\"},"
            @"{\"name\": \"Yahoo! Answers\", \"permalink\": \"yahoo-answers\"},"
            @"{\"name\": \"Yahoo! Mobile\", \"permalink\": \"yahoo-mobile\"},"
            @"{\"name\": \"Yahoo! Buzz\", \"permalink\": \"yahoo-buzz\"},"
            @"{\"name\": \"Yahoo! Open Search Platform\", \"permalink\": \"yahoo-open-search-platform\"},"
            @"{\"name\": \"Fire Eagle\", \"permalink\": \"fireeagle\"},"
            @"{\"name\": \"Shine\", \"permalink\": \"shine\"},"
            @"{\"name\": \"Yahoo! Shortcuts\", \"permalink\": \"yahoo-shortcuts\"}"
        @"]"
    @"}";
    result = [p parse:s];
    //CPLog(@"result %@", result);
    
    [self assertNotNull:result];

    var d = result;
    [self assertNotNull:d];
    [self assertTrue:[d isKindOfClass:[NSDictionary class]]];
    
    var products = [d objectForKey:@"products"];
    [self assertNotNull:products];
    [self assertTrue:[products isKindOfClass:[CPArray class]]];
}


- (void)testYahoo4 {
    s = @"["
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
        @"]";

    p = [[[TDFastJsonParser alloc] init] autorelease];
    result = [p parse:s];
    //CPLog(@"result %@", result);
    
    [self assertNotNull:result];

    var d = result;
    [self assertNotNull:d];
    [self assertTrue:[d isKindOfClass:[CPArray class]]];
    
//    var products = [d objectForKey:@"products"];
//    [self assertNotNull:products];
//    [self assertTrue:[products isKindOfClass:[CPArray class]]];
}
@end
