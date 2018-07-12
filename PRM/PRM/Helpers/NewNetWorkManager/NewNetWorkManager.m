//
//  NewNetWorkManager.m
//  WeiLv
//
//  Created by lanouhn on 16/6/27.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import "NewNetWorkManager.h"

@implementation NewNetWorkManager
+(void)requestGETWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responder))finish conError:(void (^)(NSError *error))conError{
    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5;
    
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager GET:urlStr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功的回调
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //数据请求失败的回调
        conError(error);
    }];
}

//POST请求
//GET请求
/**
 *  @param urlStr       数据请求接口地址
 *  @param dic           接口请求数据参数
 *  @param finish       数据请求成功回调
 *  @param conError  数据请求失败回调
 */
+(void)requestPOSTWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responder))finish conError:(void (^)(NSError *error))conError{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/json",@"text/javascript",nil];
    manager.requestSerializer.timeoutInterval = 10;
    manager.securityPolicy= [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        //数据请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功调用
            finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //数据请求失败调用
            conError(error);
    }];
}


+(void)requestJSONStringDataPostWith:(NSString *)urlStr parStr:(NSString *)parmStr finish:(void(^)(NSURLResponse *responder,NSString *RespStr, id respond))finish conError:(void (^)(NSError *error))conError{
    //2.创建NSURL对象   (初始化 网络连接)
    NSURL *url = [NSURL URLWithString:urlStr];
    //3.创建网络请求对象(NSURLRequest)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.2设置请求体(提交的内容)
    NSData *data = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //3.3设置请求方式
    [request setHTTPMethod:@"POST"];
    //  4.创建连接   异
    NSURLSession *session  = [NSURLSession sharedSession];    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        id dict= data;//[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if (finish != nil) {
            finish(response,dataStr,dict);
        }
        if (conError != nil) {
            conError(error);
        }        
    }];
    //7.启动任务
    [task resume];

}


+ (void)downLoadFilesWithUrlStr:(NSURL *)urlStr
                       progress:(void (^)(NSProgress *downloadProgress))progressBlock
                    destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
              completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progressBlock(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return    destination(targetPath,response);
        /*        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
         //                                                                   NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
         //
         //        NSLog(@"targetPath:%@",targetPath);
         //        NSLog(@"fullPath:%@",fullPath);
         //
         //        return [NSURL fileURLWithPath:fullPath];
         */
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response,filePath,error);
    }];
    
    
    [task resume];
    
}




@end
