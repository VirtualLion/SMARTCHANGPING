//
//  YZImageCut.m
//  maoyou_ios_app
//
//  Created by 韩云智 on 16/10/9.
//  Copyright © 2016年 茅台酒会－花阳阳. All rights reserved.
//

#import "YZImageCut.h"

@implementation YZImageCut

//压缩照片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    //    return [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 0.8)];
    return newImage;
}

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image toImageView:(UIImageView *)imageView
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (imageView.size.width / imageView.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * imageView.size.height / imageView.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * imageView.size.width / imageView.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image toSize:(CGSize)imageViewSize
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (imageViewSize.width / imageViewSize.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * imageViewSize.height / imageViewSize.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * imageViewSize.width / imageViewSize.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}


@end
