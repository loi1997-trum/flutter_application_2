import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/tour_model.dart';
import '../models/trip_model.dart';

// ================================================================
// API SERVICE
// ================================================================

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  // ----------------------------------------------------------------
  // HELPER - safe request với xử lý lỗi đầy đủ
  // ----------------------------------------------------------------
  static Future<http.Response> _safeGet(String url,
      {Map<String, String>? headers}) async {
    try {
      return await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw Exception('Không có kết nối internet');
    } on TimeoutException {
      throw Exception('Kết nối quá chậm, thử lại sau');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  static Future<http.Response> _safePost(String url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      return await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw Exception('Không có kết nối internet');
    } on TimeoutException {
      throw Exception('Kết nối quá chậm, thử lại sau');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  static Future<http.Response> _safePut(String url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      return await http
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw Exception('Không có kết nối internet');
    } on TimeoutException {
      throw Exception('Kết nối quá chậm, thử lại sau');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  static Future<http.Response> _safeDelete(String url,
      {Map<String, String>? headers}) async {
    try {
      return await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw Exception('Không có kết nối internet');
    } on TimeoutException {
      throw Exception('Kết nối quá chậm, thử lại sau');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  // ----------------------------------------------------------------
  // HELPER - auth headers
  // ----------------------------------------------------------------
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ================================================================
  // TOKEN & USER ID
  // ================================================================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ================================================================
  // API #1 - AUTH: ĐĂNG KÝ
  // POST /api/auth/register
  // ================================================================
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final res = await _safePost(
        '$baseUrl/auth/register',
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      final data = json.decode(res.body);
      // Parse sang UserModel nếu thành công
      if (data['success'] == true && data['user'] != null) {
        data['userModel'] = UserModel.fromJson({
          ...data['user'],
          'token': data['token'],
        });
      }
      return data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================================================================
  // API #2 - AUTH: ĐĂNG NHẬP
  // POST /api/auth/login
  // ================================================================
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final res = await _safePost(
        '$baseUrl/auth/login',
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      final data = json.decode(res.body);
      if (data['success'] == true && data['user'] != null) {
        data['userModel'] = UserModel.fromJson({
          ...data['user'],
          'token': data['token'],
        });
      }
      return data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================================================================
  // API #3 - AUTH: XEM PROFILE
  // GET /api/auth/profile  (cần token)
  // ================================================================
  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final res = await _safeGet(
        '$baseUrl/auth/profile',
        headers: await _authHeaders(),
      );
      return json.decode(res.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================================================================
  // API #4 - AUTH: CẬP NHẬT PROFILE
  // PUT /api/auth/profile  (cần token)
  // ================================================================
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final res = await _safePut(
        '$baseUrl/auth/profile',
        headers: await _authHeaders(),
        body: json.encode({
          'name': name,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
        }),
      );
      return json.decode(res.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================================================================
  // API #5 - TOURS: DANH SÁCH TOURS
  // GET /api/tours?category=beach&minPrice=100000&maxPrice=900000
  // ================================================================
  static Future<List<TourModel>> getTours({
    String? category,
    int? minPrice,
    int? maxPrice,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final params = <String, String>{
        'page': '$page',
        'limit': '$limit',
        if (category != null) 'category': category,
        if (minPrice != null) 'minPrice': '$minPrice',
        if (maxPrice != null) 'maxPrice': '$maxPrice',
      };
      final uri =
          Uri.parse('$baseUrl/tours').replace(queryParameters: params);
      final res = await _safeGet(uri.toString());
      final data = json.decode(res.body);
      final list = data['tours'] as List? ?? [];
      return list.map((e) => TourModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // ================================================================
  // API #6 - TOURS: CHI TIẾT TOUR
  // GET /api/tours/:id
  // ================================================================
  static Future<TourModel?> getTourById(String id) async {
    try {
      final res = await _safeGet('$baseUrl/tours/$id');
      final data = json.decode(res.body);
      return data['success'] == true
          ? TourModel.fromJson(data['tour'])
          : null;
    } catch (e) {
      return null;
    }
  }

  // ================================================================
  // API #7 - TRIPS: LẤY TRIPS CỦA USER
  // GET /api/trips?userId=xxx&status=upcoming
  // ================================================================
  static Future<List<TripModel>> getTrips(String userId,
      {String? status}) async {
    try {
      final params = <String, String>{
        'userId': userId,
        if (status != null) 'status': status,
      };
      final uri =
          Uri.parse('$baseUrl/trips').replace(queryParameters: params);
      final res = await _safeGet(uri.toString());
      final data = json.decode(res.body);
      final list = data['trips'] as List? ?? [];
      return list.map((e) => TripModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Lỗi kết nối hoặc máy chủ: $e');
    }
  }

  // ================================================================
  // API #8 - TRIPS: TẠO TRIP MỚI
  // POST /api/trips
  // ================================================================
  static Future<Map<String, dynamic>> createTrip({
    required String userId,
    required String title,
    required String location,
    required String startDate,
    required String endDate,
    String notes = '',
    String status = 'upcoming',
    String guide = '',
    double price = 0,
  }) async {
    try {
      final res = await _safePost(
        '$baseUrl/trips',
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'title': title,
          'location': location,
          'startDate': startDate,
          'endDate': endDate,
          'notes': notes,
          'status': status,
          'guide': guide,
          'price': price,
        }),
      );
      final data = json.decode(res.body);
      // Parse sang TripModel nếu thành công
      if (data['success'] == true && data['trip'] != null) {
        data['tripModel'] = TripModel.fromJson(data['trip']);
      }
      return data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================================================================
  // API #9 - TRIPS: CẬP NHẬT TRIP
  // PUT /api/trips/:id
  // ================================================================
  static Future<Map<String, dynamic>> updateTrip(
      String tripId, Map<String, dynamic> data) async {
    try {
      final res = await _safePut(
        '$baseUrl/trips/$tripId',
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return json.decode(res.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================================================================
  // API #10 - TRIPS: XÓA TRIP
  // DELETE /api/trips/:id
  // ================================================================
  static Future<bool> deleteTrip(String tripId) async {
    try {
      final res = await _safeDelete('$baseUrl/trips/$tripId');
      final data = json.decode(res.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // ================================================================
  // BONUS #1 - WEATHER: THỜI TIẾT
  // GET /api/weather?city=Da Nang
  // ================================================================
  static Future<Map<String, dynamic>?> getWeather(String city) async {
    try {
      final res = await _safeGet(
        '$baseUrl/weather?city=${Uri.encodeComponent(city)}',
      );
      return json.decode(res.body);
    } catch (e) {
      return null;
    }
  }

  // ================================================================
  // BONUS #2 - CURRENCY: ĐỔI TIỀN TỆ
  // GET /api/currency?from=USD&to=VND&amount=100
  // ================================================================
  static Future<Map<String, dynamic>?> getCurrency({
    String from = 'USD',
    String to = 'VND',
    double amount = 1,
  }) async {
    try {
      final res = await _safeGet(
        '$baseUrl/currency?from=$from&to=$to&amount=$amount',
      );
      return json.decode(res.body);
    } catch (e) {
      return null;
    }
  }

  // ================================================================
  // BONUS #3 - PLACES: TÌM ĐỊA ĐIỂM
  // GET /api/places?query=bãi biển đà nẵng
  // ================================================================
  static Future<List<dynamic>> getPlaces(String query) async {
    try {
      final res = await _safeGet(
        '$baseUrl/places?query=${Uri.encodeComponent(query)}',
      );
      final data = json.decode(res.body);
      return data['places'] ?? [];
    } catch (e) {
      return [];
    }
  }

  // ================================================================
  // BONUS #4 - UNSPLASH: TÌM ẢNH
  // GET /api/unsplash?query=da nang&count=10
  // ================================================================
  static Future<List<dynamic>> getPhotos(String query,
      {int count = 10}) async {
    try {
      final res = await _safeGet(
        '$baseUrl/unsplash?query=${Uri.encodeComponent(query)}&count=$count',
      );
      final data = json.decode(res.body);
      return data['photos'] ?? [];
    } catch (e) {
      return [];
    }
  }
}