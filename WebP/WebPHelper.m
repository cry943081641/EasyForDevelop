//
//  WebPHelper.m
//  KFT
//
//  Created by Cry on 2018/5/3.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import "WebPHelper.h"
#import <WebP/decode.h>

@implementation WebPHelper


/*
 This gets called when the UIImage gets collected and frees the underlying image.
 */
static void free_image_data(void *info, const void *data, size_t size)
{
    if(info != NULL)
    {
        WebPFreeDecBuffer(&(((WebPDecoderConfig *)info)->output));
    }
    else
    {
        free((void *)data);
    }
}

+ (UIImage *)getWebPImageFromFilePath:(NSString *)filePath {    
    NSDate *startTime = [NSDate date];
    
    // Find the path of the selected WebP image in the bundle and read it into memory
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSLog(@"Time to read data: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
    // Get the current version of the WebP decoder
    int rc = WebPGetDecoderVersion();
    
    NSLog(@"Version: %d", rc);
    
    startTime = [NSDate date];
    
    // Get the width and height of the selected WebP image
    int width = 0;
    int height = 0;
    WebPGetInfo([myData bytes], [myData length], &width, &height);
    
    NSLog(@"Time to read info: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
    NSLog(@"Image Width: %d Image Height: %d", width, height);
    
    CGDataProviderRef provider;
    
    startTime = [NSDate date];
    
    // Decode the WebP image data into a RGBA value array
    uint8_t *data = WebPDecodeRGBA([myData bytes], [myData length], &width, &height);
    
    NSLog(@"Time to decode WebP data: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
    startTime = [NSDate date];
    
    // Construct a UIImage from the decoded RGBA value array
    provider = CGDataProviderCreateWithData(NULL, data, width*height*4, free_image_data);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4*width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    NSLog(@"Time to contruct UIImage from RGBA: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
  
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    return newImage;
}


@end
