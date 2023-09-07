//
//  NicknameViewModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/09/07.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class NicknameViewModel: ObservableObject {
    
    @Published var newNickname: String = ""
    
    // firebase 싱글톤
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    struct NicknameFront {
        static let list = [f001, f002, f003, f004, f005, f006, f007, f008, f009, f010, f011, f012, f013, f014, f015, f016, f017, f018, f019, f020, f021, f022, f023, f024, f025, f026, f027, f028, f029, f030, f031, f032, f033, f034, f035, f036, f037, f038, f039, f040, f041, f042, f043, f044, f045, f046, f047, f048, f049, f050]
        static let f001 = "진지한"
        static let f002 = "근엄한"
        static let f003 = "고요한"
        static let f004 = "행복한"
        static let f005 = "차분한"
        static let f006 = "신기한"
        static let f007 = "궁금한"
        static let f008 = "도도한"
        static let f009 = "유쾌한"
        static let f010 = "활기찬"
        static let f011 = "환한"
        static let f012 = "감사한"
        static let f013 = "훌륭한"
        static let f014 = "멋진"
        static let f015 = "훈훈한"
        static let f016 = "소중한"
        static let f017 = "친절한"
        static let f018 = "즐거운"
        static let f019 = "따뜻한"
        static let f020 = "강력한"
        static let f021 = "우아한"
        static let f022 = "확고한"
        static let f023 = "유능한"
        static let f024 = "활발한"
        static let f025 = "희망찬"
        static let f026 = "무한한"
        static let f027 = "솔직한"
        static let f028 = "놀라운"
        static let f029 = "웃는"
        static let f030 = "은은한"
        static let f031 = "화려한"
        static let f032 = "소박한"
        static let f033 = "침착한"
        static let f034 = "성실한"
        static let f035 = "대단한"
        static let f036 = "정직한"
        static let f037 = "진실한"
        static let f038 = "명랑한"
        static let f039 = "귀중한"
        static let f040 = "현명한"
        static let f041 = "유연한"
        static let f042 = "멋진"
        static let f043 = "건강한"
        static let f044 = "관대한"
        static let f045 = "튼튼한"
        static let f046 = "성숙한"
        static let f047 = "쾌활한"
        static let f048 = "유순한"
        static let f049 = "세심한"
        static let f050 = "신선한"
    }
    
    struct NicknameBack {
        static let list = [b001, b002, b003, b004, b005, b006, b007, b008, b009, b010, b011, b012, b013, b014, b015, b016, b017, b018, b019, b020, b021, b022, b023, b024, b025, b026, b027, b028, b029, b030, b031, b032, b033, b034, b035, b036, b037, b038, b039, b040, b041, b042, b043, b044, b045, b046, b047, b048, b049, b050]
        static let b001 = "오렌지"
        static let b002 = "메론"
        static let b003 = "두리안"
        static let b004 = "파파야"
        static let b005 = "구아바"
        static let b006 = "복숭아"
        static let b007 = "청포도"
        static let b008 = "적포도"
        static let b009 = "코코넛"
        static let b010 = "사과"
        static let b011 = "포도"
        static let b012 = "석류"
        static let b013 = "자두"
        static let b014 = "앵두"
        static let b015 = "체리"
        static let b016 = "라임"
        static let b017 = "레몬"
        static let b018 = "자몽"
        static let b019 = "망고"
        static let b020 = "키위"
        static let b021 = "딸기"
        static let b022 = "참외"
        static let b023 = "감자"
        static let b024 = "당근"
        static let b025 = "고구마"
        static let b026 = "피망"
        static let b027 = "호박"
        static let b028 = "상추"
        static let b029 = "단호박"
        static let b030 = "애호박"
        static let b031 = "호박"
        static let b032 = "연근"
        static let b033 = "시금치"
        static let b034 = "토마토"
        static let b035 = "미나리"
        static let b036 = "열무"
        static let b037 = "피망"
        static let b038 = "무우"
        static let b039 = "양배추"
        static let b040 = "콩나물"
        static let b041 = "쪽파"
        static let b042 = "쑥갓"
        static let b043 = "청경채"
        static let b044 = "근대"
        static let b045 = "배추"
        static let b046 = "완두콩"
        static let b047 = "강낭콩"
        static let b048 = "옥수수"
        static let b049 = "생강"
        static let b050 = "마늘"
    }
    
    
    func randomNick() -> String {
        return String((NicknameFront.list.randomElement() ?? "") + " " + (NicknameBack.list.randomElement() ?? ""))
    }
    
    func uploadNickname(newNickname: String) -> Void {
        guard let currentUser = Auth.auth().currentUser else { return }

        let userDocRef = db.collection("User").document(currentUser.uid)
        print("NicknameViewModel | uploadNickname | currentUser.uid: \(currentUser.uid)")
        print("NicknameViewModel | uploadNickname | newNickname: \(newNickname)")
        
        userDocRef.updateData([
            "nickname": newNickname
        ]) { error in
            if let error = error {
                print("uploadNickname 실패: \(error)")
            } else {
                    print("uploadNickname 성공: \(newNickname)")
            }
        }
    }
    
    func isNicknameAvailable(_ nickname: String, completion: @escaping (Bool) -> Void) {
        let nicknameRef = db.collection("User").whereField("nickname", isEqualTo: nickname)
        
        nicknameRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error checking nickname availability: \(err)")
                completion(false)
            } else {
                completion(querySnapshot?.documents.isEmpty ?? false)
            }
        }
    }


}
