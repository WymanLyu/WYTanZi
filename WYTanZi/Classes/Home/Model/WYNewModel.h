//
//  WYNewModel.h
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYNewModel : NSObject

/*
 {
	clicks = 630,
	midPicUrl = (
	http://7xj9jv.com2.z0.glb.qiniucdn.com/cdsb/WEB-SRC/picture/articlePic/sim/20160522072577697948.jpg
 )
 ,
	author = 成都商报客户端,
	comments = 1,
	summary = ,
	time = 1463873204236,
	simPicUrl = (
	http://7xj9jv.com2.z0.glb.qiniucdn.com/cdsb/WEB-SRC/picture/articlePic/sim/20160522072577697948.jpg
 )
 ,
	indexId = 1,
	newsId = 272596,
	title = 广东茂名强降雨致50余万人大转移 8人死亡4人失踪
 },
 */

/** 点击数 */
@property (nonatomic, assign) int clicks;

/** 图片url */
@property (nonatomic, strong) NSArray *midPicUrl;

/** 作者 */
@property (nonatomic, copy) NSString *author;

/** 时间 */
@property (nonatomic, assign) long long time;

/** 新闻id */
@property (nonatomic, assign) int indexId;

/** 标题 */
@property (nonatomic, copy) NSString *title;


@end
