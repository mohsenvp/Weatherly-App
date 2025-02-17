//
//  SingleSettingsView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/10/21.
//

import SwiftUI

struct SingleSettingsView: View {
    @StateObject var viewModel: SingleSettingsViewModel
    @EnvironmentObject var premium: Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Group {
            if viewModel.type == .language {
                LanguageView(currentLanguage: viewModel.currentLanguage) { language in
                    viewModel.setNewLanguage(language: language)
                }
            }else if viewModel.type == .dataSources {
                
                DataSourcesView(
                    viewModel: viewModel,
                    isPremium: $premium.isPremium,
                    isSubscriptionViewPresented: isSubscriptionViewPresented,
                    onWeatherChange: { weatherDataSource in
                        viewModel.setNewWeatherDataSource(dataSource: weatherDataSource)
                    }, onAQIChange: { aqiDataSource in
                        viewModel.setNewAQIDataSource(dataSource: aqiDataSource)
                    })
            } else if viewModel.type == .userNotificationConfig {
                UserNotificationConfigView()
                    .background(Color(.systemGroupedBackground))
            } else {
                ScrollView {
                    switch viewModel.type {
                    case .appUnits:
                        AppUnitsView(selectedTemp: viewModel.loadUnit(for: .temperature) as! TemperatureUnit,
                                     selectedSpeed: viewModel.loadUnit(for: .speed) as! SpeedUnit,
                                     selectedDistance: viewModel.loadUnit(for: .distance) as! DistanceUnit,
                                     selectedPressure: viewModel.loadUnit(for: .pressure) as! PressureUnit,
                                     selectedPrecipitation: viewModel.loadUnit(for: .precipitation) as! PrecipitationUnit,
                                     defaultTemp: viewModel.loadUnit(for: .temperature) as! TemperatureUnit,
                                     defaultSpeed: viewModel.loadUnit(for: .speed) as! SpeedUnit,
                                     defaultDistance: viewModel.loadUnit(for: .distance) as! DistanceUnit,
                                     defaultPressure: viewModel.loadUnit(for: .pressure) as! PressureUnit,
                                     defaultPrecipitation: viewModel.loadUnit(for: .precipitation) as! PrecipitationUnit,
                                     onAppUnitChange : {(newValue, type) in
                            viewModel.setAppUnit(value: newValue, for: type)
                        })
                    case .timeFormat:
                        TimeFormatView(index: viewModel.timeFormat.index,
                                       defaultIndex: viewModel.timeFormat.index
                        ) { timeFormat in
                            viewModel.setValue(value: timeFormat, for: .timeFormat)
                        }
                        
                    case .appIcon:
                        AppIconView(selectedOption: viewModel.currentAppIcon,
                                    isSubscriptionViewPresented: isSubscriptionViewPresented) { selectedIndex in
                            viewModel.setAppIcon(index: selectedIndex)
                        }
                    case .appearance:
                        AppearanceView(index: viewModel.appearance.index) { appearance in
                            viewModel.setNewAppearance(appearance: appearance)
                        }
                    default:
                        EmptyView()
                    }
                }
                .background(Color(.secondarySystemBackground))
                
            }
        }
        .navigationTitle(Strings.SettingsTab.getTitle(for: viewModel.type))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private struct AppUnitsView: View {
        @State var selectedTemp: TemperatureUnit
        @State var selectedSpeed: SpeedUnit
        @State var selectedDistance: DistanceUnit
        @State var selectedPressure: PressureUnit
        @State var selectedPrecipitation: PrecipitationUnit
        
        var defaultTemp: TemperatureUnit
        var defaultSpeed: SpeedUnit
        var defaultDistance:  DistanceUnit
        var defaultPressure: PressureUnit
        var defaultPrecipitation: PrecipitationUnit
        
        var onAppUnitChange: ((AppUnitLogic, AppUnit) -> Void)?
        var body: some View {
            
            VStack(spacing: 12) {
                VStack {
                    HStack {
                        Image(Constants.Icons.getIconName(for: .dewPoint))
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Temperature", tableName: "SettingsTab").fonted(.body, weight: .medium)
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    
                    SegmentedPicker(
                        items: TemperatureUnit.allCases, titles: [
                            Text("Celsius", tableName: "SettingsTab"),
                            Text("Fahrenheit", tableName: "SettingsTab"),
                            Text("Kelvin", tableName: "SettingsTab")
                        ],
                        selected: $selectedTemp,
                        background: Color(.secondarySystemBackground),
                        selectedBackground: Color(.systemBackground)
                    )
                }
                .weatherTabShape(background: [Color(.systemBackground)])
                
                
                VStack {
                    HStack {
                        Image(Constants.Icons.getIconName(for: .wind))
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Constants.accentColor)
                            .frame(width: 24, height: 24)
                        Text("Wind Speed", tableName: "SettingsTab").fonted(.body, weight: .medium)
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    SegmentedPicker(items: SpeedUnit.allCases,
                                    titles: [
                                        Text("mph", tableName: "SettingsTab"),
                                        Text("km/h", tableName: "SettingsTab"),
                                        Text("m/s", tableName: "SettingsTab")
                                    ],
                                    selected: $selectedSpeed,
                                    background: Color(.secondarySystemBackground),
                                    selectedBackground: Color(.systemBackground))
                }
                .weatherTabShape(background: [Color(.systemBackground)])
                
                
                VStack {
                    HStack {
                        Image(Constants.Icons.getIconName(for: .visibility))
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Constants.accentColor)
                            .frame(width: 24, height: 24)
                        Text("Distance", tableName: "SettingsTab").fonted(.body, weight: .medium)
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    SegmentedPicker(items: DistanceUnit.allCases,titles: [
                        Text("km", tableName: "SettingsTab"),
                        Text("mi", tableName: "SettingsTab")
                    ],
                                    selected: $selectedDistance,
                                    background: Color(.secondarySystemBackground),
                                    selectedBackground: Color(.systemBackground))
                }
                .weatherTabShape(background: [Color(.systemBackground)])
                
                
                VStack {
                    HStack {
                        Image(Constants.Icons.getIconName(for: .pressure))
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Pressure", tableName: "WeatherDetails").fonted(.body, weight: .medium)
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    SegmentedPicker(items: PressureUnit.allCases,titles: [
                        Text("hPa", tableName: "SettingsTab"),
                        Text("mBar", tableName: "SettingsTab"),
                        Text("inHg", tableName: "SettingsTab"),
                        Text("mmHg", tableName: "SettingsTab")
                    ],
                                    selected: $selectedPressure,
                                    background: Color(.secondarySystemBackground),
                                    selectedBackground: Color(.systemBackground))
                }
                .weatherTabShape(background: [Color(.systemBackground)])
                
                
                VStack {
                    HStack {
                        Image(Constants.Icons.getIconName(for: .precipitation))
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Constants.accentColor)
                            .frame(width: 24, height: 24)
                        Text("Precipitation", tableName: "WeatherDetails").fonted(.body, weight: .medium)
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    SegmentedPicker(items: PrecipitationUnit.allCases,titles: [
                        Text("mm/h", tableName: "SettingsTab"),
                        Text("inph", tableName: "SettingsTab")
                    ],
                                    selected: $selectedPrecipitation,
                                    background: Color(.secondarySystemBackground),
                                    selectedBackground: Color(.systemBackground))
                }
                .weatherTabShape(background: [Color(.systemBackground)])
            }
            .onDisappear {
                onAppUnitChange?(selectedTemp, .temperature)
                onAppUnitChange?(selectedSpeed, .speed)
                onAppUnitChange?(selectedDistance, .distance)
                onAppUnitChange?(selectedPressure, .pressure)
                onAppUnitChange?(selectedPrecipitation, .precipitation)
            }
            .padding(.top, 12)
            .padding()
        }
    }
    
    struct DataSourcesView: View {
        
        @ObservedObject var viewModel: SingleSettingsViewModel
        @Binding var isPremium: Bool
        @Binding var isSubscriptionViewPresented: Bool
        var onWeatherChange: ((WeatherDataSource) -> Void)?
        var onAQIChange: ((AQIDataSource) -> Void)?
        
        var body: some View {
            
            List() {
                Section {
                    ForEach(viewModel.weatherDataSources, id: \.id) { dataSource in
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                AsyncImage(url: URL(string: dataSource.icon),
                                           content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                },placeholder: {
                                    ProgressView()
                                })
                                .accessibilityHidden(true)
                                .frame(width: 30, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 0.4).opacity(Constants.secondaryOpacity))
                                .padding(.vertical, 5)
                                .padding(.trailing, 18)
                                
                                Text(dataSource.title).fonted(.body, weight: .regular)
                            }
                            
                            Spacer()
                            
                            if dataSource == viewModel.currentWeatherDataSource {
                                Image(Constants.Icons.checked)
                                    .fonted(.body, weight: .semibold)
                                    .foregroundColor(.accentColor)
                                    .accessibilityLabel(Text("Selected", tableName: "General"))
                                //                                    .opacity(dataSource == viewModel.currentWeatherDataSource ? 1 : 0)
                            }
                            
                            if dataSource.premium && !isPremium {
                                Image(Constants.Icons.premium)
                                    .renderingMode(.template)
                                    .foregroundColor(.accentColor)
                                .accessibilityLabel(Text("datasource is locked, subscribe to premium to select", tableName: "Accessibility"))                            }
                        }
                        .contentShape(Rectangle())
                        .accessibilityElement(children: .combine)
                        .onTapGesture {
                            if dataSource.premium && !isPremium {
                                isSubscriptionViewPresented.toggle()
                            }else{
                                if (dataSource == viewModel.currentWeatherDataSource) {
                                    return;
                                }
                                viewModel.currentWeatherDataSource = dataSource
                                //                                onWeatherChange?(dataSource)
                            }
                        }
                    }
                    
                } header : {
                    Text("Weather Sources", tableName: "SettingsTab")
                }
                
                Section {
                    ForEach(viewModel.aqiDataSource, id: \.id) { aqiDataSource in
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                AsyncImage(url: URL(string: aqiDataSource.icon),
                                           content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                },placeholder: {
                                    ProgressView()
                                })
                                .accessibilityHidden(true)
                                .frame(width: 30, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 0.4).opacity(Constants.secondaryOpacity))
                                .padding(.vertical, 5)
                                .padding(.trailing, 18)
                                
                                Text(aqiDataSource.title).fonted(.body, weight: .regular)
                            }
                            
                            Spacer()
                            
                            if aqiDataSource == viewModel.currentAQIDataSource {
                                Image(Constants.Icons.checked)
                                    .fonted(.body, weight: .semibold)
                                    .foregroundColor(.accentColor)
                                    .accessibilityLabel(Text("Selected", tableName: "General"))
                                //                                    .opacity(aqiDataSource == viewModel.currentAQIDataSource ? 1 : 0)
                            }
                            
                            if aqiDataSource.premium && !isPremium {
                                Image(Constants.Icons.premium)
                                    .renderingMode(.template)
                                    .foregroundColor(.accentColor)
                                .accessibilityLabel(Text("datasource is locked, subscribe to premium to select", tableName: "Accessibility"))                            }
                        }
                        .contentShape(Rectangle())
                        .accessibilityElement(children: .combine)
                        .onTapGesture {
                            if aqiDataSource.premium && !isPremium {
                                isSubscriptionViewPresented.toggle()
                            }else{
                                if (aqiDataSource == viewModel.currentAQIDataSource) {
                                    return;
                                }
                                viewModel.currentAQIDataSource = aqiDataSource
                                //                                onAQIChange?(aqiDataSource)
                            }
                        }
                    }
                } header : {
                    Text("AQI Sources", tableName: "SettingsTab")
                }
                
            }
            .onAppear {
                viewModel.getDataSources()
            }
            .onDisappear {
                if !viewModel.currentAQIDataSource.selected {
                    onAQIChange?(viewModel.currentAQIDataSource)
                }
                if !viewModel.currentWeatherDataSource.selected {
                    onWeatherChange?(viewModel.currentWeatherDataSource)
                }
            }
        }
    }
    
    struct TimeFormatView: View {
        @State var index: Int
        var defaultIndex: Int
        var segmentItem : [SegmentItem] = [
            SegmentItem(title: Text(verbatim: "24h") , image: Constants.Icons.timeFormat24),
            SegmentItem(title: Text(verbatim: "12h") , image: Constants.Icons.timeFormat12)
        ]
        var onChange: ((TimeFormatType) -> Void)?
        var body: some View {
            CustomSegmentPicker(items: segmentItem, selectedIndex: index) { i in
                index = i
            }
            .onDisappear {
                if index != defaultIndex {
                    if index == 0 {
                        onChange?(.twentyFourHour)
                    } else {
                        onChange?(.twelveHour)
                    }
                }
            }
            .frame(height: 100)
            .padding()
        }
    }
    
    
    struct AppearanceView: View {
        @State var index: Int
        var segmentItems: [SegmentItem] = [
            SegmentItem(title: Text("Light", tableName: "General"), image: Constants.Icons.themeLight),
            SegmentItem(title: Text("Auto", tableName: "General"), image: Constants.Icons.themeAuto),
            SegmentItem(title: Text("Dark", tableName: "General"), image: Constants.Icons.themeDark)
        ]
        var onChange: ((AppAppearance) -> Void)?
        
        var body: some View {
            CustomSegmentPicker(items: segmentItems, selectedIndex: index) { i in
                onChange?(AppAppearance.getFromIndex(index: i))
            }
            .frame(height: 100)
            .padding()
        }
    }
    
    
    struct AppIconView: View {
        @State var selectedOption: Int
        @Binding var isSubscriptionViewPresented: Bool
        var onChange: ((Int) -> Void)?
        let iconWidth = Constants.screenWidth/4.5
        @EnvironmentObject var premium : Premium
        var body: some View {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: iconWidth)),
                GridItem(.adaptive(minimum: iconWidth)),
                GridItem(.adaptive(minimum: iconWidth))
            ]) {
                ForEach(0..<Constants.appIcons.count, id: \.self) { index in
                    VStack {
                        Image("AppIcon-\(index)-preview")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(16)
                            .accessibilityLabel("icon \(index)")
                            .onTapGesture {
                                if premium.isPremium || index == 0 {
                                    selectedOption = index
                                    onChange?(index)
                                }
                            }.isLocked(index != 0 && !premium.isPremium, cornerRadius: 16, isSubscriptionViewPresented: $isSubscriptionViewPresented)
                        
                        HStack {
                            Text("Selected", tableName: "General")
                                .foregroundColor(.accentColor)
                                .fonted(.callout, weight: .semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                            
                            Image(Constants.Icons.checked)
                                .fonted(.callout, weight: .semibold)
                                .foregroundColor(.accentColor)
                                .accessibilityHidden(true)
                        }
                        .opacity(selectedOption == index ? 1 : 0)
                        
                    }
                    .accessibilityElement(children: .combine)
                    .padding(8)
                    
                }
            }
            .padding(8)
            .dynamicTypeSize(...DynamicTypeSize.large)
        }
    }
    struct LanguageView: View {
        @State var currentLanguage: AppLanguage
        var onChange: ((AppLanguage) -> Void)?
        var body: some View {
            List(AppLanguage.allCases, id: \.id) { language in
                let code = language.rawValue
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(Locale(identifier: code).localizedString(forIdentifier: code)?.capitalized ?? "")
                            .fonted(.body, weight: .semibold)
                            .padding([.bottom],4)
                        Text(language.displayName)
                            .fonted(.footnote, weight: .regular)
                        
                    }
                    .padding([.leading],8)
                    Spacer()
                    if language == currentLanguage {
                        Image(systemName: Constants.SystemIcons.checkmark)
                            .foregroundColor(Constants.accentColor)
                            .fonted(.body, weight: .semibold)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    currentLanguage = language
                    onChange?(language)
                }
            }
        }
    }
    
    struct UserNotificationConfigView: View {
        @Environment(\.scenePhase) var scenePhase
        @StateObject var viewData = UserNotificationConfigViewData()

        var body: some View {
            if !viewData.isPermissionGranted {
                HStack {
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Spacer()
                    VStack {
                        Text ("For get you inform about every changes of weather conditions \nYou must grant permission to us to let you know about anything ")
                        if viewData.typeOfNotificationAuth == .denied {
                            Button {
                                if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=\(Constants.appBundleId)") {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            } label: {
                                Text("Go to settings for granting access")
                            }
                        }
                    }
                }
                .weatherTabShape()
                .padding()
            }
            ScrollView {
                ForEach(0..<viewData.categories.count, id: \.self) { i in
                    VStack (alignment: .leading) {
                        Text(viewData.categories[i])
                            .foregroundStyle(.secondary)
                            .padding(.leading, 16)
                        let filteredNotificationData = viewData.notificationData.filter { $0.category == viewData.categories[i] }
                        VStack (){
                            ForEach(filteredNotificationData.indices, id: \.self) { j in
                                if let item = $viewData.notificationData.first(where: {$0.type.wrappedValue == filteredNotificationData[j].type}) {
                                    SingleUserNotificationSettingRowView(notificationItem: item)
                                    .padding(.top, j == 0 ? 10 : 0)
                                    .padding(.bottom, j == filteredNotificationData.count - 1 ? 10 : 0)
                                    .padding(.leading, 16).padding(.trailing, 16)
                                    if j < filteredNotificationData.count - 1 {
                                        Divider()
                                            .padding(.leading)
                                    }
                                }
                            }
                        }
                        .weatherTabShape(horizontalPadding: false, verticalPadding: false)
                    }
                    .padding()
                }
            }
            .disabled(!viewData.isPermissionGranted)
            .onChange(of: scenePhase) { _ in
                viewData.reloadNotificationPermission()
            }
        }
            
    }
}

#if DEBUG
struct SingleSettingsView_Previews: PreviewProvider {
    static let rowType: SettingsRowType = .appearance
    static let premium = false
    static let premium1 = Premium()
    static var previews: some View {
        SingleSettingsView(viewModel: SingleSettingsViewModel(type: rowType, isPremium: false))
            .environmentObject(premium1)
    }
}
#endif
