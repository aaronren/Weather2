//
//  ContentView.swift
//  Weather2
//
//  Created by Aaron Ren on 2019/10/16.
//  Copyright © 2019 aaron. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ExtractedView(city: "上海")
                .padding()
            ExtractedView(city: "深圳")
                .padding()
            ExtractedView(city: "佳木斯")
                .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ExtractedView: View {

    @State var city: String = "上海"
    @State var imgstr: String = "unknow"
    @State var temp: String = "0"

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(imgstr.count>0 ? imgstr : "unknow")
                .resizable(capInsets: .init(), resizingMode: Image.ResizingMode.stretch)
                .frame(width: 370, height: 177.6)
                .shadow(radius: 6)
            VStack {
                Text(temp)
                    .frame(width: 90, height: 80, alignment: .center)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                Spacer()
                Text(city)
                    .frame(width: 90, height: 45, alignment: .center)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }.frame(width: 200, height: 177.6, alignment: .leading)
        }.onAppear(perform: requestWeather)
    }

    func requestWeather() {
        var urlString = "http://wthrcdn.etouch.cn/weather_mini?city="
        urlString += city
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(urlString)
        let url:URL! = URL(string: urlString)
        var request:URLRequest! = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let json:NSDictionary = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! NSDictionary
                let jdata = json["data"] as! NSDictionary
                let jwendu = jdata["wendu"] as! String
                print(jwendu)
                DispatchQueue.main.async {
                    self.temp = jwendu
                    switch (Int(jwendu)) {
                    case -4,-3,-2,-1:
                        self.imgstr = "snow-10_0"
                    case 0,1,2,3,4,5:
                        self.imgstr = "rain0_10"
                    case 6,7,8,9,10:
                        self.imgstr = "sky10_25"
                    case 11,12,13,14,15:
                        self.imgstr = "sleet-10_5"
                    case 16,17,18,19,20:
                        self.imgstr = "shower5_30"
                    case 21,22,23,24,25:
                        self.imgstr = "sunny15_25"
                    case 26,27,28,29,30:
                        self.imgstr = "haze30_40"
                    case .none:
                        self.imgstr = "unknow"
                    case .some(_):
                        self.imgstr = "unknow"
                    }
                }
            }
        }.resume()
    }
}
