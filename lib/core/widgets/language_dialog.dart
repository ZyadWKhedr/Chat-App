import 'package:chat_app/core/providers/language_provider.dart';
import 'package:chat_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDialog extends ConsumerWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(localeProvider.notifier);

    return AlertDialog(
      title: Text(loc.chooseLanguage, style: AppTextStyles.heading2(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Text("🇺🇸", style: AppTextStyles.bodyLarge(context)),
            title: Text("English", style: AppTextStyles.bodyLarge(context)),
            onTap: () async {
              await notifier.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Text("🇪🇬", style: AppTextStyles.bodyLarge(context)),
            title: Text("العربية", style: AppTextStyles.bodyLarge(context)),
            onTap: () async {
              await notifier.setLocale(const Locale('ar'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
