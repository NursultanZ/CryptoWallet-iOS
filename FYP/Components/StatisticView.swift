import SwiftUI

struct StatisticView: View {
    
    let stat: Statistic
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3){
            
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.custom.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.custom.mainText)
            
            HStack (spacing: 3){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentChange ?? 0) >= 0 ? 0 : 180))
                    
                Text(stat.percentChange != nil ? "\(stat.percentChange!.asFormattedString())%" : "")
                    .font(.caption)
            }
            .foregroundColor((stat.percentChange ?? 0) >= 0 ? Color.custom.green : Color.custom.red)
            .opacity(stat.percentChange == nil ? 0.0 : 1.0)
        }
        .padding()
        
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.stat1)
    }
}
