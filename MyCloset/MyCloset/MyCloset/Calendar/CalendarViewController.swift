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
    @IBOutlet weak var collectButton: UIButton!
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
        //let str = "http://www.weather.com.cn/data/cityinfo/101190101.html"
        let str = "https://api.seniverse.com/v3/weather/now.json?key=b80incxtoazyui2b&location=beijing&language=zh-Hans&unit=c"
        let url = NSURL(string: str)
        let data = NSData(contentsOf: url! as URL)
        
        do{
            let json =
                try  JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            let weatherInfo = (json as AnyObject).object(forKey: "results")
            
            //let city = (weatherInfo as AnyObject).object(forKey:"city")
            //let minTemp = (weatherInfo as AnyObject).object(forKey:"temp1")
            //let maxTemp = (weatherInfo as AnyObject).object(forKey:"temp2")
            //let weather = (weatherInfo as AnyObject).object(forKey:"weather")
            let location = (weatherInfo as AnyObject).object(forKey: "location")
            let city = (location as AnyObject).object(forKey:"name")
            
            let now = (weatherInfo as AnyObject).object(forKey:"now")
            let weather = (now as AnyObject).object(forKey:"text")
            let temperature = (now as AnyObject).object(forKey:"temperature")
            cityLabel.text = "\(city!)"
            weatherLabel.text = "\(weather!)"
            //temperatureLabel.text =  "\(minTemp!)～\(maxTemp!)"
            temperatureLabel.text = "\(temperature)度"
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
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dailyMatches, toFile: Match.DailyMatchesArchiveURL.path)
        if isSuccessfulSave
        {
            os_log("Daily Matches successfully saved.", log: OSLog.default, type: .debug)
        } else
        {
            os_log("Failed to save Daily Matches...", log: OSLog.default, type: .error)
        }
    }
    
    private func saveFavouriteMatches()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favouriteMatches, toFile: Match.FavouriteMatchesArchiveURL.path)
        if isSuccessfulSave
        {
            os_log("Favourite Matches successfully saved.", log: OSLog.default, type: .debug)
        } else
        {
            os_log("Failed to save Favourite Matches...", log: OSLog.default, type: .error)
        }
    }
    //MARK: Actions
    @IBAction func onDatePikerPressed(_ sender: UIButton)
    {
        
    }
    
    @IBAction func onCollectButtonPressed(_ sender: UIButton)
    {
        if favouriteMatches[CalendarViewController.selectedDate] == nil
        {
            favouriteMatches[CalendarViewController.selectedDate] = dailyMatches[CalendarViewController.selectedDate]
            collectButton.setImage(#imageLiteral(resourceName: "cellect_like"), for:.normal)  //设置图标
        }
        else
        {
            favouriteMatches.removeValue(forKey: CalendarViewController.selectedDate)
            collectButton.setImage(#imageLiteral(resourceName: "collect"), for:.normal)
            //从收藏中删除
        }
        saveFavouriteMatches()
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
        
        if favouriteMatches[CalendarViewController.selectedDate] == nil
        {
             collectButton.setImage(#imageLiteral(resourceName: "collect"), for:.normal)
        }
        else
        {
             collectButton.setImage(#imageLiteral(resourceName: "cellect_like"), for:.normal)
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
