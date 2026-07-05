import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/repositories/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/model/review_model.dart';

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  final _repo = Get.find<AdminRepository>();
  List<ReviewModel> _list = [];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listReviews();
      _list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _edit(ReviewModel r) async {
    final text = TextEditingController(text: r.comment);
    final rating = TextEditingController(text: '${r.rating.toStringAsFixed(0)}');
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Moderate review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rating,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rating 1–5',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: text,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true) return;
    final rv = double.tryParse(rating.text.trim()) ?? r.rating;
    final rr = ReviewModel(
      id: r.id,
      productId: r.productId,
      userId: r.userId,
      userName: r.userName,
      userAvatar: r.userAvatar,
      rating: rv.clamp(1.0, 5.0),
      comment: text.text.trim(),
      images: r.images,
      createdAt: r.createdAt,
    );
    await _repo.saveReview(rr);
    showSuccess('Review updated', title: 'Saved');
    _load();
  }

  Future<void> _delete(ReviewModel r) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete review?'),
        content: Text(r.comment, maxLines: 3, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.deleteReview(r.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return AdminAccessGate(
      title: 'Reviews',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Reviews'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _list.isEmpty
                ? const Center(child: Text('No reviews'))
                : ListView.separated(
                    padding: const EdgeInsets.all(DesignTokens.spacing16),
                    itemCount: _list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final r = _list[i];
                      return AdminTheme.card(
                        context: context,
                        child: ListTile(
                          title: Text(
                            '${r.rating.toStringAsFixed(0)}★ · ${r.userName}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'Product: ${r.productId}\n${r.comment}',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _edit(r),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _delete(r),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
