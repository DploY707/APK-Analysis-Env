FROM ubuntu:18.04

MAINTAINER DploY <starj1024@gmail.com>
MAINTAINER Liberty <gigacms@gmail.com>

SHELL ["/bin/bash", "-c"]

# Install basic packages
RUN \
    apt update && \
    apt install -y openjdk-8-jdk vim git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

# Gradle Settings
WORKDIR /
RUN \
    wget https://services.gradle.org/distributions/gradle-5.4.1-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-5.4.1-bin.zip

RUN \
    mkdir -p /opt/gradlew && \
    /opt/gradle/gradle-5.4.1/bin/gradle wrapper --gradle-version 5.4.1 --distribution-type all -p /opt/gradlew && \
    /opt/gradle/gradle-5.4.1/bin/gradle wrapper -p /opt/gradlew

# Android SDK Installation
# This Image targets Android API 27, x86 arch
RUN \
    wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp && \
    unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip

RUN \
    yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-27;google_apis;x86" "platforms;android-27" "build-tools;27.0.3" "emulator" && \
    yes Y | /opt/android/tools/bin/sdkmanager --licenses

RUN \
    echo "no" | /opt/android/tools/bin/avdmanager --verbose create avd --force --name "test" --device "pixel" --package "system-images;android-27;google_apis;x86" \
    --tag "google_apis" --abi "x86"

ENV GRADLE_HOME=/opt/gradle/gradle-5.4.1
ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

ADD ./start.sh /tmp/
ADD ./config.sh /tmp/

ADD ./classes.dex /tmp/
ADD ./libsmtb.so /tmp/
ADD ./t_launcher /tmp/
ADD ./t_launcher32 /tmp/

# ADD [target_APK] /tmp/
# TARGET_APK Have to locate in Build path
ADD ./ShoppingCart_clean_15_add_AssetFile.apk /tmp/

WORKDIR /tmp/
RUN \
    chmod a+x start.sh && \
    chmod a+x config.sh && \
    chmod a+x t_launcher && \
    chmod a+x t_launcher32
    
ENTRYPOINT ["/bin/bash", "-c", "/tmp/start.sh"]
