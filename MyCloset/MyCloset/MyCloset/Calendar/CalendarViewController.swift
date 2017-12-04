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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let str = "http://www.weather.com.cn/data/cityinfo/101010100.html"
        let url = NSURL(string: str)
        let data = NSData(contentsOf: url! as URL)
        
        do{
            let json =
                try  JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            let weatherInfo = (json as AnyObject).object(forKey: "weatherinfo")
            
            let city = (weatherInfo as AnyObject).object(forKey:"city")
            let maxTemp = (weatherInfo as AnyObject).object(forKey:"temp1")
            let minTemp = (weatherInfo as AnyObject).object(forKey:"temp2")
            let weather = (weatherInfo as AnyObject).object(forKey:"weather")
            //result.text = " 城市:\(city!)\n 最高温度:\(maxTemp!)\n 最低温度:\(minTemp!)\n 天气:\(weather!)\n"
            cityLabel.text = "\(city!)"
            weatherLabel.text = "\(minTemp!)度～\(maxTemp!)度"
            temperatureLabel.text = "\(weather!)"
        }catch{
            print("error")
        }
        
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
        
        self.calendarView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 200).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalToConstant: 325).isActive = true
    }
    //MARK: GCCalendarView delegate
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
    }

}
