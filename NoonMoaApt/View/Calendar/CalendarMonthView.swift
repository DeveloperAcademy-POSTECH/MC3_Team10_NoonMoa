//
//  CustomDatePicker.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/08/26.
//
//TODO: 날짜 대소비교 수정하기, 정확한 날짜를 기준으로

import SwiftUI

struct CalendarMonthView: View {
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
                            withAnimation {
                                currentMonth -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("\(extraDate()[0])년")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text(extraDate()[1])
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                currentMonth += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(.black)
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
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    .foregroundColor(isToday ? .black : comparisonResult == .orderedAscending ? .calendarGray : .calendarGray)
                Text("\(value.day)")
                    .font(.title3)
                    .bold(isToday ? true : comparisonResult == .orderedAscending ? false : false)
                
                    .foregroundColor(isToday ? .black : comparisonResult == .orderedAscending ? .calendarGray : .calendarGray)
                
                
                //만약 해당날짜에 attendance가 찍혀있다면_으로 로직 변경
                if Calendar.current.isDateInToday(value.date) {
                    Circle()
                        .background(LinearGradient.sky.clearNight)
                        .foregroundColor(.clear)
                        .clipShape(Circle())
                    
                    Image.assets.stampSmall.clearNight
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color.stampBorder.clearNight)
                    EyeView(isSmiling: true, isBlinkingLeft: true, isBlinkingRight: false, lookAtPoint: SIMD3(0,0,0), faceOrientation: SIMD3(0,0,0), bodyColor: LinearGradient.userCyan, eyeColor: LinearGradient.eyeCyan, cheekColor: LinearGradient.cheekRed, isInactiveOrSleep: false, isJumping: false)
                }
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
            
            StampLargeView(skyColor: LinearGradient.sky.clearSunset, skyImage: Image.assets.stampLarge.clearSunset, isSmiling: true, isBlinkingLeft: true, isBlinkingRight: false, lookAtPoint: SIMD3(0,0,0), faceOrientation: SIMD3(0,0,0), bodyColor: LinearGradient.userCyan, eyeColor: LinearGradient.eyeCyan, cheekColor: LinearGradient.cheekRed)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7)
                .padding(.vertical)
            
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

struct CalendarMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthView()
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

struct CustomBlurView: UIViewRepresentable {
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
