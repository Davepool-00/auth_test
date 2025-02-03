import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
// !! commented code below  is using fingerprint auth
// class AuthenticationService {
//   final LocalAuthentication _localAuth = LocalAuthentication();

//   Future<bool> authenticate() async {
//     try {
//       // Check multiple conditions for authentication availability
//       bool canAuthenticate = await _localAuth.canCheckBiometrics ||
//           await _localAuth.isDeviceSupported();

//       List<BiometricType> availableBiometrics =
//           await _localAuth.getAvailableBiometrics();

//       if (!canAuthenticate || availableBiometrics.isEmpty) {
//         debugPrint('No biometric authentication available');
//         return false;
//       }

//       return await _localAuth.authenticate(
//         localizedReason: 'Please authenticate',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//     } catch (e) {
//       debugPrint('Authentication detailed error: $e');
//       return false;
//     }
//   }

//   Future<List<BiometricType>> getAvailableBiometrics() async {
//     return await _localAuth.getAvailableBiometrics();
//   }
// }


//  !! below is for facial recognition...
//* * At the moment the physical device I am using is not being detected its facial recognition but it works in the fingerprint...
class AuthenticationService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      List<BiometricType> availableBiometrics = 
        await _localAuth.getAvailableBiometrics();
      
      debugPrint('Available biometrics: $availableBiometrics');
      bool hasFacialRecognition = availableBiometrics.contains(BiometricType.face);
      
      if (!hasFacialRecognition) {
        debugPrint('Facial recognition not available');
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Scan your face to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      debugPrint('Facial authentication error: $e');
      return false;
    }
  }
}


// !! Displays a button to trigger authentication
class AuthenticationScreen extends StatelessWidget {
  final AuthenticationService _authService = AuthenticationService();

  void _handleAuthentication(BuildContext context) async {
    bool authenticated = await _authService.authenticate();
    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication Failed')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleAuthentication(context),
          child: const Text('Authenticate'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Successfully Authenticated!'),
      ),
    );
  }
}
