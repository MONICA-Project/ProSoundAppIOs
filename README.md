# Monica Professional Sound App
<!-- Short description of the project. -->
The professional sound app allows the user to see the sound level meter data from the MONICA system. It also provides functionality to give sound feedback to the COP indicating sound problems at certain place.  

<!-- A teaser figure may be added here. It is best to keep the figure small (<500KB) and in the same repo -->

## Getting Started
<!-- Instruction to make the project up and running. -->
The app is developed in Swift using Apple XCode and is a pure iOS app. 
Clone the repository and build the app in Apple XCode.
The default endpoint it contacts the [COP APi](https://github.com/MONICA-Project/COP.API) is http://127.0.0.1:8800/
Which matches the port in [Sound Monitoring an event using Sound Level Meters](https://github.com/MONICA-Project/DockerSoundDemo)

If another adress and port is to be used, locate the file "MonicaPro\AsyncTask.swift" and change:
```
    private static let baseStart = "http://127.0.0.1:8800/"
```
Change it to desired adress and port and rebuild.


## Contributing
Contributions are welcome. 

Please fork, make your changes, and submit a pull request. For major changes, please open an issue first and discuss it with the other authors.

## Affiliation
![MONICA](https://github.com/MONICA-Project/template/raw/master/monica.png)  
This work is supported by the European Commission through the [MONICA H2020 PROJECT](https://www.monica-project.eu) under grant agreement No 732350.

