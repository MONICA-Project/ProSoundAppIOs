//
//  ScatterPlotView.h
//  EiB
//
//  Created by CNet Mac Account on 1/27/14.
//  Copyright (c) 2014 CNet Mac Account. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"



@interface UIScatterPlotView : UIView<CPTPlotSpaceDelegate,
CPTPlotDataSource,
CPTScatterPlotDelegate>
{
@private
    CPTXYGraph *lineChart;
    CPTScatterPlot *boundLinePlot;
    CPTScatterPlot *boundLinePlot2;
    CPTScatterPlot *touchPlot;
    NSMutableArray *dataForPlot;
    NSInteger valueType;
    NSInteger annotationIndex;
    float rangeMax;
    NSInteger currentAxisLabel;
    CPTPlotSpaceAnnotation *symbolTextAnnotation;
    CGPoint previousDownEvent;
    
}

@property (readwrite, nonatomic) NSInteger fixedYMax;
@property (readwrite, strong, nonatomic) CPTScatterPlot *boundLinePlot;
@property (readwrite, strong, nonatomic) NSMutableArray *dataForPlot;

- (void)reloadClearData;
- (void)createChartIfNeeded;
- (void)updatePlot;
- (void)setMaxRange:(CPTPlotRange *)xRange;
- (void)setDisplayedXRange:(CPTPlotRange *)xRange;
//- (void)setLabels:(NSString*)title xLabel:(NSString*)xLabel yLabel:(NSString*)yLabel;
-(void)updateXLabelsV2;

typedef enum AxisConversion : NSInteger AxisConversion;
enum AxisConversion : NSInteger {
    AxisDefault = 1,
    AxisQuarter = 2,
    AxisHour = 3,
    AxisHour4 = 4
};

@end
