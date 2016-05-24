//
//  FontListDataController.m
//  Font Catalogue
//
//  Created by Alvaro Carrillo on 30/04/2016.
//  Copyright (c) 2016 Alvaro Carrillo. All rights reserved.
//

#import "FontListDataController.h"

@interface FontListDataController ()

@property (nonatomic, copy) NSMutableArray *fontNameList;   //the underlying list of fonts
@property (nonatomic, copy, readwrite) NSArray *nonCharactersReversedFontList;
@property (nonatomic, assign) BOOL charactersReversed;

@end


@implementation FontListDataController

#pragma mark - Initialisers

/**
 *  The font list shared store
 *
 *  @return The font list shared store (i.e. singleton)
 */
+ (instancetype)sharedStore
{
    static FontListDataController *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

/**
 *  The initialiser will simply return an exception describing the way in which
 *  this class should be used.
 *
 *  @return An NSException describing the usage
 */
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[FontListDataController sharedStore]"];
    return nil;
}

/**
 *  The private initialiser called by <code>+sharedStore</code>. Initialises the font name list.
 *
 *  @return An initialised instance of FontDataListController
 */
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _fontNameList = [[UIFont familyNames] mutableCopy];
        _listReversed = NO;
        _currentSortType = SortTypeNone;
        _charactersReversed = NO;
    }
    
    return self;
}


#pragma mark - Custom getters & setters

/**
 *  Custom setter for fontNameList to make sure we always have a mutable array.
 *
 *  @param newArray The array to be copied to fontNameList
 */
-(void)setFontNameList:(NSArray *)newArray
{
    if (_fontNameList != newArray) {
        _fontNameList = [newArray mutableCopy];
    }
}


#pragma mark - Private Operations

/**
 *  Reverses the characters in the specified string
 *
 *  @param stringToBeReversed The string to have its characters reversed
 *
 *  @return The string with its characters reversed
 */
- (NSString *)reverseCharactersOfString:(NSString *)stringToBeReversed
{
    NSUInteger charIndex = stringToBeReversed.length;
    NSMutableString *reversedString = [[NSMutableString alloc] initWithCapacity:charIndex];
    
    // loop through text backwards.. appending the characters to a new string
    while (charIndex > 0) {
        unichar character = [stringToBeReversed characterAtIndex:--charIndex];
        NSString *charString = [NSString stringWithCharacters:&character length:1];
        [reversedString appendString:charString];
    }
    
    return reversedString;
}


/**
 *  Sorts the specified array by the specified order alphanumerically
 *  (i.e. either ascending or descending alphanumerically)
 *
 *  @param arrayToSort         The array to be sorted
 *  @param alphaAscendingOrder Specify YES to sort alphanumerically ascending, else NO
 *
 *  @return The array sorted alphanumerically
 */
- (NSArray *)sortArray:(NSArray *)arrayToSort alphanumericallyAscending:(BOOL)alphaAscendingOrder
{
    NSSortDescriptor *alphaSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:alphaAscendingOrder selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *sortedArray = [arrayToSort sortedArrayUsingDescriptors:@[alphaSortDescriptor]];
    
    return sortedArray;
}


/**
 *  Sorts the specified array by the length of its string elements in the specified order.
 *  The secondary sort is by string value (alphanumerically);
 *
 *  @param arrayToSort                The array to be sorted
 *  @param stringLengthAscendingOrder Specify YES to sort by string length ascending, else NO
 *  @param stringValueAscendingOrder  Secondary sort. Specify YES to sort by string value ascending, else NO
 *
 *  @return The sorted array
 */
- (NSArray *)sortArray:(NSArray *)arrayToSort byElementStringLenthAscending:(BOOL) stringLengthAscendingOrder andElementStringValueAscending:(BOOL)stringValueAscendingOrder
{
    //first create key value pairs (array of dictionaries)
    NSString *stringLengthKey = @"stringLength";
    NSString *stringValueKey = @"stringValue";
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSString *string in arrayToSort) {
        NSDictionary *dict = @{stringValueKey:string, stringLengthKey:[NSNumber numberWithUnsignedInteger:string.length]};
        [tempArray addObject:dict];
    }
    
    // now sort contents of the temporary array (containing key value pairs)
    NSSortDescriptor *lengthDescriptor = [[NSSortDescriptor alloc] initWithKey:stringLengthKey ascending:stringLengthAscendingOrder selector:@selector(compare:)];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:stringValueKey ascending:stringValueAscendingOrder selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *sortedTempArray = [tempArray sortedArrayUsingDescriptors:@[lengthDescriptor, valueDescriptor]];
    
    // extract values from sorted array containing key value pairs
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in sortedTempArray) {
        [sortedArray addObject:dict[stringValueKey]];
    }
    
    return [sortedArray copy];
}


/**
 *  Sorts the specified array of font names by the display size of the font name 
 *  (based on the standard label font size) in the order specified.
 *  The secondary sort is by font name (alphanumerically).
 *
 *  @param arrayToSort               The array to be sorted
 *  @param displaySizeAscendingOrder Specify YES to sort by display size ascending, else NO
 *  @param fontNameAscendingOrder    Secondary sort. Specify YES to sort by font name ascending, else NO
 *
 *  @return The sorted array of font names
 */
- (NSArray *)sortFontNameArray:(NSArray *)arrayToSort byFontNameDisplaySizeAscending:(BOOL)displaySizeAscendingOrder andFontNameAscending:(BOOL)fontNameAscendingOrder
{
    //first create key value pairs (array of dictionaries)
    NSString *fontNameLengthKey = @"fontNameLength";
    NSString *fontNameKey = @"fontName";
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSString *fontName in arrayToSort) {
        //get width of text (i.e. font name) as rendered with font
        UIFont *currentFont = [UIFont fontWithName:fontName size:[UIFont labelFontSize]];
        //CGSize textSize = [fontName sizeWithFont:currentFont];            //sizeWithFont was deprecated in iOS 7.0
        CGSize textSize = [fontName sizeWithAttributes:@{NSFontAttributeName:currentFont}];
        CGFloat textWidth = textSize.width;
        
        NSDictionary *dict = @{fontNameKey:fontName, fontNameLengthKey:[NSNumber numberWithFloat:textWidth]};
        [tempArray addObject:dict];
    }
    
    // now sort contents of the temporary array (containing key value pairs)
    NSSortDescriptor *displaySizeDescriptor = [[NSSortDescriptor alloc] initWithKey:fontNameLengthKey ascending:displaySizeAscendingOrder selector:@selector(compare:)];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:fontNameKey ascending:fontNameAscendingOrder selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *sortedTempArray = [tempArray sortedArrayUsingDescriptors:@[displaySizeDescriptor, nameDescriptor]];
    
    // extract font names from sorted array containing key value pairs
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in sortedTempArray) {
        [sortedArray addObject:dict[fontNameKey]];
    }
    
    return [sortedArray copy];
}


/**
 *  Reverses the order of the elements in the specified array
 *
 *  @param arrayToReverse The array to reverse
 *
 *  @return The array with its elements in the reverse order
 */
- (NSArray *)reverseElementsInArray:(NSArray *)arrayToReverse
{
    NSMutableArray *reversedArray = [[NSMutableArray alloc] init];
    
    NSEnumerator *enumerator = [arrayToReverse reverseObjectEnumerator];
    
    for (id element in enumerator) {
        [reversedArray addObject:element];
    }
    
    return [reversedArray copy];
}


#pragma mark - Public Operations

/**
 *  List of fonts. Only to be used when the <code>reverseCharactersInFontNames</code> message
 *  has been sent and the characters have been reversed. Returns nil if characters have not been reversed.
 *
 *  @return The font list, if characters have been reversed in the font names, else nil
 */
- (NSArray *)nonCharactersReversedFontList
{
    if (!self.charactersReversed) {
        _nonCharactersReversedFontList = nil;
    }
    
    return _nonCharactersReversedFontList;
}

/**
 *  The number of fonts in the font list
 *
 *  @return The number of fonts
 */
- (NSUInteger)count
{
    return (self.fontNameList).count;
}


/**
 *  Returns the name of the font at the specified index of the font list.
 *
 *  @param index An index within the bounds of the font list
 *
 *  @return The font name at the specified index
 */
- (NSString *)fontNameAtIndex:(NSUInteger)index
{
    return (self.fontNameList)[index];
    
    [self.fontNameList objectAtIndex:0];
}


/**
 *  Removes the font name at the specified index from the font list
 *
 *  @param index The index from which to remove the font name in the font list. 
 *               Must be within the bounds of the font list.
 */
- (void)removeFontNameAtIndex:(NSUInteger)index
{
    [self.fontNameList removeObjectAtIndex:index];
}


/**
 *  Inserts the specified font name at the specified index of the font list
 *
 *  @param fontName The name of the font to be inserted into the font list
 *  @param index    The index at which the font name will be inserted. 
 *                  Must be within the bounds of the font list.
 */
- (void)insertFontName:(NSString *)fontName atIndex:(NSUInteger)index
{
    [self.fontNameList insertObject:fontName atIndex:index];
}


/**
 *  Reverses the characters of the font names in the font list
 */
- (void)reverseCharactersInFontNames
{
    self.nonCharactersReversedFontList = [self.fontNameList copy];
    
    // loop through all items in list and reverse the characters
    NSMutableArray *fontListWithReversedCharacters = [[NSMutableArray alloc] init];
    
    for (NSString *fontName in self.fontNameList) {
        NSString *reversedFontName = [self reverseCharactersOfString:fontName];
        [fontListWithReversedCharacters addObject:reversedFontName];
    }
    
    self.fontNameList = fontListWithReversedCharacters;
    self.charactersReversed = !self.charactersReversed;
}


/**
 *  Sorts the list of fonts by the specified sortType
 *
 *  @param sortType SortTypeNone, SortTypeAlphanumeric, SortTypeCharacterCount or SortTypeDisplaySize
 */
- (void)sortFontList:(SortType)sortType
{
    switch (sortType) {
        case SortTypeAlphanumeric:
            self.fontNameList = [[self sortArray:self.fontNameList alphanumericallyAscending:YES] mutableCopy];
            self.currentSortType = SortTypeAlphanumeric;
            break;
            
        case SortTypeCharacterCount:
            self.fontNameList = [[self sortArray:self.fontNameList byElementStringLenthAscending:YES andElementStringValueAscending:YES] mutableCopy];
            self.currentSortType = SortTypeCharacterCount;
            break;
            
        case SortTypeDisplaySize:
            self.fontNameList = [[self sortFontNameArray:self.fontNameList byFontNameDisplaySizeAscending:YES andFontNameAscending:YES] mutableCopy];
            self.currentSortType = SortTypeDisplaySize;
            break;
            
        case SortTypeNone:
            self.currentSortType = SortTypeNone;
            break;
            
        default:
            NSLog(@"%@ -- unknown sortType: %i", NSStringFromSelector(_cmd), sortType);
            break;
    }
}


/**
 *  Reverses the list of fonts
 */
- (void)reverseFontList
{
    self.fontNameList = [[self reverseElementsInArray:self.fontNameList] mutableCopy];
    self.listReversed = !self.listReversed;
}

@end
