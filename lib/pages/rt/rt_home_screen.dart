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

class RtHomeScreen extends StatelessWidget {
  const RtHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: RukuninAppBar(title: l10n.home, showNotification: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: WelcomeRoleCard(
                greeting: l10n.welcomeBackGreeting,
                role: l10n.rtChairman('03', '12'),
                icon: Icons.account_balance,
              ),
            ),
            const SizedBox(height: 20),

            // RT Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildRtStats(context, l10n),
            ),
            const SizedBox(height: 24),

            // Community Updates Carousel
            CommunityCarousel(items: _getCarouselItems(l10n)),
            const SizedBox(height: 24),

            // Role Indicator - RT Functions
            _buildSectionHeader(
              context,
              l10n.rtChairmanFunctions,
              l10n.manageRtAdministration,
              Icons.account_balance,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getRtTabs(context, l10n),
              sectionTitle: l10n.rtChairmanFunctions,
            ),
            const SizedBox(height: 32),

            // Role Indicator - Resident Functions
            _buildSectionHeader(
              context,
              l10n.residentServices,
              l10n.accessResidentFeatures,
              Icons.home,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getResidentTabs(context, l10n),
              sectionTitle: l10n.residentServices,
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _recentActivity(context, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRtStats(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Main Stats Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.rtSummary('03'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.january2024,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatsDetail(
                      l10n.totalResidents,
                      '145',
                      Icons.people_rounded,
                      Colors.lightBlueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatsDetail(
                      l10n.totalKk,
                      '45',
                      Icons.family_restroom,
                      Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '38/45',
                l10n.duesPaid,
                Icons.check_circle_rounded,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '5',
                l10n.pendingSubmissions,
                Icons.pending_actions_rounded,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '3',
                l10n.reports,
                Icons.report_rounded,
                AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsDetail(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<CarouselItem> _getCarouselItems(AppLocalizations l10n) {
    return [
      CarouselItem(
        title: l10n.newLetterSubmissions(5),
        subtitle: l10n.letterRequestsNeedProcessing,
        icon: Icons.mail_rounded,
        color: AppColors.warning,
        type: 'announcement',
      ),
      CarouselItem(
        title: l10n.rtMeetingThisWeek,
        subtitle: l10n.fridayDatetime,
        icon: Icons.meeting_room_rounded,
        color: AppColors.primary,
        type: 'event',
      ),
      CarouselItem(
        title: l10n.communityServiceNextWeek,
        subtitle: l10n.sundayJan21,
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
    ];
  }

  List<TabData> _getRtTabs(BuildContext context, AppLocalizations l10n) {
    return [
      TabData(
        label: l10n.residents,
        icon: Icons.people_rounded,
        items: [
          MenuItem(
            label: l10n.residentsData,
            icon: Icons.people_rounded,
            onTap: () => context.push('/rt/warga/list'),
          ),
          MenuItem(
            label: l10n.addResident,
            icon: Icons.person_add_rounded,
            onTap: () => context.push('/rt/tambah-warga'),
          ),
          MenuItem(
            label: l10n.familyData,
            icon: Icons.family_restroom,
            onTap: () => context.push('/rt/warga/family'),
          ),
          MenuItem(
            label: l10n.recordMutation,
            icon: Icons.swap_horiz,
            onTap: () => context.push('/rt/mutasi'),
          ),
        ],
      ),
      TabData(
        label: l10n.finance,
        icon: Icons.account_balance_wallet_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: l10n.manageDues,
            icon: Icons.payments_rounded,
            onTap: () => context.push('/rt/iuran'),
            badge: '7',
          ),
          MenuItem(
            label: l10n.rtFunds,
            icon: Icons.account_balance_rounded,
            onTap: () => context.push('/rt/kas'),
          ),
          MenuItem(
            label: l10n.transactionHistory,
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/rt/transaksi'),
          ),
        ],
      ),
      TabData(
        label: l10n.activities,
        icon: Icons.event_rounded,
        items: [
          MenuItem(
            label: l10n.manageActivities,
            icon: Icons.event_rounded,
            onTap: () => context.push('/rt/activity'),
          ),
          MenuItem(
            label: l10n.meetingSchedule,
            icon: Icons.meeting_room_rounded,
            onTap: () => context.push('/rt/meetings'),
          ),
          MenuItem(
            label: l10n.createAnnouncement,
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/rt/announcements'),
          ),
        ],
      ),
      TabData(
        label: l10n.administration,
        icon: Icons.assignment_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: l10n.letterSubmissions,
            icon: Icons.description_rounded,
            onTap: () => context.push('/rt/surat/pengajuan'),
            badge: '5',
          ),
          MenuItem(
            label: l10n.manageReports,
            icon: Icons.report_rounded,
            onTap: () => context.push('/rt/reports/manage'),
            badge: '3',
          ),
          MenuItem(
            label: l10n.rtArea,
            icon: Icons.map_rounded,
            onTap: () => context.push('/rt/wilayah'),
          ),
          MenuItem(
            label: l10n.rtStatistics,
            icon: Icons.insert_chart_rounded,
            onTap: () => context.push('/rt/reports/statistic'),
          ),
        ],
      ),
    ];
  }

  List<TabData> _getResidentTabs(BuildContext context, AppLocalizations l10n) {
    return [
      TabData(
        label: l10n.personalData,
        icon: Icons.person_rounded,
        items: [
          MenuItem(
            label: l10n.populationInfo,
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
        ],
      ),
      TabData(
        label: l10n.community,
        icon: Icons.groups_rounded,
        items: [
          MenuItem(
            label: l10n.announcements,
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/resident/announcements'),
          ),
          MenuItem(
            label: l10n.residentsDirectory,
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

  Widget _recentActivity(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentActivity,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/rt/activity-log'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.viewAll,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          l10n.monthlyDuesPersonName('Pak Budi'),
          l10n.paid,
          l10n.minutesAgo(5),
          Icons.payments_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          l10n.letterSubmissionPersonName('Ibu Siti'),
          l10n.waitingVerification,
          l10n.minutesAgo(30),
          Icons.description_rounded,
          AppColors.warning,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          l10n.streetLightReport,
          l10n.needsFollowUp,
          l10n.hoursAgo(1),
          Icons.report_rounded,
          AppColors.error,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String status,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
