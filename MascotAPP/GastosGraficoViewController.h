//
//  GastosGraficoViewController.h
//  MascotAPP
//
//  Created by Samuel on 04/10/12.
//
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "CPDConstants.h"
#import "CPDStockPriceStore.h"
#import "NSDate+Reporting.h"

@interface GastosGraficoViewController : UIViewController <CPTPlotDataSource>{
    NSFetchRequest *fetchRequest;
    NSMutableArray *monthPrices;
    NSMutableArray *plotPrices;
    NSMutableDictionary *plotDataDict;
}

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *graphicsResultsController;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (strong,nonatomic) NSDate *fecha;
@property (nonatomic) BOOL porMes;

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (weak, nonatomic) IBOutlet UILabel *gastoTotallbl;

-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)configureTotal;

- (NSArray *)monthDates;
-(NSNumber *)totalForMonth:(NSInteger)month year:(NSInteger)year;

@end

