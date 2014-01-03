//
//  EZViewController.m
//  EZLocalizableDemo
//
//  Created by EZ on 14-1-2.
//  Copyright (c) 2014年 cactus. All rights reserved.
//
//Localizable paths
#define kEZLocalZipPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"Localizable.zip"]

#define kEZLocalZipDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"Localizable"]

#define kEZLocalFilePath(localizableName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"Localizable/Localizable/%@",(localizableName)]]

#define kAppLanguages @"AppLanguages"
#define kAppLanguageString @"AppLanguageString"
#import "EZViewController.h"
#import "EZZipTools.h"
#import "EZLocalizable.h"

@interface EZViewController ()

@end

@implementation EZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectLanguageAction:(UIButton *)sender {
    NSString * language;
    switch (sender.tag) {
        case 1:
            language = @"zh-Hans";
            break;
        case 2:
            language = @"en";
            break;
            
        default:
            language = @"en";
            break;
    }
    language = [NSString stringWithFormat:@"%@.strings",language];
    NSDictionary *currDict =   [EZLocalizable localDicForAtPath:kEZLocalFilePath(language)];
    [[NSUserDefaults standardUserDefaults] setValue:currDict forKey:kAppLanguageString];
    [[NSUserDefaults standardUserDefaults] synchronize];
     self.helloLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:kAppLanguageString] valueForKey:@"helloKey"];
}


// 从网上获取国际化资源，这里hardcode本地
-(void)fetchData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //网上获取的data
        NSString    *filePath = [[NSBundle mainBundle] pathForResource:@"Localizable.zip" ofType:nil];
        NSData      *zipData = [[NSData alloc] initWithContentsOfFile:filePath];
        //写入指定文件夹下
        [zipData writeToFile:kEZLocalZipPath atomically:YES];
        //解压到指定目录
        NSFileManager *manager = [NSFileManager defaultManager];
        if(![manager contentsOfDirectoryAtPath:kEZLocalZipDirectory error:nil]){
            [manager createDirectoryAtPath:kEZLocalZipDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        }
        [EZZipTools unZipFile:kEZLocalZipPath toUnzipDirectoryPath:kEZLocalZipDirectory password:nil];
        //获得某个语言
     NSString * language = [[NSUserDefaults standardUserDefaults] valueForKey:kAppLanguages];
        if (language.length == 0) {
            language = [self getPreferredLanguage];
            if (![language isEqualToString:@"en"]&&![language isEqualToString:@"zh-Hans"]) {
                language =@"en";
            }
        }
        language = [NSString stringWithFormat:@"%@.strings",language];
        NSDictionary *currDict =   [EZLocalizable localDicForAtPath:kEZLocalFilePath(language)];
        [[NSUserDefaults standardUserDefaults] setValue:currDict forKey:kAppLanguageString];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //这里做保存和更新
        dispatch_async(dispatch_get_main_queue(), ^{
           //通知更新等处理
            self.helloLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:kAppLanguageString] valueForKey:@"helloKey"];
        });
    });
}





/**
 *得到本机现在用的语言
 * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
 */
- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

@end
