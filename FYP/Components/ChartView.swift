//
//  ChartView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 13/4/2022.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    
    private let maxY: Double
    private let minY: Double
    
    private let yAxis: Double
    
    private let lineColor: Color
    
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var displayPercentage: CGFloat = 0.0
    
    init(coin: Coin){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        yAxis = maxY - minY
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.custom.green : Color.custom.red
        
        endingDate = Date(coinGeckoDate: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chart
                .frame(height: 200)
                .background(
                    VStack {
                        Divider()
                        Spacer()
                        Divider()
                        Spacer()
                        Divider()
                    }
                )
                .overlay(alignment: .leading) {
                    VStack{
                        Text(maxY.formattedWithAbbreviations())
                        Spacer()
                        Text(((maxY + minY) / 2).formattedWithAbbreviations())
                        Spacer()
                        Text(minY.formattedWithAbbreviations())
                    }
                    .padding(.horizontal, 4)
                }
            HStack{
                Text(startingDate.asShortDateString())
                Spacer()
                Text(endingDate.asShortDateString())
            }
            .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.custom.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1.5)){
                    displayPercentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
            .preferredColorScheme(.dark)
    }
}

extension ChartView {
    var chart: some View {
        GeometryReader { geometry in
            VStack {
                Path { path in
                    for index in data.indices {
                        
                        let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                        
                        let yPos = CGFloat(1 - ((data[index] - minY) / yAxis)) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPos, y: yPos))
                        }
                        
                        path.addLine(to: CGPoint(x: xPos, y: yPos))
                    }
                }
                .trim(from: 0, to: displayPercentage)
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            }
        }
    }
}
