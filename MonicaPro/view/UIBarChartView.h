//
//  UIBarChartView.h
//  EiB
//
//  Created by CNet Ipad on 10/07/14.
//  Copyright (c) 2014 CNet Mac Account. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@interface UIBarChartView : UIView<CPTBarPlotDelegate,
CPTPlotDataSource,
CPTPlotSpaceDelegate,CPTPlotAreaDelegate>
{
@private
    CPTXYGraph *barChart;
    CPTBarPlot* barPlot;
    CPTBarPlot* barPlot2;
    CPTBarPlot* selectPlot;
    NSInteger selectedIndex;
    NSMutableArray *barPlotData;
    NSDateFormatter *dateFormatter;
    NSString* unitStr;
}
//-(void)createChart:(NSMutableArray*)barData calendarUnit:(NSCalendarUnit)calendarUnit;
//- (id)initWithFrame:(CGRect)frame barPlotData:(NSMutableArray*)barData calendarUnit:(NSCalendarUnit)calendarUnit;
- (id)initWithFrame:(CGRect)frame barPlotData:(NSMutableArray*)barData unitStr:(NSString*)unitString;
@end
