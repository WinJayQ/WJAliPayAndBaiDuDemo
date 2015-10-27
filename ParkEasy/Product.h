//
//  Product.h
//  ParkEasy
//
//  Created by jh navi on 15/10/22.
//  Copyright © 2015年 WinJayQ. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end

