// Tạo file media_manager.dart
import 'package:flash_card_app/interface/media_controller.dart';

class MediaManager {
  static final MediaManager _instance = MediaManager._internal();

  factory MediaManager() => _instance;

  MediaManager._internal();

  final List<MediaController> _controllers = [];
  MediaController? _activeController;

  void registerController(MediaController controller) {
    _controllers.add(controller);
  }

  void unregisterController(MediaController controller) {
    _controllers.remove(controller);
    if (_activeController == controller) {
      _activeController = null;
    }
  }

  void setActiveController(MediaController controller) {
    if (_activeController != null && _activeController != controller) {
      _activeController!.pauseAllMedia();
    }
    _activeController = controller;
  }

  void pauseAllExcept(MediaController exceptController) {
    for (var controller in _controllers) {
      if (controller != exceptController) {
        controller.pauseAllMedia();
      }
    }
  }
}