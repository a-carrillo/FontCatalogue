//
//  FontCatalogueMasterViewController.m
//  Font Catalogue
//
//  Created by Alvaro Carrillo on 30/04/2016.
//  Copyright (c) 2016 Alvaro Carrillo. All rights reserved.
//

#import "FontCatalogueMasterViewController.h"
#import "FontCatalogueDetailViewController.h"
#import "FontListDataController.h"

@interface FontCatalogueMasterViewController()

@property (nonatomic, strong) FontListDataController *fontListDataController;
@property (nonatomic, assign) NSInteger labelAlignment;
@property (nonatomic, assign) BOOL charactersReversed;
@property (nonatomic, strong) IBOutlet UISegmentedControl *sortControl;
@property (nonatomic, strong) IBOutlet UISegmentedControl *alignmentControl;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reverseCharactersButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reverseOrderButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *restoreDefaultListButtonItem;

@end

@implementation FontCatalogueMasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.fontListDataController = [FontListDataController sharedStore];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.labelAlignment = NSTextAlignmentLeft;
    self.charactersReversed = NO;
    
    // set font for toolbar items...
    NSDictionary *toolbarButtonItemAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:[UIFont buttonFontSize]]};
    
    // ...alignment segmented control
    [self.alignmentControl setTitleTextAttributes:toolbarButtonItemAttributes forState:UIControlStateNormal];
    
    [self.alignmentControl setTitle:@"\uf036" forSegmentAtIndex:0];     //fa-align-left
    [self.alignmentControl setTitle:@"\uf038" forSegmentAtIndex:1];     //fa-align-right
    
    
    // ...reverse characters bar button item
    [self.reverseCharactersButtonItem setTitleTextAttributes:toolbarButtonItemAttributes forState:UIControlStateNormal];
    self.reverseCharactersButtonItem.title = @"\uf04a";     //fa-backward
    
    // ...sorting segmented control
    [self.sortControl setTitleTextAttributes:toolbarButtonItemAttributes forState:UIControlStateNormal];
    [self.sortControl setTitle:@"\uf15d" forSegmentAtIndex:0];      //fa-sort-alpha-asc
    [self.sortControl setTitle:@"\uf162" forSegmentAtIndex:1];      //fa-sort-numeric-asc
    [self.sortControl setTitle:@"\uf160" forSegmentAtIndex:2];      //fa-sort-amount-asc
    
    // ...reverse sorting bar button item
    [self.reverseOrderButtonItem setTitleTextAttributes:toolbarButtonItemAttributes forState:UIControlStateNormal];
    self.reverseOrderButtonItem.title = @"\uf0dd";       //fa-sort-desc
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.fontListDataController).count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FontNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //configure the cell
    NSString *currentFontName = [self.fontListDataController fontNameAtIndex:indexPath.row];
    cell.textLabel.text = currentFontName;
    
    if (self.charactersReversed) {
        cell.textLabel.font = [UIFont fontWithName:(self.fontListDataController.nonCharactersReversedFontList)[indexPath.row] size:[UIFont labelFontSize]];
    } else {
        cell.textLabel.font = [UIFont fontWithName:currentFontName size:[UIFont labelFontSize]];
    }
    
    cell.textLabel.textAlignment = self.labelAlignment;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.fontListDataController removeFontNameAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *fontNameToMove = [self.fontListDataController fontNameAtIndex:fromIndexPath.row];
    [self.fontListDataController removeFontNameAtIndex:fromIndexPath.row];
    [self.fontListDataController insertFontName:fontNameToMove atIndex:toIndexPath.row];
    
    // deselect any sort option selected
    (self.sortControl).selectedSegmentIndex = UISegmentedControlNoSegment;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    //disable toolbar items when editing    
    if (editing) {
        self.restoreDefaultListButtonItem.enabled = NO;
        self.reverseCharactersButtonItem.enabled = NO;
        self.reverseOrderButtonItem.enabled = NO;
        self.sortControl.enabled = NO;
        self.alignmentControl.enabled = NO;
        
    } else {
        self.restoreDefaultListButtonItem.enabled = YES;
        self.reverseCharactersButtonItem.enabled = YES;
        self.reverseOrderButtonItem.enabled = YES;
        self.sortControl.enabled = YES;
        self.alignmentControl.enabled = YES;
    }
}


#pragma mark - Segues & Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = (self.tableView).indexPathForSelectedRow;
        NSString *fontName = [self.fontListDataController fontNameAtIndex:indexPath.row];
        
        FontCatalogueDetailViewController *detailViewController = (FontCatalogueDetailViewController *)segue.destinationViewController;
        detailViewController.fontName = fontName;
    }
}

/**
 *  Reverts the font list to the initial default
 */
- (IBAction)revertToDefault
{
    self.fontListDataController = [FontListDataController sharedStore];
    [self.tableView reloadData];
}


/**
 *  Changes the alignment of the text in the table view cells
 *
 *  @param sender The alignment segmented control
 */
- (IBAction)alignTableCellLabels:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:         // align left
            self.labelAlignment = NSTextAlignmentLeft;
            break;
        
        case 1:         //align right
            self.labelAlignment = NSTextAlignmentRight;
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

/**
 *  Reverses the characters of the text in the table view cells
 *
 *  @param sender The reverse characters bar button item
 */
- (IBAction)reverseTableCellLabelCharacters:(id)sender
{
    UIBarButtonItem *reverseCharactersButton = sender;
    
    [self.fontListDataController reverseCharactersInFontNames];
    
    self.charactersReversed = !self.charactersReversed;
    
    if (self.charactersReversed) {
        reverseCharactersButton.title = @"\uf04e";     //fa-forward
    } else {
        reverseCharactersButton.title = @"\uf04a";     //fa-backward
    }
    
    [self.tableView reloadData];
}


/**
 *  Sorts the table view cells
 *
 *  @param sender The sort segmented control
 */
- (IBAction)sortTableCells:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case SortTypeAlphanumeric:          //sort alphanumerically
            [self.fontListDataController sortFontList:SortTypeAlphanumeric];
            break;
            
        case SortTypeCharacterCount:        //sort by character count
            [self.fontListDataController sortFontList:SortTypeCharacterCount];
            break;
            
        case SortTypeDisplaySize:           //sort by display size
            [self.fontListDataController sortFontList:SortTypeDisplaySize];
            break;
            
        default:
            NSLog(@"sortTableCells -- unknownSortType: %i", segmentedControl.selectedSegmentIndex);
            break;
    }
    
    [self.tableView reloadData];
}


/**
 *  Reverses the order of the table view cells
 */
- (IBAction)reverseTableCells
{
    [self.fontListDataController reverseFontList];
    
    [self.tableView reloadData];
}

@end
