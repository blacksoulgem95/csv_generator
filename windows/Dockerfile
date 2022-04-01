FROM mcr.microsoft.com/windows:20H2

RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_2.10.4-stable.zip -O flutter.zip && mkdir flutter
RUN tar -xf flutter.zip -C ./flutter
RUN set PATH=%PATH%;%cd%\flutter
