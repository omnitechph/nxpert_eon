import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

import 'pages/entries/dpr_entry_adc/views/dpr_entry_adc_page.dart';
import 'pages/entries/dpr_entry_c4/views/dpr_entry_c4_page.dart';
import 'pages/entries/dpr_entry_kd/views/dpr_entry_kd_page.dart';
import 'pages/entries/pallet_entry/views/pallet_entry_page.dart';
import 'pages/entries/plan_uploader/views/plan_uploader_page.dart';
import 'pages/login/views/login_page.dart';
import 'pages/logs/adc_logs/views/adc_logs_page.dart';
import 'pages/logs/machining_logs/views/machining_logs_page.dart';
import 'pages/logs/ng_logs/views/ng_logs_page.dart';
import 'pages/not_found/not_found_page.dart';
import 'pages/ppm/production_management/views/production_management_page.dart';
import 'pages/reports/kd_pallet_layout/views/kd_pallet_layout_page.dart';
import 'pages/reports/mpr_adc/views/mpr_adc_page.dart';
import 'pages/reports/mpr_c4/views/mpr_c4_page.dart';
import 'pages/reports/mpr_kd/views/mpr_kd_page.dart';
import 'pages/reports/ng_rework/views/ng_rework_page.dart';
import 'pages/settings/kanban_master/views/kanban_master_page.dart';
import 'pages/settings/locator_master/views/locator_master_page.dart';
import 'pages/settings/pallet_master/views/pallet_master_page.dart';
import 'pages/settings/preference_master/views/preference_master_page.dart';
import 'pages/settings/product_master/views/product_master_page.dart';
import 'pages/settings/shift_master/views/shift_master_page.dart';
import 'pages/settings/user_master/views/user_master_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  refreshListenable: AuthChangeNotifier(),
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = Hive.box('auth').containsKey('status');
    final bool loggingIn = state.uri.path == '/login';
    if (!loggedIn) return loggingIn ? null : '/login';
    if (loggingIn) return '/ppm/production-management';
    if (state.uri.path == '/entries') return '/entries/plan-uploader';
    if (state.uri.path == '/reports') return '/reports/mpr-adc';
    if (state.uri.path == '/settings') return '/settings/product-master';
    if (state.uri.path == '/logs') return '/logs/adc-logs';
    return null;
  },
  routes: <RouteBase>[
    GoRoute(path: '/login', builder: (BuildContext context, GoRouterState state) => const LoginPage()),
    GoRoute(path: '/ppm/production-management', builder: (BuildContext context, GoRouterState state) => const ProductionManagementPage()),
    GoRoute(path: '/entries/plan-uploader', builder: (BuildContext context, GoRouterState state) => const PlanUploaderPage()),
    GoRoute(path: '/entries/dpr-entry-adc', builder: (BuildContext context, GoRouterState state) => const DprEntryAdcPage()),
    GoRoute(path: '/entries/dpr-entry-c4', builder: (BuildContext context, GoRouterState state) => const DprEntryC4Page()),
    GoRoute(path: '/entries/dpr-entry-kd', builder: (BuildContext context, GoRouterState state) => const DprEntryKdPage()),
    GoRoute(path: '/entries/pallet-entry', builder: (BuildContext context, GoRouterState state) => const PalletEntryPage()),
    GoRoute(path: '/reports/mpr-adc', builder: (BuildContext context, GoRouterState state) => const MprAdcPage()),
    GoRoute(path: '/reports/mpr-c4', builder: (BuildContext context, GoRouterState state) => const MprC4Page()),
    GoRoute(path: '/reports/mpr-kd', builder: (BuildContext context, GoRouterState state) => const MprKdPage()),
    GoRoute(path: '/reports/kd-pallet-layout', builder: (BuildContext context, GoRouterState state) => const KdPalletLayoutPage()),
    GoRoute(path: '/reports/ng-rework', builder: (BuildContext context, GoRouterState state) => const NgReworkPage()),
    GoRoute(path: '/settings/product-master', builder: (BuildContext context, GoRouterState state) => const ProductMasterPage()),
    GoRoute(path: '/settings/kanban-master', builder: (BuildContext context, GoRouterState state) => const KanbanMasterPage()),
    GoRoute(path: '/settings/pallet-master', builder: (BuildContext context, GoRouterState state) => const PalletMasterPage()),
    GoRoute(path: '/settings/locator-master', builder: (BuildContext context, GoRouterState state) => const LocatorMasterPage()),
    GoRoute(path: '/settings/user-master', builder: (BuildContext context, GoRouterState state) => const UserMasterPage()),
    GoRoute(path: '/settings/preference-master', builder: (BuildContext context, GoRouterState state) => const PreferenceMasterPage()),
    GoRoute(path: '/settings/shift-master', builder: (BuildContext context, GoRouterState state) => const ShiftMasterPage()),
    GoRoute(path: '/logs/adc-logs', builder: (BuildContext context, GoRouterState state) => const AdcLogsPage()),
    GoRoute(path: '/logs/machining-logs', builder: (BuildContext context, GoRouterState state) => const MachiningLogsPage()),
    GoRoute(path: '/logs/ng-logs', builder: (BuildContext context, GoRouterState state) => const NgLogsPage()),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) => const NotFoundPage(),
);

/// [AuthChangeNotifier] is a simple ChangeNotifier that notifies the router when auth status changes.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier() {
    Hive.box('auth').listenable().addListener(notifyListeners);
  }
}
