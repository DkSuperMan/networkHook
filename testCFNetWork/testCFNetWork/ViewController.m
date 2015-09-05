//
//  ViewController.m
//  testCFNetWork
//
//  Created by jin on 15/8/30.
//  Copyright (c) 2015年 jin. All rights reserved.
//

#import "ViewController.h"

//#define kTestMacroDefineFunc {NSLog(@"kTestMacroDefineFunc")};
//
//typedef void *ReadStreamCallBack (CFReadStreamRef stream,CFStreamEventType type,void *clientCallBackInfo);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//HOOK_FUNCTION(CFReadStreamRef, /System/Library/Frameworks/CFNetwork.framework/CFNetwork, CFReadStreamCreateForHTTPRequest, CFAllocatorRef alloc, CFHTTPMessageRef request)
//{
//    NSLog(@"%s: %@", __FUNCTION__, CFHTTPMessageCopyRequestURL(request));
//    return _CFReadStreamCreateForHTTPRequest(alloc, request);
//}
//
//HOOK_FUNCTION(Boolean, /System/Library/Frameworks/CFNetwork.framework/CFNetwork, CFReadStreamSetClient, CFReadStreamRef stream, CFOptionFlags streamEvents, CFReadStreamClientCallBack clientCB, CFStreamClientContext *clientContext)
//{
//    NSLog(@"%s: %p", __FUNCTION__, (ReadStreamCallBack*)clientCB);
//    return _CFReadStreamSetClient(stream,streamEvents,clientCB,clientContext);
//}
//
//HOOK_FUNCTION(CFDictionaryRef, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFURLRequestCopyAllHTTPHeaderFields, id request)
//{
//    NSLog(@"%s: %p", __FUNCTION__, request);
//    return _CFURLRequestCopyAllHTTPHeaderFields(request);
//}

- (IBAction)getRequest:(id)sender
{
    
    CFStringRef urlStr = CFSTR("http://c.hiphotos.baidu.com/image/w%3D310/sign=b8f7695888d4b31cf03c92bab7d6276f/4e4a20a4462309f76248df09710e0cf3d7cad682.jpg");
    
    //GET请求
    CFStringRef method= CFSTR("GET");
    
    //构造URL
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, urlStr, NULL);
    
    //http请求
    CFHTTPMessageRef request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, method, url, kCFHTTPVersion1_1);
    
    //创建一个读取流 读取网络数据
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, request);
    
    //设置流的context这里将self传入,用于以后的回调
    CFStreamClientContext ctxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    
    //监听回调事件
    //  kCFStreamEventNone,（没有事件发生）
    //
    //  kCFStreamEventOpenCompleted,（流被成功打开）
    //
    //  kCFStreamEventHasBytesAvailable,（有数据可以读取）
    //
    //  kCFStreamEventCanAcceptBytes,（流可以接受写入数据（用于写入流））
    //
    //  kCFStreamEventErrorOccurred,（在流上有错误发生）
    //
    //  kCFStreamEventEndEncountered ,（到达了流的结束位置）
    CFOptionFlags event = kCFStreamEventHasBytesAvailable|kCFStreamEventEndEncountered;
    
    //设值回调函数myCallBack
    
    //    回调函数格式
    //    void callBack(CFReadStreamRef stream,CFStreamEventType type,void *clientCallBackInfo)
    
    CFReadStreamSetClient(readStream,event,myCallBack,&ctxt);
    
    CFReadStreamScheduleWithRunLoop(readStream,CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
    
    CFReadStreamOpen(readStream);
}

void myCallBack (CFReadStreamRef stream,CFStreamEventType type,void *clientCallBackInfo){
    
    NSLog(@"myCallBack is %@",clientCallBackInfo);
    
    static NSMutableData* imageData = nil;
    
    if(type == kCFStreamEventHasBytesAvailable){
        UInt8 buff[255];
        long length = CFReadStreamRead(stream, buff, 255);
        NSLog(@"length is %ld",length);
        if(!imageData){
            imageData = [[NSMutableData alloc] init];
        }
        [imageData appendBytes:buff length:length];
        
        
    }else if(type == kCFStreamEventEndEncountered){
        
        UIImage* image = [UIImage imageWithData:imageData];
        imageData = nil;
        CFReadStreamClose(stream);
        CFReadStreamUnscheduleFromRunLoop(stream,CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
    }
}

void postmyCallBack (CFReadStreamRef stream,CFStreamEventType type,void *clientCallBackInfo){
    
    NSLog(@"myCallBack is %@",clientCallBackInfo);
    
    static NSMutableData* imageData = nil;
    
    if(type == kCFStreamEventHasBytesAvailable){
        UInt8 buff[255];
        long length = CFReadStreamRead(stream, buff, 255);
        NSLog(@"length is %ld",length);
        if(!imageData){
            imageData = [[NSMutableData alloc] init];
        }
        [imageData appendBytes:buff length:length];
        
        
    }else if(type == kCFStreamEventEndEncountered){
        
        NSString* resString = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        NSLog(@"resString is %@",resString);
        CFReadStreamClose(stream);
        CFReadStreamUnscheduleFromRunLoop(stream,CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
    }
}

- (IBAction)postRequest:(id)sender
{
    CFStringRef urlStr = CFSTR("https://upload.api.weibo.com/2/statuses/upload.json");
    
    //GET请求
    CFStringRef method= CFSTR("POST");
    
    //构造URL
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, urlStr, NULL);
    
    //http请求
    CFHTTPMessageRef request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, method, url, kCFHTTPVersion1_1);
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809dasdasda2746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@",boundary];
    
    //OC的字符串要做C框架中使用需要__bridge桥接
    CFHTTPMessageSetHeaderFieldValue(request,  CFSTR("Content-Type"),  (__bridge  CFStringRef)(contentType));
    
    NSData  *bodyData  =  [self  getRequestData];
    CFHTTPMessageSetBody(request,  (__bridge CFDataRef)(bodyData));
    
    
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, request);
    
    //设置流的context这里将self传入,用于以后的回调
    CFStreamClientContext ctxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    CFOptionFlags event = kCFStreamEventHasBytesAvailable|kCFStreamEventEndEncountered;
    
    CFReadStreamSetClient(readStream,event,postmyCallBack,&ctxt);
    
    CFReadStreamScheduleWithRunLoop(readStream,CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
    
    CFReadStreamOpen(readStream);
}

- (NSData *)getRequestData{
    
    UIImage *image = [UIImage imageNamed:@"addressIcon"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    //分隔符，注意要与上面请求头中的一致
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809dasdasda2746641449"];
    
    
    //定义可变Data；
    NSMutableData *body = [NSMutableData data];
    
    //分隔符
    [body appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //需要发送的文字内容
    [body appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"需要发送的文字内容\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //分隔符
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //需要发送的图片内容
    [body appendData:[@"Content-Disposition: form-data; name=\"pic\"; filename=\"cat.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    
    //分割符
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //access_token 向新浪微博发送内容，需要OAuth认证，这里必须带上access_token
    [body appendData:[@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"2.00svaeojkrewe901dPLialB" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //结尾注意这里的分割符和前面不一样，--%@--后面多了两条--，如果少了会发送不成功哦
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}


@end
