//
//  PesosViewController.m
//  mascotapp
//
//  Created by Samuel Mascarell on 20/05/13.
//
//

#import "PesosViewController.h"

@interface PesosViewController ()

@end

@implementation PesosViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)volver:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nuevo:(id)sender {
}
@end
