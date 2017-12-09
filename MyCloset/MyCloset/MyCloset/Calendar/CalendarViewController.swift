//
//  CalendarViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/16.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import GCCalendar
import os.log

var matchImage = #imageLiteral(resourceName: "defaultPhoto") //暂用，之后换成返回时刷新图片！！

class CalendarViewController: UIViewController, GCCalendarViewDelegate
{
    
    //MARK: Properties
   
    private var calendarView: GCCalendarView!   //第三方日历控件
    @IBOutlet weak var cityLabel : UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var CalendarBackgroundView: UIView!
    @IBOutlet weak var DateTitle: UIButton!
    @IBOutlet weak var matchImageView: UIImageView!
    public static var selectedDate: String = "" //界面传值暂用！
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addWeatherInfo()
        self.addCalendarView()
        self.addCalendarViewConstraints()
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
        }catch
        {
            //print("Error with loading weather infomation")
            cityLabel.text = "定位失败"
            weatherLabel.text = "天气获取失败"
            temperatureLabel.text =  "气温获取失败"
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
    
    private func addCalendarViewConstraints()
    {
        self.calendarView.topAnchor.constraint(equalTo: self.CalendarBackgroundView.topAnchor).isActive = true
        self.calendarView.bottomAnchor.constraint(equalTo: self.CalendarBackgroundView.bottomAnchor).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.CalendarBackgroundView.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.CalendarBackgroundView.rightAnchor).isActive = true
    }
    
    private func saveDailyMatches() //保存每日搭配
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dailyMatches, toFile: Match.ArchiveURL.path)
        if isSuccessfulSave
        {
            os_log("Matches successfully saved.", log: OSLog.default, type: .debug)
        } else
        {
            os_log("Failed to save Matches...", log: OSLog.default, type: .error)
        }
    }
    
    
    //MARK: Actions
    @IBAction func onDatePikerPressed(_ sender: UIButton)
    {
        
    }
    //MARK: GCCalendarView delegate
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale.current // 设置时区
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        self.DateTitle.setTitle(dateFormatter.string(from: date), for: .normal)
        dateFormatter.dateFormat = "YYYYMMdd"
        CalendarViewController.selectedDate = dateFormatter.string(from: date)
        
        if let match = dailyMatches[CalendarViewController.selectedDate]
        {
            matchImageView.image = match.getScreenShot()
        }
        else
        {
            matchImageView.image = #imageLiteral(resourceName: "defaultPhoto")
        }
    }
    
    //MARK:Navigation
    @IBAction func unwindToCalendarView(sender: UIStoryboardSegue)
    {
        if sender.source is AddMatchViewController
        {
            //matchImageView.image = matchImage //改
            saveDailyMatches()
            if let match = dailyMatches[CalendarViewController.selectedDate]
            {
                matchImageView.image = match.getScreenShot()
            }
        }
    }
}
