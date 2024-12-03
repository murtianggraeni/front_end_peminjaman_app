// current_monitoring_controller.dart

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:build_app/enums/machine_type.dart';
import 'package:build_app/models/currentMonitoring_model.dart';
import 'package:build_app/provider/api.dart';

// current_monitoring_controller.dart

class CurrentMonitoringController extends GetxController {
  // Logger setup
  final _logger = Logger('CurrentMonitoringController');

  // API Controller for HTTP fallback
  final ApiController _apiController = ApiController();

  // Connection states
  var isLoading = false.obs;
  var isConnected = false.obs;
  var error = ''.obs;
  final connectionStatus = Rx<ConnectionStatus>(ConnectionStatus.disconnected);

  // WebSocket configuration constants
  static const String baseUrl = "kh8ppwzx-5000.asse.devtunnels.ms";
  static const int wsPort = 5000;
  static const Duration pingInterval = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 5);
  static const int maxReconnectAttempts = 5;

  // Connection management variables
  WebSocket? rawSocket;
  IOWebSocketChannel? channel;
  Timer? pingTimer;
  Timer? reconnectTimer;
  Timer? autoRefreshTimer;
  int reconnectAttempts = 0;
  bool isReconnecting = false;

  // Current data variable
  var currentData = CurrentMonitoring(
    success: false,
    statusCode: 0,
    data: Data(current: 0.0, waktu: DateTime.now()),
  ).obs;

  // Machine type - non-nullable and required
  final MachineType machineType;

  // Constructor to initialize machine type with a required parameter
  CurrentMonitoringController({required this.machineType}) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  @override
  void onInit() {
    super.onInit();
    initializeConnection();
  }

  // Initialize connection with WebSocket and HTTP polling as fallback
  void initializeConnection() {
    startDataPolling(); // Start HTTP polling initially
    Future.delayed(Duration(seconds: 2), initializeWebSocket); // Attempt WebSocket connection after delay
  }

  // WebSocket connection initializer
  Future<void> initializeWebSocket() async {
    if (isReconnecting) return;

    try {
      isReconnecting = true;
      isLoading(true);
      await _closeConnection();

      final wsUrl = _buildWebSocketUrl();
      _logger.info('Connecting to WebSocket: $wsUrl');

      rawSocket = await WebSocket.connect(
        wsUrl,
        headers: {
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },
      ).timeout(connectionTimeout);

      rawSocket!.pingInterval = pingInterval;
      channel = IOWebSocketChannel(rawSocket!);

      _setupWebSocketListeners();
      _setupPingMechanism();

      isConnected(true);
      connectionStatus.value = ConnectionStatus.connected;
      error('');
      reconnectAttempts = 0;

      _logger.info('WebSocket connected successfully');
    } catch (e) {
      _logger.warning('Connection error: $e');
      _handleConnectionError('Connection failed');
    } finally {
      isReconnecting = false;
      isLoading(false);
    }
  }

  // Builds the WebSocket URL based on the machine type
  String _buildWebSocketUrl() {
    final typeString = machineType.toApiString();
    return 'ws://$baseUrl:$wsPort/sensor/$typeString/updateCurrent';
  }

  // Sets up WebSocket listeners for messages, errors, and close events
  void _setupWebSocketListeners() {
    channel?.stream.listen(
      (data) {
        try {
          _logger.fine('Received WebSocket data: $data');
          final parsedData = jsonDecode(data);

          if (parsedData['type'] == 'pong') {
            _logger.fine('Received pong response');
            return;
          }

          currentData.value = CurrentMonitoring.fromJson(parsedData);
          isConnected(true);
          error('');
          currentData.value.data.waktu = DateTime.now();
        } catch (e) {
          _logger.warning('Error processing data: $e');
          error.value = 'Data processing error';
        }
      },
      onError: (error) {
        _logger.warning('WebSocket stream error: $error');
        _handleConnectionError('Stream error occurred');
      },
      onDone: _handleConnectionClosed,
      cancelOnError: false,
    );
  }

  // Sets up a ping mechanism to keep WebSocket connection alive
  void _setupPingMechanism() {
    pingTimer?.cancel();
    pingTimer = Timer.periodic(pingInterval, (timer) {
      if (channel?.sink != null && isConnected.value) {
        try {
          channel?.sink.add(jsonEncode({
            'type': 'ping',
            'timestamp': DateTime.now().toIso8601String(),
          }));
          _logger.fine('Ping sent');
        } catch (e) {
          _logger.warning('Error sending ping: $e');
          _handleConnectionError('Failed to send ping');
        }
      }
    });
  }

  // Start HTTP polling as a fallback if WebSocket connection fails
  void startDataPolling() {
    autoRefreshTimer?.cancel(); // Cancel existing timer if any

    // Initial fetch
    refreshData();

    // Start periodic polling every 5 seconds
    autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!isConnected.value) {
        await refreshData();
      }
    });
  }

  // Fetch the latest data via HTTP polling
  Future<void> refreshData() async {
    if (isLoading.value) return;

    try {
      isLoading(true);
      final apiUrl = '$baseUrl/sensor/${machineType.toApiString()}/current';
      _logger.info("Polling URL: $apiUrl");

      final response = await _apiController
          .getLatestCurrent(machineType.toApiString())
          .timeout(connectionTimeout);

      _logger.info('Polling response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        currentData.value = CurrentMonitoring.fromJson(parsedData);
        error('');
        currentData.value.data.waktu = DateTime.now();
      } else {
        _logger.warning('Server returned ${response.statusCode}');
        error.value = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      _logger.warning('Error polling data: $e');
      error.value = 'Failed to update data';
    } finally {
      isLoading(false);
    }
  }

  // Handle connection errors and manage reconnection attempts
  void _handleConnectionError(String message) {
    isConnected(false);
    connectionStatus.value = ConnectionStatus.error;
    error.value = message;

    if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
      reconnectAttempts++;
      _scheduleReconnection();
    } else {
      startDataPolling();
    }
  }

  // Method to handle connection closure
  void _handleConnectionClosed() {
    isConnected(false);
    connectionStatus.value = ConnectionStatus.disconnected;
    _logger.info('WebSocket connection closed');

    if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
      _scheduleReconnection();
    } else {
      startDataPolling(); // Switch to polling if reconnection attempts fail
    }
  }

  // Schedule reconnection attempt with exponential backoff
  void _scheduleReconnection() {
    reconnectTimer?.cancel();
    final delay = Duration(seconds: min(pow(2, reconnectAttempts).toInt(), 30));
    _logger.info('Scheduling reconnection attempt in ${delay.inSeconds} seconds');

    reconnectTimer = Timer(delay, () {
      if (!isConnected.value && !isReconnecting) {
        initializeWebSocket();
      }
    });
  }

  // Closes connection and cleans up resources
  Future<void> _closeConnection() async {
    try {
      pingTimer?.cancel();
      await channel?.sink.close();
      await rawSocket?.close();
      channel = null;
      rawSocket = null;
      isConnected(false);
      connectionStatus.value = ConnectionStatus.disconnected;
    } catch (e) {
      _logger.warning('Error closing connection: $e');
    }
  }

  @override
  void onClose() {
    stopDataPolling();
    _closeConnection();
    pingTimer?.cancel();
    reconnectTimer?.cancel();
    autoRefreshTimer?.cancel();
    super.onClose();
  }

  // Method to stop polling when WebSocket is active
  void stopDataPolling() {
    autoRefreshTimer?.cancel();
    autoRefreshTimer = null;
  }
}

enum ConnectionStatus { connected, disconnected, error }

// class CurrentMonitoringController extends GetxController {
//   // Logger setup
//   final _logger = Logger('CurrentMonitoringController');

//   // API Controller for HTTP fallback
//   final ApiController _apiController = ApiController();

//   // Connection states
//   var isLoading = false.obs;
//   var isConnected = false.obs;
//   var error = ''.obs;
//   final connectionStatus = Rx<ConnectionStatus>(ConnectionStatus.disconnected);

//   // WebSocket configuration constants
//   static const String baseUrl = "kh8ppwzx-5000.asse.devtunnels.ms";
//   static const int wsPort = 5000;
//   static const Duration pingInterval = Duration(seconds: 30);
//   static const Duration connectionTimeout = Duration(seconds: 5);
//   static const int maxReconnectAttempts = 5;

//   // Connection management variables
//   WebSocket? rawSocket;
//   IOWebSocketChannel? channel;
//   Timer? pingTimer;
//   Timer? reconnectTimer;
//   Timer? autoRefreshTimer;
//   int reconnectAttempts = 0;
//   bool isReconnecting = false;

//   // Current data variable
//   var currentData = CurrentMonitoring(
//     success: false,
//     statusCode: 0,
//     data: Data(current: 0.0, waktu: DateTime.now()),
//   ).obs;

//   // Machine type - non-nullable and required
//   final MachineType machineType;

//   // Constructor to initialize machine type with a required parameter
//   CurrentMonitoringController({required this.machineType}) {
//     // Initialize logger
//     Logger.root.level = Level.ALL;
//     Logger.root.onRecord.listen((record) {
//       print('${record.level.name}: ${record.time}: ${record.message}');
//     });
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     initializeConnection();
//   }

//   // Initialize connection with WebSocket and HTTP polling as fallback
//   void initializeConnection() {
//     startDataPolling(); // Start HTTP polling initially
//     Future.delayed(Duration(seconds: 2), initializeWebSocket); // Attempt WebSocket connection after delay
//   }

//   // WebSocket connection initializer
//   Future<void> initializeWebSocket() async {
//     if (isReconnecting) return;

//     try {
//       isReconnecting = true;
//       isLoading(true);
//       await _closeConnection();

//       final wsUrl = _buildWebSocketUrl();
//       _logger.info('Connecting to WebSocket: $wsUrl');

//       rawSocket = await WebSocket.connect(
//         wsUrl,
//         headers: {
//           'Connection': 'Upgrade',
//           'Upgrade': 'websocket',
//           'Cache-Control': 'no-cache',
//           'Pragma': 'no-cache',
//         },
//       ).timeout(connectionTimeout);

//       rawSocket!.pingInterval = pingInterval;
//       channel = IOWebSocketChannel(rawSocket!);

//       _setupWebSocketListeners();
//       _setupPingMechanism();

//       isConnected(true);
//       connectionStatus.value = ConnectionStatus.connected;
//       error('');
//       reconnectAttempts = 0;

//       _logger.info('WebSocket connected successfully');
//     } catch (e) {
//       _logger.warning('Connection error: $e');
//       _handleConnectionError('Connection failed');
//     } finally {
//       isReconnecting = false;
//       isLoading(false);
//     }
//   }

//   // Builds the WebSocket URL based on the machine type
//   String _buildWebSocketUrl() {
//     final typeString = machineType.toApiString();
//     return 'ws://$baseUrl:$wsPort/sensor/$typeString/updateCurrent';
//   }

//   // Sets up WebSocket listeners for messages, errors, and close events
//   void _setupWebSocketListeners() {
//     channel?.stream.listen(
//       (data) {
//         try {
//           _logger.fine('Received WebSocket data: $data');
//           final parsedData = jsonDecode(data);

//           if (parsedData['type'] == 'pong') {
//             _logger.fine('Received pong response');
//             return;
//           }

//           currentData.value = CurrentMonitoring.fromJson(parsedData);
//           isConnected(true);
//           error('');
//           currentData.value.data.waktu = DateTime.now();
//         } catch (e) {
//           _logger.warning('Error processing data: $e');
//           error.value = 'Data processing error';
//         }
//       },
//       onError: (error) {
//         _logger.warning('WebSocket stream error: $error');
//         _handleConnectionError('Stream error occurred');
//       },
//       onDone: () {
//         _logger.info('WebSocket connection closed');
//         _handleConnectionClosed();
//       },
//       cancelOnError: false,
//     );
//   }

//   // Sets up a ping mechanism to keep WebSocket connection alive
//   void _setupPingMechanism() {
//     pingTimer?.cancel();
//     pingTimer = Timer.periodic(pingInterval, (timer) {
//       if (channel?.sink != null && isConnected.value) {
//         try {
//           channel?.sink.add(jsonEncode({
//             'type': 'ping',
//             'timestamp': DateTime.now().toIso8601String(),
//           }));
//           _logger.fine('Ping sent');
//         } catch (e) {
//           _logger.warning('Error sending ping: $e');
//           _handleConnectionError('Failed to send ping');
//         }
//       }
//     });
//   }

//   // New startDataPolling method for HTTP polling
//   void startDataPolling() {
//     autoRefreshTimer?.cancel(); // Cancel existing timer if any

//     // Initial fetch
//     refreshData();

//     // Start periodic polling every 5 seconds
//     autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
//       if (!isConnected.value) {
//         await refreshData();
//       }
//     });
//   }

//   // Handles connection errors and manages reconnection attempts
//   void _handleConnectionError(String message) {
//     isConnected(false);
//     connectionStatus.value = ConnectionStatus.error;
//     error.value = message;

//     if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
//       reconnectAttempts++;
//       _scheduleReconnection();
//     } else {
//       _startPolling();
//     }
//   }

//   // Handle WebSocket disconnection, attempt reconnection or switch to polling
//   void _handleConnectionClosed() {
//     isConnected(false);
//     connectionStatus.value = ConnectionStatus.disconnected;

//     if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
//       _scheduleReconnection();
//     } else {
//       _startPolling();
//     }
//   }

//   // Schedule reconnection attempt with exponential backoff
//   void _scheduleReconnection() {
//     reconnectTimer?.cancel();
//     final delay = Duration(seconds: min(pow(2, reconnectAttempts).toInt(), 30));
//     _logger.info('Scheduling reconnection attempt in ${delay.inSeconds} seconds');

//     reconnectTimer = Timer(delay, () {
//       if (!isConnected.value && !isReconnecting) {
//         initializeWebSocket();
//       }
//     });
//   }

//   // Start HTTP polling as a fallback if WebSocket connection fails
//   void _startPolling() {
//     _logger.info('Starting polling mechanism');
//     error.value = 'WebSocket disconnected - Using polling';
//     _setupAutoRefresh();
//   }

//   // Set up periodic HTTP polling to fetch the latest data
//   void _setupAutoRefresh() {
//     autoRefreshTimer?.cancel();
//     autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       if (!isConnected.value) {
//         await refreshData();
//       }
//     });
//   }

//   // Fetch the latest data via HTTP polling
//   Future<void> refreshData() async {
//     if (isLoading.value) return;

//     try {
//       isLoading(true);
//       final response = await _apiController
//           .getLatestCurrent(machineType.toApiString())
//           .timeout(connectionTimeout);

//       if (response.statusCode == 200) {
//         final parsedData = jsonDecode(response.body);
//         currentData.value = CurrentMonitoring.fromJson(parsedData);
//         error('');
//         currentData.value.data.waktu = DateTime.now();
//       } else {
//         throw HttpException('Server returned ${response.statusCode}');
//       }
//     } catch (e) {
//       _logger.warning('Error polling data: $e');
//       error.value = 'Failed to update data';
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Close the WebSocket connection and cleanup
//   Future<void> _closeConnection() async {
//     try {
//       pingTimer?.cancel();
//       await channel?.sink.close();
//       await rawSocket?.close();
//       channel = null;
//       rawSocket = null;
//       isConnected(false);
//       connectionStatus.value = ConnectionStatus.disconnected;
//     } catch (e) {
//       _logger.warning('Error closing connection: $e');
//     }
//   }

//   @override
//   void onClose() {
//     stopDataPolling();
//     _closeConnection();
//     pingTimer?.cancel();
//     reconnectTimer?.cancel();
//     autoRefreshTimer?.cancel();
//     super.onClose();
//   }

//   // Method to stop polling when WebSocket is active
//   void stopDataPolling() {
//     autoRefreshTimer?.cancel();
//     autoRefreshTimer = null;
//   }
// }

// enum ConnectionStatus { connected, disconnected, error }



// class CurrentMonitorngController extends GetxController {
//   // Logger setup
//   final _logger = Logger('CurrentMonitoringController');

//   // API Controller
//   final ApiController _apiController = ApiController();

//   // Connection States
//   var isLoading = false.obs;
//   var isConnected = false.obs;
//   var error = ''.obs;
//   final connectionStatus = Rx<ConnectionStatus>(ConnectionStatus.disconnected);

//   // WebSocket Configuration
//   static const String baseUrl = "kh8ppwzx-5000.asse.devtunnels.ms";
//   static const int wsPort = 5000;
//   static const Duration pingInterval = Duration(seconds: 30);
//   static const Duration connectionTimeout = Duration(seconds: 5);
//   static const Duration reconnectDelay = Duration(seconds: 3);
//   static const int maxReconnectAttempts = 5;

//   // Connection Management
//   WebSocket? rawSocket;
//   IOWebSocketChannel? channel;
//   Timer? pingTimer;
//   Timer? reconnectTimer;
//   Timer? autoRefreshTimer;
//   int reconnectAttempts = 0;
//   bool isReconnecting = false;

//   // Current Data
//   var currentData = CurrentMonitoring(
//     success: false,
//     statusCode: 0,
//     data: Data(current: 0.0, waktu: DateTime.now()),
//   ).obs;

//   // Machine Type
//   final Rx<MachineType> currentMachineType;

//   CurrentMonitoringController(MachineType initialMachineType)
//       : currentMachineType = initialMachineType.obs {
//     // Initialize logger
//     Logger.root.level = Level.ALL;
//     Logger.root.onRecord.listen((record) {
//       print('${record.level.name}: ${record.time}: ${record.message}');
//     });
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     initializeConnection();
//   }

//   void initializeConnection() {
//     startDataPolling(); // Start polling for initial data
//     Future.delayed(
//         Duration(seconds: 2), initializeWebSocket); // Try WebSocket after delay
//   }

//   Future<void> initializeWebSocket() async {
//     if (isReconnecting) return;

//     try {
//       isReconnecting = true;
//       isLoading(true);

//       // Close existing connection if any
//       await _closeConnection();

//       final wsUrl = _buildWebSocketUrl();
//       _logger.info('Connecting to WebSocket: $wsUrl');

//       // Try to establish WebSocket connection with custom headers
//       rawSocket = await WebSocket.connect(
//         wsUrl,
//         headers: {
//           'Connection': 'Upgrade',
//           'Upgrade': 'websocket',
//           'Cache-Control': 'no-cache',
//           'Pragma': 'no-cache',
//         },
//       ).timeout(connectionTimeout);

//       // Configure WebSocket
//       rawSocket!.pingInterval = pingInterval;

//       // Create channel
//       channel = IOWebSocketChannel(rawSocket!);

//       // Setup listeners
//       _setupWebSocketListeners();

//       // Setup ping mechanism
//       _setupPingMechanism();

//       isConnected(true);
//       connectionStatus.value = ConnectionStatus.connected;
//       error('');
//       reconnectAttempts = 0;

//       _logger.info('WebSocket connected successfully');
//     } on SocketException catch (e) {
//       _logger.warning('Socket error: $e');
//       _handleConnectionError('Network error: Unable to connect to server');
//     } on TimeoutException catch (e) {
//       _logger.warning('Connection timeout: $e');
//       _handleConnectionError('Connection timeout');
//     } on WebSocketException catch (e) {
//       _logger.warning('WebSocket error: $e');
//       _handleConnectionError('WebSocket connection failed');
//     } catch (e) {
//       _logger.severe('Unexpected connection error: $e');
//       _handleConnectionError('Connection failed: Unknown error');
//     } finally {
//       isReconnecting = false;
//       isLoading(false);
//     }
//   }

//   String _buildWebSocketUrl() {
//     final machineType = currentMachineType.value.toApiString().toLowerCase();
//     return 'ws://$baseUrl:$wsPort/sensor/$machineType/updateCurrent';
//   }

//   void _setupWebSocketListeners() {
//     channel?.stream.listen(
//       (data) async {
//         try {
//           _logger.fine('Received WebSocket data: $data');
//           final parsedData = jsonDecode(data);

//           // Handle ping response
//           if (parsedData['type'] == 'pong') {
//             _logger.fine('Received pong response');
//             return;
//           }

//           // Handle regular data
//           currentData.value = CurrentMonitoring.fromJson(parsedData);
//           isConnected(true);
//           error('');

//           // Update last update time
//           currentData.value.data.waktu = DateTime.now();
//         } catch (e) {
//           _logger.warning('Error processing data: $e');
//           error.value = 'Data processing error';
//         }
//       },
//       onError: (error) {
//         _logger.warning('WebSocket stream error: $error');
//         _handleConnectionError('Stream error occurred');
//       },
//       onDone: () {
//         _logger.info('WebSocket connection closed');
//         _handleConnectionClosed();
//       },
//       cancelOnError: false,
//     );
//   }

//   void _setupPingMechanism() {
//     pingTimer?.cancel();
//     pingTimer = Timer.periodic(pingInterval, (timer) {
//       if (channel?.sink != null && isConnected.value) {
//         try {
//           channel?.sink.add(jsonEncode({
//             'type': 'ping',
//             'timestamp': DateTime.now().toIso8601String(),
//           }));
//           _logger.fine('Ping sent');
//         } catch (e) {
//           _logger.warning('Error sending ping: $e');
//           _handleConnectionError('Failed to send ping');
//         }
//       }
//     });
//   }

//   void _handleConnectionError(String message) {
//     isConnected(false);
//     connectionStatus.value = ConnectionStatus.error;
//     error.value = message;

//     if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
//       reconnectAttempts++;
//       _scheduleReconnection();
//     } else if (reconnectAttempts >= maxReconnectAttempts) {
//       _startPolling();
//     }
//   }

//   void _handleConnectionClosed() {
//     isConnected(false);
//     connectionStatus.value = ConnectionStatus.disconnected;

//     if (!isReconnecting && reconnectAttempts < maxReconnectAttempts) {
//       _scheduleReconnection();
//     } else {
//       _startPolling();
//     }
//   }

//   void _scheduleReconnection() {
//     reconnectTimer?.cancel();

//     final delay = Duration(seconds: min(pow(2, reconnectAttempts).toInt(), 30));
//     _logger.info(
//         'Scheduling reconnection attempt ${reconnectAttempts + 1} in ${delay.inSeconds} seconds');

//     reconnectTimer = Timer(delay, () {
//       if (!isConnected.value && !isReconnecting) {
//         initializeWebSocket();
//       }
//     });
//   }

//   void _startPolling() {
//     _logger.info('Starting polling mechanism');
//     error.value = 'WebSocket disconnected - Using polling';
//     _setupAutoRefresh();
//   }

//   void _setupAutoRefresh() {
//     autoRefreshTimer?.cancel();
//     autoRefreshTimer =
//         Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (!isConnected.value) {
//         await refreshData();
//       }
//     });
//   }

//   void startDataPolling() {
//     autoRefreshTimer?.cancel(); // Cancel existing timer if any

//     // Initial fetch
//     refreshData();

//     // Start periodic polling
//     autoRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
//       if (!isConnected.value) {
//         await refreshData();
//       }
//     });
//   }

//   // Optional: Method to stop polling
//   void stopDataPolling() {
//     autoRefreshTimer?.cancel();
//     autoRefreshTimer = null;
//   }

//   Future<void> refreshData() async {
//     if (isLoading.value) return;

//     try {
//       isLoading(true);
//       final response = await _apiController
//           .getLatestCurrent(currentMachineType.value.toApiString())
//           .timeout(connectionTimeout);

//       if (response.statusCode == 200) {
//         final parsedData = jsonDecode(response.body);
//         currentData.value = CurrentMonitoring.fromJson(parsedData);
//         error('');

//         // Update last update time
//         currentData.value.data.waktu = DateTime.now();
//       } else {
//         throw HttpException('Server returned ${response.statusCode}');
//       }
//     } catch (e) {
//       _logger.warning('Error polling data: $e');
//       error.value = 'Failed to update data';
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> _closeConnection() async {
//     try {
//       pingTimer?.cancel();
//       await channel?.sink.close();
//       await rawSocket?.close();
//       channel = null;
//       rawSocket = null;
//       isConnected(false);
//       connectionStatus.value = ConnectionStatus.disconnected;
//     } catch (e) {
//       _logger.warning('Error closing connection: $e');
//     }
//   }

//   // Manual reconnect method
//   Future<void> manualReconnect() async {
//     reconnectAttempts = 0;
//     await initializeWebSocket();
//   }

//   @override
//   void onClose() {
//     stopDataPolling();
//     _closeConnection();
//     pingTimer?.cancel();
//     reconnectTimer?.cancel();
//     autoRefreshTimer?.cancel();
//     super.onClose();
//   }

// }

// enum ConnectionStatus { connected, disconnected, error }
