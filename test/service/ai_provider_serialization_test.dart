import 'package:anx_reader/enums/ai_reasoning_effort.dart';
import 'package:anx_reader/models/ai_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AiProvider toJson -> fromJson round-trip preserves all fields', () {
    final provider = AiProvider(
      id: 'test-id',
      title: 'Test Provider',
      logoAsset: 'assets/images/openai.png',
      url: 'https://api.example.com/v1',
      protocol: AiProtocol.openai,
      enabled: false,
      isBuiltin: true,
      apiKeys: [
        AiApiKey(
          id: 'key-1',
          key: 'sk-test',
          enabled: true,
          label: 'primary',
          createdAt: DateTime.utc(2026, 1, 2, 3, 4, 5),
        ),
      ],
      model: 'gpt-4o-mini',
      reasoningEffort: AiReasoningEffort.high,
      keyIndex: 2,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 2),
    );

    final json = provider.toJson();
    final restored = AiProvider.fromJson(json);

    expect(restored.id, provider.id);
    expect(restored.title, provider.title);
    expect(restored.logoAsset, provider.logoAsset);
    expect(restored.url, provider.url);
    expect(restored.protocol, provider.protocol);
    expect(restored.enabled, provider.enabled);
    expect(restored.isBuiltin, provider.isBuiltin);
    expect(restored.model, provider.model);
    expect(restored.reasoningEffort, provider.reasoningEffort);
    expect(restored.keyIndex, provider.keyIndex);
    expect(restored.createdAt, provider.createdAt);
    expect(restored.updatedAt, provider.updatedAt);
    expect(restored.apiKeys.length, 1);
    expect(restored.apiKeys.first.id, 'key-1');
    expect(restored.apiKeys.first.key, 'sk-test');
    expect(restored.apiKeys.first.enabled, isTrue);
    expect(restored.apiKeys.first.label, 'primary');
    expect(restored.apiKeys.first.createdAt, provider.apiKeys.first.createdAt);
  });

  test('saveAiProviders-compatible path: toJson works via dynamic dispatch',
      () {
    // Regression: saveAiProviders(List<dynamic>) calls p.toJson() through a
    // dynamic receiver, which fails with NoSuchMethodError when the method
    // is provided only by an extension or is missing entirely.
    final Object provider = AiProvider(
      id: 'x',
      title: 'X',
      url: 'https://api.example.com/v1',
      protocol: AiProtocol.claude,
      apiKeys: const [],
    );
    final json = (provider as dynamic).toJson() as Map<String, dynamic>;
    expect(json['id'], 'x');
    expect(json['protocol'], 'claude');
    expect(json['reasoningEffort'], 'auto');
  });
}
