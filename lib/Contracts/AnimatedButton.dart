import 'package:flutter/material.dart';
import 'package:itx/requests/Requests.dart';

class LikeButton extends StatefulWidget {
  final bool isWarehouse;
  final Function(bool) onLikeChanged;
  final int likes;
  final int contractId;

  const LikeButton({
    Key? key,
    required this.isWarehouse,
    required this.onLikeChanged,
    required this.contractId,
    required this.likes,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  bool isLiked = false;
  String? selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<Map<String, dynamic>> reasons = [
    {
      'icon': Icons.location_off,
      'title': 'Wrong Address',
      'subtitle': 'The delivery address was incorrect'
    },
    {
      'icon': Icons.description,
      'title': 'Missing Documentation',
      'subtitle': 'Required documents were not provided'
    },
    {
      'icon': Icons.inventory_2,
      'title': 'Damaged Goods',
      'subtitle': 'Items arrived in damaged condition'
    },
    {
      'icon': Icons.access_time,
      'title': 'Late Delivery',
      'subtitle': 'Delivery was not made on time'
    },
    {
      'icon': Icons.warning,
      'title': 'Quality Issues',
      'subtitle': 'Items don\'t meet quality standards'
    },
    {
      'icon': Icons.more_horiz,
      'title': 'Other',
      'subtitle': 'Other reasons not listed above'
    },
  ];

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

  void _showReasonBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Why wasn\'t the contract received?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Reasons list
                Expanded(
                  child: ListView.builder(
                    itemCount: reasons.length,
                    itemBuilder: (context, index) {
                      final reason = reasons[index];
                      final isSelected = selectedReason == reason['title'];
                      
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedReason = reason['title'];
                                if (selectedReason != 'Other') {
                                  _otherReasonController.clear();
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              color: isSelected ? Colors.green.shade300.withOpacity(0.1) : null,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      reason['icon'],
                                      color: Colors.green.shade300,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reason['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          reason['subtitle'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                     Icon(
                                      Icons.check_circle,
                                      color: Colors.green.shade300,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // Show TextField when "Other" is selected
                          if (isSelected && reason['title'] == 'Other')
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: TextField(
                                controller: _otherReasonController,
                                decoration: InputDecoration(
                                  hintText: 'Please describe the reason',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                maxLines: 3,
                                onChanged: (_) => setState(() {}), // Trigger rebuild to update button state
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                // Submit button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedReason == null || 
                            (selectedReason == 'Other' && _otherReasonController.text.trim().isEmpty)
                        ? null
                        : () async {
                            final finalReason = selectedReason == 'Other' 
                                ? _otherReasonController.text.trim()
                                : selectedReason;
                            print('Selected reason: $finalReason');
                            // TODO: Add your API call here
                            Navigator.pop(context);
                            selectedReason = null;
                            _otherReasonController.clear();
                          },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _otherReasonController.dispose();
    super.dispose();
  }

  // ... rest of the code remains the same ...
  
  Future<void> _toggleLike() async {
    _controller.forward().then((_) {
      _controller.reverse();
    });

    setState(() {
      isLiked = !isLiked;
    });

    await AuthRequest.likeunlike(
      context, 
      isLiked ? 1 : 0, 
      widget.contractId
    );

    if (widget.isWarehouse && !isLiked) {
      if (!context.mounted) return;
      _showReasonBottomSheet();
    }

    widget.onLikeChanged(isLiked);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLiked 
            ? 'Liked contract ${widget.contractId}'
            : 'Unliked contract ${widget.contractId}'
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  IconData _getIcon() {
    if (isLiked && !widget.isWarehouse) {
      return Icons.favorite;
    } else if (isLiked && widget.isWarehouse) {
      return Icons.check;
    } else if (!isLiked && !widget.isWarehouse) {
      return Icons.favorite_border;
    } else {
      return Icons.cancel;
    }
  }

  Color _getIconColor() {
    if (isLiked && !widget.isWarehouse) {
      return Colors.red;
    } else if (!isLiked && !widget.isWarehouse) {
      return Colors.grey;
    } else if (isLiked && widget.isWarehouse) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Icon(
              _getIcon(),
              color: _getIconColor(),
              size: 25,
            ),
          );
        },
      ),
    );
  }
}