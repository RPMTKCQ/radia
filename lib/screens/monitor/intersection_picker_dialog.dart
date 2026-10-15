import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pill.dart';

void showIntersectionPicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.maroonLight, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Select intersection',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: Text('Choose which camera view to monitor.',
                    style: TextStyle(color: app.muted)),
              )),
          for (final i in app.intersections)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                tileColor: AppColors.surface2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(i.name),
                trailing: Pill(i.status, color: i.statusColor),
                onTap: () {
                  app.update(() => app.selected = i.id);
                  Navigator.pop(context);
                },
              ),
            ),
          const SizedBox(height: 4),
          SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'))),
        ]),
      ),
    ),
  );
}
