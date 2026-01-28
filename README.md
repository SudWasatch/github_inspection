# github_inspection

A new Flutter project.

This project is just to show the packages used and how these packages are used. The list of packages are shown in pubspec.yaml.

################# To Start The Project ########################
Commands :- 
$ flutter pub get
$ adb devices // get the device name and replace with <emulator-name>
$ flutter run -d <emulator-name>

Instructions :-
set the location's latitude and longitude on this page 
 "Data": [
      {
        "inspectionID": "IND 1",
        "incharge": "Jhon Doe",
        "designation": "Incharge",
        "mobileNo": phoneController.text,
        "DistName": "Bhopal",
        "Name": "Van Vihar",
        "Address":
            "Van Vihar National Park Bhopal",
        "latitude": 23.232355, // insert desired latitude here
        "longitude": 77.366409, // insert desired longitude here
        "FromDate": "2026-01-12T00:00:00.0000000+05:30",
        "ToDate": "2026-01-31T00:00:00.0000000+05:30",
      },
      {
        "inspectionID": "IND 2",
        "incharge": "Jhon Doe",
        "designation": "Incharge",
        "mobileNo": phoneController.text,
        "DistName": "Bhopal",
        "Name": "Kerwa Dam",
        "Address": "Kerwa Dam Bhopal",
        "latitude": 23.166403, // insert desired latitude here
        "longitude": 77.372246, // insert desired longitude here
        "FromDate": "2026-01-12T00:00:00.0000000+05:30",
        "ToDate": "2026-01-31T00:00:00.0000000+05:30",
      },
    ],