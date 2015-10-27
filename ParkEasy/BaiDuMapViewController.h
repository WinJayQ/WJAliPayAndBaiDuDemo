//
//  BaiDuMapViewController.h
//  ParkEasy
//
//  Created by jh navi on 15/10/22.
//  Copyright © 2015年 WinJayQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface BaiDuMapViewController : UIViewController<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) BMKPoiSearch *searcher;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKGeoCodeSearch* geocodesearch;
@property (weak, nonatomic) IBOutlet BMKMapView *myMapView;

//城市名
@property (strong,nonatomic) NSString *cityName;

//用户纬度
@property (nonatomic,assign) double userLatitude;

//用户经度
@property (nonatomic,assign) double userLongitude;

//用户位置
@property (strong,nonatomic) CLLocation *clloction;


- (IBAction)LoctionCurPoition:(id)sender;
- (IBAction)FollowCurPotion:(id)sender;
- (IBAction)AllowMove:(id)sender;
- (IBAction)ZoomOut:(id)sender;
- (IBAction)ZoomIn:(id)sender;
- (IBAction)AddImageLabel:(id)sender;
- (IBAction)SearchPoi:(id)sender;
- (IBAction)NavigationPotion:(id)sender;


@end
