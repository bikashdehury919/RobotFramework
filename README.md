# Robot Framework
Sample Test automation framework in Robot framework and python

This is a **highly extensible test automation framework** built on top of [Robot Framework](https://robotframework.org/), designed for:

- ✅ **End-to-End Functional Automation**
- 🧱 Modular, data-driven architecture
- 🛠️ Extensible with **custom Python libraries**
- 🌐 Support for **Web**, **API**, **Desktop**, **Mainframe**, and **OS-level tasks**
- 🔄 **Parallel test execution with Pabot**
- 🔁 **Retry on failure** for flaky tests
- 📡 Easy **CI/CD** and **Allure** integration
- 📋 Compatible with test management tools like **TestRail**, **qTestManager**, **Xray**

## 📁 Project Structure

```bash
project-root/
│
├── Configuration/               # Global configs (YAML)
│   └── config.yaml
│   └── config.robot
│
├── CustomLibraries/             # Custom Python libraries (OpenCV, Pandas, etc.)
│   └── CustomLibrary.py
│
├── Locators/                    # Page locators (element paths)
│   └── LoginPage.robot
│
├── ReusableKeyword/            # Common reusable test logic
│   ├── UI_keywords.robot
│   ├── api_keywords.robot
│   └── common_keywords.
│   └── ....
│
├── Tests/
│   ├── UI/                      # UI test cases
│   ├── API/                     # API test cases
│   ├── DB/                      # DB validation tests
│   ├── .......                  
│
├── Utils/                      # Integration with Test managment tools
├── Reports/                    # Test logs, screenshots, results
│
└── requirements.txt             # Python dependency list
```

## 🧠 Capabilities

| Feature                     | Description                                                       |
|-----------------------------|-------------------------------------------------------------------|
| ✅ Web Automation            | Using **SeleniumLibrary** for browser-based testing              |
| ✅ API Automation            | Using **RequestsLibrary** with dynamic token/session handling    |
| ✅ Database Validation       | Using **DatabaseLibrary** (MySQL, MSSQL, Oracle, etc.)           |
| ✅ Desktop App Automation    | Extendable via **AutoIt**, **Pywinauto**, **WinAppDriver**, etc. |
| ✅ Mainframe Automation      | Support via terminal emulators (e.g., **py3270**, **TN3270**)     |
| ✅ OS Process Validation     | Shell/PowerShell process execution and validation                 |
| ✅ Custom Image Comparison   | Using **OpenCV** for UI-based image validation                    |
| ✅ Parallel Execution        | Using **Pabot** for parallel and faster test execution           |
| ✅ Retry Mechanism           | Automatic retries for flaky tests using **RetryKeyword** or plugins |
| ✅ Dynamic Variables         | Runtime configurable variables for flexible test execution       |
| ✅ Logging & Screenshots     | Enhanced logging with auto screenshots on failures               |
| ✅ CI/CD Integration         | Supports **Jenkins**, **GitHub Actions**, **GitLab CI**, etc.    |
| ✅ Allure Reporting          | Easily pluggable for attractive, filterable reporting            |
| ✅ Test Management Integration | API support for **TestRail**, **Zephyr**, **Xray**, etc.         |
| ✅ AI / ML Integration       | Leverage Python libraries for AI/ML driven test validations and analytics |


## Setup

### 1. Prerequisites

- Install **Python 3.x**  
- Add **Python 3.x** to your system's **PATH** environment variable  
- Ensure **pip** is installed (Most recent Python distributions come with pip by default)  
- (Optional) Install **PyCharm** IDE or any preferred code editor to write and manage your Robot Framework test scripts  

### 2. Setup for Robot Framework

Open your command prompt (or terminal), navigate to your Python environment folder (or anywhere), and run the following commands to install Robot Framework and necessary libraries:

```bash
pip install robotframework
pip install robotframework-seleniumlibrary
# Add any other libraries you require, e.g.,
pip install robotframework-requests
pip install robotframework-databaselibrary
```

### 3. Integrate to jenkins
![image](https://github.com/user-attachments/assets/5d5ac296-3548-453d-ae41-fdaca104f9ee)
![image](https://github.com/user-attachments/assets/02edb6a5-258b-4cf2-b9da-17463638ffb2)
![image](https://github.com/user-attachments/assets/ebe9f37a-48ae-4ab1-b703-a1e52cc0edc3)
![image](https://github.com/user-attachments/assets/d766a1b3-eedd-4753-9e00-699c5632b5d4)



### 4. Email Notifications after Execution__
![image](https://github.com/user-attachments/assets/3e03b843-2ce4-4ca6-8346-41d0343e205f)



## Author

**Bikash Dehury**  
Email: bikash.dehury488@gmail.com  

Feel free to reach out for questions, contributions, or collaboration!  
Connect with me if you want to learn more about Robot Framework or automation in general.






