import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/secretary/community/community_screen.dart';
import 'package:rukunin/pages/secretary/community/document_request_form_screen.dart';
import 'package:rukunin/pages/secretary/community/documents_screen.dart';
import 'package:rukunin/pages/secretary/community/dues_screen.dart';
import 'package:rukunin/pages/secretary/community/family_details_screen.dart';
import 'package:rukunin/pages/secretary/community/finance_transparency_screen.dart';
import 'package:rukunin/pages/secretary/community/population_info_screen.dart';
import 'package:rukunin/pages/secretary/secretary_home_screen.dart';
import 'package:rukunin/pages/general/account_screen.dart';
import 'package:rukunin/pages/secretary/secretary_shell.dart';

final secretaryRoutes = ShellRoute(
  builder: (context, state, child) => SecretaryShell(child: child),
  routes: [
    GoRoute(
      path: '/secretary',
      name: 'secretary-home',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SecretaryHomeScreen()),
    ),
    GoRoute(
      path: '/secretary/community',
      name: 'secretary-community',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: CommunityScreen()),
      routes: [
        GoRoute(
          path: 'dues',
          name: 'secretary-community-dues',
          builder: (context, state) => const DuesScreen(),
        ),
        GoRoute(
          path: 'finance-transparency',
          name: 'secretary-community-finance',
          builder: (context, state) => const FinanceTransparencyScreen(),
        ),
        GoRoute(
          path: 'population',
          name: 'secretary-community-population',
          builder: (context, state) => const PopulationInfoScreen(),
        ),
        GoRoute(
          path: 'family',
          name: 'secretary-community-family',
          builder: (context, state) => const FamilyDetailsScreen(),
        ),
        GoRoute(
          path: 'documents',
          name: 'secretary-community-documents',
          builder: (context, state) => const DocumentsScreen(),
          routes: [
            GoRoute(
              path: 'domicile',
              name: 'secretary-document-domicile',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'domicile',
                documentTitle: 'Surat Keterangan Domisili',
                documentIcon: Icons.home_outlined,
                documentColor: Colors.blue,
              ),
            ),
            GoRoute(
              path: 'sktm',
              name: 'secretary-document-sktm',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'sktm',
                documentTitle: 'Surat Keterangan Tidak Mampu',
                documentIcon: Icons.people_outline,
                documentColor: Colors.orange,
              ),
            ),
            GoRoute(
              path: 'business',
              name: 'secretary-document-business',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'business',
                documentTitle: 'Surat Keterangan Usaha',
                documentIcon: Icons.business_outlined,
                documentColor: Colors.green,
              ),
            ),
            GoRoute(
              path: 'correction',
              name: 'secretary-document-correction',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'correction',
                documentTitle: 'Permohonan Koreksi Data',
                documentIcon: Icons.edit_document,
                documentColor: Colors.purple,
              ),
            ),
            GoRoute(
              path: 'family',
              name: 'secretary-document-family',
              builder: (context, state) => const DocumentRequestFormScreen(
                documentType: 'family',
                documentTitle: 'Surat Keterangan Keluarga',
                documentIcon: Icons.family_restroom,
                documentColor: Colors.teal,
              ),
            ),
            GoRoute(
              path: 'other',
              name: 'secretary-document-other',
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
      path: '/secretary/account',
      name: 'secretary-account',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AccountScreen()),
    ),
  ],
);
