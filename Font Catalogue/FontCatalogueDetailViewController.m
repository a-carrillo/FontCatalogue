//
//  FontCatalogueDetailViewController.m
//  Font Catalogue
//
//  Created by Alvaro Carrillo on 30/04/2016.
//  Copyright (c) 2016 Alvaro Carrillo. All rights reserved.
//

#import "FontCatalogueDetailViewController.h"

@interface FontCatalogueDetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *sampleTextLabel;

@end


@implementation FontCatalogueDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureView
{
    // Update the user interface for the detail item.
    NSString *displayText = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\na b c d e f g h i j k l m n o p q r s t u v w x y z\n1 2 3 4 5 6 7 8 9 0";
    
    if (self.fontName) {
        self.sampleTextLabel.text = displayText;
        self.sampleTextLabel.font = [UIFont fontWithName:self.fontName size:[UIFont labelFontSize]];
        self.title = self.fontName;
    }
}

@end
