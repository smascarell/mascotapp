//
//  SegmentedControlCell.m
//  MascotAPP
//
//  Created by Samuel on 10/08/12.
//
//

#import "SegmentedControlCell.h"

@implementation SegmentedControlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actualizar:(id)sender {
    
    [self.delegado machohembra:(NSInteger *)self.selectorsexo.selectedSegmentIndex];
}

@end