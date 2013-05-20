//
//  FAQViewController.m
//  MascotAPP
//
//  Created by Samuel on 25/10/12.
//
//

#import "FAQViewController.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

@synthesize FAQtextView = _FAQtextView;
@synthesize faqIndex = _faqIndex;

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


-(void)viewDidAppear:(BOOL)animated{
    
    NSError *error;
    NSString* path, *textString;
    
    switch (_faqIndex) {
        case 0:
            path = [[NSBundle mainBundle] pathForResource:@"agenda" ofType:@"txt"];
            textString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            [_FAQtextView setText:textString];
            break;
        case 1:
            path = [[NSBundle mainBundle] pathForResource:@"gastos" ofType:@"txt"];
            textString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            [_FAQtextView setText:textString];
            break;
        case 2:
            path = [[NSBundle mainBundle] pathForResource:@"mascotas" ofType:@"txt"];
            textString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            [_FAQtextView setText:textString];
            break;
        case 3:
            path = [[NSBundle mainBundle] pathForResource:@"contactos" ofType:@"txt"];
            textString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            [_FAQtextView setText:textString];
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFAQtextView:nil];
    [super viewDidUnload];
}
@end
