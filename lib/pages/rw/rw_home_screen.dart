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

class RwHomeScreen extends StatelessWidget {
  const RwHomeScreen({super.key});

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
                role: l10n.rwChairman('12'),
                icon: Icons.star,
              ),
            ),
            const SizedBox(height: 20),

            // RW Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildRwStats(context, l10n),
            ),
            const SizedBox(height: 24),

            // Community Updates Carousel
            CommunityCarousel(items: _getCarouselItems(l10n)),
            const SizedBox(height: 24),

            // Role Indicator - RW Functions
            _buildSectionHeader(
              context,
              l10n.rwChairmanFunctions,
              l10n.manageRwCoordination,
              Icons.star,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            MenuTabsSection(
              tabs: _getRwTabs(context, l10n),
              sectionTitle: l10n.rwChairmanFunctions,
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

  Widget _buildRwStats(BuildContext context, AppLocalizations l10n) {
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
                    l10n.rwSummary('12'),
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
                      l10n.totalRt,
                      '10',
                      Icons.apartment_rounded,
                      Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatsDetail(
                      l10n.totalResidents,
                      '1,245',
                      Icons.people_rounded,
                      Colors.lightGreenAccent,
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
                l10n.idrMillions('45.8'),
                l10n.rwFunds,
                Icons.account_balance_wallet_rounded,
                AppColors.success,
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
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '5',
                l10n.meetings,
                Icons.event_rounded,
                Colors.blue,
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
        title: l10n.reportsNeedAction(3),
        subtitle: l10n.reportFromResidents,
        icon: Icons.report_rounded,
        color: AppColors.error,
        type: 'announcement',
      ),
      CarouselItem(
        title: l10n.rwCoordinationMeeting,
        subtitle: l10n.saturdayDatetime,
        icon: Icons.meeting_room_rounded,
        color: AppColors.primary,
        type: 'event',
      ),
      CarouselItem(
        title: l10n.rwCommunityService,
        subtitle: l10n.sundayDatetime,
        icon: Icons.cleaning_services_rounded,
        color: AppColors.success,
        type: 'event',
      ),
    ];
  }

  List<TabData> _getRwTabs(BuildContext context, AppLocalizations l10n) {
    return [
      TabData(
        label: l10n.manageRt,
        icon: Icons.apartment_rounded,
        items: [
          MenuItem(
            label: l10n.rtList,
            icon: Icons.view_list_rounded,
            onTap: () => context.push('/rw/rt-list'),
          ),
          MenuItem(
            label: l10n.rtPerformance,
            icon: Icons.analytics_rounded,
            onTap: () => context.push('/rw/rt-performance'),
          ),
          MenuItem(
            label: l10n.rwResidentsData,
            icon: Icons.people_rounded,
            onTap: () => context.push('/rw/data-warga'),
          ),
          MenuItem(
            label: l10n.rwStatistics,
            icon: Icons.insert_chart_rounded,
            onTap: () => context.push('/rw/statistics'),
          ),
        ],
      ),
      TabData(
        label: l10n.activities,
        icon: Icons.event_note_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: l10n.rwActivities,
            icon: Icons.event_rounded,
            onTap: () => context.push('/rw/kegiatan'),
            badge: '2',
          ),
          MenuItem(
            label: l10n.rwMeetings,
            icon: Icons.meeting_room_rounded,
            onTap: () => context.push('/rw/rapat'),
            badge: '1',
          ),
          MenuItem(
            label: l10n.createAnnouncement,
            icon: Icons.campaign_rounded,
            onTap: () => context.push('/rw/pengumuman'),
          ),
        ],
      ),
      TabData(
        label: l10n.finance,
        icon: Icons.account_balance_rounded,
        items: [
          MenuItem(
            label: l10n.rwDues,
            icon: Icons.payments_rounded,
            onTap: () => context.push('/rw/iuran'),
          ),
          MenuItem(
            label: l10n.rtSummaryFinance,
            icon: Icons.summarize_rounded,
            onTap: () => context.push('/rw/finance-summary'),
          ),
          MenuItem(
            label: l10n.financeReport,
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push('/rw/finance-report'),
          ),
          MenuItem(
            label: l10n.fundTransparency,
            icon: Icons.visibility_rounded,
            onTap: () => context.push('/rw/transparency'),
          ),
        ],
      ),
      TabData(
        label: l10n.administration,
        icon: Icons.folder_rounded,
        hasNotification: true,
        items: [
          MenuItem(
            label: l10n.manageReports,
            icon: Icons.report_rounded,
            onTap: () => context.push('/rw/laporan'),
            badge: '3',
          ),
          MenuItem(
            label: l10n.areaMonitoring,
            icon: Icons.my_location_rounded,
            onTap: () => context.push('/rw/monitoring'),
          ),
          MenuItem(
            label: l10n.letterVerification,
            icon: Icons.description_rounded,
            onTap: () => context.push('/rw/surat'),
          ),
          MenuItem(
            label: l10n.documentArchive,
            icon: Icons.archive_rounded,
            onTap: () => context.push('/rw/archive'),
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
              onPressed: () => context.push('/rw/activity-log'),
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
          l10n.cleanlinessReport('03'),
          l10n.needsFollowUp,
          l10n.hoursAgo(2),
          Icons.report_rounded,
          AppColors.error,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          l10n.rtCoordinationMeeting,
          l10n.scheduled,
          l10n.hoursAgo(5),
          Icons.event_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          l10n.rwDuesRt('07'),
          l10n.paid,
          l10n.daysAgo(1),
          Icons.payments_rounded,
          AppColors.success,
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
