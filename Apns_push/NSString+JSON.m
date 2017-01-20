 //
//  NSString+JSON.m
//  Cicada
//
//  Created by 骆杨 on 10/29/14.
//  Copyright (c) 2014 thinkjoy. All rights reserved.
//

#import "NSString+JSON.h"


@implementation NSString (JSON)

+ (NSData *) jsonDateWithNSDictionary:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *requestBody = nil;
    @try {
        requestBody = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    }
    @catch (NSException *exception) {
//        DLog(@"exception=%@", exception);
        requestBody = [NSData data];
    }
    @finally {
        
    }
    if(error == nil)
    {
    }else {
//        DLog(@"Serialization Eror: %@",error);
    }
    return requestBody;
}

+ (id) jsonObjectWithData:(NSData *) data{
    NSError *error = nil;
    id jsonObject = nil;
    @try {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exception) {
//        DLog(@"exception=%@", exception);
        jsonObject = @{};
    }
    @finally {
        
    }
    if(error == nil)
    {
        
    }else {
//        DLog(@"Serialization Eror: %@",error);
    }
    return jsonObject;
}

+ (NSString *) jsonStringWithNSDictionary:(NSDictionary *) dict{
    NSData *jsonData = [NSString jsonDateWithNSDictionary:dict];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (id) jsonObjectWithNSString:(NSString *) jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSString jsonObjectWithData:jsonData];
    return jsonObject;
}

@end
