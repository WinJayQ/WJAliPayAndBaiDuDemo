//
//  BaiDuMapViewController.m
//  ParkEasy
//
//  Created by jh navi on 15/10/22.
//  Copyright © 2015年 WinJayQ. All rights reserved.
//

#import "BaiDuMapViewController.h"

@interface BaiDuMapViewController ()

@end

@implementation BaiDuMapViewController


- (void)viewWillAppear:(BOOL)animated {
    [_myMapView viewWillAppear];
    _myMapView.delegate = self;
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_myMapView viewWillDisappear];
    _myMapView.delegate = nil;
    _locService.delegate = nil;
    [_locService stopUserLocationService];//停止定位
    _myMapView.showsUserLocation = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _myMapView.scrollEnabled = NO;
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locService.distanceFilter = 100.f;
}

- (IBAction)LoctionCurPoition:(id)sender {
    [_locService startUserLocationService];
    _myMapView.showsUserLocation = NO;//先关闭显示的定位图层
    _myMapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//定位罗盘模式
    _myMapView.showsUserLocation = YES;//显示定位图层

}

- (IBAction)FollowCurPotion:(id)sender {
    _myMapView.showsUserLocation = NO;
    _myMapView.userTrackingMode = BMKUserTrackingModeFollow;//定位跟随模式
    _myMapView.showsUserLocation = YES;
}

- (IBAction)AllowMove:(id)sender {
    _myMapView.scrollEnabled = YES;
}

- (IBAction)ZoomOut:(id)sender {
    _myMapView.zoomLevel -= 1;
}

- (IBAction)ZoomIn:(id)sender {
    _myMapView.zoomLevel += 1;
}

- (IBAction)AddImageLabel:(id)sender {
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.userLatitude;
    coor.longitude = self.userLongitude;
    annotation.coordinate = coor;
    annotation.title = @"添加标注";
    [_myMapView addAnnotation:annotation];
}

- (IBAction)SearchPoi:(id)sender {
    _searcher = [[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(self.userLatitude, self.userLongitude);
    option.keyword = @"停车场";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if (flag) {
        NSLog(@"周边检索发送成功");
    }else{
        NSLog(@"周边检索发送失败");
    }
    
}

- (IBAction)NavigationPotion:(id)sender {
    
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.90868;
    coor1.longitude = 116.204;
    start.pt = coor1;
    //指定起点名称
    start.name = @"我的位置";
    //指定起点
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    CLLocationCoordinate2D coor2;
    coor2.latitude = 39.90868;
    coor2.longitude = 116.3956;
    end.pt = coor2;
    //指定终点名称
    end.name = @"天安门";
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
    
}



#pragma mark 底图手势操作
/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)_myMapView.zoomLevel,mapView.rotation,_myMapView.overlooking];
    NSLog(@"%@",showmeg);
}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)_myMapView.zoomLevel,_myMapView.rotation,_myMapView.overlooking];
    NSLog(@"%@",showmeg);
}

/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"onDoubleClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您双击了地图(double click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)_myMapView.zoomLevel,_myMapView.rotation,_myMapView.overlooking];
    NSLog(@"%@",showmeg);
}

//delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;
        
        if ([[annotation title] isEqualToString:@"停车场"]) {
            newAnnotationView.image = [UIImage imageNamed:@"more_friend_mark.png"];
        }
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:newAnnotationView.bounds];
        numLabel.backgroundColor = [UIColor clearColor];
        CGRect temFrame = numLabel.frame;
        temFrame.size.height = 20;
        numLabel.frame = temFrame;
        //  numLabel.height = 20;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:12];
        [newAnnotationView addSubview:numLabel];
        numLabel.text = [annotation subtitle];
        
        
        return newAnnotationView;
    }
    return nil;
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%d",poiResult.totalPoiNum);
       
        for (int i = 0; i < poiResult.currPoiNum; i++) {
            //POI详情检索
            BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
            NSString *poiUID = [[poiResult.poiInfoList objectAtIndex:i] uid];
            NSLog(@"%@",[poiResult.poiInfoList objectAtIndex:i]);
            NSLog(@"%@",poiUID);
            option.poiUid = poiUID;//POI搜索结果中获取的uid
            BMKPoiSearch *searcherDetail = [[BMKPoiSearch alloc]init];
            searcherDetail.delegate = self;
            BOOL flag = [searcherDetail poiDetailSearch:option];
            if(flag)
            {
                NSLog(@"详情检索发起成功");
            }
            else
            {
                NSLog(@"详情检索发送失败");
            }
        }
    }else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    }else{
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    if(errorCode == BMK_SEARCH_NO_ERROR){
        //在此处理正常结果
        NSLog(@"%f-%f",poiDetailResult.pt.latitude,poiDetailResult.pt.longitude);
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = poiDetailResult.pt.latitude;
        coor.longitude = poiDetailResult.pt.longitude;
        annotation.coordinate = coor;
        annotation.title = @"停车场";
        annotation.subtitle = [NSString stringWithFormat:@"%d",3];
        [_myMapView addAnnotation:annotation];
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有岐义");
    }else{
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _myMapView.showsUserLocation = YES;
    [_myMapView updateLocationData:userLocation];
    self.clloction = userLocation.location;
    self.userLatitude = self.clloction.coordinate.latitude;
    self.userLongitude = self.clloction.coordinate.longitude;
}


@end
