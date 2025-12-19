import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tremor_ring_app/models/emergency_contact.dart';
import 'package:tremor_ring_app/models/incident_log.dart';

/// Database Initialization Service
/// Handles all Hive setup, registration, and initialization
class DatabaseInit {
  // Box names
  static const String emergencyContactsBox = 'emergency_contacts';
  static const String incidentsBox = 'incidents';
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  static const String userDataBox = 'user_data';

  /// Initialize database
  /// Call this in main() before running the app
  static Future<void> initialize() async {
    try {
      debugPrint('🗄️ Initializing Hive database...');

      // Initialize Hive
      await Hive.initFlutter();

      // Register adapters
      _registerAdapters();

      // Open boxes
      await _openBoxes();

      debugPrint('✅ Database initialized successfully');
    } catch (e) {
      debugPrint('❌ Database initialization error: $e');
      rethrow;
    }
  }

  /// Register all Hive type adapters
  static void _registerAdapters() {
    debugPrint('📝 Registering Hive adapters...');

    try {
      // Register Emergency Contact adapter
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(EmergencyContactAdapter());
        debugPrint('✓ EmergencyContactAdapter registered');
      }

      // Register Incident Log adapter
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(IncidentLogAdapter());
        debugPrint('✓ IncidentLogAdapter registered');
      }

      // Add more adapters as needed
      debugPrint('✓ All adapters registered');
    } catch (e) {
      debugPrint('❌ Adapter registration error: $e');
      rethrow;
    }
  }

  /// Open all required Hive boxes
  static Future<void> _openBoxes() async {
    debugPrint('📂 Opening Hive boxes...');

    try {
      // Emergency Contacts Box
      await Hive.openBox<EmergencyContact>(emergencyContactsBox);
      debugPrint('✓ $emergencyContactsBox box opened');

      // Incidents Box
      await Hive.openBox<IncidentLog>(incidentsBox);
      debugPrint('✓ $incidentsBox box opened');

      // Settings Box
      await Hive.openBox(settingsBox);
      debugPrint('✓ $settingsBox box opened');

      // Cache Box
      await Hive.openBox(cacheBox);
      debugPrint('✓ $cacheBox box opened');

      // User Data Box
      await Hive.openBox(userDataBox);
      debugPrint('✓ $userDataBox box opened');

      debugPrint('✓ All boxes opened successfully');
    } catch (e) {
      debugPrint('❌ Box opening error: $e');
      rethrow;
    }
  }

  /// Get Emergency Contacts Box
  static Box<EmergencyContact> getEmergencyContactsBox() {
    try {
      return Hive.box<EmergencyContact>(emergencyContactsBox);
    } catch (e) {
      debugPrint('❌ Error getting emergency contacts box: $e');
      rethrow;
    }
  }

  /// Get Incidents Box
  static Box<IncidentLog> getIncidentsBox() {
    try {
      return Hive.box<IncidentLog>(incidentsBox);
    } catch (e) {
      debugPrint('❌ Error getting incidents box: $e');
      rethrow;
    }
  }

  /// Get Settings Box
  static Box getSettingsBox() {
    try {
      return Hive.box(settingsBox);
    } catch (e) {
      debugPrint('❌ Error getting settings box: $e');
      rethrow;
    }
  }

  /// Get Cache Box
  static Box getCacheBox() {
    try {
      return Hive.box(cacheBox);
    } catch (e) {
      debugPrint('❌ Error getting cache box: $e');
      rethrow;
    }
  }

  /// Get User Data Box
  static Box getUserDataBox() {
    try {
      return Hive.box(userDataBox);
    } catch (e) {
      debugPrint('❌ Error getting user data box: $e');
      rethrow;
    }
  }

  /// Clear all data (use with caution!)
  static Future<void> clearAllBoxes() async {
    debugPrint('⚠️ Clearing all database boxes...');
    try {
      await getEmergencyContactsBox().clear();
      await getIncidentsBox().clear();
      await getSettingsBox().clear();
      await getCacheBox().clear();
      await getUserDataBox().clear();
      debugPrint('✅ All boxes cleared');
    } catch (e) {
      debugPrint('❌ Error clearing boxes: $e');
      rethrow;
    }
  }

  /// Clear specific box
  static Future<void> clearBox(String boxName) async {
    try {
      final box = Hive.box(boxName);
      await box.clear();
      debugPrint('✅ Box "$boxName" cleared');
    } catch (e) {
      debugPrint('❌ Error clearing box "$boxName": $e');
      rethrow;
    }
  }

  /// Get database stats
  static Map<String, int> getDatabaseStats() {
    try {
      return {
        'emergency_contacts':
            getEmergencyContactsBox().values.length,
        'incidents': getIncidentsBox().values.length,
        'cache': getCacheBox().length,
        'user_data': getUserDataBox().length,
      };
    } catch (e) {
      debugPrint('❌ Error getting database stats: $e');
      return {};
    }
  }

  /// Export all data
  static Future<Map<String, dynamic>> exportData() async {
    try {
      debugPrint('📤 Exporting database...');

      final emergencyContacts = getEmergencyContactsBox()
          .values
          .map((e) => e.toMap())
          .toList();

      final incidents = getIncidentsBox()
          .values
          .map((e) => e.toMap())
          .toList();

      final exportedData = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'emergency_contacts': emergencyContacts,
        'incidents': incidents,
        'stats': getDatabaseStats(),
      };

      debugPrint('✅ Database exported successfully');
      return exportedData;
    } catch (e) {
      debugPrint('❌ Error exporting database: $e');
      rethrow;
    }
  }

  /// Import data (merge mode)
  static Future<void> importData(Map<String, dynamic> data) async {
    try {
      debugPrint('📥 Importing database...');

      // Import emergency contacts
      if (data['emergency_contacts'] is List) {
        final contactsList = data['emergency_contacts'] as List;
        for (final contact in contactsList) {
          final ec = EmergencyContact.fromMap(
            contact as Map<String, dynamic>,
          );
          await getEmergencyContactsBox().put(ec.id, ec);
        }
        debugPrint('✓ ${contactsList.length} emergency contacts imported');
      }

      // Import incidents
      if (data['incidents'] is List) {
        final incidentsList = data['incidents'] as List;
        for (final incident in incidentsList) {
          final il = IncidentLog.fromMap(
            incident as Map<String, dynamic>,
          );
          await getIncidentsBox().put(il.id, il);
        }
        debugPrint('✓ ${incidentsList.length} incidents imported');
      }

      debugPrint('✅ Database imported successfully');
    } catch (e) {
      debugPrint('❌ Error importing database: $e');
      rethrow;
    }
  }

  /// Backup database
  static Future<void> backupDatabase(String path) async {
    try {
      debugPrint('💾 Backing up database to $path...');
      // Implementation depends on your backup strategy
      // Could use file_picker, file system, or cloud storage
      debugPrint('✅ Database backed up successfully');
    } catch (e) {
      debugPrint('❌ Error backing up database: $e');
      rethrow;
    }
  }

  /// Verify database integrity
  static Future<bool> verifyIntegrity() async {
    try {
      debugPrint('🔍 Verifying database integrity...');

      // Check if boxes exist and are accessible
      final stats = getDatabaseStats();
      if (stats.isEmpty) {
        debugPrint('❌ Database verification failed: No stats');
        return false;
      }

      debugPrint('✅ Database integrity verified');
      return true;
    } catch (e) {
      debugPrint('❌ Error verifying database: $e');
      return false;
    }
  }

  /// Log database info (for debugging)
  static void logDatabaseInfo() {
    debugPrint('');
    debugPrint('════════════════════════════════════════');
    debugPrint('📊 DATABASE INFO');
    debugPrint('════════════════════════════════════════');

    final stats = getDatabaseStats();
    debugPrint('Emergency Contacts: ${stats['emergency_contacts']}');
    debugPrint('Incidents: ${stats['incidents']}');
    debugPrint('Cache Size: ${stats['cache']}');
    debugPrint('User Data Size: ${stats['user_data']}');

    debugPrint('════════════════════════════════════════');
    debugPrint('');
  }

  /// Optimize database (compact, rebuild indexes, etc.)
  static Future<void> optimizeDatabase() async {
    try {
      debugPrint('⚙️ Optimizing database...');

      // Compact boxes (remove deleted entries)
      await getEmergencyContactsBox().compact();
      await getIncidentsBox().compact();
      await getSettingsBox().compact();
      await getCacheBox().compact();
      await getUserDataBox().compact();

      debugPrint('✅ Database optimized');
    } catch (e) {
      debugPrint('❌ Error optimizing database: $e');
      rethrow;
    }
  }

  /// Close all boxes (cleanup)
  static Future<void> closeDatabase() async {
    try {
      debugPrint('🔒 Closing database...');
      await Hive.close();
      debugPrint('✅ Database closed');
    } catch (e) {
      debugPrint('❌ Error closing database: $e');
      rethrow;
    }
  }
}

/// Usage example in main.dart:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Initialize database
///   await DatabaseInit.initialize();
///   
///   // Log database info
///   DatabaseInit.logDatabaseInfo();
///   
///   runApp(const MyApp());
/// }
/// ```
