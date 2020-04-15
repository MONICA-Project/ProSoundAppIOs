//
//  ScatterPlotView.m
//  EiB
//
//  Created by CNet Mac Account on 1/27/14.
//  Copyright (c) 2014 CNet Mac Account. All rights reserved.
//

#import "UIScatterPlotView.h"
#import "CorePlot-CocoaTouch.h"
#import "MonicaPro-Swift.h"
//#import "History.h"
//#import "HelperClass.h"

NSString *const kAnnotationPlots    = @"Annotation Plots";
NSString *const kDataPlots          = @"Data Plots";
NSString *const kDataPlots2         = @"Data Plots2";
CGFloat const kHitPercentage        = 0.05;

@implementation UIScatterPlotView


@synthesize dataForPlot, boundLinePlot, fixedYMax;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}


- (void)reloadClearData
{
    dataForPlot = nil;
    //Remove annotation
    [self showAnnotationAndSymbol:NO index:0];
    [lineChart reloadData];
    
}



- (void)setMaxRange:(CPTPlotRange *)xRange
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)lineChart.defaultPlotSpace;
    
    if(plotSpace)
    [plotSpace setGlobalXRange:xRange];
    
}

- (void)setDisplayedXRange:(CPTPlotRange *)xRange
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)lineChart.defaultPlotSpace;
    
    if(plotSpace)
    plotSpace.xRange = xRange;
}


- (void)updatePlot
{
    [self setDisplayedRangeToData];
    [self updateXLabelsV2];
    [lineChart reloadData];
    //[self animateBarChart];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)lineChart.defaultPlotSpace;
    currentAxisLabel = 0;
    [self plotSpace:plotSpace willChangePlotRangeTo:plotSpace.xRange forCoordinate:CPTCoordinateX];
}

- (void)setDisplayedRangeToData
{
    double xMin = FLT_MAX;
    double xMax = FLT_MIN;
    double yMin = FLT_MAX;
    double yMax = FLT_MIN;
    
    
    for(NSDictionary* d in dataForPlot)
    {
        double y = [[d valueForKey:@"y"] doubleValue];
        double y2 = [[d valueForKey:@"y2"] doubleValue];
        double x = [[d valueForKey:@"x"] doubleValue];
        
        if(x<xMin)
        xMin=x;
        if(x>xMax)
        xMax=x;
        if(y<yMin)
        yMin=y;
        if(y>yMax)
        yMax=y;
        if(y2<yMin)
        yMin=y2;
        if(y2>yMax)
        yMax=y2;
    }
    rangeMax = yMax*1.3;
    if (fixedYMax > 0) {
        rangeMax = fixedYMax;
    }
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)lineChart.defaultPlotSpace;
    
    double len = 16;
    CPTPlotRange* xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-0.5f) length:CPTDecimalFromDouble(len)];
    CPTPlotRange* yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(rangeMax)];
    plotSpace.yRange = yRange;
    plotSpace.xRange = xRange;
    [plotSpace setGlobalXRange:xRange];
}

-(void)createChartIfNeeded
{
    if(lineChart) //Chart already created
    return;
    // Create barChart from theme
    /*lineChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
     CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
     [lineChart applyTheme:theme];*/
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    lineChart = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = lineChart;
    //lineChart.delegate = self;
    NSArray *chartLayers = [[NSArray alloc] initWithObjects:
                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLines],
                            [NSNumber numberWithInt:CPTGraphLayerTypePlots],
                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLabels],
                            [NSNumber numberWithInt:CPTGraphLayerTypeMajorGridLines],
                            [NSNumber numberWithInt:CPTGraphLayerTypeMinorGridLines],
                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisTitles],
                            nil];
    lineChart.topDownLayerOrder = chartLayers;
    
    // Border
    lineChart.plotAreaFrame.borderLineStyle = nil;
    lineChart.plotAreaFrame.cornerRadius    = 0.0f;
    lineChart.plotAreaFrame.masksToBorder   = NO;
    
    // Paddings
    lineChart.paddingLeft   = 0.0f;
    lineChart.paddingRight  = 0.0f;
    lineChart.paddingTop    = 0.0f;
    lineChart.paddingBottom = 0.0f;
    

    lineChart.plotAreaFrame.paddingLeft   = 30.0;
    lineChart.plotAreaFrame.paddingTop    = 20.0;
    lineChart.plotAreaFrame.paddingRight  = 20.0;
    lineChart.plotAreaFrame.paddingBottom = 40.0;

    
    //START HERE
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)lineChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(3000.0f)];
    
    //plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([[NSDate date] timeIntervalSince1970]-kOneDay) length:CPTDecimalFromFloat(kOneDay)];
    
    plotSpace.allowsUserInteraction=YES;
    plotSpace.delegate = self;
    
    
    CPTMutableLineStyle *lineStyleX = [CPTMutableLineStyle lineStyle];
    lineStyleX.lineColor = [CPTColor darkGrayColor];
    lineStyleX.lineWidth = 2.0f;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)lineChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = lineStyleX;
    x.majorTickLineStyle          = lineStyleX;
    x.minorTickLineStyle          = lineStyleX;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.title                       = @"";
    x.titleOffset                 = 30.0f;
    x.minorTicksPerInterval = 4;
    
    // Define some custom labels for the data elements
    x.labelRotation  = M_PI / 4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    CPTMutableLineStyle *lineStyleY = [CPTMutableLineStyle lineStyle];
    lineStyleY.lineColor = [CPTColor lightGrayColor];
    lineStyleY.lineWidth = 0.5f;
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.majorGridLineStyle          = lineStyleY;
    y.minorTickLineStyle          = nil;
    y.preferredNumberOfMajorTicks = 5;//         = CPTDecimalFromString(@"10");
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.title                       = @"";
    CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
    labelTextStyle.color          = [CPTColor darkGrayColor];
    labelTextStyle.fontSize       = 20.0f ;
    labelTextStyle.fontName = [UIFont appPrimaryFontWithSize:20.0].fontName;
    y.titleTextStyle              = labelTextStyle;
    y.titleOffset                 = 54.0f;
    //y.titleLocation               = CPTDecimalFromFloat(9.7f);
    NSNumberFormatter *Xformatter = [[NSNumberFormatter alloc] init];
    [Xformatter setMaximumFractionDigits:6];
    [Xformatter setNumberStyle:NSNumberFormatterDecimalStyle];
    y.labelFormatter = Xformatter;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    CPTMutableTextStyle *tsAxis = [[CPTMutableTextStyle alloc] init];
    tsAxis.fontName = [UIFont appPrimaryFontWithSize:20.0].fontName;
    y.labelTextStyle = tsAxis;
    x.labelTextStyle = tsAxis;
    //Grey line plot
    boundLinePlot  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 2.0f;
    lineStyle.lineColor         = [CPTColor colorWithCGColor:[UIColor monicaBlueLight].CGColor];//[CPTColor grayColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = kDataPlots;
    boundLinePlot.dataSource    = self;
    //boundLinePlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithInt:0] decimalValue];
    boundLinePlot.delegate = self;
    boundLinePlot.plotSymbolMarginForHitDetection = 10;
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor monicaBlueLight].CGColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor monicaBlueLight].CGColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(6.0, 6.0);
    boundLinePlot.plotSymbol = plotSymbol;

    [lineChart addPlot:boundLinePlot];
    
    boundLinePlot2  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.miterLimit        = 1.0f;
    lineStyle2.lineWidth         = 2.0f;
    lineStyle2.lineColor         = [CPTColor colorWithCGColor:[UIColor monicaYellowLight].CGColor];//[CPTColor grayColor];
    boundLinePlot2.dataLineStyle = lineStyle2;
    boundLinePlot2.identifier    = kDataPlots2;
    boundLinePlot2.dataSource    = self;
    //boundLinePlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    boundLinePlot2.areaBaseValue = [[NSDecimalNumber numberWithInt:0] decimalValue];
    boundLinePlot2.delegate = self;
    boundLinePlot2.plotSymbolMarginForHitDetection = 10;
    CPTMutableLineStyle *symbolLineStyle2 = [CPTMutableLineStyle lineStyle];
    symbolLineStyle2.lineColor = [CPTColor colorWithCGColor:[UIColor monicaYellowLight].CGColor];
    CPTPlotSymbol *plotSymbol2 = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol2.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor monicaYellowLight].CGColor]];
    plotSymbol2.lineStyle     = symbolLineStyle2;
    plotSymbol2.size          = CGSizeMake(6.0, 6.0);
    boundLinePlot2.plotSymbol = plotSymbol2;
    [lineChart addPlot:boundLinePlot2];
    
    
    lineChart.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    self.dataForPlot = nil;
    /*self.dataForPlot = [[NSMutableArray alloc] initWithObjects:
     [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1], @"x", [NSNumber numberWithFloat:0], @"y", nil],
     [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:3000], @"x", [NSNumber numberWithFloat:20], @"y", nil],
     nil];*/
    touchPlot = [[CPTScatterPlot alloc] initWithFrame:CGRectNull];
    touchPlot.identifier = kAnnotationPlots;
    touchPlot.dataSource = self;
    touchPlot.delegate = self;
    [self showAnnotationAndSymbol:NO index:0];
    [lineChart addPlot:touchPlot];
    [self updateXLabelsV2];
}

-(void)showAnnotationAndSymbol:(BOOL)visible index:(NSInteger)tt
{
    if(!visible)
    {
        touchPlot.plotSymbol = nil;
        touchPlot.dataLineStyle = nil;
        if ( symbolTextAnnotation ) {
            [lineChart.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
            symbolTextAnnotation = nil;
        }
        return;
    }
    CPTColor *touchPlotColor = [CPTColor colorWithCGColor:[UIColor appSecondaryColor].CGColor];
    CPTColor *touchTintColor = [CPTColor colorWithCGColor:[UIColor whiteColor].CGColor];
    
    CPTMutableLineStyle *touchLineStyle = [CPTMutableLineStyle lineStyle];
    touchLineStyle.lineColor = touchTintColor;
    touchLineStyle.lineWidth = 3.0f;
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = touchPlotColor;
    symbolLineStyle.lineWidth = 3.0f;
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:touchTintColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(12.0, 12.0);
    touchPlot.plotSymbol = plotSymbol;
    
    touchPlot.dataLineStyle = touchLineStyle;
    [self updateAnnotation:tt];
}


/*-(void)showPlotSymbol:(BOOL)visible
{
    if(!visible)
    {
        boundLinePlot.plotSymbol = nil;
        return;
    }
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor appSecondaryColor].CGColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor whiteColor].CGColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(6.0, 6.0);
    boundLinePlot.plotSymbol = plotSymbol;
    
}*/

-(void)updateXLabelsV2
{
    //RANGES
    /*CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)lineChart.defaultPlotSpace;
     rangeMax = 0;
     if(fixedYMax>0)
     rangeMax=fixedYMax;
     else
     rangeMax =[self getMaxHistory:self.dataForPlot]*1.3;
     
     //[self updateXLabels];plotSpace.globalXRange = plotSpace.xRange;
     plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(rangeMax)];
     */
    
    
    //[self setAxisLabels:AxisHour4 withDate:fromDate];
    
}

/*
 * Sets custom axis labels, core plot does not support automatic time labeling on axis yet! Change if core
 * plot supports this in the future.
 */
-(void)setAxisLabels:(AxisConversion)identifier
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)lineChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSMutableArray *xAxisLabels = [[NSMutableArray alloc] init];
    NSArray *hzLabels = [[NSArray alloc] initWithObjects:
                         @"0 s",@"1 s",@"2 s",@"3 s",@"4 s",@"5 s",@"6 s",@"7 s",@"8 s",@"10 s",@"11 s",@"12 s",@"13 s",@"14 s",@"15 s",
                         nil];
    for(int i=0;i<hzLabels.count;i++)
    {
        if ( i % 2 != 0)
        {
            [xAxisLabels addObject: @""];
            continue;
        }
        
        [xAxisLabels addObject: [hzLabels objectAtIndex:i]];
    }
    
    
    NSUInteger labelLocation     = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for(int i = 0; i<[xAxisLabels count]; i++)
    {
        CPTMutableTextStyle *newStyle = [x.labelTextStyle mutableCopy];
        newStyle.color = [CPTColor darkGrayColor];
        newStyle.fontName = [UIFont appPrimaryFontWithSize:20.0].fontName;
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:newStyle];
        newLabel.tickLocation = [[NSNumber numberWithInt:i] decimalValue];//[i decimalValue];
        newLabel.offset       = x.labelOffset + x.majorTickLength;
        newLabel.rotation     = M_PI / 4;
        
        [customLabels addObject:newLabel];
        
    }
    x.axisLabels = [NSSet setWithArray:customLabels];
    
}

/*-(void)setLabels:(NSString*)title xLabel:(NSString*)xLabel yLabel:(NSString*)yLabel
 {
 barChart.attributedTitle = nil;
 barChart.title = nil;
 ((CPTXYAxisSet *)barChart.axisSet).xAxis.title = xLabel;
 ((CPTXYAxisSet *)barChart.axisSet).yAxis.title = yLabel;
 
 }
 
 
 -(void)animateBarChart
 {
 CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
 [anim setDuration:0.2f];
 
 anim.toValue = [NSNumber numberWithFloat:1.0f];
 anim.fromValue = [NSNumber numberWithFloat:0.0f];
 anim.removedOnCompletion = NO;
 anim.delegate = self;
 anim.fillMode = kCAFillModeForwards;
 anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 
 boundLinePlot.anchorPoint = CGPointMake(0.0, 0.0);
 [boundLinePlot addAnimation:anim forKey:@"grow"];
 [lineChart addPlot:boundLinePlot];
 [lineChart addPlot:touchPlot];
 
 }
 */

-(CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement{
    return CGPointMake(displacement.x,0);}


-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate{
    if (coordinate == CPTCoordinateY)
    {
        newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(rangeMax)];
    }
    else if(coordinate == CPTCoordinateX)
    {
            [self setAxisLabels:AxisDefault];
            currentAxisLabel = AxisDefault;
    }
    return newRange;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([(NSString *)plot.identifier isEqualToString:kAnnotationPlots])
    {
        return 2;
    }
    else {
        return [dataForPlot count];
    }
}
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    if ([(NSString *)plot.identifier isEqualToString:kAnnotationPlots])
    {
        if ( fieldEnum == CPTScatterPlotFieldY && annotationIndex<[dataForPlot count] && annotationIndex>=0)
        {
            switch (index) {
                case 0:
                    num = [NSNumber numberWithInt:-10000];
                    break;
                default:
                    num = [[dataForPlot objectAtIndex:annotationIndex] valueForKey:@"y"];;
                    break;
            }
        }
        else if (fieldEnum == CPTScatterPlotFieldX && annotationIndex<[dataForPlot count] && annotationIndex>=0)
        {
            num = [[dataForPlot objectAtIndex:annotationIndex] valueForKey:@"x"];;
        }
    }
    else if ([(NSString *)plot.identifier isEqualToString:kDataPlots])
    {
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        num= [[dataForPlot objectAtIndex:index] valueForKey:key];
        //num = [NSNumber numberWithDouble:[num2 doubleValue] ];
    }else if ([(NSString *)plot.identifier isEqualToString:kDataPlots2])
    {
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y2");
        num= [[dataForPlot objectAtIndex:index] valueForKey:key];
    }
    
    
    return num;
    
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
    //NSLog(@"DOWN: %f,%f",point.x,point.y);
    // self showAnnotationAndSymbol:NO index:0];
    previousDownEvent = point;
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    //NSLog(@"UP: %f,%f",point.x,point.y);
    CGFloat verticalChange = previousDownEvent.x/point.x ;
    if(!((1-kHitPercentage)<=verticalChange && verticalChange<=(1+kHitPercentage)))
    return YES;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)space;
    CPTScatterPlot *scatterPlot = boundLinePlot;
    CGPoint plotAreaPoint = [[plotSpace graph] convertPoint:point toLayer:scatterPlot];
    
    
    
    NSUInteger tt = [boundLinePlot dataIndexFromInteractionPoint:plotAreaPoint];
    if(!(tt==NSNotFound))
    [self showAnnotationAndSymbol:YES index:tt];
    
    return YES;
}

/*
 Annotation touch
 - (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
 */
- (void)updateAnnotation:(NSUInteger)index
{
    if (dataForPlot!=nil && index>=dataForPlot.count)//[(NSString *)plot.identifier isEqualToString:kAnnotationPlots])
    {
        return;
    }
    annotationIndex = index;
    
    CPTXYGraph *graph = lineChart;
    [graph.plotAreaFrame.plotArea removeAllAnnotations];
    // Determine point of symbol in plot coordinates
    NSNumber *x          = [[dataForPlot objectAtIndex:index] valueForKey:@"x"];
    NSNumber *y          = [[dataForPlot objectAtIndex:index] valueForKey:@"y"];
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
    NSString* wStr = [NSString stringWithFormat:@"\n%f W",[y doubleValue]];
    NSMutableAttributedString *attStrW = [[NSMutableAttributedString alloc] initWithString:wStr];
    [attStrW addAttribute:NSFontAttributeName
                    value:[UIFont appPrimaryFontWithSize:25.0]
                    range:NSMakeRange(0, wStr.length-2)];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];
    NSDate* xDate = [NSDate dateWithTimeIntervalSince1970:[x integerValue]];
    NSMutableAttributedString *attStrDate = [[NSMutableAttributedString alloc] initWithString: [df stringFromDate:xDate]];
    
    [attStrDate appendAttributedString:attStrW];
    [attStrDate addAttribute:NSForegroundColorAttributeName
                       value:[UIColor appSecondaryColor]
                       range:NSMakeRange(0, attStrDate.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attStrDate addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStrDate.length)];
    
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithAttributedText:attStrDate];
    
    textLayer.backgroundColor = [UIColor whiteColor].CGColor;
    textLayer.borderColor = [UIColor appSecondaryColor].CGColor;
    textLayer.masksToBounds = YES;
    textLayer.paddingRight = 10;
    textLayer.paddingLeft = 10;
    textLayer.paddingTop = 10;
    textLayer.paddingBottom = 5;
    textLayer.borderWidth = 3;
    textLayer.cornerRadius = 3;
    CPTPlotSpaceAnnotation* textAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace
                                                                               anchorPlotPoint:anchorPoint];
    textAnnotation.contentLayer = textLayer;
    textAnnotation.displacement = CGPointMake(0.0f, 50.0f);
    
    [graph.plotAreaFrame.plotArea addAnnotation:textAnnotation];
    [touchPlot reloadData];
    
}

@end
