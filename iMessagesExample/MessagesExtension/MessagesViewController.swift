//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Ellina Kuznecova on 01.11.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    var poll: PollEntity!
        
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        self.poll = PollEntity(message: conversation.selectedMessage) ?? PollEntity(creatorId: conversation.localParticipantIdentifier.uuidString)
        presentVC(for: conversation, with: presentationStyle)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = activeConversation else {
            fatalError("Expected the active conversation")
        }
        if let _ = conversation.selectedMessage {
            self.poll = PollEntity(message: conversation.selectedMessage)
        }
        presentVC(for: conversation, with: presentationStyle)
    }
    
    private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        let controller: UIViewController
        
        if presentationStyle == .compact {
            controller = instantiateCompactVC()
        } else {
            controller = instantiateExpandedVC()
        }
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        self.addChildViewController(controller)
        
        //TODO: figure out why size is not right
        controller.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
        view.addSubview(controller.view)
        
        controller.didMove(toParentViewController: self)
    }
    
    private func instantiateCompactVC() -> UIViewController {
        guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "CompactVC") as? CompactViewController else {
            fatalError("Can't instantiate CompactViewController")
        }
        compactVC.delegate = self
        compactVC.options = self.poll.options
        return compactVC
    }
    
    private func instantiateExpandedVC() -> UIViewController {
        guard let expandedVC = storyboard?.instantiateViewController(withIdentifier: "ExpandedVC") as? ExpandedViewController else {
            fatalError("Can't instantiate ExpandedViewController")
        }
        expandedVC.delegate = self
        expandedVC.data = self.poll
        return expandedVC
    }
    
    private func isSenderSameAsRecipient() -> Bool {
        guard let conversation = activeConversation else { return false }
        guard let message = conversation.selectedMessage else { return false }
        
        return message.senderParticipantIdentifier == conversation.localParticipantIdentifier
    }
}

extension MessagesViewController: CompactViewControllerDelegate {
    func createPollPressed() {
        self.requestPresentationStyle(.expanded)
    }
    
    func sendMessage() {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        // Create a new message with the same session as any currently selected message.
        let message = composeMessage(with: "I created new poll!", session: conversation.selectedMessage?.session)
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    fileprivate func composeMessage(with caption: String, session: MSSession? = nil) -> MSMessage {
        
        let layout = MSMessageTemplateLayout()
        layout.image = #imageLiteral(resourceName: "poll")
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.layout = layout
        
        var components = URLComponents()
        components.queryItems = self.poll.queryItems
        message.url = components.url!
        
        return message
    }
}

extension MessagesViewController: ExpandedViewControllerDelegate {
    func pollUpdated(poll: PollEntity) {
        self.poll = poll
    }
}
