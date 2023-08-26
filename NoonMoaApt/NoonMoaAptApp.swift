//  MC3_NoonMoaApp.swift
//  MC3_NoonMoa
//
//  Created by kimpepe on 2023/07/20.
//

import SwiftUI
import WeatherKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseMessaging
import AuthenticationServices
import FirebaseAuth
import AVFoundation


@main
struct NoonMoaAptApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    var viewRouter = ViewRouter()
    var midnightUpdater = MidnightUpdater()
    var weatherKitManager = WeatherKitManager()
    var locationManager = LocationManager()
    var environmentModel = EnvironmentModel()
    
    // Initialize a sample AttendanceRecord
    let attendanceRecord = AttendanceRecord(
        userId: UUID().uuidString,
        date: Date(),
        rawIsSmiling: false,
        rawIsBlinkingLeft: true,
        rawIsBlinkingRight: false,
        rawLookAtPoint: [0, 0, 0],
        rawFaceOrientation: [0, 0, 0],
        rawCharacterColor: [0, 0, 0],
        rawWeather: "clear",
        rawTime: Date(),
        rawSunriseTime: Date(),
        rawSunsetTime: Date()
    )
    
    
    var body: some Scene {
        WindowGroup {
//            ParticleView()
            MainView(aptModel: AptModel(),
                     attendanceModel: AttendanceModel(newAttendanceRecord: attendanceRecord),
                     characterModel: CharacterModel(),
                     environmentModel: EnvironmentModel(),
                     customViewModel: CustomViewModel(),
                     loginViewModel: LoginViewModel(viewRouter: ViewRouter()),
                     weatherKitManager: WeatherKitManager(),
                     locationManager: LocationManager()
            )
            .environmentObject(delegate.viewRouter)
            .environmentObject(midnightUpdater) // Pass to view here
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                delegate.handleSceneActive()
            case .inactive:
                delegate.handleSceneInactive()
            case .background:
                delegate.handleSceneBackground()
            @unknown default:
                delegate.handleSceneUnexpectedState()
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    let viewRouter = ViewRouter() // @Published var
    let gcmMessageIDKey = "gcm.message_id"
    var loginViewModel: LoginViewModel?
    var midnightUpdater: MidnightUpdater?
    var timer: Timer?
    var isAppActiveFirst: Bool = true  // handleSceneActive를 처음 실행하는지를 판단하는 불 변수
    var messagingToken: String?
    
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        setUpPushNotifications(application: application)
        
        // 자정이 되면 모든 user의 userState를 .sleep으로 변경
        midnightUpdater = MidnightUpdater()
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            if hour == 0 && minute == 0 {
                self.midnightUpdater?.updateAllUsersToSleep()
            }
        }
        return true
    }
    
    // Method to set up push notifications
    func setUpPushNotifications(application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        var pushNotiController = PushNotiController()
        pushNotiController.responsePushNotification()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 앱이 foreground일 때 실행
    func handleSceneActive() {
        print("AppDelegate: ScenePhase: active")
        
        if isAppActiveFirst {
            // 앱을 처음 켤 때에는 이 블록을 실행
            isAppActiveFirst = false
        } else {
            // When the app is active, update the user's state to .active
            if let user = Auth.auth().currentUser {
                firestoreManager.syncDB()
                let userRef = db.collection("User").document(user.uid)
                
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let userData = document.data(), let userState = userData["userState"] as? String {
                            print("AppDelegate | handleSceneActive | userState: \(userState)")
                            if userState == UserState.sleep.rawValue {
                                _ = 0
                            } else {
                                self.db.collection("User").document(user.uid).updateData([
                                    "userState": UserState.active.rawValue
                                ])
                            }
                        }
                    } else {
                        print("No user is signed in.")
                    }
                }
            }
        }
    }
    
    // 앱이 background일 때 실행
    func handleSceneBackground() {
        print("AppDelegate: ScenePhase: background")
        
        // When the app is in the background, update the user's state to .inactive
        if let user = Auth.auth().currentUser {
            firestoreManager.syncDB()
            let userRef = db.collection("User").document(user.uid)
            
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let userData = document.data(), let userState = userData["userState"] as? String {
                        if userState == UserState.sleep.rawValue {
                            _ = 0
                        } else {
                            self.db.collection("User").document(user.uid).updateData([
                                "userState": UserState.inactive.rawValue
                            ])
                        }
                    }
                } else {
                    print("No user is signed in.")
                }
            }
        }
    }
    
    func handleSceneInactive() {
        print("AppDelegate: ScenePhase: inactive")
    }
    
    func handleSceneUnexpectedState() {
        print("AppDelegate: ScenePhase: unexpected state")
        // ... do something when in unexpected state
    }
    
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messagingToken = fcmToken
        print("Firebase registration token: \(fcmToken ?? "")")
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 1. foreground 상태일 때: remote 혹은 local 알림이 도착했을 때, 알림을 띄우기 전에 이 메서드를 실행
    // 2. background 상태일 때: remote 알림이 도착했을 때, "알림을 띄우기 전"에 이 메서드를 실행
    // 여기에서는 알림을 받아서, print문을 출력, completionHandler로 알림 배너 띄우기
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // - remote, local 알림을 "눌렀을 때" 실행하는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
}
