//
//  AliPayViewController.m
//  ParkEasy
//
//  Created by jh navi on 15/10/22.
//  Copyright © 2015年 WinJayQ. All rights reserved.
//

#import "AliPayViewController.h"
#import "Order.h"
#import "Product.h"
#import "DataSigner.h"

@interface AliPayViewController ()

@end

@implementation AliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


- (IBAction)Pay:(id)sender {
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [[Product alloc]init];
    product.price = 0.01;
    product.subject = @"";
    product.body = @"";
    product.orderId = @"";
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088811955133873";
    NSString *seller = @"pay@ginha.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMeA0sy4ia6KsMedy+hbCJPAvuN6mCoHmb3wwJRVaGXIjMqzAUlcCPL5ZI6ks6DhdZdtzBrMUSmzYQDaXtY24vkF835MxutHSMxb6WJSiopXuz3hhfDlN44gWaCZAb2LwLhCFWSKHWMLjaCwDru7VUUm/frpDA92sPaJnTJY6tWXAgMBAAECgYBnlGDd3WnObz99RFYb2zfGzqnNHVdnau7NiPPTj8xWHBvNGccvOVOEIyusS6Lfgm81IdJ4j2AMUI+qi7X1biXEzZ4Oymk3hR0f0QdzBr6XfL5GNuB48tuG6uiU3IWwdPrFn7k0ODQXi4QqusCwitUFq7fCyTEosgTxgS4kg3yvsQJBAPNBqwy1rSZTsSflZDnh9bPoEtceSCO0/76f1jz+iIXWuoPy0ztBzf51Scsy7+YPhirXufVaa7ZnFgEwWG4cDP0CQQDR9GBcR/CxWL4askzeGORdmdDLEMrX1i0B3PFWtjPf3Xt5cBOnAKkka6tsQjqGVmZOOMXu1YNn0//+9KAfjfsjAkABd1Tbl8C6aWi479YBz03WzsBGUaVnqbCc6oO1DGewPtIS94S0Z7ohHX3bXqw5e8B4Q6KYSvo5ODfWu/7ccwjVAkA+cdSHHc50sNQ51HYQSI8DV9BF1US/VTAlsbUF+UMMfi9POwpdTVEBSBTAKiKF+gSLl08nbdGbe+5TwiYtvGjJAkEA6JhU71vtdiqLgmMSXdRJvF0HCGFQW4Z0JWRF5/Vi8C1xaurnfBFPzL+Kiiey/9sRBDf+nzeCD0kzuunFe7uKVQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        //	return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    NSLog(@"%@",[self generateTradeNO]);
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.ginha.com/"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}
@end
