//
//  MainViewModel.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/6/22.
//

import Foundation


class MainViewModel: ObservableObject {
    
    @Published var weather: String = "Initial Weather"
    @Published var dailyForecasts: [DailyForecasts] = []
    @Published var hourlyForecasts: [HourlyForecast] = []
    @Published var cityName: String = "None"
    private var locationData: LocationResponse?
    
    
    //MARK: - Process Intents
    func forcastSelected(_ newValue: Int) {
        var forecast: ForecastSelection
        
        switch newValue {
        case 0:
            forecast = .hourly
        case 1:
            forecast = .oneDay
        case 2:
            forecast = .fiveDay
        default:
            forecast = .oneDay
        }
        
        self.getWeather(length: forecast)
    }
    

    //MARK: - Network Wrapper
    
    func getWeather(length forecast: ForecastSelection) {
        
        guard var urlString = forecast.urlString() else { return }
        if let locationData = locationData {
            urlString.appendPathComponent(locationData.locationKey)
        }
        switch forecast {
            
        case .hourly :
            NetworkClient.request(url: urlString) { (hourlyForecasts: [HourlyForecast]) in
                DispatchQueue.main.async {
                    self.hourlyForecasts = hourlyForecasts
                }
            }
            
        case .oneDay, .fiveDay :
            NetworkClient.request(url: urlString) { (weatherUpdate: WeatherData) in
                DispatchQueue.main.async {
                    self.weather = weatherUpdate.headline.weatherDescription
                    self.dailyForecasts = weatherUpdate.dailyForecasts
                }
            }
        }
    }
    
    func getLocationKey(_ latLong: String) {
        guard let urlString = URLConstants.locationSearch else { return }
        let locationQueryItem = URLQueryItem(name: "q", value: latLong)
        NetworkClient.request(url: urlString, parameters: [locationQueryItem]) { (locationResponse: LocationResponse) in
            DispatchQueue.main.async {
                self.locationData = locationResponse
                self.cityName = locationResponse.localizedName
            }
        }
    }
}



extension String {
    
    func formatTime() -> String {
        let time = self.split(separator: "T").last
        let hour = time?.split(separator: "-").first
        guard let strip = hour?.split(separator: ":").first,
                let hourInt = Int(strip) else { return " " }
        var returnString: String
        if hourInt == 12 {
            returnString = "12 pm"
        } else  {
            returnString = hourInt <= 12 ? "\(hourInt) am" : "\(hourInt - 12) pm"
        }
        return returnString
    }
    
    
    
    func formatDate() -> String {
        let date = self.split(separator: "T").first
        let splitDate = date?.split(separator: "-")
        let month = Int(splitDate?[1] ?? "0")
        let day = splitDate?[2] ?? "0"
        var monthString = ""
        
        switch month {
        case 1:
            monthString = "January"
        case 2:
            monthString = "February"
        case 3:
            monthString = "March"
        case 4:
            monthString = "April"
        case 5:
            monthString = "May"
        case 6:
            monthString = "June"
        case 7:
            monthString = "July"
        case 8:
            monthString = "August"
        case 9:
            monthString = "September"
        case 10:
            monthString = "October"
        case 11:
            monthString = "November"
        case 12:
            monthString = "December"
            
        default:
            monthString = ""
        }
        
        
        return monthString + " " + day
    }
    
}

