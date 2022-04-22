FROM dart:stable

WORKDIR /var/app
COPY backend ./backend
COPY backend_framework ./backend_framework
WORKDIR /var/app/backend
RUN dart pub get

CMD ["dart", "run", "/var/app/backend/bin/backend.dart"]