import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolfpackapp/src/features/updates/data/updates_repository.dart';

import '../../../../misc/app_stores.dart';
import '../domain/update_status.dart';

class OptionalUpdateCard extends ConsumerWidget {
  const OptionalUpdateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateStatusValue = ref.watch(deviceUpdateStatusProvider);

    return updateStatusValue.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
      data: (updateStatus) {
        if (updateStatus == UpdateStatus.optional) {
          return Card(
            color: Colors.amber.shade600,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                launchUrl(
                  Uri.parse(storeUrl!),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.arrow_up_right_diamond_fill,
                      color: Colors.black87,
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'A new update is available!',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    Icon(
                      CupertinoIcons.chevron_forward,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    );
  }
}