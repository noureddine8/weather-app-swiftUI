# 🌤️ Weatherly – iOS Weather App

**Weatherly** is a simple iOS weather application that displays real-time temperature data using the [Open-Meteo API](https://open-meteo.com/). Built with Swift and SwiftUI, it features a clean, modular architecture and a fully custom networking layer leveraging modern Swift concurrency.

---

## 🔍 Overview

This app focuses on:

- Clean separation of concerns using protocol-oriented programming
- A reusable and extendable networking stack
- Swift Concurrency (`async/await`) for async networking
- Robust error handling and validation
- Real-time temperature fetching using a public weather API

---

## 📦 Features

- Fetches current temperature based on coordinates
- Implements an abstracted network layer to handle all HTTP communication
- Clean error management with localized descriptions for debugging or user messaging
- Easily extensible to support more endpoints or APIs in the future

---

## 🛠️ Networking Architecture

### HTTP Method Abstraction

The app defines a custom enumeration to represent HTTP methods such as GET, POST, PUT, DELETE, and PATCH for type safety and clarity in API request construction.

### Unified Error Handling

A comprehensive error enum is used to manage various failure cases during the networking process. This includes invalid URLs, decoding issues, network timeouts, HTTP errors with status codes, and more—each with human-readable descriptions.

### Request Abstraction

The app defines a protocol to abstract individual API requests. This allows each request to specify its own path, method, headers, query items, and body data. Default implementations are provided for common properties like base URL and headers.

### Network Client

A protocol-driven network client is implemented using `URLSession`. It handles:

- Constructing requests from the defined protocols
- Performing network calls asynchronously
- Validating HTTP responses and status codes
- Decoding JSON responses into Swift models
- Mapping URLSession errors to custom error types

The client also integrates with a debugging tool (`ResponseDetective`) to log all requests and responses during development.

---

## 🌦️ Weather Service

A dedicated service layer abstracts the networking logic from the UI. It uses the network client to perform a specific weather forecast request, parsing the current temperature data and exposing it to the app’s views.

---

## 💡 Architecture & Design

- **Protocol-Oriented:** Each major component (request, client, service) is designed around protocols for flexibility and testability.
- **Dependency Injection:** The weather service is initialized with a concrete implementation of the network client, making it easily testable or mockable.
- **ObservableObject + SwiftUI:** The weather service is injected into SwiftUI views using `@EnvironmentObject` for reactive UI updates.

---

## 📚 Dependencies

- [Open-Meteo API](https://open-meteo.com/) – for weather data
- [ResponseDetective](https://github.com/netguru/ResponseDetective) *(optional)* – for network debugging during development
