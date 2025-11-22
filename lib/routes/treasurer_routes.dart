import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/treasurer/activities/activity_screen.dart';
import 'package:rukunin/pages/treasurer/community/community_screen.dart';
import 'package:rukunin/pages/treasurer/community/document_request_form_screen.dart';
import 'package:rukunin/pages/treasurer/community/documents_screen.dart';
import 'package:rukunin/pages/treasurer/community/dues_screen.dart';
import 'package:rukunin/pages/treasurer/community/family_details_screen.dart';
import 'package:rukunin/pages/treasurer/community/finance_transparency_screen.dart';
import 'package:rukunin/pages/treasurer/community/population_info_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_home_screen.dart';
import 'package:rukunin/pages/treasurer/treasurer_shell.dart';

final treasurerRoutes = ShellRoute(
  builder: (context, state, child) => TreasurerShell(child: child),
  routes: [
    GoRoute(
      path: '/treasurer',
      name: 'treasurer-home',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: TreasurerHomeScreen()),
    ),
    GoRoute(
      path: '/treasurer/activities',
      name: 'treasurer-activities',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ActivityScreen()),
    ),
    GoRoute(
      path: '/treasurer/community',
      name: 'treasurer-community',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: CommunityScreen()),
      routes: [
        GoRoute(
          path: 'dues',
          name: 'treasurer-community-dues',
          builder: (context, state) => const DuesScreen(),
        ),
        GoRoute(
          path: 'finance-transparency',
          name: 'treasurer-community-finance',
          builder: (context, state) => const FinanceTransparencyScreen(),
        ),
        GoRoute(
          path: 'population',
          name: 'treasurer-community-population',
          builder: (context, state) => const PopulationInfoScreen(),
        ),
        GoRoute(
          path: 'family',
          name: 'treasurer-community-family',
          builder: (context, state) => const FamilyDetailsScreen(),
        ),
        GoRoute(
          path: 'documents',
          name: 'treasurer-community-documents',
          builder: (context, state) => const DocumentsScreen(),
          routes: [
            GoRoute(
              path: 'domicile',
              name: 'treasurer-document-domicile',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'domicile',
                documentTitle: 'Surat Keterangan Domisili',
                documentIcon: Icons.home_outlined,
                documentColor: Colors.blue,
              ),
            ),
            GoRoute(
              path: 'sktm',
              name: 'treasurer-document-sktm',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'sktm',
                documentTitle: 'Surat Keterangan Tidak Mampu',
                documentIcon: Icons.people_outline,
                documentColor: Colors.orange,
              ),
            ),
            GoRoute(
              path: 'business',
              name: 'treasurer-document-business',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'business',
                documentTitle: 'Surat Keterangan Usaha',
                documentIcon: Icons.business_outlined,
                documentColor: Colors.green,
              ),
            ),
            GoRoute(
              path: 'correction',
              name: 'treasurer-document-correction',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'correction',
                documentTitle: 'Permohonan Koreksi Data',
                documentIcon: Icons.edit_document,
                documentColor: Colors.purple,
              ),
            ),
            GoRoute(
              path: 'family',
              name: 'treasurer-document-family',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'family',
                documentTitle: 'Surat Keterangan Keluarga',
                documentIcon: Icons.family_restroom,
                documentColor: Colors.teal,
              ),
            ),
            GoRoute(
              path: 'other',
              name: 'treasurer-document-other',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'other',
                documentTitle: 'Surat Lainnya',
                documentIcon: Icons.description_outlined,
                documentColor: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/treasurer/account',
      name: 'treasurer-account',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AccountScreen()),
    ),
  ],
);
