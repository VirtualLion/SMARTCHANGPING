//
//  YZServerMaster.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/15.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#ifndef YZServerMaster_h
#define YZServerMaster_h

#define YZ_APP_VERSION @"1.0.0"

//2.	首页
//a)	首页统一获取数据接口
#define SERVER_HOME_LIST @"/Home/getIndexData"
//d)	更新我的主题
#define SERVER_THEME_UPDATE @"/Home/saveMytheme"

//3.	新闻
//a)	获取新闻分类
#define SERVER_DYNAMIC_TITLES @"/Home/getArticleCategoryList"
//b)	根据分类id获取新闻列表
#define SERVER_DYNAMIC_LIST @"/Home/getCategoryNewsList"
//a)	获取政民互动新闻列表
#define SERVER_INTERACTION_LIST @"/Home/getMasatamiNewsList"
//b)	根据新闻id获取新闻详情
#define SERVER_NEWS_DETAILS @"/Home/NewsDetails"

//4.	办事指南
//a)	获取办事事项列表
#define SERVER_THINGS_LIST @"/Home/getGuideList"
//b)	获取办事指南部门列表
#define SERVER_THINGS_DEPARTMENT @"/Home/getGuideSectionList"
//c)	获取办事指南主题列表
#define SERVER_THINGS_THEME @"/Home/getGuideThemeList"
//d)	获取办事事项详情
#define SERVER_THINGS_DETAILS @"/Home/getGuideDetails"

//5.	黄页
//a)	获取黄页列表
#define SERVER_YELLOW_LIST @"/Home/getYellowPageList"

//6.	生活
//a)	获取生活服务列表
#define SERVER_LIFE_LIST @"/Home/getLifeServiceList"
//b)	获取生活详情
#define SERVER_LIFE_DETAILS @"/Home/getLifeDetails"
//c)	获取商店生活服务
#define SERVER_LIFE_HOME @"/Home/getShopsLifeList"
//d)	获取商店生活分类列表
#define SERVER_LIFE_CATE @"/Home/getLifeCategoryList"

//7.	工具
//a)	获取工具分类列表
#define SERVER_TOOL_LIST @"/Home/getToolCategoryList"




#endif /* YZServerMaster_h */
