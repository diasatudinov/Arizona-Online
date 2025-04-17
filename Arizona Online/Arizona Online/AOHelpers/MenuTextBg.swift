import SwiftUI

struct MenuTextBg: View {
    @State var text: String
    var body: some View {
        ZStack {
            Image(.buttonBgAO)
                .resizable()
                .scaledToFit()
            
            TextWithBorder(text: text, font: .system(size: AODeviceInfo.shared.deviceType == .pad ?  48:24, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                .offset(y: AODeviceInfo.shared.deviceType == .pad ? -8:-4)
        }.frame(height: AODeviceInfo.shared.deviceType == .pad ? 180:90)
    }
}

#Preview {
    MenuTextBg(text: "Play")
}
