import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../misc/convert_build_version_value.dart';
import '../domain/build_version.dart';
import '../domain/update_status.dart';

part 'updates_repository.g.dart';

class UpdatesRepository {
  Future<String> deviceVersionNum() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> deviceBuildNum() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<BuildVersion?> buildVersionInfo() async {
    return Future.value(
      const BuildVersion(
        // -=-  TEMP VALUES  -=- (later will add getting from supabase api for min and latest values)
        minimumBuildVersion: '1.0.0.1',
        latestBuildVersion: '1.0.0.1',
      )
    );
  }

  Future<UpdateStatus> deviceUpdateStatus() async {
    BuildVersion? buildVersion = await buildVersionInfo();

    if (buildVersion == null) {
      return UpdateStatus.none;
    }

    String minVer = buildVersion.minimumBuildVersion;
    String latestVer = buildVersion.latestBuildVersion;
    String curVer = '${await deviceVersionNum()}.${await deviceBuildNum()}';

    if (ConvertBuildVersionValue.toValue(minVer) > ConvertBuildVersionValue.toValue(latestVer)) {
      latestVer = minVer;
    }

    if (ConvertBuildVersionValue.toValue(curVer) < ConvertBuildVersionValue.toValue(minVer)) {
      return UpdateStatus.mandatory;
    } else if (ConvertBuildVersionValue.toValue(curVer) < ConvertBuildVersionValue.toValue(latestVer)) {
      return UpdateStatus.optional;
    }

    return UpdateStatus.none;
  }
}

@Riverpod(keepAlive: true)
Future<String> deviceVersion(DeviceVersionRef ref) async {
  final updatesRepository = ref.watch(updatesRepositoryProvider);
  return await updatesRepository.deviceVersionNum();
}

@Riverpod(keepAlive: true)
Future<String> deviceBuild(DeviceBuildRef ref) async {
  final updatesRepository = ref.watch(updatesRepositoryProvider);
  return await updatesRepository.deviceBuildNum();
}

@Riverpod(keepAlive: true)
UpdatesRepository updatesRepository(UpdatesRepositoryRef ref) {
  return UpdatesRepository();
}

@Riverpod(keepAlive: true)
Future<UpdateStatus> deviceUpdateStatus(DeviceUpdateStatusRef ref) async {
  final updatesRepository = ref.watch(updatesRepositoryProvider);
  return await updatesRepository.deviceUpdateStatus();
}