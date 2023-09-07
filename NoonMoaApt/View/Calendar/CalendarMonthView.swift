//
//  CustomDatePicker.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/08/26.
//
//TODO: 날짜 대소비교 수정하기, 정확한 날짜를 기준으로

import SwiftUI

struct CalendarMonthView: View {
    @EnvironmentObject var characterViewModel: CharacterViewModel
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @State private var currentDate: Date = Date()
    @State private var currentMonth: Int = 0
    @State private var isDayClicked: Bool = false
    @State private var selectedDate: DateValue = DateValue(day: 0, date: Date())
    
    var body: some View {
        ZStack {
            CustomBlurView(effect: .systemUltraThinMaterialLight) { view in }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            if !isDayClicked {
                VStack {
                    let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
                    
                    //연도와 월 View
                    HStack(spacing: 20) {
                        Button {
                                currentMonth -= 1
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding(.trailing, 16)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("\(extraDate()[0])년")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text(extraDate()[1])
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer(minLength: 0)

                        Button {
                                currentMonth += 1
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding(.leading, 16)
                        }
                    }
                    .padding(.top, 16)
                    .onTapGesture {
                        currentMonth = 0
                    }
                    
                    Rectangle()
                        .foregroundColor(.calendarGray)
                        .frame(height: 1)
                    
                    //요일 View
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.calendarGray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    //Lazy Grid
                    let columns = Array(repeating: GridItem(.flexible()), count: 7)
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(extractDate()) { value in
                            ZStack {
                                CardView(value: value)
                                    .onTapGesture {
                                        selectedDate = value
                                        isDayClicked = true
                                    }
                            }
                        }
                    }
                    .onChange(of: currentMonth) { newValue in
                        currentDate = getCurrentMonth()
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
            } else {
                DayView(value: selectedDate)
            }
        }//ZStack
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        ZStack {
            
            if value.day != -1 {
                let isToday = Calendar.current.isDateInToday(value.date)
                let comparisonResult = Calendar.current.compare(value.date, to: Date(), toGranularity: .day)
                
                Circle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    .frame(width: 36, height: 36)
                    .foregroundColor(isToday ? .black : comparisonResult == .orderedAscending ? .calendarGray : .calendarGray)
                Text("\(value.day)")
                    .font(.title3)
                    .bold(isToday ? true : comparisonResult == .orderedAscending ? false : false)
                
                    .foregroundColor(isToday ? .black : comparisonResult == .orderedAscending ? .calendarGray : .calendarGray)
                
                
                //TODO: 만약 attendance Records의 키값인 날짜에서 value에 해당하는 날짜가 있다면 그 날짜에 들어있는 스탬프 정보를 받아와서 그려야함.
                //TODO: CharacterModel과 EnvironmentModel, CustomViewModel에 있는 함수인 fetch 함수를 실행시키고, 각 모델의 recorded변수에 접근하면 뷰를 그릴 수 있다.
                StampButtonView(skyColor: environmentViewModel.recordedEnvironmentViewData.colorOfSky, skyImage: environmentViewModel.recordedEnvironmentViewData.stampSmallSkyImage, isSmiling: characterViewModel.recordedCharacterViewData.isSmiling, isBlinkingLeft: characterViewModel.recordedCharacterViewData.isBlinkingLeft, isBlinkingRight: characterViewModel.recordedCharacterViewData.isBlinkingRight, lookAtPoint: characterViewModel.recordedCharacterViewData.lookAtPoint, faceOrientation: characterViewModel.recordedCharacterViewData.faceOrientation, bodyColor: characterViewModel.recordedCharacterViewData.bodyColor, eyeColor: characterViewModel.recordedCharacterViewData.eyeColor, cheekColor: characterViewModel.recordedCharacterViewData.cheekColor, borderColor: environmentViewModel.recordedEnvironmentViewData.stampBorderColor)
            }
        }
    }
    
    @ViewBuilder
    func DayView(value: DateValue) -> some View {
        VStack {
            HStack {
                
                Button {
                    isDayClicked = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.trailing, 16)
                }
                
                Text(String(Calendar.current.component(.year, from: value.date)) + "년")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(String(Calendar.current.component(.month, from: value.date)) + "월")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("\(value.day)" + "일")
                    .font(.title)
                    .fontWeight(.semibold)
                
               Spacer()
            }
            .padding(.top, 16)
            
            Rectangle()
                .foregroundColor(.calendarGray)
                .frame(height: 1)
            
            //TODO: attendance record에서 value에 해당하는 날짜를 찾은다음에, StampLargeView에 값을 뿌려서 그려야함.
    
            
            Spacer()
                
        }
        .padding(.horizontal)
    }
            
    
    func extraDate() -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        formatter.locale = Locale(identifier: "ko_KR")
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date  {
        let calendar = Calendar.current
        //현재 달의 요일을 받아옴
        guard let currentMonth = calendar.date(byAdding: .month, value:  self.currentMonth,to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        //현재 달의 요일을 받아옴
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        var range = calendar.range(of: .day, in: .month, for: startDate)!
        range.removeLast()
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
            
        }
    }
}

private struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> ()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}

struct CalendarMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthView()
    }
}
