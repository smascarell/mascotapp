//
//  GastosGraficoViewController.m
//  MascotAPP
//
//  Created by Samuel on 04/10/12.
//
//

#import "GastosGraficoViewController.h"

@interface GastosGraficoViewController ()

@end

@implementation GastosGraficoViewController

@synthesize hostView = hostView_;
@synthesize graphicsResultsController = _graphicsResultsController;
@synthesize fetchedResultsController = _fetchedResultsController;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize gastoTotallbl = _gastoTotallbl;
@synthesize fecha = _fecha;
@synthesize porMes = _porMes;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#pragma mark - UIViewController lifecycle methods

-(void)viewDidAppear:(BOOL)animated {
            
    [super viewDidAppear:animated];
    if (self.porMes) {
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        fetchRequest = [self.fetchedResultsController fetchRequest];
        
        self.graphicsResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        NSError *error = nil;
        
        if (![self.graphicsResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
               
        plotPrices = [[NSMutableArray alloc]initWithCapacity:12];
        
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = self.fecha;
        NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit
                                                       fromDate:date];
        NSInteger year = [dateComponents year];
               
        for (int i = 0; i<12; i++) {
            [plotPrices addObject:[self totalForMonth:i+1 year:year]];
        }
        
        [self initPlot];

    } else {
        
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
        
        fetchRequest = [self.fetchedResultsController fetchRequest];
        
        self.graphicsResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:@"getYear"
                                                                                      cacheName:nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error = nil;
        
        if (![self.graphicsResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        plotDataDict = [[NSMutableDictionary alloc]initWithCapacity:[self.graphicsResultsController.sections count]];
        plotPrices = [[NSMutableArray alloc]initWithCapacity:[self.graphicsResultsController.sections count]];
          
        for (int i = 0; i<[self.graphicsResultsController.sections count]; i++) {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.graphicsResultsController sections]
                                                            objectAtIndex:i];
            NSInteger year = [[sectionInfo name] integerValue];
            NSDate *d = [NSDate dateWithYear:year month:1 day:1];
            NSNumber *expense = [self totalForYear:d];
            
            [plotPrices addObject:expense];
                       
            NSString *key = [NSString stringWithFormat:@"%i",i];
            [plotDataDict setObject:[NSMutableArray arrayWithObjects:[sectionInfo name],plotPrices[i], nil] forKey:key];
            
        }
        [self initPlot];
    }
}

#pragma mark - Chart behavior
-(void)initPlot {
    
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    [self configureTotal];
    
   }

-(void)configureTotal {
   
    NSNumber *sum = [self.graphicsResultsController.fetchedObjects
                     valueForKeyPath:@"@sum.precio"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    [f setMinimumFractionDigits:2];
    [f setMaximumFractionDigits:2];
    
    NSString *precio = [f stringFromNumber: sum];
    
    self.gastoTotallbl.text = [NSString stringWithString:precio];
    
}
-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    // 2 - Set graph title
    NSString *title = @"MascoGastos";
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 12.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 5.0f);
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:9.0f];
    [graph.plotAreaFrame setPaddingBottom:5.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
}

-(void)configurePlots {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // 2 - Create the plots
    CPTScatterPlot *petPlot = [[CPTScatterPlot alloc] init];
    petPlot.dataSource = self;
    petPlot.identifier = CPDTickerSymbolAAPL;
    CPTColor *aaplColor = [CPTColor whiteColor];
    [graph addPlot:petPlot toPlotSpace:plotSpace];
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:petPlot, nil]];
    
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)]; 
    plotSpace.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *aaplLineStyle = [petPlot.dataLineStyle mutableCopy];
    aaplLineStyle.lineWidth = 2.5f;
    aaplLineStyle.lineColor = aaplColor;
    petPlot.dataLineStyle = aaplLineStyle;
    CPTMutableLineStyle *aaplSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    aaplSymbolLineStyle.lineColor = aaplColor;
    CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    aaplSymbol.fill = [CPTFill fillWithColor:aaplColor];
    aaplSymbol.lineStyle = aaplSymbolLineStyle;
    aaplSymbol.size = CGSizeMake(6.0f, 6.0f);
    petPlot.plotSymbol = aaplSymbol;
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 10.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Fecha";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
        
    CGFloat dateCount = [plotPrices count];
    
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    if (self.porMes) {
        for (NSString *date in [self monthDates]) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
            CGFloat location = i++;
            label.tickLocation = CPTDecimalFromCGFloat(location);
            label.offset = x.majorTickLength;
            if (label) {
                [xLabels addObject:label];
                [xLocations addObject:[NSNumber numberWithFloat:location]];
            }
        }

    } else {
        for (int i = 0; i<dateCount; i++) {
            NSString *currentValue = [NSString stringWithFormat:@"%i",i];
            NSArray *valuesArray = [plotDataDict valueForKeyPath:currentValue];
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@",valuesArray[0]] textStyle:x.labelTextStyle];
            CGFloat location = i;
            label.tickLocation = CPTDecimalFromCGFloat(location);
            label.offset = x.majorTickLength;
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Gasto";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -35.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    
    NSInteger majorIncrement = 10;
    NSInteger minorIncrement = 1;

    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    
    NSArray *sortedArray = [plotPrices sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
            
    // determine dynamically based on max price
    CGFloat yMax = [sortedArray[0] floatValue];

    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {

    return [plotPrices count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSInteger valueCount = [plotPrices count];

    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
           if (index < valueCount) {
               return [NSNumber numberWithUnsignedInteger:index];
           }
            break;

        case CPTScatterPlotFieldY: {
            NSNumber *num = plotPrices[index];
            return num;
        }

        break;
    }
    return [NSDecimalNumber zero];
}

- (NSArray *)monthDates
{
    static NSArray *dates = nil;
    if (!dates)
    {
        dates = [NSArray arrayWithObjects:
                 @"Ene",
                 @"",
                 @"",
                 @"Abr",
                 @"",
                 @"",
                 @"",
                 @"Ago",
                 @"",
                 @"",
                 @"",
                 @"Dic",
                 nil];
    }
    return dates;
}

-(NSNumber *)totalForMonth:(NSInteger)month year:(NSInteger)year{
    
    NSDate *date1 = [NSDate firstDayOfMonth:month year:year];
    date1 = [NSDate midnightOfDate:date1];
    NSDate *date2 = [NSDate firstDayOfNextMonth:date1];
    
    NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha < %@", date1, date2];

    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Gastos"
                                              inManagedObjectContext:self.managedObjectContext];
    [req setPredicate:sumPredicate];
    [req setEntity:entity];
    
    
    NSError *errorSubjects;
    NSArray *subjectList = [self.managedObjectContext executeFetchRequest:req error:&errorSubjects];
       
    NSNumber *sum = [subjectList valueForKeyPath:@"@sum.precio"];

    return sum;
}

-(NSNumber *)totalForYear:(NSDate *)date{
    
    NSDate *date1 = [NSDate firstDayOfYear:date];
    NSDate *date2 = [NSDate lastDayOfYear:date];
    
    NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha < %@", date1, date2];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Gastos"
                                              inManagedObjectContext:self.managedObjectContext];
    [req setPredicate:sumPredicate];
    [req setEntity:entity];
    
    
    NSError *errorSubjects;
    NSArray *subjectList = [self.managedObjectContext executeFetchRequest:req error:&errorSubjects];
    
    NSNumber *sum = [subjectList valueForKeyPath:@"@sum.precio"];
    //NSLog(@"%i",[sum integerValue]);
    
    return sum;
}

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


- (void)viewDidUnload {
    [self setGastoTotallbl:nil];
    [super viewDidUnload];
}
@end
