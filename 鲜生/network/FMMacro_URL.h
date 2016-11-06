//
//  FMMacro_URL.h
//  FreshMan
//
//  Created by VictorXiong on 15/8/13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//





#ifndef FreshMan_FMMacro_URL_h
#define FreshMan_FMMacro_URL_h

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define MF_URL_HOST @"http://120.25.103.201"

#define MF_URL_LOGIN @"/app.php/user/login"
#define GET_GOODS_Catagory @"/app.php/goods/goodsCatagory"//获得商品首页
#define GET_GOODS_ONSALE @"/app.php/goods/onsale"//获得零元购首页
#define GET_GOODS_LIST @"/app.php/goods/goodslist"
#define GET_GOOES_DETAIL @"/app.php/goods/gooddetail"
#define GET_YIYUAN_LIST @"/app.php/goods/yiyuan"
#define GET_SHOPPINGCAR_LIST @"/app.php/goods/shoppinglist"
#define MAKE_ORDER @"/app.php/order/makeorder"
#define GO_PAY @"/app.php/order/gopay"
#define GET_USERINFO @"/app.php/user/userinfo"
#define SAVE_USERINFO @"/app.php/user/saveuserinfo"
#define GET_ADDRESS_LIST @"/app.php/user/addressList"
#define GET_TRACKADDRESS_LIST @"/app.php/user/trackList"
#define DELETE_ORDER @"/app.php/user/deleteOrder"
#define SAVE_ADDRESS @"/app.php/user/addressSave"
#define DELETE_ADDRESS @"/app.php/user/addressDelete"
#define GET_SHOP_LOCATION @"/app.php/goods/coordinate"
#define SAVE_GETPOINT @"/app.php/order/setClaim"
#define GET_ORDER_LIST @"/app.php/user/getUserOrder"
#define GET_DISTRICT_LIST @"/app.php/goods/districtList"
#define GET_MESSAGE_LIST @"/app.php/user/notificationList"//获取我的消息列表
#define DELETE_MESSAGE @"/app.php/user/deleteNotification"//删除一条我的消息

//#define GET_SHOPPINGCAR_LIST @"/app.php/goods/shoppinglist"
//登录
//url
//http://120.25.103.201/app.php/user/login?phone=15811328155&pwd=ac204a6e49c097a6e9b451f822118ba6
//参数：
//1、 pohone 电话
//2、 pwd 密码
//返回：
//1、 登录成功
//1. status=1
//2. token=xxxxxxxxxxxxxxxxxxx   令牌
//2、 登录失败
//1. status=0

#define MF_URL_REGISTER @"/app.php/user/signUp"
//注册
//url：
//http://120.25.103.201/app.php/user/signUp
//参数：
//1、 phone   电话
//2、 pwd     密码
//3、 verify    验证码
//
//返回：
//3、 验证码错误
//1. status=0
//4、 验证码超时  10分钟
//1. status=2
//5、 重复注册
//1. status=3
//6、 验证成功
//1. status=1
//2. token=xxxxxxxxxxxxx     令牌

#define  MF_URL_REGISTER_VALITE @"/app.php/user/signVerify"
//注册验证码发送
//url:
//http://120.25.103.201/app.php/user/signVerify
//参数：
//1、 phone 电话
//返回
//1、 	验证码错误
//1. status=0
//2、 验证码成功
//1. status=1
//





#endif
