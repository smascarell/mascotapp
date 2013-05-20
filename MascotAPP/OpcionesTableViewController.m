//
//  OpcionesTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 08/10/12.
//
//

#import "OpcionesTableViewController.h"

@interface OpcionesTableViewController ()

@end

@implementation OpcionesTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 4;
            break;
        default:
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Versión", nil);
                    cell.detailTextLabel.text = NSLocalizedString(@"1.0.0", nil);
                    cell.imageView.image = [UIImage imageNamed:@"info-icon"];
                    cell.userInteractionEnabled = NO;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Desarrollo", nil);
                    cell.detailTextLabel.text = NSLocalizedString(@"Samuel Mascarell", nil);
                    cell.imageView.image = [UIImage imageNamed:@"desarrollo-icon"];
                    cell.userInteractionEnabled = NO;
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Soporte", nil);
                    cell.detailTextLabel.text = @"";
                    cell.imageView.image = [UIImage imageNamed:@"email-icon"];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"FAQ", nil);
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    cell.detailTextLabel.text = @"";
                    cell.imageView.image = [UIImage imageNamed:@"faq-icon"];
                    break;
                default:
                    break;
            }
            break;

        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Inspirado en", nil);
                    cell.detailTextLabel.text = NSLocalizedString(@"Uruk Hai", nil);
                    cell.imageView.image = [UIImage imageNamed:@"uruk-icon"];
                    cell.userInteractionEnabled = NO;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Tapku Library", nil);
                    cell.detailTextLabel.text = NSLocalizedString(@"Tapku", nil);
                    cell.imageView.image = [UIImage imageNamed:@"categoria-gasto"];
                    cell.userInteractionEnabled = NO;
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"ProgressHUD", nil);
                    cell.detailTextLabel.text = NSLocalizedString(@"M. Bukovinski", nil);
                    cell.imageView.image = [UIImage imageNamed:@"categoria-gasto"];
                    cell.userInteractionEnabled = NO;
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"Plotting Framework", nil);
                    cell.detailTextLabel.text = NSLocalizedString(@"Core Plot", nil);
                    cell.imageView.image = [UIImage imageNamed:@"categoria-gasto"];
                    cell.userInteractionEnabled = NO;
                    break;
                default:

                    break;

            }
            
        default:
            break;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *texto = @"";
    switch (section) {
        case 0:
            texto = NSLocalizedString(@"Info", nil);
            break;
        case 1:
            texto = NSLocalizedString(@"Créditos", nil);
            break;            
        default:
            break;
    }
    return texto;
}

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 2:
                    [self setupEmailModalView];
                    break;
                case 3:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MascotApp" bundle:[NSBundle mainBundle]];
                    FAQTableViewController *faq = (FAQTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FAQTableViewController"];
                    [faq setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self.navigationController presentModalViewController:faq animated:YES];
                    break;
                    
                }
                   
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) setupEmailModalView {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = (id)self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet

    // Fill out the email body text
    NSArray *toRecipients = [NSArray arrayWithObject:@"s.mascarell@gmail.com"];
    NSString *subjectText = [NSString stringWithFormat:NSLocalizedString(@"Soporte/Feedback MascotApp", nil)];
       
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [picker setSubject:subjectText];
    [picker setToRecipients:toRecipients];
   
    [self presentModalViewController:picker animated:YES];
    
}


@end
