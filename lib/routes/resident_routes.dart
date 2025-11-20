import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/resident/community/community_screen.dart';
import 'package:rukunin/pages/resident/community/dues_screen.dart';
import 'package:rukunin/pages/resident/community/finance_transparency_screen.dart';
import 'package:rukunin/pages/resident/community/population_info_screen.dart';
import 'package:rukunin/pages/resident/resident_home_screen.dart';
import 'package:rukunin/pages/resident/marketplace/marketplace_screen.dart';
import 'package:rukunin/pages/resident/events/events_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/resident/resident_shell.dart';
import 'package:rukunin/pages/resident/community/family_details_screen.dart';
import 'package:rukunin/pages/resident/community/documents_screen.dart';
import 'package:rukunin/pages/resident/community/document_request_form_screen.dart';

final residentRoutes = ShellRoute(
  builder: (context, state, child) => ResidentShell(child: child),
  routes: [
    GoRoute(
      path: '/resident',
      name: 'resident-home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: ResidentHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/marketplace',
      name: 'resident-marketplace',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MarketplaceScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/events',
      name: 'resident-events',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: EventsScreen(),
      ),
    ),
    GoRoute(
      path: '/resident/community',
      name: 'resident-community',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: CommunityScreen(),
      ),
      routes: [
        GoRoute(
          path: 'dues',
          name: 'resident-community-dues',
          builder: (context, state) => const DuesScreen(),
        ),
        GoRoute(
          path: 'finance-transparency',
          name: 'resident-community-finance',
          builder: (context, state) => const FinanceTransparencyScreen(),
        ),
        GoRoute(
          path: 'population',
          name: 'resident-community-population',
          builder: (context, state) => const PopulationInfoScreen(),
        ),
        GoRoute(
          path: 'family',
          name: 'resident-community-family',
          builder: (context, state) => const FamilyDetailsScreen(),
        ),
        GoRoute(
          path: 'documents',
          name: 'resident-community-documents',
          builder: (context, state) => const DocumentsScreen(),
          routes: [
            GoRoute(
              path: 'domicile',
              name: 'document-domicile',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'domicile',
                documentTitle: 'Surat Keterangan Domisili',
                documentIcon: Icons.home_outlined,
                documentColor: Colors.blue,
              ),
            ),
            GoRoute(
              path: 'sktm',
              name: 'document-sktm',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'sktm',
                documentTitle: 'Surat Keterangan Tidak Mampu',
                documentIcon: Icons.people_outline,
                documentColor: Colors.orange,
              ),
            ),
            GoRoute(
              path: 'business',
              name: 'document-business',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'business',
                documentTitle: 'Surat Keterangan Usaha',
                documentIcon: Icons.business_outlined,
                documentColor: Colors.green,
              ),
            ),
            GoRoute(
              path: 'correction',
              name: 'document-correction',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'correction',
                documentTitle: 'Permohonan Koreksi Data',
                documentIcon: Icons.edit_document,
                documentColor: Colors.purple,
              ),
            ),
            GoRoute(
              path: 'family',
              name: 'document-family',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'family',
                documentTitle: 'Surat Keterangan Keluarga',
                documentIcon: Icons.family_restroom,
                documentColor: Colors.teal,
              ),
            ),
            GoRoute(
              path: 'other',
              name: 'document-other',
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
      path: '/resident/account',
      name: 'resident-account',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AccountScreen(),
      ),
    ),
  ],
);
