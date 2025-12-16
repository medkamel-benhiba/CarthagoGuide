import 'dart:async';
import 'dart:convert';
import 'package:CarthagoGuide/models/guestHouse.dart';
import 'package:CarthagoGuide/models/hotel_details.dart';
import 'package:CarthagoGuide/models/state.dart';
import 'package:CarthagoGuide/models/voyage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../models/artisanat.dart';
import '../models/destination.dart';
import '../models/event.dart';
import '../models/festival.dart';
import '../models/hotel.dart';
import '../models/monument.dart';
import '../models/musee.dart';
import '../models/restaurant.dart';


class ApiService {
  static const String _baseUrl = 'https://7test.tunisiagotravel.com';
  final String _cachevoy = 'cached_voyages';

  Future<List<Destination>> getDestinations() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/utilisateur/alldestinations'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['destinations'];
      return data.map((json) => Destination.fromJson(json)).toList();
    } else {
      print('Failed to load destinations');
      throw Exception('Failed to load destinations');
    }
  }

  Future<List<StateApp>> fetchStates() async {
    final response = await http.get(Uri.parse("$_baseUrl/utilisateur/states"));
    print("fetching states....");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List statesJson = data['states'] ?? [];
      return statesJson.map((json) => StateApp.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors du chargement des states");

    }

  }


Future<List<Hotel>> gethotels() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/allhotels'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['hotels'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['hotels'] is List) {
          return (jsonData['hotels'] as List)
              .map((hotel) => Hotel.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['hotels']}");
        }
      } else {
        throw Exception("Failed to fetch hotels: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in gethotels: $e");
      print("StackTrace: $stackTrace");
      return [];
    }
  }

  Future<HotelDetail?> gethoteldetail(String slug) async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/hoteldetail/$slug'));
      print('$_baseUrl/utilisateur/hoteldetail/$slug');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['hotels'] == null) {
          throw Exception("API returned null data");
        }
        final List<dynamic>? hotels = jsonData['hotels'];

        final firstHotel = hotels!.first;

        if (firstHotel != null) {
          return HotelDetail.fromJson(firstHotel);
        } else {
          throw Exception("Unexpected data format: ${jsonData['hotels']}");
        }
      } else {
        throw Exception("Failed to fetch hotels: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in gethotels: $e");
      print("StackTrace: $stackTrace");
      return null;
    }
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/allrestaurants'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['restaurants'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['restaurants'] is List) {
          return (jsonData['restaurants'] as List)
              .map((r) => Restaurant.fromJson(r))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['restaurants']}");
        }
      } else {
        throw Exception("Failed to fetch restaurants: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getAllRestaurants: $e");
      print("StackTrace: $stackTrace");
      return []; // Return empty list on failure
    }
  }

  Future<List<GuestHouse>> getmaisons() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/allmaison'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['maisons'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['maisons'] is List) {
          return (jsonData['maisons'] as List)
              .map((hotel) => GuestHouse.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['maisons']}");
        }
      } else {
        throw Exception("Failed to fetch maisons: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getMaison: $e");
      print("StackTrace: $stackTrace");
      return []; // Return empty list on failure
    }
  }

  Future<List<Activity>> getallactivities() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/allactivity'));
      print('$_baseUrl/utilisateur/allactivity');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['activety'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['activety']['data'] is List) {
          return (jsonData['activety']['data'] as List)
              .map((hotel) => Activity.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['events']}");
        }
      } else {
        throw Exception("Failed to fetch events: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getallactivitys: $e");
      print("StackTrace: $stackTrace");
      return []; // Return empty list on failure
    }
  }

  Future<List<Event>> getallevents() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/allevent'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['events'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['events']['data'] is List) {
          return (jsonData['events']['data'] as List)
              .map((hotel) => Event.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['events']}");
        }
      } else {
        throw Exception("Failed to fetch events: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getallevents: $e");
      print("StackTrace: $stackTrace");
      return [];
    }
  }



  Future<List<Musees>> getmusee() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/musees'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['musees'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['musees']['data'] is List) {
          return (jsonData['musees']['data'] as List)
              .map((hotel) => Musees.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['musees']}");
        }
      } else {
        throw Exception("Failed to fetch musees: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getmusees: $e");
      print("StackTrace: $stackTrace");
      return [];
    }
  }

  Future<List<Artisanat>> getArtisanat() async {
    try {
      final response =
      await http.get(Uri.parse('$_baseUrl/utilisateur/artisanat'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['data'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((hotel) => Artisanat.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected artisanat format: ${jsonData['data']}");
        }
      } else {
        throw Exception("Failed to fetch artisanat: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getartisanat: $e");
      print("StackTrace: $stackTrace");
      return []; // Return empty list on failure
    }
  }

  Future<List<Monument>> getmonument(String page) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/utilisateur/monument?page=$page'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['monument'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['monument']['data'] is List) {
          return (jsonData['monument']['data'] as List)
              .map((hotel) => Monument.fromJson(hotel))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['monument']}");
        }
      } else {
        throw Exception("Failed to fetch musees: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getmonument: $e");
      print("StackTrace: $stackTrace");
      return []; // Return empty list on failure
    }
  }

  Future<List<Festival>> getfestival([String page = "1"]) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/utilisateur/festival?page=$page'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['festival'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['festival']['data'] is List) {
          return (jsonData['festival']['data'] as List)
              .map((festival) => Festival.fromJson(festival))
              .toList();
        } else {
          throw Exception("Unexpected data format: ${jsonData['festival']}");
        }
      } else {
        throw Exception("Failed to fetch festival: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getfestival: $e");
      print("StackTrace: $stackTrace");
      return [];
    }
  }

  Future<Musees> getMuseeBySlug(String slug) async {
    try {
      final encodedSlug = Uri.encodeComponent(slug);
      final url = Uri.parse('$_baseUrl/utilisateur/musees/$encodedSlug'); // note le chemin
      final response = await http.get(url);

      print("Request URL: $url");
      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        return Musees.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Musée introuvable pour le slug: $slug');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print("Erreur getMuseeBySlug: $e");
      print("StackTrace: $stackTrace");
      rethrow;
    }
  }

  Future<Monument> getMonumentBySlug(String slug) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/monument/$slug'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Monument.fromJson(data['monument'] ?? data);
    } else {
      throw Exception('Failed to load monument: ${response.statusCode}');
    }
  }

  Future<Artisanat> getArtisanatBySlug(String slug) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/artisanat/$slug'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Artisanat.fromJson(data['artisanat'] ?? data);
    } else {
      throw Exception('Failed to load artisanat: ${response.statusCode}');
    }
  }

  /*
  Future<List<Agil>> getagil() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/utilisateur/agil'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['agil'] == null) {
          throw Exception("API returned null agil");
        }

        if (jsonData['agil'] is List) {
          return (jsonData['agil'] as List)
              .map((agil) => Agil.fromJson(agil))
              .toList();
        } else {
          throw Exception("Unexpected agil format: ${jsonData['agil']}");
        }
      } else {
        throw Exception("Failed to fetch agil: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getagil: $e");
      print("StackTrace: $stackTrace");
      return []; 
    }
  }
*/


  Future<List<Restaurant>> getRestaurantsByState(String state) async {
    final uri = Uri.parse('$_baseUrl/utilisateur/restaurantsbystate/$state');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List<dynamic> list = decoded['restaurants']?['data'] ?? [];

      return list.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<List<Hotel>> getHotelsByState(String state) async {
    final uri = Uri.parse('$_baseUrl/utilisateur/hotelsbystate/$state');
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print("*************hotels by state ${response.contentLength}");
      final List<dynamic> list = decoded['hotels']?['data'] ?? [];

      return list.map((e) => Hotel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<List<Voyage>> getAllVoyage() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/utilisateur/voyages'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null || jsonData['voyages'] == null) {
          throw Exception("API returned null data");
        }

        if (jsonData['voyages'] is List) {
          final voyages = (jsonData['voyages'] as List)
              .map((v) => Voyage.fromJson(v))
              .toList();

          // Save to SharedPreferences cache
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(_cachevoy, jsonEncode(voyages.map((v) => v.toJson()).toList()));

          return voyages;
        } else {
          throw Exception("Unexpected data format: ${jsonData['voyages']}");
        }
      } else {
        throw Exception("Failed to fetch voyages: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error in getAllVoyage: $e");
      print("StackTrace: $stackTrace");

      // Try to load cached voyages if API fails
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cachevoy);
      if (cachedData != null) {
        try {
          final List jsonList = jsonDecode(cachedData);
          return jsonList.map((v) => Voyage.fromJson(v)).toList();
        } catch (_) {
          print("Failed to load cached voyages");
        }
      }
      return [];
    }
  }
}
