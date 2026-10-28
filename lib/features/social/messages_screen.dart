import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../data/demo_data.dart';
import '../../shared/widgets.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, required this.state});
  final AppState state;
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _query = '';
  void _open(Friend friend) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => ChatScreen(state: widget.state, friend: friend),
    ),
  );
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, _) => DesignSurface(
      builder: (height) {
        final filtered = friends
            .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();
        return Stack(
          children: [
            const PageHeading(title: 'Messages', back: true),
            Positioned(
              left: 42,
              right: 42,
              top: 119,
              height: 59,
              child: TextField(
                key: const Key('message-search'),
                onChanged: (value) => setState(() => _query = value),
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search friends or neighbors',
                  hintStyle: TextStyle(fontSize: 14, color: AppColors.muted),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFBFBFC2)),
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            Positioned(
              left: 42,
              right: 42,
              top: 220,
              bottom: 30,
              child: filtered.isEmpty
                  ? Center(
                      child: label('No friends found', color: AppColors.muted),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(bottom: height < 850 ? 65 : 0),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 30),
                      itemBuilder: (context, i) {
                        final friend = filtered[i];
                        final sent = widget.state.messages[friend.name] ?? [];
                        return GestureDetector(
                          key: Key('conversation-${friend.name}'),
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _open(friend),
                          child: SizedBox(
                            height: 46,
                            child: Row(
                              children: [
                                friend.avatar.isEmpty
                                    ? Container(
                                        width: 46,
                                        height: 46,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFFFECE6),
                                        ),
                                        child: const Icon(
                                          Icons.group,
                                          color: AppColors.orange,
                                        ),
                                      )
                                    : Avatar(image: friend.avatar),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      label(
                                        friend.name,
                                        bold: true,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 5),
                                      label(
                                        sent.isEmpty
                                            ? friend.preview
                                            : sent.last,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                label(
                                  sent.isEmpty ? friend.time : 'Now',
                                  size: 14,
                                  color: AppColors.muted,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              right: 42,
              bottom: 43,
              child: ActionCircle(
                key: const Key('new-message'),
                onTap: _newMessage,
                icon: Icons.add,
                tooltip: 'New message',
              ),
            ),
          ],
        );
      },
    ),
  );

  void _newMessage() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: label('New message', size: 24, bold: true),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: friends
                  .where((f) => f.avatar.isNotEmpty)
                  .map(
                    (f) => ListTile(
                      leading: Avatar(image: f.avatar, size: 38),
                      title: Text(f.name),
                      onTap: () {
                        Navigator.pop(context);
                        _open(f);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.state, required this.friend});
  final AppState state;
  final Friend friend;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _text = TextEditingController();
  final _scroll = ScrollController();
  @override
  void dispose() {
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_text.text.trim().isEmpty) return;
    final message = _text.text;
    _text.clear();
    await widget.state.sendMessage(widget.friend.name, message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        key: const Key('chat-back'),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.chevron_left, color: Color(0xFFBFBFC2)),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          if (widget.friend.avatar.isNotEmpty)
            Avatar(image: widget.friend.avatar, size: 36),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(widget.friend.name, bold: true),
              label('Daility friends', size: 12, color: AppColors.muted),
            ],
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          label('Today', size: 12, color: AppColors.muted),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.state,
              builder: (context, _) {
                final sent = widget.state.messages[widget.friend.name] ?? [];
                return ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _bubble(
                      widget.friend.preview.replaceAll('…', ' you?'),
                      false,
                    ),
                    ...sent.map((message) => _bubble(message, true)),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('chat-input'),
                    controller: _text,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Write a message…',
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 12),
                ActionCircle(
                  key: const Key('chat-send'),
                  size: 52,
                  icon: Icons.arrow_upward_rounded,
                  onTap: _send,
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _bubble(String text, bool mine) => Align(
    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 270),
      decoration: BoxDecoration(
        color: mine ? AppColors.orange : const Color(0xFFF4F3F7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: label(text, color: mine ? Colors.white : AppColors.ink),
    ),
  );
}
