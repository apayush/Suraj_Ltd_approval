import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class NotificationBell extends StatefulWidget {
  final List<String> notifications;
  final int unreadCount;

  const NotificationBell({
    super.key,
    required this.notifications,
    required this.unreadCount,
  });

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _toggleOverlay();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
              Positioned(
                width: 320,
                top: 50,
                right: 40,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: Offset(-300, 40),
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 300,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.notifications.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    radius: 10,
                                  ),
                                  title: Text(
                                    widget.notifications[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          TextButton(
                            onPressed: () {},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('See All Alerts'),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -5, end: -5),
          badgeContent: Text(
            widget.unreadCount.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 10),
          ),
          child: const Icon(Icons.notifications, size: 30, color: Colors.black),
        ),
      ),
    );
  }
}
