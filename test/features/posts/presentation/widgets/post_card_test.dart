import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/presentation/widgets/post_card.dart';

void main() {
  testWidgets('PostCard displays post data correctly', (tester) async {
    const post = Post(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PostCard(post: post),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Body'), findsOneWidget);
  });

  testWidgets('PostCard handles long text correctly', (tester) async {
    final post = Post(
      id: 1,
      title: 'Very Long Title ' * 10,
      body: 'Very Long Body ' * 20,
      userId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCard(post: post),
        ),
      ),
    );

    expect(find.byType(PostCard), findsOneWidget);
  });
}
