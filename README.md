Sustainable EV Journey Planner 🚗⚡🌱


A comprehensive Flutter mobile application that helps electric vehicle owners plan sustainable journeys by finding eco-friendly charging stations and battery swapping services along their route, while tracking environmental impact aligned with UN Sustainable Development Goals.
🌟 Key Features

🚗 Multi-Vehicle Support

Support for 13+ electric vehicle types including Tesla, Nissan Leaf, BMW i3, NIO models, and more
Compatibility checking for charging connectors and battery swapping services
Optimized recommendations based on vehicle specifications

⚡ Dual Service Types

Charging Stations: Fast charging with CCS, CHAdeMO, Tesla Supercharger, and Type 2 connectors
Battery Swapping: Quick battery replacement services (NIO Power Swap, Gogoro GoStation)
Flexible service type selection (Both, Charging Only, Battery Swapping Only)

🌍 Sustainability Focus

UN SDG Integration: Aligned with SDG 7 (Clean Energy), SDG 11 (Sustainable Cities), and SDG 13 (Climate Action)
Renewable Energy Priority: Filter stations powered by solar, wind, and other clean energy sources
Environmental Impact Tracking: Real-time CO₂ reduction and renewable energy usage metrics

📊 Smart Prioritization

Fastest Service: Minimize charging/swapping time
Shortest Detour: Optimize route efficiency
Greenest Energy: Prioritize renewable-powered stations
Community Impact: Support stations with local community benefits
Price & Quality: Balance cost and user ratings

🎯 SDG Impact Tracker

Track CO₂ emissions saved (kg)
Monitor renewable energy usage (kWh)
Count sustainable trips completed
Visual impact dashboard with real-time metrics

🛠️ Technology Stack

Framework: Flutter 3.x
Language: Dart
AI Integration: Google Gemini API for intelligent station recommendations
HTTP Client: http package for API communications
State Management: StatefulWidget with local state management
UI Components: Material Design with custom sustainability-themed widgets

🚀 Getting Started
Prerequisites

Flutter SDK 3.0+
Dart SDK 2.17+
Android Studio / VS Code
Google Gemini API key

Installation

Clone the repository
bashgit clone https://github.com/1abhijiths/Infosys-EV-Hackathon-PROJECT
cd sustainable-ev-journey-planner

Install dependencies
bashflutter pub get

Configure API Key

Open lib/main.dart (or your main file)
Replace 'YOUR_API_KEY_HERE' with your actual Gemini API key

dartstatic const String _apiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';

Run the app
bashflutter run


📱 App Screenshots
Main Features

Trip Planning Interface: Clean, intuitive form for route input
Vehicle Selection: Comprehensive dropdown with 13+ EV models
SDG Dashboard: Real-time environmental impact tracking
Station Cards: Detailed information with sustainability metrics
Renewable Energy Badges: Visual indicators for clean energy stations

SDG Mode Features

Toggle between standard and SDG-focused interface
UN SDG badges (SDG 7, 11, 13) with visual indicators
Environmental impact cards with CO₂ savings
Community benefit information for each station

🌱 Sustainability Features
Environmental Impact

CO₂ Reduction Tracking: Calculate and display carbon footprint reduction
Renewable Energy Metrics: Track clean energy usage across trips
Sustainable Trip Counter: Gamification element to encourage eco-friendly travel

Community Benefits

Local Job Creation: Highlight stations supporting local employment
Educational Programs: Identify stations with sustainability education initiatives
Community Partnerships: Show stations with local business collaborations

Green Energy Integration

Solar Powered Stations: Prioritize solar-powered charging infrastructure
Wind Energy: Include wind-powered charging networks
Mixed Renewable: Support for hybrid renewable energy sources

🔧 Technical Implementation
Architecture

Single Page Application: Centralized state management
API Integration: RESTful communication with Gemini AI
Error Handling: Comprehensive error management and user feedback
Responsive UI: Adaptive layout for different screen sizes

Data Models

ChargingStation Class: Comprehensive station information model
JSON Serialization: Robust data parsing from API responses
Compatibility Logic: Smart vehicle-station matching algorithms

Performance Optimization

Lazy Loading: Efficient widget rendering
State Management: Optimized setState usage
Network Optimization: Efficient API calls with error handling

🤝 Contributing
We welcome contributions! Please follow these steps:

Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

Development Guidelines

Follow Flutter/Dart best practices
Maintain code documentation
Test on multiple devices
Ensure SDG alignment for new features

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
🌟 Future Enhancements

 Real-time station availability
 Route optimization algorithms
 Multi-language support
 Offline map integration
 User authentication and trip history
 Social features and community sharing
 Integration with more EV manufacturers
 Advanced analytics and reporting


This app supports the UN Sustainable Development Goals:

SDG 7: Affordable and Clean Energy
SDG 11: Sustainable Cities and Communities
SDG 13: Climate Action

