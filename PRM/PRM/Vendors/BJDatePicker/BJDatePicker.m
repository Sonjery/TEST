//
//  BJDatePicker.m
//  BJDatePicker
//
//  Created by zbj-mac on 16/4/8.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "BJDatePicker.h"
@interface BJDatePicker()
/**
 *  确认按钮size=(50，40)
 */
@property(nonatomic,strong)UIButton*confirmBtn;
/**
 *  datePicker height=186
 */
@property(nonatomic,strong)UIDatePicker*datePicker;
/**
 *  选中回调
 */
@property(nonatomic,copy)dateSelected dateSelected;
/**
 *  选中的时间串
 */
@property(nonatomic,copy)NSString*dateStr;
@end
@implementation BJDatePicker
#pragma mark-----这里修改控件属性-----
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.frame=CGRectMake(0, 50, KDeviceWidth, 176);
        _datePicker.datePickerMode=UIDatePickerModeDate;
        //设置时间范围
        NSDate*minDate=[[NSDate alloc] initWithTimeIntervalSince1970:40*365*24*3600+10*24*3600];
        NSDate*maxDate=[NSDate distantFuture];
        _datePicker.minimumDate=minDate;
        _datePicker.maximumDate=maxDate;
        _datePicker.backgroundColor=[UIColor whiteColor];
    }
    return _datePicker;
}
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn=[[UIButton alloc] init];
        _confirmBtn.frame=CGRectMake(KDeviceWidth-60,0,50,50);
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        _confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_confirmBtn setTitle:@"完  成" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.cornerRadius=5;
        _confirmBtn.layer.masksToBounds=YES;
    }
    return _confirmBtn;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn=[[UIButton alloc] init];
        _cancelBtn.frame=CGRectMake(10,0,50,50);
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_cancelBtn setTitle:@"取  消" forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius=5;
        _cancelBtn.layer.masksToBounds=YES;
    }
    return _cancelBtn;
}
#pragma mark----创建-----
 static BJDatePicker* instance;
+(BJDatePicker*)shareDatePicker{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[BJDatePicker alloc] init];
        });
    }
    return instance;
}
+(instancetype)datePicker{
    return [[self alloc] init];
}
-(instancetype)init{
    if (self=[super init]) {
        [self addSubview:self.datePicker];
        [self addSubview:self.confirmBtn];
        [self addSubview:self.cancelBtn];
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        self.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
    }
    return self;
}

-(void)datePickerDidSelected:(dateSelected)dateSelected{
    self.dateSelected=dateSelected;
}
#pragma mark----点击事件-----
-(void)confirmBtnClicked:(UIButton*)btn{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //这里设置输出格式
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    self.dateStr=[outputFormatter stringFromDate:self.datePicker.date];
    !self.dateSelected ? :self.dateSelected(self.dateStr);
}



@end

