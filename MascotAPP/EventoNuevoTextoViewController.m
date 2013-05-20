//
//  EventoNuevoTextoViewController.m
//  MascotAPP
//
//  Created by Samuel on 13/08/12.
//
//

#import "EventoNuevoTextoViewController.h"

@interface EventoNuevoTextoViewController ()

@end

@implementation EventoNuevoTextoViewController
@synthesize texto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTexto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (IBAction)usartexto:(id)sender {
    
    [self.delegado ActualizarTextoEvento:self texto:self.texto.text indexPath:self.indexPath];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.texto.text = [NSString stringWithFormat:@"section %i, row %i",self.indexPath.section, self.indexPath.row];
    [self.texto becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
