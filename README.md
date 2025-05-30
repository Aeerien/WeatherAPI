# ☀️ WeatherAPI

WeatherAPI is an iOS application written in Swift that displays current weather, hourly forecasts,
and daily forecasts. The project is built using the MVVM architecture and leverages `Core Location`
to detect the user's current location. It is modular, scalable, and includes error handling,
location services, and reusable UI components.

---

## 🚀 Key Features

- Display of current weather, hourly and daily forecasts
- Determine user location via `Core Location`
- Fetch weather data using `WeatherService`
- Manage data through `WeatherViewModel`
- Interactive UI with multiple forecast views
- Launch screen implemented using Storyboard
- Error handling via `WeatherServiceError`

---

## 📁 Project Structure

```
WeatherAPI/
│
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── Models/
│   └── WeatherModels.swift
│
├── Resources/
│   ├── Assets.xcassets
│   ├── Info.plist
│   └── LaunchScreen.storyboard
│
├── Services/
│   ├── LocationManager.swift
│   ├── WeatherService.swift
│   └── WeatherServiceError.swift
│
├── ViewModels/
│   └── WeatherViewModel.swift
│
├── Views/
│   ├── DailyForecast/
│   │   ├── DailyForecastView.swift
│   │   └── DayCell.swift
│   ├── HourlyForecast/
│   │   ├── HourCell.swift
│   │   └── HourlyForecastView.swift
│   ├── CurrentWeatherView.swift
│   └── WeatherViewController.swift
```

---

## 🛠 Technologies Used

- Swift 5
- UIKit
- Core Location
- MVVM Architecture
- URLSession
- REST API
- Storyboard

---

## 📦 Getting Started

1. Clone the repository:

```bash
git clone https://github.com/Aeerien/WeatherAPI.git
```

2. Open the project:

```bash
open WeatherAPI.xcodeproj
```

3. Build and run in Xcode 14.0+ on a simulator or physical device.

---

## 📸 Screenshots

```markdown
![Current Weather](docs/screenshots/current_weather.png)
![Hourly Forecast](docs/screenshots/hourly_forecast.png)
```
