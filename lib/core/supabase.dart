import 'package:supabase_flutter/supabase_flutter.dart';

/// Convenience accessor — everywhere else does `sb.from(...)` or `sb.auth`.
SupabaseClient get sb => Supabase.instance.client;
