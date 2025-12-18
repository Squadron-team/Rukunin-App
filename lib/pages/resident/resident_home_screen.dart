import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/l10n/app_localizations.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/widgets/welcome_role_card.dart';
import 'package:rukunin/widgets/community_carousel.dart';
import 'package:rukunin/widgets/menu_tabs_section.dart';
import 'package:rukunin/models/carousel_item.dart';
import 'package:rukunin/models/menu_item.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: RukuninAppBar(title: l10n.home, showNotification: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: WelcomeRoleCard(
                greeting: l10n.welcomeBack,
                role: l10n.residentRole,
                icon: Icons.home,
              ),
            ),
            const SizedBox(height: 24),
            CommunityCarousel(items: _getCarouselItems(l10n)),
            const SizedBox(height: 24),
            MenuTabsSection(tabs: _getMenuTabs(context, l10n)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<CarouselItem> _getCarouselItems(AppLocalizations l10n) {
    return [
      CarouselItem(
        title: l10n.communityWorkThisWeek,
        subtitle: 'Minggu, 15 Januari 2024 • 07:00 WIB',
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
      CarouselItem(
        title: l10n.announcementSecuritySchedule,
        subtitle: l10n.securityScheduleChange,
        icon: Icons.campaign_rounded,
        color: AppColors.warning,
        type: 'announcement',
      ),
      CarouselItem(
        title: l10n.duesDeadline,
        subtitle: l10n.payDuesSoon,
        icon: Icons.payments_rounded,
        color: AppColors.error,
        type: 'payment',
      ),
    ];
  }

  List<TabData> _getMenuTabs(BuildContext context, AppLocalizations l10n) {
    return [
      TabData(
        label: l10n.personal,
        icon: Icons.person,
        items: [
          MenuItem(
            label: l10n.populationInformation,
            icon: Icons.person_2_outlined,
            onTap: () => context.push('/resident/community/population'),
          ),
          MenuItem(
            label: l10n.familyDataKk,
            icon: Icons.family_restroom,
            onTap: () => context.push('/resident/community/family'),
          ),
          MenuItem(
            label: l10n.houseData,
            icon: Icons.home,
            onTap: () => context.push('/resident/community/home'),
          ),
        ],
      ),
      TabData(
        label: l10n.dues,
        icon: Icons.payments_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: l10n.payDues,
            icon: Icons.payment_rounded,
            onTap: () => context.push('/resident/community/dues'),
            badge: '1',
          ),
          MenuItem(
            label: l10n.paymentHistory,
            icon: Icons.history_rounded,
            onTap: () => context.push('/resident/payment-history'),
          ),
          MenuItem(
            label: l10n.digitalReceipts,
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/resident/digital-receipts'),
          ),
          MenuItem(
            label: l10n.financialTransparency,
            icon: Icons.trending_up,
            onTap: () =>
                context.push('/resident/community/finance-transparency'),
          ),
        ],
      ),
      TabData(
        label: l10n.services,
        icon: Icons.description_rounded,
        items: [
          MenuItem(
            label: l10n.submitLetter,
            icon: Icons.description_rounded,
            onTap: () => context.push('/resident/community/documents'),
          ),
          MenuItem(
            label: l10n.reportIssue,
            icon: Icons.report_problem_rounded,
            onTap: () => context.push('/resident/report-issue'),
          ),
          MenuItem(
            label: l10n.sendSuggestion,
            icon: Icons.feedback_rounded,
            onTap: () => context.push('/resident/submit-suggestion'),
          ),
          MenuItem(
            label: l10n.submissionStatus,
            icon: Icons.checklist_rounded,
            onTap: () => context.push('/resident/submission-status'),
          ),
        ],
      ),
      TabData(
        label: l10n.community,
        icon: Icons.groups_rounded,
        items: [
          MenuItem(
            label: l10n.eventCalendar,
            icon: Icons.event_rounded,
            onTap: () => context.push('/resident/event-calendar'),
          ),
          MenuItem(
            label: l10n.announcements,
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/resident/announcements'),
          ),
          MenuItem(
            label: l10n.residentsData,
            icon: Icons.people_rounded,
            onTap: () => context.push('/resident/residents-directory'),
          ),
          MenuItem(
            label: l10n.emergencyContacts,
            icon: Icons.contact_phone_rounded,
            onTap: () => context.push('/resident/emergency-contacts'),
          ),
        ],
      ),
    ];
  }
}
