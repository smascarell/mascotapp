//
//  SegmentedControlCell.h
//  MascotAPP
//
//  Created by Samuel on 10/08/12.
//
//

#import <UIKit/UIKit.h>

@protocol CambiarSexo;

@interface SegmentedControlCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *selectorsexo;
@property (nonatomic, weak) id <CambiarSexo> delegado;


@end

@protocol CambiarSexo

- (void)machohembra:(NSInteger *)segmento;

@end