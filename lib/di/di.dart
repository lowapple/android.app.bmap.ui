import 'package:bmap/data/database/data_storage_local.dart';
import 'package:bmap/data/network/data_network.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<DataStorageLocal>(DataStorageLocal());
  getIt.registerSingleton<DataNetwork>(DataNetwork());
}
