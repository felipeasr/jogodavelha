import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildIntroCard(context, l10n),
            const SizedBox(height: 16),
            _buildSection(
              context,
              icon: Icons.storage,
              title: l10n.privacyPolicyDataCollection,
              content: l10n.privacyPolicyDataCollectionText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              icon: Icons.ads_click,
              title: l10n.privacyPolicyAds,
              content: l10n.privacyPolicyAdsText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              icon: Icons.shopping_cart,
              title: l10n.privacyPolicyPurchases,
              content: l10n.privacyPolicyPurchasesText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              icon: Icons.child_care,
              title: l10n.privacyPolicyChildren,
              content: l10n.privacyPolicyChildrenText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              icon: Icons.update,
              title: l10n.privacyPolicyChanges,
              content: l10n.privacyPolicyChangesText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              icon: Icons.email,
              title: l10n.privacyPolicyContact,
              content: l10n.privacyPolicyContactText,
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                l10n.privacyPolicyLastUpdate,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.privacy_tip,
                color: AppTheme.primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.privacyPolicyIntro,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
