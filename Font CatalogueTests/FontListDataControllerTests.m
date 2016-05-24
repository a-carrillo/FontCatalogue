//
//  FontListDataControllerTests.m
//  Font Catalogue
//
//  Created by Alvaro Carrillo on 30/04/2016.
//  Copyright © 2016 Alvaro Carrillo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FontListDataController.h"

@interface FontListDataControllerTests : XCTestCase

@end


@interface FontListDataController (Test)

@property (nonatomic, copy) NSMutableArray *fontNameList;

- (NSString *)reverseCharactersOfString:(NSString *) stringToBeReversed;
- (NSArray *)sortArray:(NSArray *)arrayToSort alphanumericallyAscending:(BOOL)ascendingOrder;
- (NSArray *)sortArray:(NSArray *)arrayToSort byElementStringLenthAscending:(BOOL) stringLengthAscendingOrder andElementStringValueAscending:(BOOL)stringValueAscendingOrder;
- (NSArray *)sortFontNameArray:(NSArray *)arrayToSort byFontNameDisplaySizeAscending:(BOOL)displaySizeAscendingOrder andFontNameAscending:(BOOL)fontNameAscendingOrder;
- (NSArray *)reverseElementsInArray:(NSArray *)arrayToReverse;

@end


@implementation FontListDataControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - Private method tests

- (void)testFontListDataControllerReverseCharactersOfString {
    NSString *originalText = @"abcdef";
    NSString *reversedOriginalText = @"fedcba";
    
    NSString *reversedText = [[FontListDataController sharedStore] reverseCharactersOfString:originalText];
    
    XCTAssertEqualObjects(reversedOriginalText, reversedText);
}


- (void)testFontListDataControllerSortAlphanumerically {
    NSArray *testFontNameList = @[@"a", @"ab", @"abc", @"a1", @"ab1", @"abc1"];
    NSArray *testFontNameListAscending = @[@"a", @"a1", @"ab", @"ab1", @"abc", @"abc1"];
    NSArray *testFontNameListDescending = @[@"abc1", @"abc", @"ab1", @"ab", @"a1", @"a"];
    
    NSArray *sortedArray = [[FontListDataController sharedStore] sortArray:testFontNameList alphanumericallyAscending:YES];
    
    XCTAssertEqualObjects(testFontNameListAscending, sortedArray);
    
    NSArray *sortedArrayDesc = [[FontListDataController sharedStore] sortArray:testFontNameList alphanumericallyAscending:NO];
    
    XCTAssertEqualObjects(testFontNameListDescending, sortedArrayDesc);
}

- (void)testFontListDataControllerSortCharacterCount {
    NSArray *testFontNameList = @[@"a", @"ab", @"abc", @"a1", @"ab1", @"abc1"];
    NSArray *testFontNameListAscending = @[@"a", @"a1", @"ab", @"ab1", @"abc", @"abc1"];
    NSArray *testFontNameListAscending2 = @[@"a", @"ab", @"a1", @"abc", @"ab1", @"abc1"];
    NSArray *testFontNameListDescending = @[@"abc1", @"ab1", @"abc", @"a1", @"ab", @"a"];
    NSArray *testFontNameListDescending2 = @[@"abc1", @"abc", @"ab1", @"ab", @"a1", @"a"];
    
    NSArray *sortedArray = [[FontListDataController sharedStore] sortArray:testFontNameList byElementStringLenthAscending:YES andElementStringValueAscending:YES];
    
    XCTAssertEqualObjects(testFontNameListAscending, sortedArray);
    
    NSArray *sortedArray2 = [[FontListDataController sharedStore] sortArray:testFontNameList byElementStringLenthAscending:YES andElementStringValueAscending:NO];
    
    XCTAssertEqualObjects(testFontNameListAscending2, sortedArray2);
    
    NSArray *sortedArrayDesc = [[FontListDataController sharedStore] sortArray:testFontNameList byElementStringLenthAscending:NO andElementStringValueAscending:YES];
    
    XCTAssertEqualObjects(testFontNameListDescending, sortedArrayDesc);
    
    NSArray *sortedArrayDesc2 = [[FontListDataController sharedStore] sortArray:testFontNameList byElementStringLenthAscending:NO andElementStringValueAscending:NO];
    
    XCTAssertEqualObjects(testFontNameListDescending2, sortedArrayDesc2);
}

- (void)testFontListDataControllerSortByDisplaySize {
    NSArray *testFontNameList = @[@"Arial", @"Georgia", @"Gill Sans", @"Futura", @"Helvetica",
                                  @"Courier New", @"Heiti TC", @"Heiti SC"];
    
    NSArray *testFontNameListAscending = @[@"Arial", @"Futura", @"Gill Sans", @"Georgia",
                                           @"Heiti TC", @"Heiti SC", @"Helvetica",@"Courier New"];
    
    NSArray *testFontNameListDescending = @[@"Courier New", @"Helvetica", @"Heiti SC", @"Heiti TC",
                                            @"Georgia", @"Gill Sans", @"Futura", @"Arial"];
    
    
    NSArray *sortedArray = [[FontListDataController sharedStore] sortFontNameArray:testFontNameList byFontNameDisplaySizeAscending:YES andFontNameAscending:YES];
    
    XCTAssertEqualObjects(testFontNameListAscending, sortedArray);
    
    NSArray *sortedArray2 = [[FontListDataController sharedStore] sortFontNameArray:testFontNameList byFontNameDisplaySizeAscending:YES andFontNameAscending:NO];
    
    XCTAssertEqualObjects(testFontNameListAscending, sortedArray2);
    
    NSArray *sortedArrayDesc = [[FontListDataController sharedStore] sortFontNameArray:testFontNameList byFontNameDisplaySizeAscending:NO andFontNameAscending:YES];
    
    XCTAssertEqualObjects(testFontNameListDescending, sortedArrayDesc);
    
    NSArray *sortedArrayDesc2 = [[FontListDataController sharedStore] sortFontNameArray:testFontNameList byFontNameDisplaySizeAscending:NO andFontNameAscending:NO];
    
    XCTAssertEqualObjects(testFontNameListDescending, sortedArrayDesc2);
}

- (void)testFontListDataControllerReverseElementsInArray {
    NSArray *testFontNameList = @[@"a", @"ab", @"abc", @"a1", @"ab1", @"abc1"];
    NSArray *testFontNameListReversed = @[@"abc1", @"ab1", @"a1", @"abc", @"ab", @"a"];
    
    NSArray *reversedArray = [[FontListDataController sharedStore] reverseElementsInArray:testFontNameList];
    
    XCTAssertEqualObjects(testFontNameListReversed, reversedArray);
    
    NSArray *reversedArray2 = [[FontListDataController sharedStore] reverseElementsInArray:reversedArray];
    
    XCTAssertEqualObjects(testFontNameList, reversedArray2);
}


#pragma marks - Public method tests

- (void)testFontListDataControllerSharedStoreIsOnlyOne {
    FontListDataController *sharedStore = [FontListDataController sharedStore];
    
    XCTAssertTrue([[FontListDataController sharedStore] isEqual:sharedStore]);
}

- (void)testFontListDataControllerInitFailsWithException {
    XCTAssertThrowsSpecific([[FontListDataController alloc] init], NSException);
}

- (void)testFontListDataControllerSharedStoreFontListIsMoreThanZero {
    XCTAssertTrue([[FontListDataController sharedStore] count] > 0);
}

- (void)testFontListDataControllerSharedStoreFontListIsNotNilWhenCharactersReversed {
    XCTAssertNil([[FontListDataController sharedStore] nonCharactersReversedFontList]);
    
    [[FontListDataController sharedStore] reverseCharactersInFontNames];
    
    XCTAssertNotNil([[FontListDataController sharedStore] nonCharactersReversedFontList]);
    XCTAssertTrue([[FontListDataController sharedStore] count] > 0);
}

- (void)testFontListDataControllerSharedStoreInsertAndRemoveFontName {
    NSUInteger originalCount = [[FontListDataController sharedStore] count];
    
    XCTAssertGreaterThan(originalCount, 0);
    
    [[FontListDataController sharedStore] insertFontName:@"TestFontName" atIndex:0];
    NSString *firstFontName = [[FontListDataController sharedStore] fontNameAtIndex:0];
    
    XCTAssertTrue([firstFontName isEqualToString:@"TestFontName"]);
    
    NSUInteger newCount = [[FontListDataController sharedStore] count];
    XCTAssertEqual(newCount, originalCount + 1);
    
    [[FontListDataController sharedStore] removeFontNameAtIndex:0];
    
    XCTAssertEqual([[FontListDataController sharedStore] count], newCount - 1);
    XCTAssertEqual([[FontListDataController sharedStore] count], originalCount);
    XCTAssertNotEqualObjects([[FontListDataController sharedStore] fontNameAtIndex:0], @"TestFontName");
}

- (void)testFontListDataControllerSharedStoreReverseCharacters {
    NSUInteger originalCount = [[FontListDataController sharedStore] count];
    NSString *firstFontName = [[FontListDataController sharedStore] fontNameAtIndex:0];
    NSString *reversedFontName = [[FontListDataController sharedStore] reverseCharactersOfString:firstFontName];
    
    [[FontListDataController sharedStore] reverseCharactersInFontNames];
    
    XCTAssertEqual(originalCount, [[FontListDataController sharedStore] count]);
    
    NSString *reversedFirstFontName = [[FontListDataController sharedStore] fontNameAtIndex:0];
    
    XCTAssertNotEqualObjects(firstFontName, reversedFirstFontName);
    XCTAssertEqualObjects(reversedFontName, reversedFirstFontName);
}




@end
