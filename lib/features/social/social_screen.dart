import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../data/demo_data.dart';
import '../../shared/widgets.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key, required this.state, required this.onProfile});
  final AppState state;
  final VoidCallback onProfile;
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      PageHeading(
        title: 'Social Friends',
        subtitle: 'What about your friends?',
        onProfile: onProfile,
        avatar: state.avatar,
      ),
      Positioned(
        left: 0,
        right: 0,
        top: 146,
        bottom: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 42),
                itemCount: 6,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, i) => GestureDetector(
                  key: Key('story-$i'),
                  onTap: () => i == 0 ? _addStory(context) : _story(context, i),
                  child: Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF8A00),
                        width: 1.8,
                      ),
                    ),
                    child: i == 0
                        ? const Icon(
                            Icons.add,
                            color: Color(0xFFFF8A00),
                            size: 27,
                          )
                        : Avatar(
                            image: friends[[0, 3, 4, 5, 2][i - 1]].avatar,
                            size: 46,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _post(
              context,
              0,
              'Ivan Morais',
              'avatar_ivan.png',
              '1h ago',
              'post_football.png',
            ),
            const SizedBox(height: 42),
            _post(
              context,
              1,
              'Stephanie Bailey',
              'avatar_fatima.png',
              '2h ago',
              'post_gym.png',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ],
  );

  Widget _post(
    BuildContext context,
    int index,
    String name,
    String avatar,
    String time,
    String image,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 42),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Avatar(image: avatar, size: 23),
            const SizedBox(width: 8),
            Expanded(child: label(name, bold: true)),
            label(time, size: 14, color: AppColors.muted),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 246,
          child: label(
            'After a while now I do it right like as my friend and I am so happy.',
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          key: Key('post-$index'),
          onDoubleTap: () => state.toggleLike(index),
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  asset(image, fit: BoxFit.cover),
                  ListenableBuilder(
                    listenable: state,
                    builder: (context, _) => TextButton.icon(
                      onPressed: () => state.toggleLike(index),
                      icon: Icon(
                        state.likedPosts.contains(index)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.orange,
                      ),
                      label: Text(
                        state.likedPosts.contains(index)
                            ? 'Liked'
                            : 'Like this activity',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: asset(image, width: 291, height: 180, fit: BoxFit.cover),
              ),
              if (state.likedPosts.contains(index))
                const Positioned(
                  right: 14,
                  bottom: 14,
                  child: Icon(
                    Icons.favorite,
                    color: AppColors.orange,
                    size: 28,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  void _story(BuildContext context, int index) {
    final friend = friends[[0, 3, 4, 5, 2][index - 1]];
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Avatar(image: friend.avatar, size: 32),
                  const SizedBox(width: 12),
                  Expanded(child: label(friend.name, bold: true)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            asset(
              index.isOdd ? 'post_football.png' : 'post_gym.png',
              height: 330,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: label('A little stronger every day.'),
            ),
          ],
        ),
      ),
    );
  }

  void _addStory(BuildContext context) => showNotice(
    context,
    'Your activity story',
    'Start a workout from Home, then share your progress with friends. Photo uploads will be available when a media service is connected.',
  );
}
