import 'package:backend/core/backend_request.dart';
import 'package:backend/event/event_emitter.dart';

/// Before the request is processed, this event is emitted.
class BeforeRequestProcessingEvent with IEvent {
  final BackendRequest request;

  BeforeRequestProcessingEvent(this.request);
}

/// After the request has been processed, this event is emitted.
/// Modification to the request will be executed before sending the result to the client.
class AfterRequestProcessingEvent with IEvent {
  final BackendRequest request;

  AfterRequestProcessingEvent(this.request);
}
