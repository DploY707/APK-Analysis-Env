# APK-Analysis-Env
This project provide a docker based testing environment to analyze APK

Now this project analyze an example, you can change the DockerFile and shell scripts to analyze your target

## How to build Dockerfile
docker build -t android-emulator ./

## How to Start Docker Image
docker run --privileged -it --rm -v [PLACE_TO_STORE_EXTRACTED_LOG_FILE]:/data/ --name emul android-emulator
