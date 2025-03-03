# Skipad

## Overview
**Skipad** is a multi-component platform for managing skippable video advertisements. It automates the "Skip Ad" feature common in streaming services, allowing video ads to be skipped after a set duration while still tracking user engagement and preserving monetization. The project includes a web interface, background automation services, and logging/analytics components to provide a full-stack solution for handling skippable ads.

## Installation
1. **Clone the Repository** – Download or clone the `inqwise/skipad` repository to your local machine.
2. **Open the Solution** – The codebase is organized as a Visual Studio solution (e.g. `Skipad.sln`). Open this solution in Visual Studio. Ensure you have the required .NET framework or SDK installed.
3. **Restore Dependencies** – Restore NuGet packages for all projects via **Build > Restore NuGet Packages** in Visual Studio.
4. **Configure Settings** – Update necessary configuration files such as `Web.config` or `appsettings.json`.
5. **Build and Run** – Build the solution and start the **Skipad.Web** project using IIS Express or another web server.

## Usage
Once the Skipad platform is running:
- **Ad Playback with Skip**: Integrate Skipad with your video player. The Skipad system will play the advertisement and display a "Skip Ad" button after a designated time.
- **Skipping Ads**: Clicking the skip button or waiting for the skip timer to elapse triggers the system to terminate the ad playback and resume main content.
- **Tracking & Analytics**: Skip events and ad engagement data are collected for analysis.

The Skipad web interface can be used to test the functionality, and integration can be done through its API or script embedding.

## Components
The Skipad repository consists of several modules:
- **Skipad.Web** – The main web application providing the user interface and API.
- **Skipad.Automation** – Background services for ad delivery and skip event processing.
- **Skipad.Common** – Shared utilities and data models.
- **skipad-collector** – Collects ad engagement data for analytics.
- **skipad-infrastructure** – Deployment scripts and infrastructure configuration.
- **skipad-log-appenders** – Logging components for integration with monitoring tools.
- **skipad-system-templates** – Template files for system configuration and setup.

Each component works together to provide a robust, skippable ad experience. For production, all necessary services should be deployed and configured accordingly.

---
This README provides a high-level overview of the project. For more detailed configuration or advanced usage, refer to the source code and internal documentation.

