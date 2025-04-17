import SwiftUI

struct MoneyViewDC: View {
    @StateObject var user = AOUser.shared
    var body: some View {
        ZStack {
            Image(.moneyBgAO)
                .resizable()
                .scaledToFit()
                
          
                
                Text("\(user.money)")
                    .font(.system(size: AODeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    
                
            
        }.frame(height: AODeviceInfo.shared.deviceType == .pad ? 126:63)
            
    }
}

#Preview {
    MoneyViewDC()
}
