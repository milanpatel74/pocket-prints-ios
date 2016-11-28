/*************************************************************************
* ADOBE CONFIDENTIAL
* ___________________
*
*  Copyright 2015 Adobe Systems Incorporated
*  All Rights Reserved.
*
* NOTICE:  All information contained herein is, and remains
* the property of Adobe Systems Incorporated and its suppliers,
* if any.  The intellectual and technical concepts contained
* herein are proprietary to Adobe Systems Incorporated and its
* suppliers and are protected by all applicable intellectual property 
* laws, including trade secret and copyright laws.
* Dissemination of this information or reproduction of this material
* is strictly forbidden unless prior written permission is obtained
* from Adobe Systems Incorporated.
**************************************************************************/

/**************************************************************************
 * [PRIVATE BETA] CreativeSync enables seamless multi-app workflows via
 * the included APIs. If you have any questions, please contact us at
 * https://creativesdk.zendesk.com/hc/en-us/requests/new
 *************************************************************************/

#ifndef Adobe360WorkflowStatusBarVCHeader
#define Adobe360WorkflowStatusBarVCHeader

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Adobe360Message;
@class Adobe360MessageBuilder;

/**
 * Defines methods for responding to user interaction and message handling events on the 
 * Adobe360WorkflowStatusBarViewController. You must implement this protocol on the delegate of the 
 * status bar view controller.
 */
@protocol Adobe360WorkflowReceiverDelegate <NSObject>

@required

/**
 * Called by the Adobe360WorkflowStatusBarController when the message has been successfully
 * returned back to the primary application. The integrating application should clean up the message handling
 * workspace and return to the previous state.
 *
 * @param messageBuilder The message builder object representing the message sent.
 * @see Adobe360MessageBuilder
 */
- (void)didSendCompletedResponse:(Adobe360MessageBuilder *)messageBuilder;

/**
 * The action was canceled by the user, and the initiating app will be launched.
 * This situation is equivalent to cancelMessageAndCleanup, but the user has
 * selected to return to the original application.
 *
 * You should tear down and reset the workspace to the state before the
 * workflow started.
 *
 * The Adobe360Message object that was sent will be cleaned up after the return
 * of this method. You will need to persist any input data before returning. If this
 * is a file, that means copying it into your workspace.
 *
 * @param message The Adobe360Message object that was canceled.
 */
- (void)didSendCanceledResponse:(Adobe360Message *)message;

/**
 * Called by the status bar to add the necessary information to the message builder.
 *
 * This information includes:
 *
 * - outputs: for most messages, outputs should be specified. For message types of 
 *     embed, outputs will not be specified.
 * - responseContext: the context information. This already be partially filled out using the 
 *                    information available to the status bar.
 *
 * @param messageBuilder The message builder that will be used to construct the response.
 *
 * @see [Adobe360MessageBuilder addOutputAsset:withError:]
 * @see [Adobe360MessageBuilder responseContext]
 * @see Adobe360Context
 */
- (void)updateResponseMessageBuilder:(Adobe360MessageBuilder *)messageBuilder;

/**
 * A required method for the delegate of the status bar view controller.
 *
 * This method will be called when an error is encountered while preparing and sending the 360 
 * message.
 *
 * @param error The Adobe360Error object.
 * @see Adobe360Error
 */
- (void)errorHandlingMessage:(NSError *)error;

@optional

/**
 * Called by the Adobe360WorkflowStatusBarController when the message has begun packaging and being 
 * dispatched. The progress object can be used to show user facing progress or for cancelling the 
 * operation.
 * 
 * @param messageBuilder The message builder object in the process of being packaged.
 * @param progress       An NSProgress object representing the progress of the packaging/sending 
 *                       operation.
 *
 * @see Adobe360MessageBuilder
 */
- (void)beganPackagingResponse:(Adobe360MessageBuilder *)messageBuilder withProgress:(NSProgress *)progress;

@end


/**
 * In the secondary app (responder) side of the workflow, you are required to show this view 
 * controller above or below the workspace for editing the element. This view controller provides 
 * the necessary user experience elements to respond to messages.
 */
@interface Adobe360WorkflowStatusBarViewController : UIViewController

/**
 * In the notification handler for Adobe360WorkflowActionInitiatedNotification, you will provide 
 * this object with the message from the notification.
 */
@property (nonatomic, strong) Adobe360Message *messageToProcess;

/**
 * The delegate object for callbacks.
 */
@property (nonatomic, weak) NSObject<Adobe360WorkflowReceiverDelegate> *receiverDelegate;

/**
 * Creates an instance of the Adobe360WorkflowActionStatusBarViewController object. This should be presented in
 * a popover on iPad and modally on iPhone.
 */
+ (instancetype)instantiateWorkflowStatusBarViewController;

/**
 * Set when the application is in a state to start packaging the response message. This will 
 * trigger all UI elements to be active and selectable.
 *
 * @param enabled Should be set to YES when you would like to enable user interaction on
 *                the status bar.
 */
- (void)setRoundtripEnabled:(BOOL)enabled;

@end

#endif
