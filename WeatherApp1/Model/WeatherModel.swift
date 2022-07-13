//
//  WeatherModel.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/6/22.
//

import Foundation

//MARK: - Weather Data Models

struct WeatherData: Decodable {
    
    let headline: Headline
    let dailyForecasts: [DailyForecasts]
    
    enum CodingKeys: String, CodingKey {
            case headline = "Headline"
            case dailyForecasts = "DailyForecasts"
    }
    
}

struct Headline: Decodable {
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "Text"
    }
    
}

struct HourlyForecast: Decodable, Identifiable {
    let id: String
    let description: String
    let temp: TemperatureData
    let hasPrecip: Bool
    let precipChance: Int
    let isDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "DateTime"
        case description = "IconPhrase"
        case temp = "Temperature"
        case hasPrecip = "HasPrecipitation"
        case precipChance = "PrecipitationProbability"
        case isDay = "IsDaylight"
    }
}



struct DailyForecasts: Decodable, Identifiable {
    let id: String
    let temperature: Temperature
    let day: TwelveHourForecast
    let night: TwelveHourForecast
    
    
    enum CodingKeys: String, CodingKey {
        case id = "Date"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
    }
}


struct Temperature: Decodable {
    let low: TemperatureData
    let high: TemperatureData
    
    enum CodingKeys: String, CodingKey {
        case low = "Minimum"
        case high = "Maximum"
    }
    
}

struct TemperatureData: Decodable {
    let value: Int
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
    }
}

struct TwelveHourForecast: Decodable {
    let description: String
    let hasPrecipitation: Bool
    let precipitationType: String?
    let precipitationLevel: String?
    
    
    enum CodingKeys: String, CodingKey {
        case description = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
        case precipitationType = "PrecipitationType"
        case precipitationLevel = "PrecipitationIntensity"
    }
}


//MARK: - Location Models
struct LocationResponse: Decodable {
    let locationKey: String
    let localizedName: String
    
    enum CodingKeys: String, CodingKey {
            case locationKey = "Key"
            case localizedName = "LocalizedName"
    }
}


//MARK: - Forecast Selection

enum ForecastSelection {
    case hourly
    case oneDay
    case fiveDay
    
    func urlString() -> URL? {
        var url: URL?
        
        switch self {
            case .hourly:
                url = URL(string: "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/")
            case .oneDay:
                url = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/1day/")
            case .fiveDay:
                url = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/")
        }
        return url
    }
}
