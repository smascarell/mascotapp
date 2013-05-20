//
//  FAQViewController.h
//  MascotAPP
//
//  Created by Samuel on 25/10/12.
//
//

#import <UIKit/UIKit.h>

@interface FAQViewController : UIViewController <UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITextView *FAQtextView;
@property (nonatomic,assign) NSInteger faqIndex;

@end