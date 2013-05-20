//
//  OpcionesTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 08/10/12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FAQTableViewController.h"

@interface OpcionesTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

-(void) setupEmailModalView;

@end
