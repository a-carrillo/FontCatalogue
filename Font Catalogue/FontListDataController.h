//
//  FontListDataController.h
//  Font Catalogue
//
//  Created by Alvaro Carrillo on 30/04/2016.
//  Copyright (c) 2016 Alvaro Carrillo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SortType) {
    SortTypeNone = -1,
    SortTypeAlphanumeric = 0,
    SortTypeCharacterCount,
    SortTypeDisplaySize
};


@interface FontListDataController : NSObject

/**
 *  The font list without the characters reversed. 
 *  To be used only when the characters have been reversed.
 */
@property (nonatomic, copy, readonly) NSArray *nonCharactersReversedFontList;

/**
 *  Indicates the current sort type
 */
@property (nonatomic, assign) SortType currentSortType;

/**
 *  Indicates whether the font list has been reversed
 */
@property (nonatomic, assign) BOOL listReversed;

/**
 *  The number of fonts in the font list
 */
@property (nonatomic, readonly) NSUInteger count;

- (NSString *)fontNameAtIndex:(NSUInteger)index;
- (void)removeFontNameAtIndex:(NSUInteger)index;
- (void)insertFontName:(NSString *)fontName atIndex:(NSUInteger)index;
- (void)reverseCharactersInFontNames;
- (void)sortFontList:(SortType)sortType;
- (void)reverseFontList;

+ (instancetype)sharedStore;

@end
