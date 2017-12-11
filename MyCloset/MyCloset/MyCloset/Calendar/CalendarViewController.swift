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
import CoreLocation
import MapKit

enum LoadingWeatherError: Error
{
    case loseNetworkConnection  //网络连接错误
}
class CalendarViewController: UIViewController, GCCalendarViewDelegate, CLLocationManagerDelegate
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
    @IBOutlet weak var weatherImage: UIImageView!
    public static var selectedDate: String = "" //界面传值暂用！
    var queue = OperationQueue()
    var city: String?
    var weather: String?
    var code: String?
    var temperature: String?
    
    let locationManager = CLLocationManager()
    var latitude: Double? = 0
    var longitude: Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        self.addThread()
        self.addCalendarView()
        self.addCalendarViewConstraints()
    }

    //MARK: Private Methods
    private func addThread()
    {
        //queue = OperationQueue()
        let loadLocationOperation = BlockOperation(block:
        {
            self.loadLocation()
            return
        })
        loadLocationOperation.completionBlock =
        {
            print("loadLocationOperation completed, cancelled:\(loadLocationOperation.isCancelled)")
        }
        queue.addOperation(loadLocationOperation)
        
    }
    private func loadLocation()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation() //更新位置
            print("定位开始")
        }
        
    }
    private func updateWeather()
    {
        if self.city != nil && self.weather != nil && self.temperature != nil && self.code != nil
        {
            self.cityLabel.text = "\(self.city!)"
            self.weatherLabel.text = "\(self.weather!)"
            self.temperatureLabel.text = "\(self.temperature!)℃"
            self.weatherImage.image = UIImage(named:self.code!)
        }
        else
        {
            self.cityLabel.text = "定位失败"
            self.weatherLabel.text = "天气获取失败"
            self.temperatureLabel.text =  "气温获取失败"
        }
        
    }
    private func loadWeatherInfo()
    {

        let longitude_2 = String(format: "%.2f", longitude!)
        let latitude_2 = String(format: "%.2f", latitude!)
        let str = "https://api.seniverse.com/v3/weather/now.json?key=b80incxtoazyui2b&location=\(latitude_2):\(longitude_2)&language=zh-Hans&unit=c"  //经纬度定位
        //let str = "https://api.seniverse.com/v3/weather/now.json?key=b80incxtoazyui2b&location=ip&language=zh-Hans&unit=c"    //ip定位
        let url = NSURL(string: str)
        let data = NSData(contentsOf: url! as URL)
        
        if data == nil
        {
            return
        }
        
        do{
            let json =
                try  JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            let results = (json as AnyObject).object(forKey: "results") as? NSArray
            
            let location = (results![0] as AnyObject).object(forKey: "location")
            city = (location as AnyObject).object(forKey:"name") as? String
            
            let now = (results![0] as AnyObject).object(forKey:"now")
            weather = (now as AnyObject).object(forKey:"text") as? String
            temperature = (now as AnyObject).object(forKey:"temperature") as? String
            code = (now as AnyObject).object(forKey: "code") as? String
        }catch
        {
            print("Error with loading weather infomation")
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
            if matchImageView.image != #imageLiteral(resourceName: "defaultPhoto")
            {
            favouriteMatches[CalendarViewController.selectedDate] = dailyMatches[CalendarViewController.selectedDate]
            collectButton.setImage(#imageLiteral(resourceName: "cellect_like"), for:.normal)  //设置图标
            saveFavouriteMatches()
            }
        }
        else
        {
            favouriteMatches.removeValue(forKey: CalendarViewController.selectedDate)
            collectButton.setImage(#imageLiteral(resourceName: "collect"), for:.normal)
            saveFavouriteMatches()
            //从收藏中删除
        }
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
            saveDailyMatches()
            if let match = dailyMatches[CalendarViewController.selectedDate]
            {
                matchImageView.image = match.getScreenShot()
            }
        }
    }
    
    //MARK: location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let currLocation:CLLocation = locations.last!
        longitude = currLocation.coordinate.longitude
        latitude = currLocation.coordinate.latitude
        
        let loadWeatherOperation = BlockOperation(block:
        {
            self.loadWeatherInfo()
            OperationQueue.main.addOperation({self.updateWeather()})
        })
    
        loadWeatherOperation.completionBlock =
            {
                print("loadWeatherOperation completed, cancelled:\(loadWeatherOperation.isCancelled)")
        }
        queue.addOperation(loadWeatherOperation)
     
    }
    
}
