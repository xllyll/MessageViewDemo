//
//  YLYMessageView.m
//  MessgaeViewDemo
//
//  Created by xinyu_mac on 15/4/1.
//  Copyright (c) 2015年 xllyll. All rights reserved.
//

#import "YLYMessageView.h"

#define K_BUTTON_HIGHT 50
#define K_BUTTON_TO_TOP 10

@interface YLYMessageView()<UITextFieldDelegate>
{
    CGSize _keyboardSize;
}
//文字输入框
@property (strong , nonatomic)UITextField *messageTextField;
//音频，文字切换按钮
@property (strong , nonatomic)UIButton    *textOrAudioButton;
//音频输入按钮
@property (strong , nonatomic)UIButton    *audioButton;
//表情输入按钮
@property (strong , nonatomic)UIButton    *expressionButton;
//更多输入按钮
@property (strong , nonatomic)UIButton    *moreButton;



@end


@implementation YLYMessageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}
-(void)awakeFromNib{
    [self initConfig];
}

-(void)initConfig{
    [self registerForKeyboardNotifications];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.frame = CGRectMake(0, rx.size.height-K_BUTTON_HIGHT, rx.size.width, K_BUTTON_HIGHT);
    self.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0f];
    float bt_size =K_BUTTON_HIGHT - 2*K_BUTTON_TO_TOP;
    _textOrAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _textOrAudioButton.frame = CGRectMake(K_BUTTON_TO_TOP, K_BUTTON_TO_TOP, bt_size, bt_size);
    [_textOrAudioButton setBackgroundImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
    [_textOrAudioButton setBackgroundImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateSelected];
    [_textOrAudioButton addTarget:self action:@selector(swichTextAndAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textOrAudioButton];
    [self showTextOrAudio];
    
    
    _expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _expressionButton.frame = CGRectMake(rx.size.width - K_BUTTON_TO_TOP*2-bt_size*2, K_BUTTON_TO_TOP, bt_size, bt_size);
    [_expressionButton setBackgroundImage:[UIImage imageNamed:@"dd_emotion"] forState:UIControlStateNormal];
    //[_expressionButton setBackgroundImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateSelected];
    //[_expressionButton addTarget:self action:@selector(swichTextAndAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_expressionButton];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake(rx.size.width - K_BUTTON_TO_TOP-bt_size, K_BUTTON_TO_TOP, bt_size, bt_size);
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"dd_utility"] forState:UIControlStateNormal];
    //[_expressionButton setBackgroundImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateSelected];
    //[_moreButton addTarget:self action:@selector(swichTextAndAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    
}

-(void)swichTextAndAudio:(UIButton*)sender{
    BOOL is_select = sender.selected;
    if (is_select==YES) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    [self showTextOrAudio];
}
-(void)showTextOrAudio{
    if (_textOrAudioButton.selected==YES) {
        [self showAudio];
    }else{
        [self showText];
    }
}
/**
 * 显示文本输入框
 */
-(void)showText{
    float bt_size =K_BUTTON_HIGHT - 2*K_BUTTON_TO_TOP;
    if (_messageTextField==nil) {
        _messageTextField = [[UITextField alloc]initWithFrame:CGRectMake(K_BUTTON_TO_TOP*2+_textOrAudioButton.bounds.size.width, K_BUTTON_TO_TOP, self.bounds.size.width-(K_BUTTON_TO_TOP*5+bt_size*3), bt_size)];
        _messageTextField.borderStyle = UITextBorderStyleBezel;
        _messageTextField.delegate = self;
        [self addSubview:_messageTextField];
    }
    [_messageTextField setHidden:NO];
    [_messageTextField becomeFirstResponder];
    [_audioButton setHidden:YES];
    
}
/**
 * 显示音频输入按钮
 */
-(void)showAudio{
    float bt_size =K_BUTTON_HIGHT - 2*K_BUTTON_TO_TOP;
    if (_audioButton==nil) {
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioButton.frame = CGRectMake(K_BUTTON_TO_TOP*2+_textOrAudioButton.bounds.size.width, K_BUTTON_TO_TOP, self.bounds.size.width-(K_BUTTON_TO_TOP*5+bt_size*3), bt_size);
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"dd_press_to_say_normal"] forState:UIControlStateNormal];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"dd_record_release_end"] forState:UIControlStateHighlighted];
        [self addSubview:_audioButton];
    }
    [_messageTextField setHidden:YES];
    [_messageTextField resignFirstResponder];
    [_audioButton setHidden:NO];
}
/**
 *
 */
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
#pragma mark 动态获取键盘高度
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    CGRect rx = [ UIScreen mainScreen ].bounds;
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _keyboardSize = keyboardSize;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        CGRect rect = self.frame;
        rect.origin.y = rx.size.height-keyboardSize.height-rect.size.height;
        if (_textOrAudioButton.selected == YES) {
            rect.origin.y = rx.size.height-rect.size.height;
        }
        self.frame = rect;
        
    } completion:^(BOOL finished){
        
    }];
}
- (void)keyboardWasHidden:(NSNotification *) notif
{
    CGRect rx = [ UIScreen mainScreen ].bounds;
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    _keyboardSize = keyboardSize;
    
    
    [UIView animateWithDuration:0.1 animations:^{
        
        CGRect rect = self.frame;
        rect.origin.y = rx.size.height-keyboardSize.height-rect.size.height;
        if (_textOrAudioButton.selected == YES) {
            rect.origin.y = rx.size.height-rect.size.height;
        }
        self.frame = rect;
        
    } completion:^(BOOL finished){
        
    }];
}
@end
