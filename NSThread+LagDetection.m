/**
 *  NSThread+LagDetection.m
 *
 * Created by Florian Agsteiner
 */

#import "NSThread+LagDetection.h"

@implementation NSThread (LagDetection)

+ (void) killIfMainThreadIsBlockedForDuration:(NSTimeInterval)duration{
    if ([NSThread currentThread] != [NSThread mainThread]) {
        [NSException raise:@"This method should be called from the main thread" format:nil];
    }

    __block BOOL canceled = NO;

    CFRunLoopRef mainRunLoop = [[NSRunLoop mainRunLoop] getCFRunLoop];

    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL,
                                                                       kCFRunLoopAllActivities,
                                                                       false,
                                                                       LONG_MAX, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                                                                           canceled = YES;
                                                                           CFRelease(observer);
                                                                       });
    CFRunLoopAddObserver(mainRunLoop, observer, kCFRunLoopDefaultMode);

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (!canceled) {
            [[NSThread mainThread] doesNotRecognizeSelector:@selector(crash)];
        }
    });
}

+ (void) killIfMainThreadIsBlocked{
    [self killIfMainThreadIsBlockedForDuration:1];
}

@end
