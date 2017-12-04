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
    @IBOutlet weak var cityLabel : UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var CalendarBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addWeatherInfo()
        self.addCalendarView()
        self.addConstraints()
    }

    //MARK: Private Methods
    private func addWeatherInfo()
    {
        let str = "http://www.weather.com.cn/data/cityinfo/101190101.html"
        let url = NSURL(string: str)
        let data = NSData(contentsOf: url! as URL)
        
        do{
            let json =
                try  JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            let weatherInfo = (json as AnyObject).object(forKey: "weatherinfo")
            
            let city = (weatherInfo as AnyObject).object(forKey:"city")
            let minTemp = (weatherInfo as AnyObject).object(forKey:"temp1")
            let maxTemp = (weatherInfo as AnyObject).object(forKey:"temp2")
            let weather = (weatherInfo as AnyObject).object(forKey:"weather")
            cityLabel.text = "\(city!)"
            weatherLabel.text = "\(weather!)"
            temperatureLabel.text =  "\(minTemp!)～\(maxTemp!)"
        }catch{
            print("Error with loading weather infomation")
        }
    }
    private func addCalendarView() {
        
        self.calendarView = GCCalendarView()
        
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        //self.view.addSubview(self.calendarView)
        self.CalendarBackgroundView.addSubview(self.calendarView)
    }
    private func addConstraints()
    {
        
        //self.calendarView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 200).isActive = true
        self.calendarView.topAnchor.constraint(equalTo: self.CalendarBackgroundView.topAnchor).isActive = true
        self.calendarView.bottomAnchor.constraint(equalTo: self.CalendarBackgroundView.bottomAnchor).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.CalendarBackgroundView.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.CalendarBackgroundView.rightAnchor).isActive = true
        //self.calendarView.heightAnchor.constraint(equalToConstant: 325).isActive = true
    }
    //MARK: GCCalendarView delegate
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
    }

}
