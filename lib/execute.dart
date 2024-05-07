import 'package:ecommerce_app/utils/log.dart';
import 'package:get/get.dart';

abstract class Execute {
  final String instance;

  Execute({required this.instance}){
    executeWithCatchError(instance);
  }

  execute();

  executeWithCatchError(String instance) {
    try {
      execute();
    } on Exception catch (error) {
      catchError(instance, error);
    }
  }

  catchError(String instance, dynamic error) {
    Log.red("Error in $instance: $error");
    if (Get.isSnackbarOpen) Get.back();
  }
}
