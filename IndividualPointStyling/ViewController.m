//
//  ViewController.m
//  ColumnSeries
//
//  Created by Colin Eberhardt on 04/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import "TrafficLightColumnSeries.h"
#import <ShinobiCharts/ShinobiCharts.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    NSDictionary* _sales;
    ShinobiChart* _chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sales = @{@"Broccoli" : @5.65, @"Carrots" : @12.6, @"Mushrooms" : @8.4, @"Okra" : @0.6};
	
    // Create the chart
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Grocery Sales Figures";
    
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    _chart.xAxis = xAxis;
    
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Sales (1000s)";
    yAxis.rangePaddingHigh = @1.0;
    _chart.yAxis = yAxis;
    
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    
    // show the legend 
    _chart.legend.hidden = NO;
    _chart.legend.placement = SChartLegendPlacementInsidePlotArea;
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    TrafficLightColumnSeries *columnSeries = [TrafficLightColumnSeries new];
    
    /*
     We won't actually see the purple color in the series as we have overwritten
     the style in the TrafficLightColumnSeries.
     
     We will however see it in the legend as this is the property it reads from
     to decide what color to render its symbols.
     */
    columnSeries.style.areaColor = [UIColor purpleColor];
    
    columnSeries.selectionMode = SChartSelectionPoint;
    
    return columnSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _sales.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = _sales.allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = _sales[key];
    return datapoint;
}

@end
