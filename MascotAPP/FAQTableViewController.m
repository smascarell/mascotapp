//
//  FAQTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 25/10/12.
//
//

#import "FAQTableViewController.h"

@interface FAQTableViewController ()

@end

@implementation FAQTableViewController

- (IBAction)cerrarVolver:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    FAQViewController *faqView = (FAQViewController *)[segue destinationViewController];
    [faqView.FAQtextView setShowsVerticalScrollIndicator:YES];
    
    if ([segue.identifier isEqualToString:@"faqAgenda"]) {
        faqView.faqIndex = 0;
    }
    if ([segue.identifier isEqualToString:@"faqGastos"]) {
        faqView.faqIndex = 1;
    }
    if ([segue.identifier isEqualToString:@"faqMascotas"]) {
        faqView.faqIndex = 2;
    }
    if ([segue.identifier isEqualToString:@"faqContactos"]) {
        faqView.faqIndex = 3;
    }
        
}


@end
