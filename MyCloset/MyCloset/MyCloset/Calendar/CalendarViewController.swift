//
//  CalendarViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/16.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import GCCalendar
class CalendarViewController: UIViewController, GCCalendarViewDelegate
{
    
    //MARK: Properties
    private var calendarView: GCCalendarView!   //第三方日历控件
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.addCalendarView()
         self.addConstraints()
        // Do any additional setup after loading the view.
    }

    //MARK: Private Methods
    private func addCalendarView() {
        
        self.calendarView = GCCalendarView()
        
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.calendarView)
    }
    private func addConstraints()
    {
        
        self.calendarView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalToConstant: 325).isActive = true
    }
    //MARK: GCCalendarView delegate
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
    }

}
