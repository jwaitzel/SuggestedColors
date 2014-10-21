//
//  ColorsViewController.m
//  Plugin
//
//  Created by Javi Waitzel on 10/20/14.
//  Copyright (c) 2014 Monsters Inc. All rights reserved.
//

#import "ColorsViewController.h"
#import "ColorCell.h"

@interface ColorsViewController () <NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *colorsTableView;

@end

@implementation ColorsViewController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return 5;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    
    // Get an existing cell with the MyView identifier if it exists
    ColorCell *colorCell = [tableView makeViewWithIdentifier:@"ColorCell" owner:self];
    colorCell.textField.stringValue = [NSString stringWithFormat:@"%i", row];
    colorCell.colorWell.color = [NSColor redColor];
    
    // Return the result
    return colorCell;
}

@end
