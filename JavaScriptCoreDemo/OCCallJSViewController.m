//
//  OCCallJSViewController.m
//  JavaScriptCoreDemo
//
//  Created by reborn on 16/9/12.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "OCCallJSViewController.h"

@interface OCCallJSViewController ()<UIWebViewDelegate>
{
    UITextField *textField;
    UILabel     *resultL;
    
    UIWebView *_webView;
}
@end

@implementation OCCallJSViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"oc call js";
    self.view.backgroundColor = [UIColor grayColor];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 250, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    UIButton *caculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    caculateBtn.frame = CGRectMake(20, 180, 140, 30);
    caculateBtn.backgroundColor = [UIColor blueColor];
    [caculateBtn setTitle:@"调用js方法计算" forState:UIControlStateNormal];
    [caculateBtn addTarget:self action:@selector(caculateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:caculateBtn];
    
    UIButton *callJsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callJsButton.frame = CGRectMake(180, 180, 140, 30);
    callJsButton.backgroundColor = [UIColor blueColor];
    [callJsButton setTitle:@"调用js方法1" forState:UIControlStateNormal];
    [callJsButton addTarget:self action:@selector(callJsButtonAction1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callJsButton];
    
    callJsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callJsButton.frame = CGRectMake(20, 215, 140, 30);
    callJsButton.backgroundColor = [UIColor purpleColor];
    [callJsButton setTitle:@"调用js方法2" forState:UIControlStateNormal];
    [callJsButton addTarget:self action:@selector(callJsButtonAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callJsButton];
    
    callJsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callJsButton.frame = CGRectMake(180, 215, 140, 30);
    callJsButton.backgroundColor = [UIColor purpleColor];
    [callJsButton setTitle:@"调用js方法3" forState:UIControlStateNormal];
    [callJsButton addTarget:self action:@selector(callJsButtonAction3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callJsButton];
    
    resultL = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, 80, 30)];
    resultL.font = [UIFont systemFontOfSize:14];
    resultL.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:resultL];
    
    self.context = [[JSContext alloc] init];
    [self.context evaluateScript:[self loadJsFile:@"test"]];
    
    
    // add
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 300, 320, 200)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil];
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (NSString *)loadJsFile:(NSString*)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsScript;
}

- (void)caculateButtonAction:(id)sender
{
    NSNumber *inputNumber = [NSNumber numberWithInteger:[textField.text integerValue]];
    JSValue *function = [self.context objectForKeyedSubscript:@"factorial"];
    JSValue *result = [function callWithArguments:@[inputNumber]];

    resultL.text = [NSString stringWithFormat:@"%@",[result toNumber]];
}

-(void)callJsButtonAction1:(UIButton *)button{
    [textField resignFirstResponder];
    NSString *inputValue = textField.text;
//    JSValue *function = [self.context objectForKeyedSubscript:@"function1"]; //获得JS脚本
    JSValue *function = self.context[@"function1"]; //获得js脚本
    [function callWithArguments:@[inputValue]];
}

-(void)callJsButtonAction2:(UIButton *)button{
    [textField resignFirstResponder];
    NSString *inputValue = textField.text;
    NSString *script = [NSString stringWithFormat:@"function2('%@')", inputValue];
    [self.context evaluateScript:script];
}

-(void)callJsButtonAction3:(UIButton *)button{
    [textField resignFirstResponder];
    NSString *inputValue = textField.text;
    NSString *script = [NSString stringWithFormat:@"self.function3('%@')", inputValue];
    [_webView stringByEvaluatingJavaScriptFromString:script];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL absoluteString];
    if ([urlStr rangeOfString:@"gotoLogin"].location != NSNotFound) {
        [self gotoLoginAction];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self.context evaluateScript:[self loadJsFile:@"test"]];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)gotoLoginAction {
    NSLog(@"这里面可以编写跳转登录界面的代码咯");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"要跳转到OC原生的登录界面吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:cancelAction];
    [self.navigationController presentViewController:alertControl animated:YES completion:nil];
}

@end
