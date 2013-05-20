//
//  GaleriaFotosViewController.h
//  MascotAPP
//
//  Created by Samuel on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaleriaFotosViewController : UIViewController <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end