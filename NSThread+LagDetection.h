/**
 *  NSThread+LagDetection.h
 *
 * Created by Florian Agsteiner
 *
 *
 * This Category adds lag detection that can be used to generate Crashreports when a method blocks the main thread for too long.
 *
 * When the main thread timeouts the app will be killed, generating a Crashreport at the current state of the app.
 * Hopefully this crash will point you to a deadlock, wait or sleeping part of the code.
 *
 * Call the methods early (e.g. in IBActions oder other user events) and before your logic, e.g.:
 *
 * - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 *    [NSThread killIfMainThreadIsBlocked];
 *
 *    [self createAndPushViewController];
 * }
 */

#import <Foundation/Foundation.h>

/**
 * Adds the method to NSThread
 */
@interface NSThread (LagDetection)

/**
 * Force quits the App when the main thread is blocked for the given duration in seconds.
 */
+ (void) killIfMainThreadIsBlockedForDuration:(NSTimeInterval)duration;

/**
 * Force quits the App when the main thread is blocked for 1 second.
 */
+ (void) killIfMainThreadIsBlocked;

@end
