//
//  DatePickerViewController.swift
//  PuyoSim
//
//  Created by roza on 2016/10/17.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

class DatePickerViewController : UIViewController, StoryboardInstantiatable {
    static func showPicker(viewController: UIViewController , date: Date? = Date(), minDate: Date? = nil, maxDate: Date? = nil, completion: @escaping (Date) -> ()) {
        let picker = DatePickerViewController.instantiate()
        picker.selectedDate = date ?? Date()
        picker.minDate = minDate
        picker.maxDate = maxDate
        picker.completion = completion
        if let tabBarController = viewController.tabBarController {
            tabBarController.present(picker, animated: false) {picker.showPicker()}
        } else {
            viewController.present(picker, animated: false) {picker.showPicker()}
        }
    }

    private var selectedDate : Date? = Date()
    private var minDate : Date?
    private var maxDate : Date?
    
    @IBOutlet private weak var pickerView :UIDatePicker?
    @IBOutlet private weak var backgroundView :UIView?
    @IBOutlet private weak var pickerBackY :NSLayoutConstraint?
    
    var completion :((Date) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView?.date = selectedDate!
        pickerView?.minimumDate = minDate
        pickerView?.maximumDate = maxDate
    }
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return UIModalPresentationStyle.overCurrentContext
        }
        set {
            super.modalPresentationStyle = newValue
        }
    }
    
    func showPicker() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView!.alpha = 0.6
            self.pickerBackY!.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func showPicker(completion:@escaping (Date) -> ()) {
        self.completion = completion
        UIView.animate(withDuration: 0.25) {
            self.backgroundView!.alpha = 0.6
            self.pickerBackY!.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePicker() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView!.alpha = 0
            self.pickerBackY!.constant = -220
            self.view.layoutIfNeeded()
        }) { finished in
            self.dismiss(animated: false) {
                if self.selectedDate != nil {
                    self.completion?(self.selectedDate!)
                }
                self.completion = nil
            }
        }
    }
    
    @IBAction private func complete() {
        selectedDate = pickerView?.date
        self.hidePicker()
    }
    
    @IBAction private func cancel() {
        self.completion = nil
        selectedDate = nil
        self.hidePicker()
    }
}
