import 'package:flutter/material.dart';
import 'package:itx/requests/Requests.dart';

class LikeButton extends StatefulWidget {
  final Function(bool) onLikeChanged;
  final int likes;
  final int contractId;

  const LikeButton({
    Key? key,
    required this.onLikeChanged,
    required this.contractId,
    required this.likes,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    isLiked = widget.likes > 0;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  Future<void> _toggleLike() async {
    // Trigger the animation
    _controller.forward().then((_) {
      _controller.reverse();
    });

    // Update the like state
    setState(() async {
      isLiked = !isLiked;
    await AuthRequest.likeunlike(context, isLiked ? 1 : 0, widget.contractId);
    });

    widget.onLikeChanged(isLiked);

    // Optionally, you can display feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLiked
            ? 'Liked contract ${widget.contractId}'
            : 'Unliked contract ${widget.contractId}'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _toggleLike(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 30,
            ),
          );
        },
      ),
    );
  }
}
