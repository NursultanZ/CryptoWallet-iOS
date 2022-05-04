import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldings: Bool
    var backgroundColor: Color?
    
    var body: some View {
        
        HStack(spacing: 0){
            CoinInfo
            Spacer()
            
            if showHoldings {
                HoldingsInfo
            }
            
            PriceInfo
        }
        .font(.subheadline)
        .background(backgroundColor == nil ? Color(UIColor.systemBackground) : backgroundColor!)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldings: true, backgroundColor: nil)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldings: true, backgroundColor: Color.custom.background)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CoinRowView {
    private var CoinInfo: some View {
        HStack{
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.custom.secondaryText)

            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .foregroundColor(Color.custom.mainText)
                .font(.headline)
        }
    }
    
    private var HoldingsInfo: some View {
        VStack (alignment: .trailing){
            Text(coin.currentHoldingsValue.currencyFormat2())
                .bold()
            Text((coin.currentHoldings ?? 0).asFormattedString())
        }
        .foregroundColor(Color.custom.mainText)
        .padding(.trailing, 15)
    }
    
    private var PriceInfo: some View {
        VStack (alignment: .trailing){
            Text("\(coin.currentPrice.currencyFormat6())")
                .bold()
                .foregroundColor(Color.custom.mainText)
            Text("\(coin.priceChangePercentage24H?.asFormattedString() ?? "0.00")%")
                .foregroundColor((coin.priceChangePercentage24H ?? 0.0) >= 0 ? Color.custom.green : Color.custom.red)
        }
    }
}
