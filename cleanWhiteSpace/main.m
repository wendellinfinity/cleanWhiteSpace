//
//  main.m
//  cleanWhiteSpace
//
//  Created by Wendell on 11/18/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    if(argc > 1) {
        @autoreleasepool {
            NSString *stringFromParams = [[NSString alloc] initWithCString:argv[1] encoding:NSUTF8StringEncoding];
            NSURL *URL = [[NSURL alloc] initFileURLWithPath: stringFromParams];
            NSError *error;
            NSString *stringFromFileAtURL = [[NSString alloc]
                                             initWithContentsOfURL:URL
                                             encoding:NSUTF8StringEncoding
                                             error:&error];
            if (stringFromFileAtURL == nil) {
                // an error occurred
                NSLog(@"Error reading file at %@\n%@", URL, [error localizedFailureReason]);
            } else {
                // read file line by line and remove blank lines
                NSUInteger length = [stringFromFileAtURL length];
                NSUInteger paraStart = 0, paraEnd = 0, contentsEnd = 0;
                NSMutableArray *array = [NSMutableArray array]; // array buffer
                NSRange currentRange;
                NSString *currentLine;
                while (paraEnd < length) {
                    [stringFromFileAtURL getParagraphStart:&paraStart end:&paraEnd
                                               contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
                    currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
                    // read current line
                    currentLine = [stringFromFileAtURL substringWithRange:currentRange];
                    // trim spaces
                    currentLine = [currentLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if([currentLine length] > 0) {
                        // if there is no whitespace add to array
                        [array addObject:currentLine];
                        // write current line
                        //NSLog(@"%@", currentLine);
                    }
                }
                if([array count] > 0) {
                    // write to file if there are strings in array buffer
                    stringFromFileAtURL = [array componentsJoinedByString:@"\n"];
                    [stringFromFileAtURL  writeToFile:[stringFromParams stringByAppendingString:@".1"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    NSLog(@"File written to: %@", [stringFromParams stringByAppendingString:@".1"]);
                }
            }
            
        }        
    } else {
        NSLog(@"No file specified");
    }
    return 0;
}

