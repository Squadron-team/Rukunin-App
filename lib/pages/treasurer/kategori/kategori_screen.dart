import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/repositories/category_repository.dart';
import 'package:rukunin/models/category.dart';
import 'package:rukunin/pages/treasurer/kategori/kategori_form_screen.dart';
import 'package:rukunin/pages/rt/wilayah/widgets/confirm_dialogs.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CategoryRepository repo = CategoryRepository();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openForm({Category? edit}) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KategoriFormScreen(edit: edit)),
    );
    if (res == true) setState(() {});
  }

  Future<bool?> _confirmDelete(Category c) async {
    if (repo.hasRelated(c)) {
      await showCannotDeleteDialog(context);
      return false;
    }

    final ok = await showConfirmDeleteDialog(context, c.name);
    return ok;
  }

  Widget _buildList(String type) {
    final items = repo.byType(type);
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Belum ada kategori',
          style: TextStyle(color: Colors.grey[700]),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 120),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final c = items[index];
        return Dismissible(
          key: ValueKey(c.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: AppColors.error,
            child: const Icon(Icons.delete_forever, color: Colors.white),
          ),
          confirmDismiss: (_) async {
            final ok = await _confirmDelete(c);
            if (ok ?? false) {
              repo.remove(c);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kategori "${c.name}" dihapus'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            return ok ?? false;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  c.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: c.type == 'iuran'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (c.targetPerFamily != null) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.paid,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rp ${c.targetPerFamily}',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${c.startDate != null ? c.startDate!.toLocal().toString().split(' ')[0] : '-'}  s/d  ${c.deadline != null ? c.deadline!.toLocal().toString().split(' ')[0] : '-'}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _openForm(edit: c),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Kategori',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Pengeluaran'),
            Tab(text: 'Pemasukan'),
            Tab(text: 'Iuran Warga'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList('pengeluaran'),
              _buildList('pemasukan'),
              _buildList('iuran'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-kategori',
        backgroundColor: AppColors.primary,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
