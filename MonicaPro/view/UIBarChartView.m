//
//  UIBarChartView.m
//  EiB
//
//  Created by CNet Ipad on 10/07/14.
//  Copyright (c) 2014 CNet Mac Account. All rights reserved.
//

#import "UIBarChartView.h"
#import "CorePlot-CocoaTouch.h"
#import "SimpleReading.h"

#import "MonicaPro-Swift.h"

@implementation UIBarChartView



- (id)initWithFrame:(CGRect)frame barPlotData:(NSMutableArray*)barData unitStr:(NSString*)unitString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        barPlotData = barData;
        unitStr = unitString;
        selectedIndex = -1;
        [self createChart];
    }
    return self;
}


- (float)getMaxHistory:(NSMutableArray*)arr
{
    float max = 0;
    for(SimpleReading* sr in arr)
    {
        if(max<sr.readingValue)
            max=sr.readingValue;
    }
    return max;
}


-(void)updateXLabels
{
    //AXIS
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSMutableArray *xAxisLabels = [[NSMutableArray alloc] init];
    NSArray *hzLabels = [[NSArray alloc] initWithObjects:
                            @"12.5 Hz",@"16 Hz",@"20 Hz",@"25 Hz",@"31.5 Hz",@"40 Hz",@"50 Hz",@"63 Hz",@"80 Hz",@"100 Hz",@"125 Hz",@"160 Hz",@"200 Hz",@"250 Hz",@"315 Hz",@"400 Hz",@"500 Hz",@"630 Hz",@"800 Hz",@"1.0 kHz",@"1.25 kHz",@"1.6 kHz",@"2.0 kHz",@"2.5 kHz",@"3.15 kHz",@"4.0 kHz",@"5.0 kHz",@"6.3 kHz",@"8.0 kHz",@"10 kHz",@"12.5 kHz",@"16 kHz",@"20 kHz",
                            nil];
    for(int i=0;i<barPlotData.count;i++)
    {
        if ( i % 4 != 0)
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
    
    //RANGES
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    float f =[self getMaxHistory:barPlotData] ;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(f*1.4)];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([xAxisLabels count])];
    
}

-(void)createChart
{
    if (!([barPlotData count]>0)) {
        return;
    }
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    barChart = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = barChart;
    NSArray *chartLayers = [[NSArray alloc] initWithObjects:
                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLines],
                            [NSNumber numberWithInt:CPTGraphLayerTypePlots],
                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLabels],
                            [NSNumber numberWithInt:CPTGraphLayerTypeMajorGridLines],
                            [NSNumber numberWithInt:CPTGraphLayerTypeMinorGridLines],
                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisTitles],
                            nil];
    barChart.topDownLayerOrder = chartLayers;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0f;
    barChart.plotAreaFrame.masksToBorder   = NO;
    
    // Paddings
    barChart.paddingLeft   = 0.0f;
    barChart.paddingRight  = 0.0f;
    barChart.paddingTop    = 0.0f;
    barChart.paddingBottom = 0.0f;
    
    barChart.plotAreaFrame.paddingLeft   = 30.0;
    barChart.plotAreaFrame.paddingTop    = 20.0;
    barChart.plotAreaFrame.paddingRight  = 20.0;
    barChart.plotAreaFrame.paddingBottom = 40.0;

    barChart.titleDisplacement        = CGPointMake(0.0f, 0.0f);
    barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(30.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromInteger(barPlotData.count+1)];
    plotSpace.delegate = self;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.titleOffset                 = 42.0f;
    
    // Define some custom labels for the data elements
    x.labelRotation  = M_PI / 4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.preferredNumberOfMajorTicks = 0;
    
    
    CPTMutableLineStyle *lineStyleY = [CPTMutableLineStyle lineStyle];
    lineStyleY.lineColor = [CPTColor lightGrayColor];
    lineStyleY.lineWidth = 0.5f;
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorGridLineStyle          = lineStyleY;
    y.preferredNumberOfMajorTicks = 5;//         = CPTDecimalFromString(@"10");
    y.labelingPolicy                    = CPTAxisLabelingPolicyAutomatic;
    y.title                       = unitStr;
    CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
    labelTextStyle.color          = [CPTColor darkGrayColor];
    labelTextStyle.fontSize       = 20.0f ;
    labelTextStyle.fontName = [UIFont appPrimaryFontWithSize:20.0].fontName;

    y.titleTextStyle              = labelTextStyle;
    CPTMutableTextStyle *tsAxis = [[CPTMutableTextStyle alloc] init];
    tsAxis.fontName = [UIFont appPrimaryFontWithSize:20.0].fontName;
    y.labelTextStyle = tsAxis;
    y.titleOffset                 = 54.0f;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    //y.titleLocation               = CPTDecimalFromFloat(9.7f);
    
    NSNumberFormatter *Xformatter = [[NSNumberFormatter alloc] init];
    [Xformatter setMaximumFractionDigits:6];
    [Xformatter setNumberStyle:NSNumberFormatterDecimalStyle];
    y.labelFormatter = Xformatter;
    
    CPTColor* chartColor = [CPTColor colorWithCGColor:[[UIColor monicaBlueLight] CGColor]];
    //bar plot
    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor whiteColor] horizontalBars:NO];
    
    barPlot.fill = [CPTFill fillWithColor:chartColor];
    barPlot.dataSource      = self;
    barPlot.baseValue       = CPTDecimalFromString(@"0");
    barPlot.barCornerRadius = 2.0f;
    barPlot.delegate = self;
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor clearColor] CGColor]];
    lineStyle.lineWidth = 0.0f;
    barPlot.lineStyle = lineStyle;
    barPlot.identifier = @"barPlot";
    barPlot.barOffset = CPTDecimalFromString(@"0.2");
    
    barPlot2 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor whiteColor] horizontalBars:NO];
    CPTColor* chartColor2 = [CPTColor colorWithCGColor:[[UIColor monicaYellowLight] CGColor]];
    barPlot2.fill = [CPTFill fillWithColor:chartColor2];
    barPlot2.dataSource      = self;
    barPlot2.baseValue       = CPTDecimalFromString(@"0");
    barPlot2.barCornerRadius = 2.0f;
    barPlot2.delegate = self;
    barPlot2.lineStyle = lineStyle;
    barPlot2.identifier = @"barPlot2";
    barPlot2.barOffset = CPTDecimalFromString(@"-0.2");
    barPlot.barWidth = CPTDecimalFromString(@"0.5");
    barPlot2.barWidth = CPTDecimalFromString(@"0.5");
    [barChart addPlot:barPlot2 toPlotSpace:plotSpace];
    [barChart addPlot:barPlot toPlotSpace:plotSpace];

    selectPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor whiteColor] horizontalBars:NO];
    selectPlot.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    selectPlot.dataSource      = self;
    selectPlot.baseValue       = CPTDecimalFromString(@"0");
    selectPlot.barCornerRadius = 2.0f;
    selectPlot.identifier = @"select";
    selectPlot.delegate = self;
    CPTMutableLineStyle *selectStyle = [CPTMutableLineStyle lineStyle];
    selectStyle.lineColor = chartColor;
    selectStyle.lineWidth = 4.0f;
    if([self bounds].size.width < 400 ) {
        selectStyle.lineWidth = 2.0f;
    }
    selectPlot.lineStyle = selectStyle;
    [barChart addPlot:selectPlot toPlotSpace:plotSpace];
    
    
    barChart.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    [self updateXLabels];
    //[self animateBarChart];
    barPlot.plotArea.delegate=self;
    
}


/*-(void)animateBarChart
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [anim setDuration:0.8f];
    
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    barPlot.anchorPoint = CGPointMake(0.0, 0.0);
    [barPlot addAnimation:anim forKey:@"grow"];
    [barChart addPlot:barPlot];
    
}*/



#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([(NSString *)plot.identifier isEqualToString:@"select"])
    {
        if (selectedIndex >= 0) {
            return 1;
        }else {
            return 0;
        }
    }
    else {
        return [barPlotData count];
    }
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    
    if ([(NSString *)plot.identifier isEqualToString:@"select"])
    {
        SimpleReading* sr =[barPlotData objectAtIndex:selectedIndex];
        switch ( fieldEnum ) {
                
            case CPTBarPlotFieldBarLocation:
            {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
                break;
            }
            case CPTBarPlotFieldBarTip:
            {
                
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:sr.readingValue];
                break;
            }
        }
    }else {
        SimpleReading* sr =[barPlotData objectAtIndex:index];
        switch ( fieldEnum ) {
                
            case CPTBarPlotFieldBarLocation:
            {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
                break;
            }
            case CPTBarPlotFieldBarTip:
            {
                if ([(NSString *)plot.identifier isEqualToString:@"barPlot"]){
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:sr.readingValue];
                    break;
                }else {
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:sr.readingValue2];
                    break;
                }
            }
        }
    }
    
    return num;
}
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx
{
    if ([(NSString *)plot.identifier isEqualToString:@"select"]) {
        return;
    }
    [barPlot.plotArea removeAllAnnotations];
    NSNumber *plotXvalue = [self numberForPlot:plot field:CPTScatterPlotFieldX recordIndex:idx];
    //NSNumber *plotYvalue = [self numberForPlot:plot field:CPTScatterPlotFieldY recordIndex:idx];
    
    SimpleReading* sr =[barPlotData objectAtIndex:idx];
    
    NSNumber *x = plotXvalue;
    NSNumber *y = [NSNumber numberWithDouble:sr.readingValue];
    
    NSArray *anchorPoint = [NSArray arrayWithObjects:x,y,nil];
    
    NSString* kwhStr = [NSString stringWithFormat:@"\n%.2f %@ ",[y doubleValue],unitStr];
    /*if (sr.readingValue<10) {
        kwhStr = [NSString stringWithFormat:@"\n%.1f %@ ",sr.readingValue,unitStr];
    }*/
    NSMutableAttributedString *attStrKwh = [[NSMutableAttributedString alloc] initWithString:kwhStr];
    [attStrKwh addAttribute:NSFontAttributeName
                   value:[UIFont appPrimaryFontWithSize:25.0]
                   range:NSMakeRange(0, kwhStr.length-5)];
    
    
    NSMutableAttributedString *attStrDate = [[NSMutableAttributedString alloc] initWithString: @"VALUE:"];
    [attStrDate appendAttributedString:attStrKwh];
    [attStrDate addAttribute:NSForegroundColorAttributeName
                   value:[UIColor monicaBlueLight]
                   range:NSMakeRange(0, attStrDate.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attStrDate addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStrDate.length)];

    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithAttributedText:attStrDate];
    
    textLayer.backgroundColor = [UIColor whiteColor].CGColor;
    textLayer.borderColor = [UIColor monicaBlueLight].CGColor;
    textLayer.masksToBounds = YES;
    textLayer.paddingRight = 10;
    textLayer.paddingLeft = 10;
    textLayer.paddingTop = 10;
    textLayer.paddingBottom = 5;
    textLayer.borderWidth = 3;
    textLayer.cornerRadius = 3;
    CPTPlotSpaceAnnotation* textAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:barChart.defaultPlotSpace
                                                                               anchorPlotPoint:anchorPoint];
    textAnnotation.contentLayer = textLayer;
    textAnnotation.displacement = CGPointMake(0.0f, 50.0f);

    [barPlot.plotArea addAnnotation:textAnnotation];
    selectedIndex = idx;
    [selectPlot reloadData];
    
    
}
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
    //NSLog(@"DOWN: %f,%f",point.x,point.y);
    // self showAnnotationAndSymbol:NO index:0];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)space;
    CPTBarPlot *scatterPlot = barPlot;
    CGPoint plotAreaPoint = [[plotSpace graph] convertPoint:point toLayer:scatterPlot];
    
    
    [self callClosestBarDelegate:plotAreaPoint];
    return YES;
}

-(void)callClosestBarDelegate:(CGPoint)point
{
    double distance = 0.1;
    for (int i=1; i<100; i++) {
        
        NSUInteger ttL = [barPlot dataIndexFromInteractionPoint:CGPointMake(point.x-distance, 0)];
        NSUInteger ttR = [barPlot dataIndexFromInteractionPoint:CGPointMake(point.x+distance, 0)];
        //NSLog(@"TT: %lu %f" ,(unsigned long)tt,normalizedPoint.x);
        if (ttL <= barPlotData.count) {
            [self barPlot:barPlot barWasSelectedAtRecordIndex:ttL];
            NSLog(@"PlotSearch finished i=%d",i);
            break;
        }
        if (ttR <= barPlotData.count) {
            [self barPlot:barPlot barWasSelectedAtRecordIndex:ttR];
            NSLog(@"PlotSearch finished i=%d",i);
            break;
        }
        distance = distance+i;
    }
}
@end
