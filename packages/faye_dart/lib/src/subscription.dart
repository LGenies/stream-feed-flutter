import 'package:faye_dart/src/client.dart';
import 'package:faye_dart/src/message.dart';

typedef Callback = void Function(Map<String, dynamic>? data);
typedef WithChannelCallback = void Function(String, Map<String, dynamic>?);

class Subscription {
  Subscription(
    this._client,
    this._channel, {
    Callback? callback,
  }) : _callback = callback;
  final FayeClient _client;
  final String _channel;
  final Callback? _callback;
  WithChannelCallback? _withChannel;
  bool _cancelled = false;

  /// Connexion status stream
  Stream<FayeClientState> get stateStream => _client.stateStream;

  void call(Message message) {
    _callback?.call(message.data);
    _withChannel?.call(message.channel, message.data);
  }

  Subscription withChannel(WithChannelCallback withChannel) {
    _withChannel = withChannel;
    return this;
  }

  void cancel() {
    if (_cancelled) return;
    _client.unsubscribe(_channel, this);
    _cancelled = true;
  }
}
