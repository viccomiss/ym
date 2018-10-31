//
//  NSAttributedString+JLAdd.m
//  SuperEducation_Host
//
//  Created by 123 on 2017/4/14.
//  Copyright © 2017年 shanghailuoqi. All rights reserved.
//

#import "NSAttributedString+JLAdd.h"

@implementation NSAttributedString (JLAdd)

-(CGFloat)getHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil].size;
    return size.height;
}

-(CGFloat)getHeightWithWidth:(CGFloat)width{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading| NSStringDrawingUsesDeviceMetrics context:nil].size;
    return size.height;
}


- (NSString *)attributeStrToHtml{
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [self dataFromRange:NSMakeRange(0, self.length)
                        documentAttributes:tempDic
                                     error:nil];
    return [[NSString alloc] initWithData:htmlData
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark ===========解析为只要正文内容的html=============
- (NSRange)firstParagraphRangeFromTextRange:(NSRange)range
{
    NSInteger start = -1;
    NSInteger end = -1;
    NSInteger length = 0;
    
    NSInteger startingRange = (range.location == self.string.length || [self.string characterAtIndex:range.location] == '\n') ?
    range.location-1 :
    range.location;
    
    for (NSInteger i= startingRange ; i>=0 ; i--)
    {
        char c = [self.string characterAtIndex:i];
        if (c == '\n')
        {
            start = i+1;
            break;
        }
    }
    
    start = (start == -1) ? 0 : start;
    
    NSInteger moveForwardIndex = (range.location > start) ? range.location : start;
    
    for (NSInteger i = moveForwardIndex; i<= self.string.length-1 ; i++)
    {
        char c = [self.string characterAtIndex:i];
        if (c == '\n')
        {
            end = i;
            break;
        }
    }
    
    end = (end == -1) ? self.string.length : end;
    length = end - start;
    
    return NSMakeRange(start, length);
}

- (NSArray *)rangeOfParagraphsFromTextRange:(NSRange)textRange
{
    NSMutableArray *paragraphRanges = [NSMutableArray array];
    NSInteger rangeStartIndex = textRange.location;
    
    while (true)
    {
        NSRange range = [self firstParagraphRangeFromTextRange:NSMakeRange(rangeStartIndex, 0)];
        rangeStartIndex = range.location + range.length + 1;
        
        [paragraphRanges addObject:[NSValue valueWithRange:range]];
        
        if (range.location + range.length >= textRange.location + textRange.length)
            break;
    }
    
    return paragraphRanges;
}

- (NSString *)htmlTextAlignmentString:(NSTextAlignment)textAlignment
{
    switch (textAlignment)
    {
        case NSTextAlignmentLeft:
            return @"left";
            
        case NSTextAlignmentCenter:
            return @"center";
            
        case NSTextAlignmentRight:
            return @"right";
            
        case NSTextAlignmentJustified:
            return @"justify";
            
        default:
            return nil;
    }
}

- (NSString *)htmlRgbColor:(UIColor *)color
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSString stringWithFormat:@"rgb(%d,%d,%d)",(int)(red*255.0), (int)(green*255.0), (int)(blue*255.0)];
}

@end
