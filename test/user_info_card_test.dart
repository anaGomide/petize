// O requisito técnico solicitava a criação de testes unitários para listagem de usuários, mas como não há listagem de usuários, fiz teste unitário do widget UserInfoCard.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petize/modules/profile/user_info_card.dart';
import 'package:petize/shared/models/user_model.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    if (url.path.contains('avatars.githubusercontent.com')) {
      return MockHttpClientRequest();
    }
    throw Exception('URL not supported');
  }

  @override
  void close({bool force = false}) {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => 1000;

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([Uint8List(1000)]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return MockPlatformWebViewController(params);
  }
}

class MockPlatformWebViewController extends PlatformWebViewController {
  MockPlatformWebViewController(PlatformWebViewControllerCreationParams params) : super.implementation(params);

  Future<void> loadUrl(String url, Map<String, String>? headers) async {
    print('Carregando URL simulada: $url');
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    print('Simulando configuração de JavaScriptMode: $javaScriptMode');
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
    WebViewPlatform.instance = MockWebViewPlatform();
  });

  group('UserInfoCard', () {
    testWidgets('Deve exibir avatar e nome do usuário', (WidgetTester tester) async {
      final user = User(
        name: 'Ana Luiza Gomide',
        login: 'anaGomide',
        bio: 'Hi, I\'m Ana Luiza!',
        followers: 1,
        following: 0,
        company: 'App Service',
        location: 'Brasil',
        email: 'analuizagomide.n@gmail.com',
        blog: 'https://www.linkedin.com/in/ana-luiza-gomide-0113/',
        twitterUsername: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(user: user),
          ),
        ),
      );

      expect(find.text('Ana Luiza Gomide'), findsOneWidget);
      expect(find.text('@anaGomide'), findsOneWidget);
      expect(find.text('Hi, I\'m Ana Luiza!'), findsOneWidget);
      expect(find.text('1 seguidores'), findsOneWidget);
      expect(find.text('0 seguindo'), findsOneWidget);
      expect(find.text('App Service'), findsOneWidget);
      expect(find.text('Brasil'), findsOneWidget);
      expect(find.text('analuizagomide.n@gmail.com'), findsOneWidget);
      expect(find.text('https://www.linkedin.com/in/ana-luiza-gomide-0113/'), findsOneWidget);
    });

    testWidgets('Deve lidar com dados ausentes', (WidgetTester tester) async {
      final user = User(login: 'joaosilva');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(user: user),
          ),
        ),
      );

      expect(find.text('@joaosilva'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      expect(find.textContaining('seguidores'), findsNothing);
      expect(find.textContaining('seguindo'), findsNothing);
    });
  });
}
