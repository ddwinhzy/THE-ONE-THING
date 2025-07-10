//
//  AppIntent.swift
//  Widgets
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import WidgetKit
import AppIntents

struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource { "Open The One Thing" }
    static var description: IntentDescription { "Open The One Thing app" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
