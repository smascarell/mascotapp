//
//  EventoAgendaCell.m
//  MascotAPP
//
//  Created by Samuel on 13/08/12.
//
//

#import "EventoAgendaCell.h"


@implementation EventoAgendaCell

@synthesize titulo;
@synthesize useDarkBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:useDarkBackground ? @"DarkBackground" : @"LightBackground" ofType:@"png"];
//        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
//        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
//        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.backgroundView.frame = self.bounds;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)botonPulsado{
    [self.delegado cambiarEstadoEvento:self];
}

@end
