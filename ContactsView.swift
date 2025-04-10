//
//  ContactsView.swift
//  ZesulE
//
//  Created by 시모니 on 4/7/25.
//

import SwiftUI

struct ContactsView: View {
    
    let contacts = [
        ("강남구청", "02-3423-5114"),
        ("강동구청", "02-1577-1188"),
        ("강서구청", "02-2600-6114"),
        ("강북구청", "02-901-6114"),
        ("관악구청", "02-879-5000"),
        ("광진구청", "02-450-1114"),
        ("구로구청", "02-860-2114"),
        ("금천구청", "02-2627-2114"),
        ("노원구청", "02-2116-3114"),
        ("동대문구청", "02-2127-5000"),
        ("도봉구청", "02-2091-2120"),
        ("동작구청", "02-820-1114"),
        ("마포구청", "02-3153-8114"),
        ("서대문구청", "02-330-1114"),
        ("성동구청", "02-2286-5114"),
        ("성북구청", "02-2241-3114"),
        ("서초구청", "02-2155-6114"),
        ("송파구청", "02-2147-2000"),
        ("영등포구청", "02-2670-3114"),
        ("용산구청", "02-2199-6114"),
        ("양천구청", "02-2620-3114"),
        ("은평구청", "02-351-6114"),
        ("종로구청", "02-2148-1114"),
        ("중구청", "02-3396-4114"),
        ("중랑구청", "02-2094-0114")
    ]
    
    var body: some View {
        VStack() {
            Text("관리구 연락처")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            List {
                ForEach(contacts , id: \.0) { contact in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(contact.0)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(contact.1)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
}
