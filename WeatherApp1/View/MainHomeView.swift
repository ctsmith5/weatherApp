//
//  ContentView.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/6/22.
//

import SwiftUI

struct MainHomeView: View {
    
    @ObservedObject var mainViewModel = MainViewModel()
    @ObservedObject var locationViewModel = LocationViewModel()
    @State var forecastSelector = 1
    
    var body: some View {
        VStack {
            TextField("Search Locations", text: $locationViewModel.locationSearchText)
            Picker(selection: $forecastSelector) {
                Text("Hourly").tag(0)
                Text("Daily").tag(1)
                Text("5 Day").tag(2)
            } label: {
                Text("Forecast Picker??")
            }
            .padding(.horizontal, 8)
            .pickerStyle(.segmented)
            .onChange(of: forecastSelector) { newValue in
                mainViewModel.forcastSelected(newValue)
            }
            ScrollView {
                switch forecastSelector {
                case 0:
                    HStack {
                        
                        HStack {
                            Image(systemName: "clock")
                                .padding([.trailing], 18)

                            Image(systemName: "thermometer")
                            

                            Image(systemName: "cloud.rain")
                            
                            Spacer()
                            
                        }
                    }
                    .padding(.horizontal, 12)
                    VStack {
                        ForEach(mainViewModel.hourlyForecasts) { hourlyForecast in
                            HourlyForecastView(hourlyForecast: hourlyForecast)
                                .frame(height: 48)
                        }
                    }
                case 1:
                    Text(mainViewModel.cityName)
                    
                case 2:
                    Text(mainViewModel.weather)
                        .padding()
                    ForEach(mainViewModel.dailyForecasts) { dailyForecast in
                        DailyForecastView(dailyForecast: dailyForecast)
                    }
                default:
                    Text("Error State")
                }
            }
            Spacer()
        }
        .onAppear {
            //go get location and then pass to the view model
            locationViewModel.requestLocation { latLong in
                self.mainViewModel.getLocationKey(latLong ?? "")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeView()
    }
}

struct DailyForecastView: View {
    var dailyForecast: DailyForecasts
    var body: some View {
        HStack {
            Text(dailyForecast.id.formatDate())
                .bold()
            Spacer()
        }
        .padding(.horizontal, 8)
        VStack {
            HStack {
                let high = dailyForecast.temperature.high
                let low = dailyForecast.temperature.low
                VStack {
                   Image(systemName: "sun.max")
                        .resizable()
                        .frame(width: 36, height: 36)
                    Text("\(high.value) º\(high.unit)")
                        .font(.largeTitle)
                        .bold()
                    Text(dailyForecast.day.description)
                        .frame(width: 150)
                }
                .frame(height: 150)
                Spacer()
                VStack {
                    Image(systemName: "moon")
                        .resizable()
                        .frame(width: 36, height: 36)
//                    padding()
                    Text("\(low.value) º\(low.unit)")
                        .font(.largeTitle)
                        .bold()
                    Text(dailyForecast.night.description)
                        .frame(width: 150)
                }
                .frame(height: 150)
            }


        }
        .foregroundColor(.white)
        .background(UIConstants.Colorz.dayNightGradient)
        .cornerRadius(8)
        .padding(8)
    }
}

struct HourlyForecastView: View {
    var hourlyForecast: HourlyForecast
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.gray)
            HStack {
                Text(hourlyForecast.id.formatTime())
   
                Text("\(hourlyForecast.temp.value)º")

                Text("\(hourlyForecast.precipChance)%")

                Spacer()
                Text(hourlyForecast.description)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: 100)
            }
        }
        .padding(.horizontal, 12)
    }
}
