import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class SupabaseService {
  static SupabaseClient? _client;

  /// Initialize Supabase client
  static Future<void> initialize() async {
    await dotenv.load();

    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Supabase credentials not found in .env file');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _client = Supabase.instance.client;
  }

  /// Get Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
          'Supabase client not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Register a new user
  static Future<void> registerUser(
      String name, String email, String password) async {
    try {
      final response = await client.auth
          .signUp(password: password, email: email, data: {'full_name': name});

      if (response.user == null) {
        throw Exception('Error in registration!');
      }
    } catch (e) {
      throw Exception('Error in registration!');
    }
  }

  /// Sign in an existing user
  static Future<void> signInUser(String email, String password) async {
    try {
      final response = await client.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) {
        throw Exception('Invalid credentials!');
      }
      //Consider returning user data
    } catch (e) {
      throw Exception('Error signing in!');
    }
  }

  /// Send password reset email
  static Future<void> resetPassword(String email) async {
    try {
      final _ = await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Error resetting password!');
    }
  }

  /// Log out the current user
  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Error signing out!');
    }
  }

  /// Fetch all rows from a table
  static Future<List<Map<String, dynamic>>> fetchAll(String tableName) async {
    try {
      final response = await client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  /// Fetch rows from a table with a filter
  static Future<List<Map<String, dynamic>>> fetchWhere(
      String tableName, String column, dynamic value) async {
    try {
      final response = await client.from(tableName).select().eq(column, value);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  /// Fetch rows from a table within a date range
  static Future<List<Map<String, dynamic>>> fetchByDateRange(
      String tableName, String dateColumn, DateTime startDate, DateTime endDate,
      {String? orderBy, bool? ascending}) async {
    try {
      final dateFormatter = DateFormat('yyyy-MM-dd');
      final formattedStartDate = dateFormatter.format(startDate);
      final formattedEndDate = dateFormatter.format(endDate);

      final response = await client
          .from(tableName)
          .select()
          .gte(dateColumn, formattedStartDate)
          .lte(dateColumn, formattedEndDate)
          .order(orderBy ?? 'id', ascending: ascending ?? true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching data by date range: $e');
    }
  }

  /// Insert a row into a table
  static Future<Map<String, dynamic>> insert(
      String tableName, Map<String, dynamic> data) async {
    try {
      final response = await client.from(tableName).insert(data).select();
      return response.first;
    } catch (e) {
      throw Exception('Error inserting data: $e');
    }
  }

  /// Insert a row into a table
  static Future<void> insertRows(String tableName, List data) async {
    try {
      final _ = await client.from(tableName).insert(data);
    } catch (e) {
      throw Exception('Error inserting data: $e');
    }
  }

  /// Update a row in a table
  static Future<Map<String, dynamic>> update(String tableName, String idColumn,
      dynamic idValue, Map<String, dynamic> data) async {
    try {
      final response = await client
          .from(tableName)
          .update(data)
          .eq(idColumn, idValue)
          .select();
      return response.first;
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  /// Delete a row from a table
  static Future<void> delete(
      String tableName, String column, dynamic value) async {
    try {
      await client.from(tableName).delete().eq(column, value);
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }
}
