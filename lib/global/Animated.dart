import 'package:flutter/material.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart'; // Make sure to import your appBloc

class LikeButton extends StatefulWidget {
  final Function(bool) onLikeChanged;

  final int contractId;
  final Map<int, dynamic> data;

  const LikeButton({
    Key? key,
    required this.onLikeChanged,
    required this.contractId,
    required this.data,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _bounceAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike(appBloc bloc) {
    bool isLiked = bloc.watchList.containsKey(widget.contractId);

    if (isLiked) {
      bloc.removeFromWatchList(widget.contractId);
      print(bloc.watchList);
    } else {
      bloc.addToWatchList(widget.contractId, widget.data);
       print(bloc.watchList);
    }
    widget.onLikeChanged(!isLiked);

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<appBloc>(
      builder: (context, bloc, child) {
        bool isLiked = bloc.watchList.containsKey(widget.contractId);
        return GestureDetector(
          onTap: () => _toggleLike(bloc),
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
      },
    );
  }
}
