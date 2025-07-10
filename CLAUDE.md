# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"The One Thing" is a SwiftUI productivity app designed to help users reclaim focus through a minimalist, single-tasking approach. The app enforces a strict "one-at-a-time" methodology where users maintain a task queue but can only see and work on their single chosen "One Thing" at a time. All other tasks are hidden until the current one is complete, creating a digital environment of pure focus.

**Target Audience**: Overwhelmed professionals, students, creative freelancers, and individuals with ADHD or focus challenges who need structured, simple tools to manage attention.

**Design Goal**: Win an Apple Design Award for excellence in Delight and Interaction, UI/UX Design, and Innovation.

## Development Commands

### Building and Testing
```bash
# Build the project
xcodebuild -project "The One Thing.xcodeproj" -scheme "The One Thing" build

# Run all tests
xcodebuild -project "The One Thing.xcodeproj" -scheme "The One Thing" test

# Run tests for specific platform
xcodebuild -project "The One Thing.xcodeproj" -scheme "The One Thing" -destination "platform=iOS Simulator,name=iPhone 15 Pro" test

# Build widget extension
xcodebuild -project "The One Thing.xcodeproj" -scheme "WidgetsExtension" build
```

## Core Principles (Must Guide Every Decision)

1. **One Task at a Time**: UI must enforce this - when a task is active, it's the only one visible in Focus view
2. **The Most Important Thing**: App language and flow should encourage conscious selection of most impactful task
3. **Eliminate All Distractions**: Until "One Thing" is done, everything else is hidden - UI must be minimal and serene
4. **Delight in Simplicity**: KISS principle - every animation, sound, and haptic feedback should add calm and satisfaction

## Architecture

### Technology Stack
- **SwiftUI**: 100% SwiftUI across all Apple platforms (iOS 17+, iPadOS 17+, macOS 14+, watchOS 10+, visionOS 1.0+)
- **SwiftData**: On-device persistence with CloudKit sync
- **Observation Framework**: Reactive state management
- **WidgetKit**: Home/Lock screen widgets and Live Activities

### MVP v1.0 Features

#### 1. Onboarding
- 3-4 screen flow explaining core philosophy
- **Morphing animations** between screens with UI elements smoothly transforming
- Conclude with call-to-action to add first task

#### 2. Task Management ("The Queue")
- Simple task addition to the Queue
- Clean vertical list view (separate from Focus view)
- **Drag-and-drop prioritization** - top task is implicitly next "One Thing"
- Tapping top task transitions to Focus Mode and hides rest of list

#### 3. Focus Mode (Core Feature)
- **Full-screen view** displaying only current "One Thing" text
- No other tasks, lists, or distracting UI elements visible
- **Integrated Pomodoro timer** displayed cleanly within view
- **Task completion** with satisfying action (long press, checkmark animation)
- Graceful return to Queue to select next "One Thing"

#### 4. Pomodoro Timer
- Integrated directly into Focus Mode
- Standard settings: 25min focus, 5min short break, 15min long break
- Customizable durations in settings
- Non-intrusive notifications for session/break endings
- Elegant, simple controls (start, pause, stop)

#### 5. Widgets & Live Activities
- **Lock Screen Widget**: Simple display of current "One Thing"
- **Home Screen Widget**: Small (task text) and Medium (task + timer progress) sizes
- **Live Activity**: During timer, shows task and countdown on Lock Screen and Dynamic Island

#### 6. Cross-Platform Sync
- **iPhone/iPad**: Core mobile experience
- **Mac**: Native app with menu bar item always showing current "One Thing"
- **Apple Watch**: View Queue, select "One Thing", control timer, complications for watch face
- **Vision Pro**: Dedicated Focus Mode window in spatial environment with 3D timer elements

### Design Requirements

#### Aesthetics
- **Color Palette**: Simple, muted, calm tones supporting focus (light/dark mode)
- **Typography**: Clean, legible using San Francisco font family
- **Visual Effects**: Modern SwiftUI Materials (thin, thick, ultra-thin) and Vibrancy for "glassy" feel

#### Interaction & Delight
- **Animations**: Fluid, purposeful transitions especially morphing onboarding and Queue→Focus transitions
- **Haptics**: Tactile feedback for task completion, timer start
- **Sound**: Subtle, custom, rewarding sound effects for key actions

#### Simplicity
- Ruthlessly edited features - if not essential to core loop, not in v1.0
- Minimal settings - app works beautifully out of the box

### Current State
The codebase contains SwiftUI template code. The `Item` model and `ContentView` are placeholders that need replacement with the actual task management system described in PRD.md.

### SwiftData Configuration
App uses shared `ModelContainer` in `The_One_ThingApp.swift` with persistent storage and CloudKit sync capability. Test configurations use in-memory storage via `.modelContainer(for: Item.self, inMemory: true)`.

### Success Metrics
- **Engagement**: DAU/MAU, "One Things" completed per day, Pomodoro sessions per day
- **Retention**: Day 1, 7, 30 retention rates
- **Qualitative**: 4.8+ App Store rating, Apple Design Award nomination